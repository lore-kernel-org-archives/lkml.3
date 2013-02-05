Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3BERPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:15:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35918 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab3BERPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:15:35 -0500
Date: Tue, 5 Feb 2013 17:14:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Cyril Chemparathy <cyril@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, balbi@ti.com,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        "Nair, Sandeep" <sandeep_n@ti.com>, Chris Ball <cjb@laptop.org>,
        Matt Porter <mporter@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
	arm/common
Message-ID: <20130205171451.GE17852@n2100.arm.linux.org.uk>
References: <510FF1A6.403@mvista.com> <20130204164712.GB4269@arwen.pp.htv.fi> <510FF5C9.3030600@mvista.com> <20130204170216.GC4269@arwen.pp.htv.fi> <51100A72.6030909@ti.com> <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com> <20130204203358.GX4720@opensource.wolfsonmicro.com> <CACRpkdbPyZt8=pLhz-5qcaSSAk6VBn61dPTNp6teU9HksBwN2w@mail.gmail.com> <51102E25.8040107@ti.com> <CACRpkdaUQ60W8Vmg3MpvP5uV+3jD3y4+9V2et4Ni+z-7k=aFTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaUQ60W8Vmg3MpvP5uV+3jD3y4+9V2et4Ni+z-7k=aFTg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:30:45PM +0100, Linus Walleij wrote:
> On Mon, Feb 4, 2013 at 10:54 PM, Cyril Chemparathy <cyril@ti.com> wrote:
> > On 02/04/2013 04:11 PM, Linus Walleij wrote:
> 
> >> Cyril, just stack up the cookies and take a sweep over them to see
> >> which ones are baked when the NAPI poll comes in -> problem
> >> solved.
> >
> > You're assuming that cookies complete in order.  That is not necessarily
> > true.
> 
> So put them on a wait list? Surely you will have a list of pending
> cookies and pick from the front of the queue if there isn't a hole on
> queue position 0.

Not quite.  The key is the cookie system DMA engine employs to indicate
when a cookie is complete.

Cookies between the "issued sequence" and "completed sequence" are defined
to be in progress, everything else is defined to be completed.

This means that if "completed sequence" is 1, and "issued sequence" is 5,
then cookies with values 2, 3, 4, 5 are in progress.  You can't mark
sequence 4 as being complete until 2 and 3 have completed.

If we need out-of-order completion, then that's a problem for the DMA
engine API, because you'd need to radically change the way "completion"
is marked.
