Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaESWfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:35:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61232 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750852AbaESWfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:35:30 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 1/2] ACPI: Cleanup to convert acpi.no_static_ssdt into a compile-time configurable.
Date: Tue, 20 May 2014 00:52:24 +0200
Message-ID: <7128235.yLzY3DMMj5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3194723.o46ouvvENe@vostro.rjw.lan>
References: <cover.1396925060.git.lv.zheng@intel.com> <5a2b1a503fbc65f63a18ca28727e023e5f48efcd.1399880919.git.lv.zheng@intel.com> <3194723.o46ouvvENe@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 20, 2014 12:49:04 AM Rafael J. Wysocki wrote:
> On Monday, May 12, 2014 03:49:59 PM Lv Zheng wrote:
> > User can specify a DSDT with SSDT embedded, in which case, no_static_ssdt
> > must be enforced during compile-time.  If we don't do that and forget to
> > specify acpi.no_static_ssdt as a boot parameter, then:
> > 1. The AML executable will be executed twice, the second execution is
> >    running under a changed environment.
> > 2. The namespace object conflicts will result in an AE_ALREADY_EXISTS
> >    exception;
> > 3. The namespace objects that are deleted from the original SSDT will be
> >    restored by the auto loading of the original SSDT.
> > 
> > Note that:
> > 1. The DSDT customization is a compile-time feature, thus the SSDT
> >    inclusion indication of the DSDT customization should also be
> >    implemented as a compile-time configurable.
> > 2. According to the commit log:
> >     Commit: 67effe8fff32f60bdf51cba484766ba6003005bb
> >     Subject: ACPI: add "acpi_no_auto_ssdt" bootparam
> >    The acpi.no_static_ssdt (originally acpi.no_auto_ssdt) was introduced to
> >    be used for this use case.  And over a long time, there is no other
> >    situation than this requires this boot parameter.
> > This patch thus converts the runtime kernel parameter into the compile-time
> > configuration item.
> > 
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=3774
> > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=69711
> > Original-by: Enrico Etxe Arte <goitizena.generoa@gmail.com>
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > ---
> >  Documentation/kernel-parameters.txt |   10 ----------
> >  drivers/acpi/Kconfig                |   32 ++++++++++++++++++++++++++------
> >  drivers/acpi/internal.h             |    5 +++++
> >  drivers/acpi/osl.c                  |    8 +++-----
> >  drivers/acpi/tables.c               |    2 ++
> >  5 files changed, 36 insertions(+), 21 deletions(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 831fb1e..ceba0d6 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -237,16 +237,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			This feature is enabled by default.
> >  			This option allows to turn off the feature.
> >  
> > -	acpi_no_static_ssdt	[HW,ACPI]
> > -			Disable installation of static SSDTs at early boot time
> > -			By default, SSDTs contained in the RSDT/XSDT will be
> > -			installed automatically and they will appear under
> > -			/sys/firmware/acpi/tables.
> > -			This option turns off this feature.
> > -			Note that specifying this option does not affect
> > -			dynamic table installation which will install SSDT
> > -			tables to /sys/firmware/acpi/tables/dynamic.
> > -
> >  	acpica_no_return_repair [HW, ACPI]
> >  			Disable AML predefined validation mechanism
> >  			This mechanism can repair the evaluation result to make
> > diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> > index c0160bb..51dc3b8 100644
> > --- a/drivers/acpi/Kconfig
> > +++ b/drivers/acpi/Kconfig
> > @@ -216,22 +216,40 @@ config ACPI_NUMA
> >  	depends on (X86 || IA64)
> >  	default y if IA64_GENERIC || IA64_SGI_SN2
> >  
> > -config ACPI_CUSTOM_DSDT_FILE
> > -	string "Custom DSDT Table file to include"
> > -	default ""
> > +menu "Table override"
> > +
> > +menuconfig ACPI_CUSTOM_DSDT
> 
> I would make this a choice, like the "Kernel compression mode" (in init/Kconfig).
> 
> Then ACPI_CUSTOM_DSDT_ONLY and ACPI_CUSTOM_DSDT_WITH_SSDT may be the options
> and they both would select ACPI_CUSTOM_DSDT (otherwise invisible to the user),

With the third (and default) option NO_ACPI_CUSTOM_DSDT that would not
select ACPI_CUSTOM_DSDT.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
