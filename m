Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3E3MAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:00:54 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:47752 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab3E3MAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:00:44 -0400
Message-ID: <51A73F68.7060500@parrot.com>
Date: Thu, 30 May 2013 14:00:40 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel-bounces@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Subject: Re : A bug about  system call on ARM
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Hi  all,
> 
> I am a new comer to this mailing list ,
> I am happy to join this community .
> 

You should send this to arm ML.

Also I believe most of people don't enable CONFIG_OABI_COMPAT, that's why they
don't hit the bug.


Matthieu


> I have a bug reported from our android phones which is caused by  the system call .
> It seems like kernel bugs from my view .
> 
> Crash in  file  arch\arm\kernel\ entry-common.S
> 
> /***************************************************************/
> 
> ENTRY(vector_swi)
> 	sub	sp, sp, #S_FRAME_SIZE
> 	stmia	sp, {r0 - r12}			@ Calling r0 - r12
>  ARM(	add	r8, sp, #S_PC		)
>  ARM(	stmdb	r8, {sp, lr}^		)	@ Calling sp, lr
>  THUMB(	mov	r8, sp			)
>  THUMB(	store_user_sp_lr r8, r10, S_SP	)	@ calling sp, lr
> 	mrs	r8, spsr			@ called from non-FIQ mode, so ok.
> 	str	lr, [sp, #S_PC]			@ Save calling PC
> 	str	r8, [sp, #S_PSR]		@ Save CPSR
> 	str	r0, [sp, #S_OLD_R0]		@ Save OLD_R0
> 	zero_fp
> 
> 	/*
> 	 * Get the system call number.
> 	 */
> 
> #if defined(CONFIG_OABI_COMPAT)
> 
> 	/*
> 	 * If we have CONFIG_OABI_COMPAT then we need to look at the swi
> 	 * value to determine if it is an EABI or an old ABI call.
> 	 */
> #ifdef CONFIG_ARM_THUMB
> 	tst	r8, #PSR_T_BIT
> 	movne	r10, #0				@ no thumb OABI emulation
> 	ldreq	r10, [lr, #-4]			@ get SWI instruction          // crash at this instruction, \
> when get SWI instruction #else
> 	ldr	r10, [lr, #-4]			@ get SWI instruction
>   A710(	and	ip, r10, #0x0f000000		@ check for SWI		)
>   A710(	teq	ip, #0x0f000000						)
>   A710(	bne	.Larm710bug						)
> #endif
> #ifdef CONFIG_CPU_ENDIAN_BE8
> 	rev	r10, r10			@ little endian instruction
> #endif
> 
> /************************************************************************************* \
> **************/
> 
> Then reason why it will crash when get SWI instruction is maybe 
> This page is clear to aged by kernel,
> But this MMU fault happpened in kernel,
> So the kernel do_page_fault function will not clear this page to young,
> So that  will crash .
> 
> It should poll this page to make it present or the fault should be handled by fixup \
> section , Anyway, this place should not crash by kernel .
> 
> The kernel version I used  is  3.4.0
> I have add the kernel log and the call stack recovered  by trace32 tools 
> Pls have a look at it .
> 
> 
