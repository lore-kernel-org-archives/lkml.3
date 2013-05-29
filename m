Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935260Ab3E2V4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:56:53 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:47309 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935228Ab3E2V4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:56:45 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <20130529173634.GA2020@redhat.com>
References: <1369846916-13202-1-git-send-email-james.hogan@imgtec.com>
	<51A638A4.2000705@gmail.com>
	<20130529173634.GA2020@redhat.com>
Date: Wed, 29 May 2013 22:56:44 +0100
X-Google-Sender-Auth: 0UnJQ0Vw4BWJ322ZjkdkCqs6n3s
Message-ID: <CAAG0J9_yJd5mf0t7whnKDYtf0AdZDnErjOgUga7t0p3TEL_9YQ@mail.gmail.com>
Subject: Re: [RFC PATCH] kernel/signal.c: avoid BUG_ON with SIG128 (MIPS)
From: James Hogan <james.hogan@imgtec.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Daney <ddaney.cavm@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2013 18:36, Oleg Nesterov <oleg@redhat.com> wrote:
> On 05/29, David Daney wrote:
>>
>> On 05/29/2013 10:01 AM, James Hogan wrote:
>>> MIPS has 128 signals, the highest of which has the number 128. The
>>
>> I wonder if we should change the ABI and reduce the number of signals to
>> 127 instead of this patch.
>
> Same thoughts...

I'll give it a try. I wouldn't have thought it'd break anything, but
you never know. glibc (incorrectly) sets [__]SIGRTMAX to 127 already.
On the other hand uClibc sets it to 128, so anything built against
uClibc that uses signals SIGRTMAX-n (where n may be 0) or uses an
excessive number of rt signals starting from SIGRTMIN (sounds
unlikely) could well need an updated uClibc (or a full rebuild if it's
crazy enough to use __SIGRTMAX).

>>> @@ -2366,8 +2366,12 @@ relock:
>>>
>>>              /*
>>>               * Death signals, no core dump.
>>> +             *
>>> +             * MIPS has a signal number 128 which clashes with the core dump
>>> +             * bit. If this was the signal we still want to report a valid
>>> +             * exit code, so round it down to 127.
>>>               */
>>> -            do_group_exit(info->si_signo);
>>> +            do_group_exit(min(info->si_signo, 127));
>
> This avoids BUG_ON() but obviously fools WIFSIGNALED(), doesn't look
> very nice.

Agreed.

Cheers
James
