Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaJFQ1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:27:43 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41449 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaJFQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:27:40 -0400
Date: Mon, 6 Oct 2014 17:27:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>, b29396@freescale.com,
        boris.brezillon@free-electrons.com,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'VIKAS SAJJAN C'" <vikas.sajjan@samsung.com>, naushad@samsung.com,
        "'Thomas P Abraham'" <thomas.ab@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, Li.Xiubo@freescale.com,
        geert+renesas@glider.be, "'Stephen Warren'" <swarren@nvidia.com>,
        "'Doug Anderson'" <dianders@chromium.org>
Subject: Re: [PATCH v7] mfd: syscon: Decouple syscon interface from platform
 devices
Message-ID: <20141006162732.GB3848@lee--X1>
References: <1412066127-27063-1-git-send-email-pankaj.dubey@samsung.com>
 <CAD=FV=VYc+5qwZ==vTgXkXzbX1wALRpqsaTe8LR-N00nKiyycQ@mail.gmail.com>
 <004101cfe144$5aa3e570$0febb050$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <004101cfe144$5aa3e570$0febb050$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Oct 2014, Pankaj Dubey wrote:

> Hi Lee,
> 
> On Tuesday, September 30, 2014 9:39 PM Doug Anderson wrote,
> > Subject: Re: [PATCH v7] mfd: syscon: Decouple syscon interface from platform
> > devices
> > 
> > Pankaj,
> > 
> > On Tue, Sep 30, 2014 at 1:35 AM, Pankaj Dubey <pankaj.dubey@samsung.com>
> > wrote:
> > > Currently a syscon entity can be only registered directly through a
> > > platform device that binds to a dedicated syscon driver. However in
> > > certain use cases it is desirable to make a device used with another
> > > driver a syscon interface provider.
> > >
> > > For example, certain SoCs (e.g. Exynos) contain system controller
> > > blocks which perform various functions such as power domain control,
> > > CPU power management, low power mode control, but in addition contain
> > > certain IP integration glue, such as various signal masks, coprocessor
> > > power control, etc. In such case, there is a need to have a dedicated
> > > driver for such system controller but also share registers with other
> > > drivers. The latter is where the syscon interface is helpful.
> > >
> > > In case of DT based platforms, this patch decouples syscon object from
> > > syscon platform driver, and allows to create syscon objects first time
> > > when it is required by calling of syscon_regmap_lookup_by APIs and
> > > keep a list of such syscon objects along with syscon provider
> > > device_nodes and regmap handles.
> > >
> > > For non-DT based platforms, this patch keeps syscon platform driver
> > > structure so that syscon can be probed and such non-DT based drivers
> > > can use syscon_regmap_lookup_by_pdev API and access regmap handles.
> > > Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> > > we can completely remove platform driver of syscon, and keep only
> > > helper functions to get regmap handles.
> > >
> > > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > > Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> > > Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> > > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> > > Tested-by: Heiko Stuebner <heiko@sntech.de>
> > > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > > ---
> > > Patch v6 and related discussions can be found here [1].
> > >
> > > Change since v5:
> > >  - Addressed review comments from "Heiko Stuebner".
> > >  - Updated commit description.
> > >  - Including Arnd's and Heiko's Reviewed-by.
> > >
> > > Change since v5:
> > >  - Dropping creation of dummy platform device in of_syscon_register.
> > >  - As we are changing syscon to decouple from platform_device, creation of
> > >    dummy platform_device does not look good option, and as suggested by Arnd,
> > >    I made another attempt so that regmap_mmio_init API should work with NULL
> > >    dev pointer itself. Since regmap needs to know about Syscon device node
> > >    properties so let's parse device node of syscon in syscon itself for any
> > >    such properties and using regmap_config parameter pass all such information
> > >    to regmap. Other concern of crashes due to NULL dev pointer in regmap already
> > >    addressed in separate patches of regmap. Please see [2] and [3].
> > >
> > > Changes since v4:
> > >  - Addressed Tomasz Figa's comments for v4.
> > >  - Added error handing in of_syscon_register function.
> > >  - Using devm_regmap_init_mmio instead of regmap_init_mmio.
> > >
> > > Changes since v3:
> > >  - Addressed Arnd's comment for v2.
> > >  - Updated of_syscon_register for adding dev pointer in regmap_init_mmio.
> > >  - For early users created dummy platform device.
> > >
> > > Changes since v2:
> > >  - Added back platform device support from syscon, with one change that
> > >    syscon will not be probed for DT based platform.
> > >  - Added back syscon_regmap_lookup_by_pdevname API so that non-DT base
> > >    users of syscon will not be broken.
> > >  - Removed unwanted change in syscon.h.
> > >  - Modified Signed-off-by list, added Suggested-by of Tomasz Figa and
> > >    Arnd Bergmann.
> > >  - Added Tested-by of Vivek Gautam for testing on Exynos platform.
> > >
> > > Changes since v1:
> > >  - Removed of_syscon_unregister function.
> > >  - Modified of_syscon_register function and it will be used by syscon.c
> > >    to create syscon objects whenever required.
> > >  - Removed platform device support from syscon.
> > >  - Removed syscon_regmap_lookup_by_pdevname API support.
> > >  - As there are significant changes w.r.t patchset v1, I am taking over
> > >    author for this patchset from Tomasz Figa.
> > >
> > > [1]: https://lkml.org/lkml/2014/9/29/99
> > > [2]: https://lkml.org/lkml/2014/9/18/130
> > > [3]: https://lkml.org/lkml/2014/9/27/2
> > >  drivers/mfd/syscon.c |   96
> > ++++++++++++++++++++++++++++++++++++++------------
> > >  1 file changed, 74 insertions(+), 22 deletions(-)
> > 
> > You probably already have enough tags, but just in case.  ;)  On an rk3288-based
> > system (this patch backported to 3.14):
> > 
> > Tested-by: Doug Anderson <dianders@chromium.org>
> 
> I think now we can take have this patch in. So will you please take this patch.

I plan to take this when the merge window has closed.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
