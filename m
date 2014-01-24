Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaAXMIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:08:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44404 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbaAXMIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:08:18 -0500
Date: Fri, 24 Jan 2014 12:08:15 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro
 CLOCKSOURCE_ACPI_DECLARE
Message-ID: <20140124120815.GH814@e106331-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
 <1389961514-13562-19-git-send-email-hanjun.guo@linaro.org>
 <CACRpkdYKwaH5DX27irzmcTDAMhQMUhuzz6N7mjKWv9tZchv0Ug@mail.gmail.com>
 <20140122114537.GA15591@e106331-lin.cambridge.arm.com>
 <52E1B1DE.5050507@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52E1B1DE.5050507@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 12:20:46AM +0000, Hanjun Guo wrote:
> On 2014年01月22日 19:45, Mark Rutland wrote:
> > On Wed, Jan 22, 2014 at 08:26:50AM +0000, Linus Walleij wrote:
> >> On Fri, Jan 17, 2014 at 1:25 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> >>
> >>> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
> >>>
> >>> This macro does the same job as CLOCKSOURCE_OF_DECLARE. The device
> >>> name from the ACPI timer table is matched with all the registered
> >>> timer controllers and matching initialisation routine is invoked.
> >>>
> >>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> >>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> >> Actually I have a fat patch renaming CLOCKSOURCE_OF_DECLARE()
> >> to TIMER_OF_DECLARE() and I think this macro, if needed, should
> >> be named TIMER_ACPI_DECLARE().
> >>
> >> The reason is that "clocksource" is a Linux-internal name and this
> >> macro pertains to the hardware name in respective system
> >> description type.
> >>
> >>> +#ifdef CONFIG_ACPI
> >>> +#define CLOCKSOURCE_ACPI_DECLARE(name, compat, fn)                     \
> >>> +       static const struct acpi_device_id __clksrc_acpi_table_##name   \
> >>> +               __used __section(__clksrc_acpi_table)                   \
> >>> +                = { .id = compat,                              \
> >>> +                    .driver_data = (kernel_ulong_t)fn }
> >>> +#else
> >>> +#define CLOCKSOURCE_ACPI_DECLARE(name, compat, fn)
> >>> +#endif
> >> This hammers down the world to compile one binary for ACPI
> >> and one binary for device tree. Maybe that's fine, I don't know.
> > How does it do that?
> >
> > As far as I could tell CONFIG_ACPI and CONFIG_OF are not mutually
> > exclusive, and this just means that we only build the datastructures for
> > matching from ACPI when CONFIG_ACPI is enabled.
> >
> > Have I missed something?
> >
> > I definitely don't want to see mutually exclusive ACPI and DT support.
> 
> ACPI and DT did the same job so I think they should mutually exclusive.
> if we enable both DT and ACPI in one system, this will leading confusions.

ACPI and DT do similar jobs, and we should be mutually exclusive at
runtime. However, they should not be mutually exclusive at compile-time.

Being mutually exclusive at compile-time is just broken. It creates more
work for distributions (who need to ship double the number of kernels),
it increases the number of configurations requiring testing, and it
makes it easier for bugs to be introduced. It's just painful, and
there's no reason for it.

At boot time the kernel needs to decide which to use for hardware
description, and completely ignore the other (which should not be
present, but lets not assume that or inevitably someone will break that
assumption for a quick hack).

The same kernel should boot on a system that has a DTB or a system that
has ACPI tables. On a system that's provided both it should use one or
the other, but not both.

Thanks,
Mark.
