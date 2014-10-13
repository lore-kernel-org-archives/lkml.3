Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaJMObs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:31:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50095 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752509AbaJMObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:31:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-gpio@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
        linux-acpi@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 2/2] PMIC / opregion: support PMIC customized operation region for CrystalCove
Date: Mon, 13 Oct 2014 16:51:57 +0200
Message-ID: <1472711.eXHKSpNgJz@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141013090213.GB2829@aaronlu.sh.intel.com>
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com> <54365398.10701@intel.com> <20141013090213.GB2829@aaronlu.sh.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 13, 2014 05:02:13 PM Aaron Lu wrote:
> On Thu, Oct 09, 2014 at 05:21:28PM +0800, Aaron Lu wrote:
> > On 10/08/2014 04:05 PM, Lee Jones wrote:
> > > To all those CC'ed,
> > > 
> > >> The Baytrail-T platform firmware has defined two customized operation
> > >> regions for PMIC chip Crystal Cove - one is for power resource handling
> > >> and one is for thermal: sensor temperature reporting, trip point setting,
> > >> etc. This patch adds support for them on top of the existing Crystal Cove
> > >> PMIC driver.
> > >>
> > >> The reason to split code into a separate file intel_soc_pmic_opregion.c
> > >> is that there are more PMIC driver with ACPI operation region support
> > >> coming and we can re-use those code. The intel_soc_pmic_opregion_data
> > >> structure is created also for this purpose: when we need to support a
> > >> new PMIC's operation region, we just need to fill those callbacks and
> > >> the two register mapping tables.
> > >>
> > >> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > >> ---
> > >>  drivers/mfd/Kconfig                       |  11 +
> > >>  drivers/mfd/Makefile                      |   1 +
> > >>  drivers/mfd/intel_soc_pmic_crc.c          |   3 +
> > >>  drivers/mfd/intel_soc_pmic_crc_opregion.c | 229 +++++++++++++++++++
> > >>  drivers/mfd/intel_soc_pmic_opregion.c     | 350 ++++++++++++++++++++++++++++++
> > >>  drivers/mfd/intel_soc_pmic_opregion.h     |  35 +++
> > > 
> > > With the influx of new same-chip devices, I think the MFD subsystem is
> > > fast becoming overloaded.  I think all of the PMIC handling should in
> > > fact either live in Regulators or have its own subsystem.
> > > 
> > > Let's open this up to the floor by Cc'ing some probable interested
> > > parties.
> > 
> > The ACPI operation region handler provides implementation for the ASL
> > code written by firmware developer, and since the ACPI PMIC device node
> > has two customized operation regions: power rail handling and thermal
> > sensor manipulating, implementing the handler will inevitably touch
> > power rail registers and thermal registers of the PMIC chip. In this
> > regard, it doesn't fit what the MFD subsystem is meant to contain(
> > according to your comments, I didn't know this before, sorry about that).
> > 
> > It seems that we have two options:
> > 1 Create two cell devices from the PMIC I2C driver, one for power and
> >   one for thermal; the driver for the power part goes to drivers/power
> >   or drivers/regulator and the driver for thermal one goes to
> >   drivers/thermal;
> >   The problem of this approach is that, the operation region handler
> >   driver doesn't really need to expose those power or thermal sysfs
> >   interfaces for user space to consume, perhaps it shouldn't, as its
> >   sole purpose is to satisfy the ASL code access, not more.
> > 2 Move these operation region handler drivers to drivers/acpi
> >   We now have EC operation region handler driver there, but we also have
> >   I2C, GPIO, i915 operation region handlers in their own subsystems. Not
> >   sure if PMIC operation region handler qualifies there.
> 
> Rafael,
> 
> May I have your opinion on option 2? Do you think it is OK to place the
> operation region code under drivers/acpi? Thanks.

In my opinion, yes it is.  After all, operation regions are a mechanism by
which the AML interpreter can access hardware.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
