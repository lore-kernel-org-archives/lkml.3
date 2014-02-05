Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaBET20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:28:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33941 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaBET2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:28:23 -0500
Date: Wed, 5 Feb 2014 13:25:02 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v2 5/5] of: document bindings for reserved-memory nodes
Message-ID: <20140205192502.GO20228@joshc.qualcomm.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
 <1391515773-6112-6-git-send-email-m.szyprowski@samsung.com>
 <20140205100750.58EFAC40A89@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205100750.58EFAC40A89@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:07:50AM +0000, Grant Likely wrote:
> On Tue, 04 Feb 2014 13:09:33 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> > From: Grant Likely <grant.likely@linaro.org>
> > +/reserved-memory node
> > +---------------------
> > +#address-cells, #size-cells (required) - standard definition
> > +    - Should use the same values as the root node
> > +#memory-region-cells (required) - dictates number of cells used in the child
> > +                                  nodes memory-region specifier
>
> I don't think this isn't defined well enough. These reserved regions may
> not have a driver attached to them, so there is no central agent to
> decide what the specifier means. That leaves the interpretation of
> the memory region in the hands of the client drivers. How do you see the
> specifier getting parsed and used?

I had a specific usecase in mind when I added it, although admittedly I
haven't yet worked through all of the details.

On MSM chips, there is a region of memory accessible from the various
processors on the SoC.  This region is used for (among other things)
inter-processor communication.  Inside this region, a heap allocation
protocol is implemented by software on all interested processors.

Consumers of this shared memory heap specify a 32-bit identifier and a
size, and are either given a matching preexisting chunk (for example,
another processor has already allocated a chunk with the corresponding
identifier), or are allocated a new chunk for that identifier out of the
region.

Given it's shared nature, this region has some specific requirements
about how it may be accessed by the kernel (specifically regarding
cacheability/how it's mapped), which means it at least needs _some_
representation in a reserved-memory node.

I had envisioned expressing the shared memory/consumer relationship in
the device tree:

	reserved-memory {
		smem : smem {
			compatible = "qcom,shared-memory";
			reg = <...>;
			#memory-region-cells = <2>;
			no-map;
		};
	};

	consumer {
		/* ... */;
		memory-region = <&smem 0xDEADBEEF 0x1000>;
	};

That is, the heap protocol implementation exists as a "driver" for the
smem reserved-memory node, and the consumer's 2-cell specifier is a
32-bit identifier and a size.

If your concern is for the case where a "qcom,shared-memory" node is
specified in a device tree, but the "driver" hasn't been built into the
kernel, then the appropriate behavior would be the same as the DMA/CMA
case: fallback to a default case of memblock_reserve/memblock_remove'ing
the region.

Would using reserved-memory in this way be outside the scope of what was
originally intended?

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
