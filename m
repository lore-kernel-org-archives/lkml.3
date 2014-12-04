Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaLDABy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:01:54 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:63096 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaLDABw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:01:52 -0500
MIME-Version: 1.0
In-Reply-To: <20141203155352.ea5322ff45c6200238c7ef51@linux-foundation.org>
References: <43c88012a4959cd427ab634906e697fbc524e847.1414604015.git.luto@amacapital.net>
 <alpine.DEB.2.11.1410291908290.5308@nanos> <CALCETrWtBCFXzwCAh8fpeFv-EvPxYW20oRmFk1iCYwUvpft=Rw@mail.gmail.com>
 <20141110.211319.1983610686941713044.davem@davemloft.net> <5461EA6B.9020305@nod.at>
 <CALCETrUZhbx-PN8A168khFr6ve_9vdkSiwOcQ-hZbqu4po8hnQ@mail.gmail.com>
 <20141203153721.30b32472145aa560921bdc1e@linux-foundation.org>
 <CALCETrVk0EBL0vk8kjOhjkMAOaxXukCdSptzfHU=g1s7JChXiQ@mail.gmail.com> <20141203155352.ea5322ff45c6200238c7ef51@linux-foundation.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Dec 2014 16:01:30 -0800
Message-ID: <CALCETrX7HFqurW066+UL92GnR3Ue32xG0-etb7g97Y5+jN+rQg@mail.gmail.com>
Subject: Re: [PATCH v2] all arches, signal: Move restart_block to struct task_struct
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>, David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 3:53 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 3 Dec 2014 15:38:29 -0800 Andy Lutomirski <luto@amacapital.net> wrote:
>
>> Yes, exactly.
>>
>> >
>> > Spelling this out in the changelog would be useful for the ignorant and
>> > the forgetful ;)
>>
>> Want a new version, or will you fix it up yourself?
>>
>
> I think I can work that out.
>
> A couple of linux-next things to check:
>
> - arch/arm/include/asm/thread_info.h:arm_restart_block has
>   disappeared from the thread_info.
>
> - the reference to ti->restart_block in arch/arm/kernel/traps.c has
>   vanished.  I couldn't find anywhere where it was moved to.

This looks like it's:

commit 3f4aa45ceea5789a4aade536acc27f2e0d3da5e1
Author: Vladimir Murzin <vladimir.murzin@arm.com>
Date:   Thu Nov 27 11:39:04 2014 +0100

    ARM: 8226/1: cacheflush: get rid of restarting block

    We cannot restart cacheflush safely if a process provides user-defined
    signal handler and signal is pending. In this case -EINTR is returned
    and it is expected that process re-invokes syscall. However, there are
    a few problems with that:
     * looks like nobody bothers checking return value from cacheflush
     * but if it did, we don't provide the restart address for that, so the
       process has to use the same range again
     * ...and again, what might lead to looping forever

    So, remove cacheflush restarting code and terminate cache flushing
    as early as fatal signal is pending.

If you haven't already done the obvious fixup (just drop the offending
hunk), I can send a new version.

-- 
Andy Lutomirski
AMA Capital Management, LLC
