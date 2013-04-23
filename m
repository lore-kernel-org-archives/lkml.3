Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3DWJPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:15:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46368 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756003Ab3DWJPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:15:49 -0400
Date: Tue, 23 Apr 2013 10:15:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
Message-ID: <20130423091536.GB17593@mudshark.cambridge.arm.com>
References: <517168BB.3070903@dawncrow.de>
 <20130422143616.GP14496@n2100.arm.linux.org.uk>
 <20130422151836.GA15665@mudshark.cambridge.arm.com>
 <5175A697.3080308@dawncrow.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5175A697.3080308@dawncrow.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 10:07:35PM +0100, André Hentschel wrote:
> Am 22.04.2013 17:18, schrieb Will Deacon:
> > On Mon, Apr 22, 2013 at 03:36:16PM +0100, Russell King - ARM Linux wrote:
> >> On Fri, Apr 19, 2013 at 05:54:35PM +0200, André Hentschel wrote:
> >>> From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
> >>>
> >>> There are more and more applications coming to WinRT, Wine could support them,
> >>> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
> >>> This register must be preserved per thread instead of being cleared.
> >>>
> >>> Signed-off-by: André Hentschel <nerv@dawncrow.de>
> >>
> >> This actually makes things less efficient all round, because you
> >> now use the value immediately after loading, which means it will cause
> >> pipeline stalls, certainly on older CPUs.
> >>
> >> Could you please rework the patch to try avoiding soo many modifications
> >> to the way things have been done here?
> > 
> > copy_thread also needs updating so that the *register* value for the parent
> > is copied to the child, since the parent may have written the register
> > after the last context-switch, meaning that tp_value is out-of-date.
> 
> Thank you both for reviewing.
> 
> I guess you mostly mean "ldr	r6, [r2, #TI_CPU_DOMAIN]".
> I just thought about old CPUs and remembered again that we at Wine
> need that patch only on v7 (and later). So is it ok to introduce a set_tls_v7
> in tls.h and make use of CONFIG_CPU_V7 compile-time check in
> the changed files and in the copy_thread function?

No, we should support this feature on any CPU with the TPIDRURW register,
otherwise it's going to get really confusing for userspace.

> Do i need any further flag checks in copy_thread or can i use the
> compile-time check to add unconditional code?

You could introduce `get' tls functions, which don't do anything for CPUs
without the relevant registers.

Will
