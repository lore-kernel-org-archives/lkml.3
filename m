Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaASKCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 05:02:51 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41626 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751614AbaASKCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 05:02:46 -0500
Date: Sun, 19 Jan 2014 10:02:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Amarinder Bindra <a-bindra@ti.com>, Balaji T K <balajitk@ti.com>,
        Chris Ball <cjb@laptop.org>, linux-sh@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmc: omap_hsmmc: Restrict compilation to ARM
Message-ID: <20140119100235.GN27282@n2100.arm.linux.org.uk>
References: <1390123794-26401-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390123794-26401-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 10:29:54AM +0100, Geert Uytterhoeven wrote:
> commit bcf24e1daa94f4c52ef7a3f657e43cc6bc50d46b ("mmc: omap_hsmmc: use the
> generic config for omap2plus devices"), enabled the build for other
> platforms for compile testing.
> 
> sh-allmodconfig now fails with:
> 
>     include/linux/omap-dma.h:171:8: error: expected identifier before numeric constant
>     make[4]: *** [drivers/mmc/host/omap_hsmmc.o] Error 1
> 
> This happens because sh #defines "CCR", which is one of the enum values in
> include/linux/omap-dma.h.
> 
> I expect a similar failure on blackfin, which also has #define CCR.
> 
> Restrict the build to ARM to fix this.

This isn't the right fix.  When this has happened on ARM in the past, we've
had a lot of pressure to change the definition since it's far too generic.

"CCR" should only be used for stuff which is restricted to (eg) one driver,
and not in some system wide header file included by lots of files.

In the case of OMAP, the unfortunate thing is that include/linux/omap-dma.h
was moved lock stock and barrel out of the ARM-private includes.  It
really needs splitting up in two - one which drivers are expected to
include, and the other for shared definitions between arch/arm/*omap*/dma.c
and drivers/dma/omap-dma.c.

Even so, "CCR" will still exist - but will be localised to the compilation
units which need it.  The same should happen with SH.

So, as for this patch, that's a NAK.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
