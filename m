Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbbALVEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:04:54 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:41794 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbbALVEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:04:51 -0500
Date: Mon, 12 Jan 2015 21:01:34 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@denx.de>
Cc: atull <atull@opensource.altera.com>, gregkh@linuxfoundation.org,
        jgunthorpe@obsidianresearch.com, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devel@driverdev.osuosl.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Message-ID: <20150112210134.687176ed@lxorguk.ukuu.org.uk>
In-Reply-To: <20150109205643.GA5761@amd>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
	<1420575219-27061-3-git-send-email-atull@opensource.altera.com>
	<20150107084819.GA1887@amd>
	<alpine.DEB.2.02.1501091302370.30067@linuxheads99>
	<20150109205643.GA5761@amd>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then configure udev to load right firmware for you, or ln -s
> image-i-want-now socfpga-fpga-image to select the one to read...?

Your conceptual model is wrong. FPGA firmware is dynamic. There are
already people who lazy reload FPGA firmware on taskswitches. This
proposed fpga manager is broken but it's broken in exactly the reverse
direction to the one you are arguing for.

There are plenty of people today who treat the FPGA as an entirely
dynamic resource. It's not like flashing a controller, its near
immediate.

The udev/sysfs model is broken because
- it's too slow for dynamic switching
- it doesn't address permissions
- it doesn't address namespaces
- it doesn't address dynamic management of resources (open/use/close)
  with dyanmic resource recovery on the final close as is the Unix way.

not because FPGA's are some static boot time resource.

If you look at all the academic work on this you see the same kind
of dynamic usage, even more so.

The library API you actually need is much closer to

	/* Get my firmware */
	fw = fpga_openfirmware("foo.fpga");
	/* Get me a suitable FPGA for it */
	fd = fpga_alloc(&w);
	/* Load it */
	fgpa_load(fd, "foo.fpga");

	do_shit(fd);

	fpga_close(fd);

You want to be able to have things like your game just load up an audio
physics engine, lob it into a random fpga, play it, drop it. Likewise
lots of other FPGA apps - video processing for example, crypto, format
convertors, gesture analysers and so on. Think a world where there are
gimp filters that want to just grab an fpga for 3 seconds.

Its completely dynamic and it will get more so as we switch from the
painful world of VHDL and friends to high level parallel aware language
compilers for FPGAs and everyone will be knocking up quick FPGA hacks.

Alan
