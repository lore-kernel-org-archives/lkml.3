Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaGUB0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:26:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:27228 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaGUB0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:26:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,697,1400050800"; 
   d="scan'208";a="564696821"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH v3 2/7] ACPICA: Linux: Add stub implementation of ACPICA
 64-bit mathematics.
Thread-Topic: [PATCH v3 2/7] ACPICA: Linux: Add stub implementation of
 ACPICA 64-bit mathematics.
Thread-Index: AQHPo6kZpbMK9ozajE+AgOcc2mHqgpuptB+g
Date: Mon, 21 Jul 2014 01:26:10 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802643932@SHSMSX101.ccr.corp.intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
 <cover.1405500886.git.lv.zheng@intel.com>
 <01bab2394df93a3064f09d961f4011b62895eef2.1405500886.git.lv.zheng@intel.com>
 <3777197.HSR7Q9huIS@vostro.rjw.lan>
In-Reply-To: <3777197.HSR7Q9huIS@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6L1QSSP026638

Hi, Rafael

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Sunday, July 20, 2014 7:46 AM
> To: Zheng, Lv
> 
> On Wednesday, July 16, 2014 04:58:00 PM Lv Zheng wrote:
> > This patch adds default 64-bit mathematics in aclinux.h using do_div(). As
> > do_div() can be used for all Linux architectures, this can also be used as
> > stub macros for ACPICA 64-bit mathematics.
> >
> > But this is not a performance friendly way, as ACPICA's architecture
> > specific division OSL only requires a dividing 64-bit number with a 32-bit
> > number implementation, while Linux __div64_32() is not available for all
> > build environments. So currently, if an architecture really wants to
> > support ACPICA, it must implement its own division OSL.
> 
> What does this mean for i386, in particular?

All ACPICA environment macros have defaults in actypes.h or acenv.h, these macros are the only ones do not have defaults.
Because their defaults should be provided by OSPMs.
This patch just adds their default implementation for __KERNEL__ surrounded code for Linux kernel.
It only provides build protection and demonstrations of the functionality, no one actually uses it now.

Let me figure out the possible users below:

These macros are required by drivers/acpi/utmath.c when ACPI_USE_NATIVE_DIVIDE is not defined.
It is used by ACPICA, so currently this is only meaningful to CONFIG_ACPI builds.
So kernel will not use these macros unless CONFIG_ACPI is defined and ACPI_USE_DIVIDE is not defined.

For 64-bit kernels: 
In include/acpi/actypes.h, for ACPI_MACHINE_WIDTH=64, ACPI_USE_NATIVE_DIVIDE will be defined, thus these macros are not used.
In include/acpi/platform/aclinux.h, for __KERNEL__ surrounded code, ACPI_MACHINE_WIDTH is defined to be BITS_PER_LONG.
So all 64-bit kernels do not use these macros.

For 32-bit kernels:
As mentioned above, these macros will be used when BITS_PER_LONG is 32.
Thus currently the i328 kernels are the only users for these macros.
But they won't use this default implementation provided by this patch because:
In arch/x86/include/asm/acenv.h, there are already overrides implemented.
So these default macros are not used by 32-bit x86 (i386) kernels.

These macros will only be used by future non x86 32-bit architectures that try to support ACPI in Linux kernel.
During the period they do not have arch specific implementations of such macros, we can avoid build errors for them.
And since they can see ACPICA functioning without implementing any arch specific environment tunings, we  can also avoid function errors for them.
As this implementation is not performance friendly, those architectures still need to implement real support in the end.

As a conclusion, IMO:
1. This default implementation just fill an ACPICA default environment gap.
1. There are no users and will be no users of this default implementation in the kernel.
3. Though this default implementation is not performance friendly, it functions correctly, so it can be a demo for future 32-bit architectures that try to support ACPI.
4. We can use this default implementation to avoid build troubles.

Thanks and best regards
-Lv

> 
> > This is required by the ACPICA header stub support. ACPICA header stubs are
> > useful to protect CONFIG_ACPI=n Linux kernel builds where ACPICA headers
> > are included. Lv Zheng.
> >
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > ---
> >  include/acpi/platform/aclinuxex.h |   22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/include/acpi/platform/aclinuxex.h b/include/acpi/platform/aclinuxex.h
> > index 191e741..568d4b8 100644
> > --- a/include/acpi/platform/aclinuxex.h
> > +++ b/include/acpi/platform/aclinuxex.h
> > @@ -46,6 +46,28 @@
> >
> >  #ifdef __KERNEL__
> >
> > +#ifndef ACPI_USE_NATIVE_DIVIDE
> > +
> > +#ifndef ACPI_DIV_64_BY_32
> > +#define ACPI_DIV_64_BY_32(n_hi, n_lo, d32, q32, r32) \
> > +	do { \
> > +		u64 (__n) = ((u64) n_hi) << 32 | (n_lo); \
> > +		(r32) = do_div ((__n), (d32)); \
> > +		(q32) = (u32) (__n); \
> > +	} while (0)
> > +#endif
> > +
> > +#ifndef ACPI_SHIFT_RIGHT_64
> > +#define ACPI_SHIFT_RIGHT_64(n_hi, n_lo) \
> > +	do { \
> > +		(n_lo) >>= 1; \
> > +		(n_lo) |= (((n_hi) & 1) << 31); \
> > +		(n_hi) >>= 1; \
> > +	} while (0)
> > +#endif
> > +
> > +#endif
> > +
> >  /*
> >   * Overrides for in-kernel ACPICA
> >   */
> >
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
