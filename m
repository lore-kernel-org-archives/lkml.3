Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaETCB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:01:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:16733 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbaETCB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:01:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,870,1392192000"; 
   d="scan'208";a="543246754"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] ACPI: Cleanup to convert acpi.no_static_ssdt
 into a compile-time configurable.
Thread-Topic: [PATCH v3 1/2] ACPI: Cleanup to convert acpi.no_static_ssdt
 into a compile-time configurable.
Thread-Index: AQHPc7I6UBG4YbIGO0WHUKMAgazcdJtH/H4AgAC6rpA=
Date: Tue, 20 May 2014 02:01:11 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880256A2FF@SHSMSX101.ccr.corp.intel.com>
References: <cover.1396925060.git.lv.zheng@intel.com>
 <5a2b1a503fbc65f63a18ca28727e023e5f48efcd.1399880919.git.lv.zheng@intel.com>
 <3194723.o46ouvvENe@vostro.rjw.lan> <7128235.yLzY3DMMj5@vostro.rjw.lan>
In-Reply-To: <7128235.yLzY3DMMj5@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4K21d57008240

Hi, Rafael

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, May 20, 2014 6:52 AM
> Subject: Re: [PATCH v3 1/2] ACPI: Cleanup to convert acpi.no_static_ssdt into a compile-time configurable.
> 
> On Tuesday, May 20, 2014 12:49:04 AM Rafael J. Wysocki wrote:
> > On Monday, May 12, 2014 03:49:59 PM Lv Zheng wrote:
> > > User can specify a DSDT with SSDT embedded, in which case, no_static_ssdt
> > > must be enforced during compile-time.  If we don't do that and forget to
> > > specify acpi.no_static_ssdt as a boot parameter, then:
> > > 1. The AML executable will be executed twice, the second execution is
> > >    running under a changed environment.
> > > 2. The namespace object conflicts will result in an AE_ALREADY_EXISTS
> > >    exception;
> > > 3. The namespace objects that are deleted from the original SSDT will be
> > >    restored by the auto loading of the original SSDT.
> > >
> > > Note that:
> > > 1. The DSDT customization is a compile-time feature, thus the SSDT
> > >    inclusion indication of the DSDT customization should also be
> > >    implemented as a compile-time configurable.
> > > 2. According to the commit log:
> > >     Commit: 67effe8fff32f60bdf51cba484766ba6003005bb
> > >     Subject: ACPI: add "acpi_no_auto_ssdt" bootparam
> > >    The acpi.no_static_ssdt (originally acpi.no_auto_ssdt) was introduced to
> > >    be used for this use case.  And over a long time, there is no other
> > >    situation than this requires this boot parameter.
> > > This patch thus converts the runtime kernel parameter into the compile-time
> > > configuration item.
> > >
> > > References: https://bugzilla.kernel.org/show_bug.cgi?id=3774
> > > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=69711
> > > Original-by: Enrico Etxe Arte <goitizena.generoa@gmail.com>
> > > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > > ---
> > >  Documentation/kernel-parameters.txt |   10 ----------
> > >  drivers/acpi/Kconfig                |   32 ++++++++++++++++++++++++++------
> > >  drivers/acpi/internal.h             |    5 +++++
> > >  drivers/acpi/osl.c                  |    8 +++-----
> > >  drivers/acpi/tables.c               |    2 ++
> > >  5 files changed, 36 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > index 831fb1e..ceba0d6 100644
> > > --- a/Documentation/kernel-parameters.txt
> > > +++ b/Documentation/kernel-parameters.txt
> > > @@ -237,16 +237,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> > >  			This feature is enabled by default.
> > >  			This option allows to turn off the feature.
> > >
> > > -	acpi_no_static_ssdt	[HW,ACPI]
> > > -			Disable installation of static SSDTs at early boot time
> > > -			By default, SSDTs contained in the RSDT/XSDT will be
> > > -			installed automatically and they will appear under
> > > -			/sys/firmware/acpi/tables.
> > > -			This option turns off this feature.
> > > -			Note that specifying this option does not affect
> > > -			dynamic table installation which will install SSDT
> > > -			tables to /sys/firmware/acpi/tables/dynamic.
> > > -
> > >  	acpica_no_return_repair [HW, ACPI]
> > >  			Disable AML predefined validation mechanism
> > >  			This mechanism can repair the evaluation result to make
> > > diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> > > index c0160bb..51dc3b8 100644
> > > --- a/drivers/acpi/Kconfig
> > > +++ b/drivers/acpi/Kconfig
> > > @@ -216,22 +216,40 @@ config ACPI_NUMA
> > >  	depends on (X86 || IA64)
> > >  	default y if IA64_GENERIC || IA64_SGI_SN2
> > >
> > > -config ACPI_CUSTOM_DSDT_FILE
> > > -	string "Custom DSDT Table file to include"
> > > -	default ""
> > > +menu "Table override"
> > > +
> > > +menuconfig ACPI_CUSTOM_DSDT
> >
> > I would make this a choice, like the "Kernel compression mode" (in init/Kconfig).
> >
> > Then ACPI_CUSTOM_DSDT_ONLY and ACPI_CUSTOM_DSDT_WITH_SSDT may be the options
> > and they both would select ACPI_CUSTOM_DSDT (otherwise invisible to the user),
> 
> With the third (and default) option NO_ACPI_CUSTOM_DSDT that would not
> select ACPI_CUSTOM_DSDT.

OK.

Thanks
-Lv

> 
> Thanks!
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
