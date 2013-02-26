Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab3BZHdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:33:49 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:46034 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3BZHdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:33:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130225141234.99b76738.akpm@linux-foundation.org>
References: <1361786813-14652-1-git-send-email-avagin@openvz.org>
	<20130225141234.99b76738.akpm@linux-foundation.org>
Date: Tue, 26 Feb 2013 11:33:39 +0400
Message-ID: <CANaxB-x2uzgyd-EmhtyDcKJ6+bB1onL_ftmuZpCTLXnm5z-dcg@mail.gmail.com>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 from a queue (v2)
From: Andrey Wagin <avagin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-api@vger.kernel.org,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pedro Alves <palves@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, thank you for the comments. I will fix them and send a new
patch. A few comments are inline.

2013/2/26 Andrew Morton <akpm@linux-foundation.org>:
> On Mon, 25 Feb 2013 14:06:53 +0400
>> +     for (i = 0; i < arg.nr; i++) {
>> +             off = arg.off + i;
>
> "long long" = "u64" + "int".
>
> Wanna have a little think about what we're doing here, see if we can
> pick the most appropriate types?

A number of signal has the type int, because the system call ptrace()
return "int" and my interface supposed to return a number of dumped
signals.
"off" is signed to check on a negative value and it can not be more
then MAX_RAM / sizeof(siginfo), so
long long is enough. It can be changed on s64 for avoiding misleading.

>
> `off' could be made local to this loop, which is a bit neater.
>
>> +             spin_lock_irq(&child->sighand->siglock);
>> +             list_for_each_entry(q, &pending->list, list) {
>> +                     if (!off--) {
>> +                             copy_siginfo(&info, &q->info);
>> +                             break;
>> +                     }
>> +             }
>> +             spin_unlock_irq(&child->sighand->siglock);
>> +
>> +             if (off >= 0)
>> +                     break;
>
> <scratches head>
>
> Oh I see what you did there - the user requested an entry which is
> beyond the end of the list? A code comment would be nice.
>
> What's the return value in this case?  "i".  So how does userspace find
> out what happened?

The request PTRACE_PEEKSIGINFO returns a number of dumped signals. If
a signal with the specified sequence number doesn't exist, ptrace
returns 0.

>
> Please fully describe the interface so things such as this can be
> understood.
>
>> +#ifdef CONFIG_COMPAT
>> +             if (unlikely(is_compat_task())) {
>> +                     compat_siginfo_t __user *uinfo = compat_ptr(data);
>> +
>> +                     ret = copy_siginfo_to_user32(uinfo, &info);
>> +                     if (!ret)
>> +                             ret = __put_user(info.si_code, &uinfo->si_code);
>> +             } else
>> +#endif
>> +             {
>> +                     siginfo_t __user *uinfo = (siginfo_t __user *) data;
>> +
>> +                     ret = copy_siginfo_to_user(uinfo, &info);
>> +                     if (!ret)
>> +                             ret = __put_user(info.si_code, &uinfo->si_code);
>> +             }
>> +
>> +             if (ret)
>> +                     break;
>> +
>> +             data += sizeof(siginfo_t);
>> +
>> +             if (signal_pending(current)) {
>> +                     i++;
>
> What does the i++ do?

For accounting a current siginfo. I will add a comment here.

>
>> +                     break;
>> +             }
>> +
>> +             cond_resched();
>> +     }
>> +
>> +     return i ? : ret;
>
> I hate that gcc thing :(
>
> Also, is it buggy?  `ret' might be -EFAULT here.  We appear to be using
> read() return semantics here?

I have tried to implement read() semantics here. ptrace() returns a
number of dumped signals even if dumping of the last signal is failed.
And it returns an error if not one signal has been dumped
successfully.

The similar logic is used in read()
generic_file_aio_read()
....
                retval += desc.written;
                if (desc.error) {
                        retval = retval ?: desc.error;
                        break;
                }

Thanks,
  Andrey
