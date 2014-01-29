Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaA2S1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:27:10 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38861 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaA2S1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:27:08 -0500
Date: Wed, 29 Jan 2014 18:28:05 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Message-ID: <20140129182805.GF11329@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
 <20140122112055.GF1621@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122112055.GF1621@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 11:20:55AM +0000, Will Deacon wrote:
> > +#ifdef CONFIG_CPU_CP15
> > +/* Macro for setting/clearing bits in sctlr */
> > +	.macro update_sctlr, set:req, clear:req, tmp:req, tmp2:req
> > +	mrc	p15, 0, \tmp, c1, c0, 0
> > +	ldr	\tmp2, =\set
> > +	orr	\tmp, \tmp, \tmp2
> > +	ldr	\tmp2, =\clear
> > +	mvn	\tmp2, \tmp2
> > +	and	\tmp, \tmp, \tmp2
> > +	mcr	p15, 0, \tmp, c1, c0, 0
> 
> I think this would be cleaner if you force the caller to put set and clear
> into registers beforehand, rather than have to do the literal load every
> time. Also, I don't think set and clear should be required (and then you can
> lose tmp2 as well).

I can't figure out how to make register-parameters non-required
(i.e. conditionalise on whether an optional parameter was provided),
so my attempt of refactoring actually ends up using an additional
register:

#ifdef CONFIG_CPU_CP15
/* Macro for setting/clearing bits in sctlr */
	.macro	update_sctlr, set:req, clear:req, tmp:req
	mrc	p15, 0, \tmp, c1, c0, 0
	orr	\tmp, \set
	mvn	\clear, \clear
	and	\tmp, \tmp, \clear
	mcr	p15, 0, \tmp, c1, c0, 0
	.endm
#endif

If you think that's an improvement I can do that, and I have (just)
enough registers to spare.
If I'm being daft with my macro issues, do point it out.

/
    Leif
