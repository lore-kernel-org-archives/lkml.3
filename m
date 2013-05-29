Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965516Ab3E2JtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:49:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40369 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964948Ab3E2Js7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:48:59 -0400
Date: Wed, 29 May 2013 10:48:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: A bug about system call on ARM
Message-ID: <20130529094826.GD13095@mudshark.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D1610991B85B@CNBJMBX05.corpusers.net>
 <CAFLxGvy39xWdZmtiVHP+y=zH1coCVmMuREcmD25wSb=w-VK7Xg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D1610991B85D@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B85E@CNBJMBX05.corpusers.net>
 <CAFLxGvyy=73dGQqG8W6SXZah7WQZ4gJAeeHXN8opKaOuG-5yUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvyy=73dGQqG8W6SXZah7WQZ4gJAeeHXN8opKaOuG-5yUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 29, 2013 at 09:46:42AM +0100, richard -rw- weinberger wrote:
> On Wed, May 29, 2013 at 10:24 AM, Wang, Yalin <Yalin.Wang@sonymobile.com> wrote:
> > I have download the latest linux kernel code  3.9.4
> > And Compare with  3.4.0 kernel .
> >
> > It seems there is no change for this part ,
> > So it will still happen .
> > Does anyone know who is responsible for  arm arch part kernel code ?
> 
> See MAINTAINERS file.
> CC'ing linux-arm-kernel@lists.infradead.org

Cheers for adding us to CC.

> >> #ifdef CONFIG_ARM_THUMB
> >>         tst     r8, #PSR_T_BIT
> >>         movne   r10, #0                         @ no thumb OABI emulation
> >>         ldreq   r10, [lr, #-4]                  @ get SWI instruction          // crash at this instruction, when get SWI instruction

Do you have the panic log please? Also, which SoC are you using and how are
you reproducing this?

> >>         ldr     r10, [lr, #-4]                  @ get SWI instruction
> >>   A710( and     ip, r10, #0x0f000000            @ check for SWI         )
> >>   A710( teq     ip, #0x0f000000                                         )
> >>   A710( bne     .Larm710bug                                             )
> >> #endif
> >> #ifdef CONFIG_CPU_ENDIAN_BE8
> >>         rev     r10, r10                        @ little endian instruction
> >> #endif
> >>
> >> /*********************************************************************
> >> ******************************/
> >>
> >> Then reason why it will crash when get SWI instruction is maybe This
> >> page is clear to aged by kernel, But this MMU fault happpened in
> >> kernel, So the kernel do_page_fault function will not clear this page
> >> to young, So that  will crash .

Sounds like we might need some USER annotations around the instruction
loads, but we should also rework the code so that we re-enable interrupts
first.

Will
