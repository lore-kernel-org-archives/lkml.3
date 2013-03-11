Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3CKTem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:34:42 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:41723 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3CKTek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:34:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130311192805.GA19428@redhat.com>
References: <20130311191156.GA17763@www.outflux.net>
	<20130311192805.GA19428@redhat.com>
Date: Mon, 11 Mar 2013 12:34:39 -0700
X-Google-Sender-Auth: IaX8GqcxxKmw_VSbC0hcHfJG7_Y
Message-ID: <CAGXu5jJEhDHgVR_iAdf27G0+Mip82vYBHv-r0Q_vZwDodfADRQ@mail.gmail.com>
Subject: Re: [PATCH] signal: always clear sa_restorer on execve
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:28 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/11, Kees Cook wrote:
>>
>> When the new signal handlers are set up for a fork, the location of
>> sa_restorer is not cleared, leaking a parent process's address space
>> location to children. This allows for a potential bypass of the parent's
>> ASLR by examining the sa_restorer value returned when calling sigaction().
>
> I don't understand.
>
> fork() should not change restorer/etc, and the child has the same address
> space anyway. There is no any leak and the patch can't make any difference
> in this case because flush_signal_handlers() is not called by fork().

I probably failed to explain this correctly. From the perspective of
what should be considered "secret", it only matters across the exec,
not the fork (since the VMAs haven't changed until the exec). But the
info leak is easy to see, and this patch fixes it. As you say, since
other things were reset, so should sa_restorer.

>
>> @@ -485,6 +485,9 @@ flush_signal_handlers(struct task_struct *t, int force_default)
>>               if (force_default || ka->sa.sa_handler != SIG_IGN)
>>                       ka->sa.sa_handler = SIG_DFL;
>>               ka->sa.sa_flags = 0;
>> +#ifdef __ARCH_HAS_SA_RESTORER
>> +             ka->sa.sa_restorer = NULL;
>> +#endif
>
> However, exec sets SIG_DFL but keeps ->sa_restorer, so probably this
> patch makes sense anyway.
>
> Oleg.
>

-Kees


-- 
Kees Cook
Chrome OS Security
