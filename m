Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaETHsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:48:20 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55797 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaETHsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:48:18 -0400
Date: Tue, 20 May 2014 08:48:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org, Carlo Caione <carlo@caione.org>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com
Subject: Re: [RFC PATCH 1/3] mfd: AXP22x: add support for APX221 PMIC
Message-ID: <20140520074810.GE20874@lee--X1>
References: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
 <1400176305-22737-2-git-send-email-boris.brezillon@free-electrons.com>
 <20140519172817.GE20435@lee--X1>
 <537A4324.4060905@free-electrons.com>
 <537B06A0.3040706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537B06A0.3040706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> This patch introduces preliminary support for the X-Powers AXP221 PMIC.
> >>> The AXP221 is typically used on boards using Allwinner's A31 SoC.
> >>>
> >>> At the moment, this driver only exposes regulator devices, but other
> >>> subdevices.
> >>>
> >>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >>> ---
> >>>  drivers/mfd/Kconfig        |  12 +++
> >>>  drivers/mfd/Makefile       |   1 +
> >>>  drivers/mfd/axp22x.c       | 237 +++++++++++++++++++++++++++++++++++++++++++++
> >>>  include/linux/mfd/axp22x.h | 149 ++++++++++++++++++++++++++++
> >>>  4 files changed, 399 insertions(+)
> >>>  create mode 100644 drivers/mfd/axp22x.c
> >>>  create mode 100644 include/linux/mfd/axp22x.h
> >> Not a chance.
> >>
> >> Farrrr, too much common code with axp20x.c - please merge into one file.
> >>
> > 
> > This was one of the questions I asked in my cover letter (could you take
> > a look at it and tell me what's your prefered solution ?) ;-).
> > 
> > I first tried to reuse the axp20x drivers, but ended up copying almost
> > all definitions, hence I decided to first do a different driver and ask
> > for advices.
> 
> I've just taken a good look at this (I'm planning on doing an axp152 driver
> myself), and it seems that using a single mfd driver for the 20x and 221 should
> be quite feasible:
> 
> - axp20x.h would get some new register defines for registers which are
>   different (or unique) to the 221 prefixed with aXP221
> - An axp20x_writeable_ranges would need
>   to be extended with a third range going from AXP221_BAT_CAP1 (0xe0)
>   to AXP221_BAT_LOW_THRESH (0xe6)
> - axp20x_writeable_table would get .n_yes_ranges set to 2, and a new
>   apx22x_writeable_table would be introduced with n_yes_ranges set to 3.
> - add a new axp221_supplies array
> - add a new axp221_cells array
> - and finally use the proper structs in axp20x_i2c_probe depending on the type
> 
> Note that this means sharing ie the interrupt table, which is ok since they
> are the same, except that the 221 has a couple of interrupts missing, but
> the ones which are shared are all at the same place.

Exactly.  As .probe() is identical, you only require some device
matching and some extra structs where the data actually differs
between devices.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
