Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3EaDzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:55:03 -0400
Received: from relais.videotron.ca ([24.201.245.36]:44444 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3EaDy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:54:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 30 May 2013 23:54:56 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Will Deacon <will.deacon@arm.com>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: A bug about system call on ARM
In-reply-to: <20130530114112.GH7483@mudshark.cambridge.arm.com>
Message-id: <alpine.LFD.2.03.1305302319430.30828@syhkavp.arg>
References: <35FD53F367049845BC99AC72306C23D1610991B85B@CNBJMBX05.corpusers.net>
 <CAFLxGvy39xWdZmtiVHP+y=zH1coCVmMuREcmD25wSb=w-VK7Xg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D1610991B85D@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B85E@CNBJMBX05.corpusers.net>
 <CAFLxGvyy=73dGQqG8W6SXZah7WQZ4gJAeeHXN8opKaOuG-5yUQ@mail.gmail.com>
 <20130529094826.GD13095@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B865@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B866@CNBJMBX05.corpusers.net>
 <20130530090949.GC7483@mudshark.cambridge.arm.com>
 <20130530114112.GH7483@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Will Deacon wrote:

> On Thu, May 30, 2013 at 10:09:49AM +0100, Will Deacon wrote:
> > On Thu, May 30, 2013 at 02:41:42AM +0100, Wang, Yalin wrote:
> > > If you have some patch for this issue,
> > > I can do the test for it .
> > 
> > I'll have a look at cooking something which uses an exception table entry
> > to rewind the PC and retry the system call. That's simpler than directly
> > injecting a user page fault from the system call path.
> 
> Ok, please can you try the following?
> 
> Will
> 
> --->8
> 
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index bc5bc0a..855926e 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -361,6 +361,15 @@ ENTRY(vector_swi)
>  	str	r8, [sp, #S_PSR]		@ Save CPSR
>  	str	r0, [sp, #S_OLD_R0]		@ Save OLD_R0
>  	zero_fp
> +	enable_irq
> +	ct_user_exit
> +
> +#ifdef CONFIG_ALIGNMENT_TRAP
> +	ldr	ip, __cr_alignment
> +	ldr	ip, [ip]
> +	mcr	p15, 0, ip, c1, c0		@ update control register
> +#endif

This is wrong.  you must set up the align bit in the control register 
_before_ enabling IRQs or an IRQ handler might run without alignment 
fixup.

Otherwise the patch looks good to me.


Nicolas
