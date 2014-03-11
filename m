Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaCKNAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:00:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:60398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbaCKNAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:00:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="489751314"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: "can't evaluate _CRS: 1" messages since b355cee [ACPI /
 resources: ignore invalid ACPI device resources]
Thread-Topic: "can't evaluate _CRS: 1" messages since b355cee [ACPI /
 resources: ignore invalid ACPI device resources]
Thread-Index: AQHPPQYgy2nXtxFXAECTqpl1notGyprbU12AgACDXnA=
Date: Tue, 11 Mar 2014 12:59:47 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B9092630120179D@SHSMSX103.ccr.corp.intel.com>
References: <20140311084409.GA282@x4> <1586607.L4KMXXX471@vostro.rjw.lan>
In-Reply-To: <1586607.L4KMXXX471@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2BD0WTK025512

I think the reason problem is that:
1. there are zero length IO/Memory resources for these machines, and for those resources
   a) w/o commit b355cee88e3b1a193f0e9a81db810f6f83ad728b, acpi_dev_resource_memory/io returns true 
   b) w commit b355cee88e3b1a193f0e9a81db810f6f83ad728b, acpi_dev_resource_memory/io returns false
2. in pnpacpi_allocated_resource(), when acpi_dev_resource_memory/io() returns false, it translates into "the resource is not IO/Memory resource".

IMO, the root cause is that the BOOL return value of acpi_dev_resource_memory/io() can not represent the following three situations
1) a valid IO/Memory resource
2) an invalid IO/Memory resource
3) not an IO/Memory resource

Thanks,
rui
> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> Sent: Tuesday, March 11, 2014 9:00 PM
> To: Markus Trippelsdorf
> Cc: linux-acpi@vger.kernel.org; Zhang, Rui; Wysocki, Rafael J; linux-
> kernel@vger.kernel.org
> Subject: Re: "can't evaluate _CRS: 1" messages since b355cee [ACPI /
> resources: ignore invalid ACPI device resources]
> Importance: High
> 
> On Tuesday, March 11, 2014 09:44:09 AM Markus Trippelsdorf wrote:
> > Since:
> >  commit b355cee88e3b1a193f0e9a81db810f6f83ad728b
> >  Author: Zhang Rui <rui.zhang@intel.com>
> >  Date:   Thu Feb 27 11:37:15 2014 +0800
> >
> >      ACPI / resources: ignore invalid ACPI device resources
> >
> > The following error message is printed three times during boot on my
> > machine: "can't evaluate _CRS: 1"
> 
> It may be catching a BIOS bug actually.
> 
> Please attach the output of acpidump from that system.
> 
> > Here's the dmesg diff:
> >
> > @@ -308,6 +308,8 @@
> >  Switched to clocksource hpet
> >  pnp: PnP ACPI init
> >  ACPI: bus type PNP registered
> > +pnp 00:00: unknown resource type 10 in _CRS pnp 00:00: can't
> evaluate
> > +_CRS: 1
> >  system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)  pnp
> > 00:01: [dma 4]  pnp 00:01: Plug and Play ACPI device, IDs PNP0200
> > (active) @@ -318,6 +320,8 @@  system 00:06: [mem
> > 0xfec00000-0xfec00fff] could not be reserved  system 00:06: [mem
> > 0xfee00000-0xfee00fff] has been reserved  system 00:06: Plug and Play
> > ACPI device, IDs PNP0c02 (active)
> > +pnp 00:07: unknown resource type 4 in _CRS pnp 00:07: can't evaluate
> > +_CRS: 1
> >  system 00:07: [io  0x04d0-0x04d1] has been reserved  system 00:07:
> > [io  0x040b] has been reserved  system 00:07: [io  0x04d6] has been
> > reserved @@ -334,19 +338,9 @@  system 00:07: [io  0x0cd8-0x0cdf] has
> > been reserved  system 00:07: [io  0x0b00-0x0b3f] has been reserved
> > system 00:07: [io  0x0800-0x089f] could not be reserved -system 00:07:
> > [io  0x0b00-0x0b0f] has been reserved -system 00:07: [io
> > 0x0b20-0x0b3f] has been reserved -system 00:07: [io  0x0900-0x090f]
> > has been reserved -system 00:07: [io  0x0910-0x091f] has been
> reserved
> > -system 00:07: [io  0xfe00-0xfefe] has been reserved -system 00:07:
> > [mem 0xdff00000-0xdfffffff] has been reserved -system 00:07: [mem
> > 0xffb80000-0xffbfffff] has been reserved -system 00:07: [mem
> > 0xfec10000-0xfec1001f] has been reserved  system 00:07: Plug and Play
> > ACPI device, IDs PNP0c02 (active) -system 00:08: [io  0x0230-0x023f]
> > has been reserved -system 00:08: [io  0x0290-0x029f] has been
> reserved
> > -system 00:08: [io  0x0f40-0x0f4f] has been reserved -system 00:08:
> > [io  0x0a30-0x0a3f] has been reserved
> > +pnp 00:08: unknown resource type 4 in _CRS pnp 00:08: can't evaluate
> > +_CRS: 1
> >  system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> system
> > 00:09: [mem 0xe0000000-0xefffffff] has been reserved  system 00:09:
> > Plug and Play ACPI device, IDs PNP0c02 (active)
> >
> >
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
