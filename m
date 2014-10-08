Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaJHJQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:16:15 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:65533 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbaJHJQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:16:12 -0400
MIME-Version: 1.0
In-Reply-To: <20141008080515.GC20647@lee--X1>
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
	<1410229968-11638-3-git-send-email-aaron.lu@intel.com>
	<20141008080515.GC20647@lee--X1>
Date: Wed, 8 Oct 2014 11:16:11 +0200
Message-ID: <CACRpkdaPFzq=Qya_UoZpxHom+VcynTwQL9EfdLb_Vpr=g6+Prg@mail.gmail.com>
Subject: Re: [PATCH 2/2] PMIC / opregion: support PMIC customized operation
 region for CrystalCove
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 10:05 AM, Lee Jones <lee.jones@linaro.org> wrote:

> With the influx of new same-chip devices, I think the MFD subsystem is
> fast becoming overloaded.  I think all of the PMIC handling should in
> fact either live in Regulators or have its own subsystem.

You have a valid point, and it's been raised before that MFD risk being
a dumping ground of the same kind that drivers/misc used to be (is?).

PMIC (Power Management Integrated Circuit) is often not even a
correct name for the thing if it contains things like audio amplifiers
USB PHY intrerfaces or LED boosters as some do.

MSIC (Mixed-Signal Integrated Circuit) is the correct name for
silicon that is created as a one-stop shop for anything combining
digital and analog constructions, often in a higher micron node
(not as densely integrated) as a digital IC (the latter referred to
as SoCs, "baseband", "CPU" and whatnot).

If they shall live in MFD the driver there should (IMHO) just be
an exchange station, multiplexing messages and spawning
MFD cells into platform devices for respective *real* subsystem,
various misc stuff should not be allowed to be shoehorned
into MFD just because there is no other place to put it.

This driver clearly does not qualify, look:

> +static int intel_crc_pmic_update_power(struct regmap *regmap,
> +                                    struct pmic_pwr_reg *preg, bool on)
> +{
> +     int data;
> +
> +     if (regmap_read(regmap, preg->reg, &data))
> +             return -EIO;
> +
> +     if (on) {
> +             data |= PWR_SOURCE_SELECT | BIT(preg->bit);
> +     } else {
> +             data &= ~BIT(preg->bit);
> +             data |= PWR_SOURCE_SELECT;
> +     }
> +
> +     if (regmap_write(regmap, preg->reg, data))
> +             return -EIO;
> +     return 0;
> +}

Selecting power source? Isn't that something and MFD cell
spawned driver in either drivers/regulator or drivers/power should
be doing?

I know I have sinned in this regard in the past. But let's move
forward with defining what this subsystem should *REALLY*
be.

Yours,
Linus Walleij
