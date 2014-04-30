Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbaD3Rtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:49:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905AbaD3Rtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:49:39 -0400
Message-ID: <53613793.6070600@redhat.com>
Date: Wed, 30 Apr 2014 18:49:07 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Kettenis <mark.kettenis@xs4all.nl>
CC: hpa@zytor.com, pinskia@gmail.com, teawater@gmail.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, eparis@redhat.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, gdb@sourceware.org
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by
 GDB
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>	<53554846.3070608@zytor.com>	<CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com>	<53608125.2020103@zytor.com> <CA+=Sn1=y-smZOaD_yRxEwgu-PPaZYdQtB_RGPCA5-9wmB6=hvQ@mail.gmail.com> <536085B7.5070002@zytor.com> <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl>
In-Reply-To: <201404301335.s3UDZX4J017978@glazunov.sibelius.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 02:35 PM, Mark Kettenis wrote:
>> Date: Tue, 29 Apr 2014 22:10:15 -0700
>> From: "H. Peter Anvin" <hpa@zytor.com>
>>
>> On 04/29/2014 10:08 PM, Andrew Pinski wrote:
>>>
>>> restoring the values is hard since even the ptrace interface does not
>>> allow for that.
>>>
>>
>> So that begs the ultimate question, which is: given the fact that there
>> is *state missing* from the state vector (this is the core of the
>> problem), is there a way we can add that state so that gdb will be able
>> to save and restore it?
> 
> Carrying around additional state in GDB is complicated; I'd rather
> avoid it.

Agreed very much.

> arch/x86/kernel/ptrace.c:putreg32() has this bit of code:
> 
>         case offsetof(struct user32, regs.orig_eax):
>                 /*
>                  * A 32-bit debugger setting orig_eax means to restore
>                  * the state of the task restarting a 32-bit syscall.
>                  * Make sure we interpret the -ERESTART* codes correctly
>                  * in case the task is not actually still sitting at the
>                  * exit from a 32-bit syscall with TS_COMPAT still set.
>                  */
>                 regs->orig_ax = value;
>                 if (syscall_get_nr(child, regs) >= 0)
>                         task_thread_info(child)->status |= TS_COMPAT;
>                 break;
> 
> which gets used for 32-bit compat ptrace(2).  Perhaps the same logic
> should be added to putreg() if the child is a 32-bit process?

Sounds like the right fix to me.

-- 
Pedro Alves

