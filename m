Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab3ATSnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 13:43:24 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38453 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3ATSnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 13:43:22 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20130120174153.GA5675@paralelels.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
 <1358182435-19245-3-git-send-email-avagin@openvz.org> <20130116123502.70af6b85.akpm@linux-foundation.org>
 <CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com>
 <CANaxB-wXdPZFzD3BhkD6niDA6M1NiNrc5coKf9bSx+ar_fZecg@mail.gmail.com>
 <CAKgNAkjK9iWh_PuJ92A-MKW6Q6_B8DvTL5-fkxyULqx9ZoDPfg@mail.gmail.com> <20130120174153.GA5675@paralelels.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 20 Jan 2013 19:43:01 +0100
Message-ID: <CAKgNAkiVQqdaGWq83G7t6yHcjr=9rmwVUF_k-P20_Wcg469F7Q@mail.gmail.com>
Subject: Re: [CRIU] [PATCH 2/3] signalfd: add ability to return siginfo in a
 raw format (v2)
To: Andrew Vagin <avagin@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrey Wagin <avagin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Sun, Jan 20, 2013 at 6:41 PM, Andrew Vagin <avagin@parallels.com> wrote:
>
>> > signalfd is a special descriptor, so I think it
>> > is not a big deal, that it works a bit strange.
>>
>> Sure, but the more we special case things, the uglier the ABI as a
>> whole becomes. So special casing should be avoided as far as we can.
>>
>> > If all other would
>> > decides, that a new syscall is better, I will not ague.
>>
>> And that's more or less how I see it too. I'm not going to argue for a
>> new syscall, based on what I know so far.
>>
>> Here is one idea to think about though, while more or less maintaining
>> your proposed interface.
>>
>> At the moment, you select signal queues in the pread() call. An
>> alternative would be to do it in the signalfd() call. In other words,
>> you could have the following flags used with signalfd()
>>
>> SFD_RAW
>> SFD_SHARED_QUEUE -- reads will be from process-wide shared signal queue
>> SFD_PER_THREAD_QUEUE --reads will be from per-thread signal queue
>
> I suggested this variant in the initial series, but then we decided to
> avoid adding new flags. Oleg, what do you think about this?
>
>>
>> Specifying both SFD_SHARED_QUEUE  and SFD_PER_THREAD_QUEUE would be
>> the same as omitting them both, providing the default behavior of
>> slecting from both queues.
>>
>> My point here is that you can then separate the RAW functionality from
>> the queue selector functionality. Now, it might be that at the moment
>> you always require that if the caller specifies SFD_SHARED_QUEUE  or
>> SFD_PER_THREAD_QUEUE, then they must also specify SFD_RAW. But later,
>> that constraint might be relaxed, so that users could use signalfd()
>> to select from a particular queue when reading traditional (non-RAW)
>> signalfd_siginfo structures from a signalfd.
>
> I am not sure, that you understood this moment correctly.
> Currently SFD_RAW is independent on SFD_*_QUEUE. If signalfd is
> created without SFD_RAW, pread returns signalfd_siginfo-s.
> If SFD_RAW is set, read returns siginfo_t-s.

So, do you mean it is already possible to do:

fd = signalfd(-1, &mask, 0)      // no SFD_RAW flag
pread(fd, buf, count, SFD_PER_THREAD_QUEUE_OFFSET + pos)

to read a siginfo from the thread specific signal queue?

Thanks

> One more point for two flags is that we will be able to choose a queue
> from which signals will be dequeued. Currently we can choose a queue only
> for pread.

Also a good point, and another reason to place queue selection in the
signalfd() call, rather than in pread().

Cheers,

Michael


>> This does seem like a
>> very sensible design optimization to make now (and an easy one, I
>> would suppose). What do you think?
>>
>> Cheers,
>>
>> Michael
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
