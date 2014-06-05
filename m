Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaFEBPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:15:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:58973 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbaFEBO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:14:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,976,1392192000"; 
   d="scan'208";a="542655078"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Lee Jones <lee.jones@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [PATCH 1/7] ACPICA: Only include ACPI asm files if ACPI is
 enabled
Thread-Topic: [PATCH 1/7] ACPICA: Only include ACPI asm files if ACPI is
 enabled
Thread-Index: AQHPf+4KU6l0YPi7HkGxvvNa/8AWq5tgXPuAgAAEfoCAAVM9IA==
Date: Thu, 5 Jun 2014 01:14:54 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880262042C@SHSMSX101.ccr.corp.intel.com>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <1401883796-17841-2-git-send-email-lee.jones@linaro.org>
 <3061297.feg5DGUjIt@vostro.rjw.lan> <20140604125137.GA18171@lee--X1>
In-Reply-To: <20140604125137.GA18171@lee--X1>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s551FG1d021298

Hi, Lee

> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: Wednesday, June 04, 2014 8:52 PM
> To: Rafael J. Wysocki
> 
> On Wed, 04 Jun 2014, Rafael J. Wysocki wrote:
> 
> > On Wednesday, June 04, 2014 01:09:50 PM Lee Jones wrote:
> > > Any drivers which support ACPI and Device Tree probing need to include
> > > both respective header files.  Without this patch, if a driver is being
> > > used on a platform which does not support ACPI and subsequently does not
> > > have the config option enabled, but includes linux/acpi.h the build
> > > breaks with:
> > >
> > >   In file included from ../include/acpi/platform/acenv.h:150:0,
> > >                    from ../include/acpi/acpi.h:56,
> > >                    from ../include/linux/match.h:2,
> > >                    from ../drivers/i2c/i2c-core.c:43:
> > >   ../include/acpi/platform/aclinux.h:73:23:
> > >    fatal error: asm/acenv.h: No such file or directory
> > >    #include <asm/acenv.h>
> > >                        ^

Note that:
In our tree:
<asm/acenv.h> is only included by <acpi/acpi.h>.
And <acpi/acpi.h> is only included by
1. <linux/acpi.h> when CONFIG_ACPI enabled
2. <linux/sfi_acpi.h> - this is x86 specific, we'll clean it up by implementing stubs for all ACPI external interfaces.
So there is no case we need to exclude <asm/acenv.h> when CONFIG_ACPI is not enabled.

I cannot find linux/match.h here.
If <linux/match.h> want to include ACPI features, it shouldn't include <acpi/acpi.h>, but should include <linux/acpi.h>.
Please refer to:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8b48463f
And stop including <acpi/acpi.h> directly in any cases.

Thanks and best regards
-Lv


> >
> > Which kernel does this happen with?
> 
> a0a962d (tag: refs/tags/next-20140602, refs/remotes/next/master)
>   Add linux-next specific files for 20140602
> 
> > > Cc: Lv Zheng <lv.zheng@intel.com>
> > > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Cc: linux-acpi@vger.kernel.org
> > > Cc: devel@acpica.org
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  include/acpi/platform/aclinux.h | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> > > index cd1f052..fdf7663 100644
> > > --- a/include/acpi/platform/aclinux.h
> > > +++ b/include/acpi/platform/aclinux.h
> > > @@ -70,9 +70,10 @@
> > >  #ifdef EXPORT_ACPI_INTERFACES
> > >  #include <linux/export.h>
> > >  #endif
> > > -#include <asm/acenv.h>
> > >
> > > -#ifndef CONFIG_ACPI
> > > +#ifdef CONFIG_ACPI
> > > +#include <asm/acenv.h>
> > > +#else
> > >
> > >  /* External globals for __KERNEL__, stubs is needed */
> > >
> > >
> >
> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org â”‚ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
