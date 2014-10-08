Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbaJHL6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:58:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:49685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbaJHL6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:58:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,677,1406617200"; 
   d="scan'208";a="585311918"
Date: Wed, 8 Oct 2014 04:58:12 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        Daniel =?UTF-8?B?R2zDtmNrbmVy?= <dg@emlix.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 2/2] PMIC / opregion: support PMIC customized operation
 region for CrystalCove
Message-ID: <20141008045812.734a24db@ultegra>
In-Reply-To: <CACRpkdaPFzq=Qya_UoZpxHom+VcynTwQL9EfdLb_Vpr=g6+Prg@mail.gmail.com>
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
	<1410229968-11638-3-git-send-email-aaron.lu@intel.com>
	<20141008080515.GC20647@lee--X1>
	<CACRpkdaPFzq=Qya_UoZpxHom+VcynTwQL9EfdLb_Vpr=g6+Prg@mail.gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2014 11:16:11 +0200
Linus Walleij <linus.walleij@linaro.org> wrote:

> On Wed, Oct 8, 2014 at 10:05 AM, Lee Jones <lee.jones@linaro.org>
> wrote:
> 
> > With the influx of new same-chip devices, I think the MFD subsystem
> > is fast becoming overloaded.  I think all of the PMIC handling
> > should in fact either live in Regulators or have its own subsystem.
> 
> You have a valid point, and it's been raised before that MFD risk
> being a dumping ground of the same kind that drivers/misc used to be
> (is?).
> 
> PMIC (Power Management Integrated Circuit) is often not even a
> correct name for the thing if it contains things like audio amplifiers
> USB PHY intrerfaces or LED boosters as some do.
> 
> MSIC (Mixed-Signal Integrated Circuit) is the correct name for
> silicon that is created as a one-stop shop for anything combining
> digital and analog constructions, often in a higher micron node
> (not as densely integrated) as a digital IC (the latter referred to
> as SoCs, "baseband", "CPU" and whatnot).
> 
> If they shall live in MFD the driver there should (IMHO) just be
> an exchange station, multiplexing messages and spawning
> MFD cells into platform devices for respective *real* subsystem,
> various misc stuff should not be allowed to be shoehorned
> into MFD just because there is no other place to put it.
> 
I agree since in most cases there are not much common code to
consolidate among cell drivers. MFD is convenient as an exchange
station as you pointed out but the same time, drivers can create their
own platform devices without MFD. Perhaps we can add a set of MFD
internal APIs for PMIC for the things are common, e.g.
- regmap
- irq chip

> This driver clearly does not qualify, look:
> 
ACPI is kind of special since it is already an abstraction of the HW
making it easy to consolidate code. Perhaps that is why Aaron provides
the kind of callbacks for each PMIC.
> > +static int intel_crc_pmic_update_power(struct regmap *regmap,
> > +                                    struct pmic_pwr_reg *preg,
> > bool on) +{
> > +     int data;
> > +
> > +     if (regmap_read(regmap, preg->reg, &data))
> > +             return -EIO;
> > +
> > +     if (on) {
> > +             data |= PWR_SOURCE_SELECT | BIT(preg->bit);
> > +     } else {
> > +             data &= ~BIT(preg->bit);
> > +             data |= PWR_SOURCE_SELECT;
> > +     }
> > +
> > +     if (regmap_write(regmap, preg->reg, data))
> > +             return -EIO;
> > +     return 0;
> > +}
> 
> Selecting power source? Isn't that something and MFD cell
> spawned driver in either drivers/regulator or drivers/power should
> be doing?
> 
The difference in this case is that opregion handler driver does not
need the interfaces provided by sys/class/power_supply, or regulator
etc. By moving them away from the opregion common code, you would need
to export the APIs. I think we can have opregion code under
drivers/acpi?
> I know I have sinned in this regard in the past. But let's move
> forward with defining what this subsystem should *REALLY*
> be.
> 

> Yours,
> Linus Walleij

[Jacob Pan]
