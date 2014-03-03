Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaCCTqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:46:40 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:59677
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbaCCTqi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:46:38 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551bizbb2dI98dIc89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz17326ah8275dh1de097h186068hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh906i1155h)
Date: Mon, 3 Mar 2014 11:46:25 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Gerhard Sittig <gsi@denx.de>, Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/3] clk: CCF clock primitives + custom IO accessors
References: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140302202940.GQ3327@book.gsilab.sittig.org>
 <19206d89-cd0d-4fea-9170-3fd0a8482bf5@VA3EHSMHS045.ehs.local>
 <20140303190736.GU3327@book.gsilab.sittig.org>
 <87e0d582-77a2-4645-a52a-c303b7cd8b84@VA3EHSMHS007.ehs.local>
 <5314DA49.9060001@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5314DA49.9060001@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <8d1a2e24-869d-4e77-aa73-d5c0ca36fe28@VA3EHSMHS011.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 11:38AM -0800, Stephen Boyd wrote:
> On 03/03/14 11:13, Sören Brinkmann wrote:
> > On Mon, 2014-03-03 at 08:07PM +0100, Gerhard Sittig wrote:
> >> On Mon, Mar 03, 2014 at 09:35 -0800, Sören Brinkmann wrote:
> >>> It would be nice if we could use the logic provided in the mux, div etc
> >>> primitives independently of how the HW is accessed and what is
> >>> necessary to shift and mask those register values around, right? I
> >>> mean, at then end we want to model a clk-(div|mux) and not a
> >>> clk-(div|mux) which has only a single, memory-mapped control register,
> >>> that does not overlap with other things, ...
> >> Did you lookup the ll_ops discussion in the thread that
> >> originated from
> >> http://article.gmane.org/gmane.linux.ports.arm.kernel/289895 and
> >> did you see the outlined logic in
> >> http://article.gmane.org/gmane.linux.ports.arm.omap/109233 and
> >> http://article.gmane.org/gmane.linux.ports.arm.omap/109381 ?
> >>
> >> Support for regmap access instead of mere MMIO was one of the
> >> things you could do with this approach.  You appear to be in the
> >> situation where you need such an extension (or something similar,
> >> but you really should look into the ll_ops thing).
> > Thanks for those pointer, I have some reading to do. That seems to
> > go into the right direction.  What is the status of those patches?
> > Are they already merged or actively worked on?
> >
> 
> Ugh. The ll_ops design is a simplified form of regmap. Why not just use
> regmap? It seems like it would be possible to make a regmap per
> clk_register_{basic_type}() call via regmap_init_mmio() while still
> allowing those functions to take a void __iomem pointer. Then we could
> remove clk_readl/clk_writel (after providing *_be variants of the
> registration functions for PPC) and just use a regmap throughout the
> basic clock type code. Finally we can introduce *_regmap() registration
> functions that allow drivers to register basic clock types with regmaps.

Migrating everything to regmap would be a good step, IMHO. That would
accommodate most of my concerns. One remains though: Especially the I2C
clocks may have parameters like dividers stored in more than one register
(in my particular case there is a 10-bit divider which - obviously -
spans across two device registers).
So, replacing a readl() with regmap_read() would not be enough for such
a clock. Would be nice if we could have a solution for such HW as well.

	Sören


