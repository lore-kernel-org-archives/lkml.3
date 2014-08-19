Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaHSSZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:25:51 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:51620 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaHSSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:25:49 -0400
Date: Tue, 19 Aug 2014 21:25:33 +0300
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: "edubezval@gmail.com" <edubezval@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Juha-Matti Tilli <jtilli@nvidia.com>
Subject: Re: [PATCH v4 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
Message-ID: <20140819182533.GA51539@sandfort.unics.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC-25o-bLeDYpTgPy5UOvBGJ7k7HJkBM3YcCRPSZHBkyxugULA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Originally, I thought the fuse offsets were incorrect but as it turns
> > out, the official Linux kernel starts counting the fuses at a different
> > location than NVIDIA's internal kernel.
> 
> This is a major concern. Juha-Matti and Mikko, can you please cross
> check if this driver is accessing to the correct fuse register
> location?

Mikko told me that the official Linux kernel and NVIDIA's internal
kernel have an offset of 0x100 between fuse registers. I believe it is
accessing correct fuse register locations, as I tested the code and it
works. But, if I port the code to a codebase that is using NVIDIA's
internal kernel functions, it fails (all fuses read 0x0) unless I offset
all fuses by 0x100. All fuse register locations in this code indeed have
the same offset of 0x100 between NVIDIA's internal docs & code and the
new driver code.

I'm not entirely sure why the official Linux kernel and NVIDIA's
internal code starts counting the fuses at a different location, but the
fuses read do have data in them and the temperature readings look sane,
so I assume they are indeed the correct fuses. The calculated
calibration values also seem to be similar to (but not identical with)
the ones calculated by NVIDIA's internal driver, but more on this later.

drivers/soc/tegra/fuse/fuse-tegra30.c in upstream has "#define
FUSE_BEGIN 0x100" and the read is "readl_relaxed(fuse_base + FUSE_BEGIN
+ offset);" so there's the explanation for the 0x100 offset.

I believe Mikko's explanation about the 0x100 offset, so the code in my
opinion seems correct as the offset of 0x100 is consistent, and the code
does in fact work. Reading incorrect fuses would mean the fuses read 0x0
and the temperatures are so strange that they are obviously incorrect.

Mikko said he did the same mistake earlier and fixed it. Well, I too did
the same mistake. I guess everyone working with fuses on both NVIDIA's
internal code and the upstream kernel will make the same mistake once
but not again.

> > The temperature readings look sane and do vary with load, but I think
> > they're a bit different than what NVIDIA's internal soc_therm driver
> 
> hmm..  Based on a single sample?

Yes, the comparison between NVIDIA's internal driver and this driver was
based only on a single sample. I don't now recall what the difference
was, but I should probably test it multiple times tomorrow so I can
report how large the difference is. Might be within the error margin, as
the temperatures are not stable to a 0.5 degrees C precision. A problem
here is that my test was basically loading code adopted from this new
driver dynamically on a system already using the NVIDIA's existing
driver as a static driver, so a new sample requires a reboot and there's
always a time delay between the commands used to manually read the
temperature, load the dynamic module and re-read the temperature. I
could tomorrow write a userspace test program to overwrite the registers
with the old and new values and read the temperature sensor register
immediately before and after the value switch to see how much the
readings differ. That way I could get multiple accurate data points with
no reboots required.

The test that the temperatures do vary with load was based on multiple
samples of running four shell infinite loops in the background. I can
easily reach 80 degrees C with that on my development board with passive
cooling. Killing the four loops results in the temperature slowly
trickling to the idle temperature. The idle temp seems to be a bit over
30 degrees C. My Jetson TK1 has active cooling, so the peak temperatures
are a lot lower than for the other development board. This loads only
the CPU, though. Loading additionally the GPU would cause higher
temperatures.

Mikko already noticed that NVIDIA's internal driver uses
div64_s64_precise and Mikko opted for a simpler implementation, so that
might be indeed the cause for the different calibration values. I'll
need to investigate this more. Yet another difference could be that
Mikko posted a link to an older version of the downstream kernel sources
(https://developer.nvidia.com/sites/default/files/akamai/mobile/files/L4T/kernel_src.tbz2)
-- if Mikko has based his code on that old code, it's possible that the
calibration value calculation has been improved afterwards. We'll know
for sure after I have had time to investigate this more.
