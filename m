Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaBSSL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:11:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56734 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754486AbaBSSL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:11:57 -0500
Date: Wed, 19 Feb 2014 18:11:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "nsekhar@ti.com" <nsekhar@ti.com>
Subject: Re: [PATCH v5 2/2] memory: ti-aemif: add bindings for AEMIF driver
Message-ID: <20140219181152.GG25079@e106331-lin.cambridge.arm.com>
References: <1392817210-14312-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1392817210-14312-3-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392817210-14312-3-git-send-email-ivan.khoronzhuk@ti.com>
Thread-Topic: [PATCH v5 2/2] memory: ti-aemif: add bindings for AEMIF driver
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:40:10PM +0000, Ivan Khoronzhuk wrote:
> Add bindings for TI Async External Memory Interface (AEMIF) controller.
> 
> The Async External Memory Interface (EMIF16/AEMIF) controller is intended to
> provide a glue-less interface to a variety of asynchronous memory devices like
> ASRA M, NOR and NAND memory. A total of 256M bytes of any of these memories
> can be accessed via 4 chip selects with 64M byte access per chip select.
> 
> We are not encoding CS number in reg property, it's memory partition number.
> The CS number is encoded for Davinci NAND node using standalone property
> "ti,davinci-chipselect" and we need to provide two memory ranges to it,
> as result we can't encode CS number in "reg" for AEMIF child devices
> (NAND/NOR/etc), as it will break bindings compatibility.
> 
> In this patch, NAND node is used just as an example of child node.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  .../bindings/memory-controllers/ti-aemif.txt       | 210 +++++++++++++++++++++
>  1 file changed, 210 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/memory-controllers/ti-aemif.txt

[...]

> +- ranges:		Contains memory regions. There are two types of
> +			ranges/partitions:
> +			- CS-specific partition/range. If continuous, must be
> +			set up to reflect the memory layout for 4 chipselects,
> +			if not then additional range/partition can be added and
> +			child device can select the proper one.
> +			- control partition which is common for all CS
> +			interfaces.

This really doesn't sound anything like the typical meaning of ranges on
a bus.

Why isn't this information encoded in reg properties on the child nodes?

[...]

> +- ti,cs-ss:		enable/disable select strobe mode
> +				In select strobe mode chip select behaves as
> +				the strobe and is active only during the strobe
> +				period. If present then enable.
> +
> +- ti,cs-ew:		enable/disable extended wait mode
> +				if set, the controller monitors the EMIFWAIT pin
> +				mapped to that chip select to determine if the
> +				device wants to extend the strobe period. If
> +				present then enable.

When would you have these two in the DT and when wouldn't you? Why can't
the driver decide?

These names are also opaque. We can clearly do better.

> +
> +- ti,cs-ta:		minimum turn around time, ns
> +				Time between the end of one asynchronous memory
> +				access and the start of another asynchronous
> +				memory access. This delay is not incurred
> +				between a read followed by read or a write
> +				followed by a write to same chip select.

The name is opaque. How about ti,min-turnaround-time-ns ?

> +
> +- ti,cs-rsetup:		read setup width, ns
> +				Time between the beginning of a memory cycle
> +				and the activation of read strobe.
> +				Minimum value is 1 (0 treated as 1).
> +
> +- ti,cs-rstobe:		read strobe width, ns
> +				Time between the activation and deactivation of
> +				the read strobe.
> +				Minimum value is 1 (0 treated as 1).
> +
> +- ti,cs-rhold:		read hold width, ns
> +				Time between the deactivation of the read
> +				strobe and the end of the cycle (which may be
> +				either an address change or the deactivation of
> +				the chip select signal.
> +				Minimum value is 1 (0 treated as 1).
> +
> +- ti,cs-wsetup:		write setup width, ns
> +				Time between the beginning of a memory cycle
> +				and the activation of write strobe.
> +				Minimum value is 1 (0 treated as 1).
> +
> +- ti,cs-wstrobe:	write strobe width, ns
> +				Time between the activation and deactivation of
> +				the write strobe.
> +				Minimum value is 1 (0 treated as 1).
> +
> +- ti,cs-whold:		write hold width, ns
> +				Time between the deactivation of the write
> +				strobe and the end of the cycle (which may be
> +				either an address change or the deactivation of
> +				the chip select signal.
> +				Minimum value is 1 (0 treated as 1).

Likewise I think these can be given more descriptive names.

Thanks,
Mark.
