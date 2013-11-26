Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3KZAcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:32:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:26031 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab3KZAcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:32:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,771,1378882800"; 
   d="scan'208";a="439757365"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <zetalog@gmail.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [UPDATE PATCH 4/4] ACPI: Add support to force header inclusion
 rules for <linux/acpi.h>.
Thread-Topic: [UPDATE PATCH 4/4] ACPI: Add support to force header inclusion
 rules for <linux/acpi.h>.
Thread-Index: AQHO6joITc2HYruZ20SIv3NQMx0ZRpo2qMfg
Date: Tue, 26 Nov 2013 00:32:12 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880248D7FE@SHSMSX101.ccr.corp.intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
 <2930f1fabbb8319c11180c8db3d1693adc71aac1.1385163359.git.lv.zheng@intel.com>
 <5998708.qlCSNdGapO@vostro.rjw.lan>
In-Reply-To: <5998708.qlCSNdGapO@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAQ0WR8p007857

Hi, Rafael

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, November 26, 2013 8:10 AM
> To: Lv Zheng
> Cc: Wysocki, Rafael J; Brown, Len; Zheng, Lv; linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org
> Subject: Re: [UPDATE PATCH 4/4] ACPI: Add support to force header inclusion rules for <linux/acpi.h>.
> 
> On Saturday, November 23, 2013 07:54:18 AM Lv Zheng wrote:
> > From: Lv Zheng <lv.zheng@intel.com>
> >
> > (Update due to some typo fixes.)
> >
> > As there is only CONFIG_ACPI=n processing in the <linux/acpi.h>, it is not
> > safe to include <acpi/acpi.h>, <acpi/acpi_drivers.h> and <acpi/acpi_bus.h>
> > directly for source out of Linux ACPI subsystems.
> >
> > This patch adds error messaging to warn developers of such wrong
> > inclusions.
> >
> > In order not to be bisected and reverted as a wrong commit, warning
> > messages are carefully split into a seperate patch other than the wrong
> > inclusion cleanups.
> >
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> 
> I don't like this one to be honest.

I generate this to prevent device driver writers to do stupid things before we can sort <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> out.

> 
> > ---
> >  drivers/acpi/acpica/Makefile    |    2 +-
> >  include/acpi/acpi_bus.h         |    5 +++++
> >  include/acpi/acpi_drivers.h     |    5 +++++
> >  include/acpi/platform/aclinux.h |   10 ++++++++++
> >  4 files changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
> > index 4383040..7738677 100644
> > --- a/drivers/acpi/acpica/Makefile
> > +++ b/drivers/acpi/acpica/Makefile
> > @@ -2,7 +2,7 @@
> >  # Makefile for ACPICA Core interpreter
> >  #
> >
> > -ccflags-y			:= -Os
> > +ccflags-y			:= -Os -DLINUXIZED_ACPICA
> 
> I don't like this (the naming and the way it is done).
> 
> >  ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
> >
> >  # use acpi.o to put all files here into acpi.o modparam namespace
> > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > index 0af9667..0b1ea80 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -26,6 +26,11 @@
> >  #ifndef __ACPI_BUS_H__
> >  #define __ACPI_BUS_H__
> >
> > +/* <acpi/acpi_bus.h> is not safe for CONFIG_ACPI=n environment */
> > +#ifndef _LINUX_ACPI_H
> > +#error "Please don't include <acpi/acpi_bus.h> directly, include <linux/acpi.h> instead."
> > +#endif
> 
> And this should either go into all of the <acpi/*.h> files, not only to the two
> of them you chose, or to none of them.  I prefer none.

OK, let it be done for now.  So we need to open eyes on new ACPI commits. :-)

I'll merge patch 2 and 3 and send it with your comments addressed and re-based.

Thanks and best regards
-Lv

> 
> Thanks,
> Rafael

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
