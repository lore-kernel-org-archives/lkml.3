Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3FDRvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:51:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61944 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3FDRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:51:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 15/15] OF: remove #ifdef from linux/of_platform.h
Date: Tue, 4 Jun 2013 19:51:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, patches@lists.linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <201306012257.02327.arnd@arndb.de> <CAL_JsqKMOy4CM=FXbsy7mQ1f0DLyK6n_cuZ92uhsSM2Mq-3B1g@mail.gmail.com>
In-Reply-To: <CAL_JsqKMOy4CM=FXbsy7mQ1f0DLyK6n_cuZ92uhsSM2Mq-3B1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306041951.00447.arnd@arndb.de>
X-Provags-ID: V02:K0:hk51sK4v9P1B7sdi57akjwyYtM/vVKKHyvfVelh51qg
 QgajTRFGauV5uyqSin/fhVnsqjp1XjaxwsA9G7CfxFZAw6CW7L
 2+Q4aiOSN7oT7i/fu9ASs9QVhzpLhp62Na4PUUXjwvGRiDzGT3
 byQbBuwS9MUYmGJKBqXST2vlg5WL/QLS4iPN4JNaLx+EIEu0iO
 PUNEJcXNWpk25a1YSdjF6ABI8LEMojfsj1q4n/FhdO5NF/gfiH
 eI87Pr/e1S+nZXzTM+Z3pJ9jPsWRqRB/SakEe4EYoKXBvIGk/S
 SW3cm0xco7kvtharCaBYiibAhfn1lZYYQ0oJ6eV77u3TUtlrSG
 yD48Biy8hrlHtnCfIRg4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013, Rob Herring wrote:
> On Sat, Jun 1, 2013 at 3:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Saturday 01 June 2013, Rob Herring wrote:
> >> No, we still need empty functions. Here is what of_device.h looks like:
> >>
> >> http://tinyurl.com/l2azz5m
> >>
> >> BTW, it has your ack.
> >>
> >
> > Could you add a patch on top that only puts the function declarations
> > inside of #ifdef that don't have an inline wrapper?
> 
> I'm confused. You mean that DO have an inline? Like this:
> 
> void foo(void);
> 
> #ifdef CONFIG_OF
> void bar(void);
> #else
> static inline void bar(void) {}
> #endif

Yes, sorry. That's what I meant.

> > It's really annoying to have to change the header file every time one
> > needs to call a function from a driver in the DT-only case.
> 
> The functions without inlines are ones that drivers should not call
> and should only be called from OF enabled code. That's why we have not
> done a complete pass of adding inlines for everything.

The problem is that it's a bad default. The convention in kernel code
is not to hide declarations in #ifdef, for multiple reasons:

* It avoids unnecessary code rebuilds when the symbol changes between 
  two 'make' runs.

* It lets drivers and platform code call the function from dead code
  without causing a build error, thus improving compile coverage.

* It's much nicer to read when can write your code like

void __init exynos_init_io(struct map_desc *mach_desc, int size)
{
        if (IS_ENABLED_(CONFIG_OF) && initial_boot_params)
                of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
        else
                iotable_init(exynos_iodesc, ARRAY_SIZE(exynos_iodesc));
	...
}

instead of

void __init exynos_init_io(struct map_desc *mach_desc, int size)
{
#ifdef CONFIG_OF
        if (initial_boot_params)
                of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
        else
#endif
                iotable_init(exynos_iodesc, ARRAY_SIZE(exynos_iodesc));
	...
}

The first one looks like actual C code, the second is really ugly,
and an inline wrapper wouldn't even do the right thing here.

	Arnd
