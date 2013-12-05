Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3LEN4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:56:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:10305 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab3LEN4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:56:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,833,1378882800"; 
   d="scan'208";a="419890400"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Lu, Aaron" <aaron.lu@intel.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: RE: [PATCH 0/4] Convert ACPI fan driver to platform driver
Thread-Topic: [PATCH 0/4] Convert ACPI fan driver to platform driver
Thread-Index: AQHO8AG7IqGhYDMw+UKvrRUIsoohAZpEJReAgAAAkoCAAXOdoA==
Date: Thu, 5 Dec 2013 13:56:24 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B909263011B057A@SHSMSX101.ccr.corp.intel.com>
References: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
 <1654759.afJtadVnDQ@vostro.rjw.lan> <1539785.BAHHmmHfI6@vostro.rjw.lan>
In-Reply-To: <1539785.BAHHmmHfI6@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB5Dv3Tl008648



> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Thursday, December 05, 2013 7:10 AM
> To: Lu, Aaron
> Cc: Zhang, Rui; linux-acpi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Lan, Tianyu; Brown, Len; Matthew Garrett
> Subject: Re: [PATCH 0/4] Convert ACPI fan driver to platform driver
> Importance: High
> 
> Cc: +Matthew (sorry, omitted by mistake previously)
> 
> On Thursday, December 05, 2013 12:07:31 AM Rafael J. Wysocki wrote:
> > On Tuesday, December 03, 2013 04:28:28 PM Aaron Lu wrote:
> > > This patchset converts ACPI fan driver to platform driver. Patch 1-
> 3
> > > are cleanups for existing fan driver and patch 4 does the
> convertion.
> > >
> > > Tested on harris beach.
> > > Apply on top of Rafael's linux-next branch.
> > >
> > > Aaron Lu (4):
> > >   ACPI / fan: remove unused macro for debug
> > >   ACPI / fan: remove no need check for device pointer
> > >   ACPI / fan: use acpi_device_xxx_power instead of acpi_bus
> equivelant
> > >   ACPI / fan: convert to platform driver
> > >
> > >  drivers/acpi/acpi_platform.c |  3 ++
> > >  drivers/acpi/device_pm.c     |  1 +
> > >  drivers/acpi/fan.c           | 88 ++++++++++++++++----------------
> ------------
> > >  drivers/acpi/internal.h      |  2 -
> > >  include/acpi/acpi_bus.h      |  1 +
> > >  5 files changed, 36 insertions(+), 59 deletions(-)
> >
> > Unfortunately, we need to postpone these conversions, because Matthew
> > Garrett has problems with adding more entries to
> > acpi_platform_device_ids[].  He seems to be concerned that that list
> > will grow indefinitely and will become difficult to maintain
> eventually.
> >
> > For this reason, he would prefer it if we did the following:
> > - Figure out the list of ACPI device IDs we need to create PNP
> devices for
> >   via ACPI PNP.

Agreed.
I'd also prefer a whitelist for pnpacpi instead of a backlist.
And this is helpful for us to clean up the ACPI code in PNP bus,
Including pnpacpi code and PNP drivers that actually bind to
ACPI enumerated PNP devices.

Question is how to get this white list?
Can we just collect the pnp_device_id in all the PNP drivers as the first step?

> > - Make ACPI PNP create PNP devices for these IDs only and make the
> ACPI core create
> >   platform devices for all "unassigned" ACPI device objects by
> default.

So the above statement means that an ACPI device will be enumerated
to either PNP bus or platform bus, right?
Then I'm wondering how to handle the following cases,
1. an ACPI device may have both _HID and _CID, if its _CID is in the
   PNP whitelist, does this mean the device will always be enumerated
   to PNP bus?
2. is it possible to see the following ASL code?
   Device (ABCDEFG) /* should be enumerated to platform bus */
   {
     Device (PNPABCD) /* should be enumerated to PNP bus */
     {
     }
   }
   If yes, it seems that we will introduce some ugly parent/child
   relationship in driver core?

> > - Do the conversions at that point.
> >
> > I'm slightly worried that we'll encounter ordering issues while doing
> > that, but this is the only way forward I can see without going
> > straight against the Matthew's objections, which I'd prefer to avoid.
> >
Maybe a stupid question, why can't we enumerate all ACPI devices to
platform bus? Here are some of my thoughts,
1. enumerate all ACPI devices to platform bus, thus our ACPI -> platform bus
   conversion work can continue.
2. workout a white list for PNPACPI (by collecting all the pnp_device_ids)
3. cleanup the PNP drivers.
   If a PNP driver is supposed to bind to ACPI enumerated PNP devices,
   convert it to a platform driver.
   If a PNP driver can probe device enumerated from either PNPBIOS or PNPACPI,
   make it a dual-head driver that can probe both PNP and platform devices.
   If a PNP driver is supposed to bind to PNPBIOS enumerated PNP devices,
   leave it as it is.
   Note: every time we have done the cleanup for a driver,
         we can delete one entry in the PNPACPI whitelist in step 2.
4. after cleanup all the PNP drivers, the whitelist is empty
   and we can remove all the PNPACPI code.

Thanks,
rui
> > Thanks,
> > Rafael
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
