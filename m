Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156Ab3E2IY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:24:29 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:19627 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964992Ab3E2IY0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:24:26 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'richard -rw- weinberger'" <richard.weinberger@gmail.com>
CC: "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 29 May 2013 16:24:14 +0800
Subject: RE: A bug about system call on ARM
Thread-Topic: A bug about system call on ARM
Thread-Index: Ac5cPvzjYaBEBPWJTwuyQi2e6ELslQAAFfwQAAE/DfA=
Message-ID: <35FD53F367049845BC99AC72306C23D1610991B85E@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1610991B85B@CNBJMBX05.corpusers.net>
 <CAFLxGvy39xWdZmtiVHP+y=zH1coCVmMuREcmD25wSb=w-VK7Xg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D1610991B85D@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D1610991B85D@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  

I have download the latest linux kernel code  3.9.4
And Compare with  3.4.0 kernel .

It seems there is no change for this part ,
So it will still happen .
Does anyone know who is responsible for  arm arch part kernel code ?


Thanks  


-----Original Message-----
From: Wang, Yalin 
Sent: Wednesday, May 29, 2013 3:38 PM
To: 'richard -rw- weinberger'
Cc: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: RE: A bug about system call on ARM

Hi  Richard,

Thanks for your reply ,
I will make a check for this .


-----Original Message-----
From: richard -rw- weinberger [mailto:richard.weinberger@gmail.com]
Sent: Wednesday, May 29, 2013 3:35 PM
To: Wang, Yalin
Cc: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: A bug about system call on ARM

Hi!

On Wed, May 29, 2013 at 8:52 AM, Wang, Yalin <Yalin.Wang@sonymobile.com> wrote:
> Hi  all,
>
> I am a new comer to this mailing list , I am happy to join this 
> community .
>
> I have a bug reported from our android phones which is caused by  the system call .
> It seems like kernel bugs from my view .

Is this a unmodified Linux kernel from kernel.org? In other works, no (half broken) board support package from your hardware vendor?
Did you try a more recent kernel? (At least 3.4.47).
Maybe your problem is already known and fixed...

> Crash in  file  arch\arm\kernel\ entry-common.S
>
> /***************************************************************/
>
> ENTRY(vector_swi)
>         sub     sp, sp, #S_FRAME_SIZE
>         stmia   sp, {r0 - r12}                  @ Calling r0 - r12
>  ARM(   add     r8, sp, #S_PC           )
>  ARM(   stmdb   r8, {sp, lr}^           )       @ Calling sp, lr
>  THUMB( mov     r8, sp                  )
>  THUMB( store_user_sp_lr r8, r10, S_SP  )       @ calling sp, lr
>         mrs     r8, spsr                        @ called from non-FIQ mode, so ok.
>         str     lr, [sp, #S_PC]                 @ Save calling PC
>         str     r8, [sp, #S_PSR]                @ Save CPSR
>         str     r0, [sp, #S_OLD_R0]             @ Save OLD_R0
>         zero_fp
>
>         /*
>          * Get the system call number.
>          */
>
> #if defined(CONFIG_OABI_COMPAT)
>
>         /*
>          * If we have CONFIG_OABI_COMPAT then we need to look at the swi
>          * value to determine if it is an EABI or an old ABI call.
>          */
> #ifdef CONFIG_ARM_THUMB
>         tst     r8, #PSR_T_BIT
>         movne   r10, #0                         @ no thumb OABI emulation
>         ldreq   r10, [lr, #-4]                  @ get SWI instruction          // crash at this instruction, when get SWI instruction
> #else
>         ldr     r10, [lr, #-4]                  @ get SWI instruction
>   A710( and     ip, r10, #0x0f000000            @ check for SWI         )
>   A710( teq     ip, #0x0f000000                                         )
>   A710( bne     .Larm710bug                                             )
> #endif
> #ifdef CONFIG_CPU_ENDIAN_BE8
>         rev     r10, r10                        @ little endian instruction
> #endif
>
> /*********************************************************************
> ******************************/
>
> Then reason why it will crash when get SWI instruction is maybe This 
> page is clear to aged by kernel, But this MMU fault happpened in 
> kernel, So the kernel do_page_fault function will not clear this page 
> to young, So that  will crash .
>
> It should poll this page to make it present or the fault should be 
> handled by fixup section , Anyway, this place should not crash by kernel .
>
> The kernel version I used  is  3.4.0
> I have add the kernel log and the call stack recovered  by trace32 
> tools Pls have a look at it .
>
>
> Thanks .
>
>
>
> Sony Mobile Communications
> Tel: +86 10 5966 9819
> Phone: 18610323092
> Address: No.16 Guangshun South Street, Chaoyang, Beijing, P.R.C.
>
> sonymobile.com
>
>
>



--
Thanks,
//richard
