Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaKXRSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:18:07 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38303 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbaKXRSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:18:04 -0500
Date: Mon, 24 Nov 2014 17:17:49 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "zhichang.yuan@linaro.org" <zhichang.yuan@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1] arm64:mm: An optimization about kernel direct
 sapce mapping
Message-ID: <20141124171749.GA12895@e104818-lin.cambridge.arm.com>
References: <1416406915-10939-1-git-send-email-zhichang.yuan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416406915-10939-1-git-send-email-zhichang.yuan@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to make some sense of this patch, so questions below:

On Wed, Nov 19, 2014 at 02:21:55PM +0000, zhichang.yuan@linaro.org wrote:
> From: "zhichang.yuan" <zhichang.yuan@linaro.org>
> 
> This patch make the processing of map_mem more common and support more
> discrete memory layout cases.
> 
> In current map_mem, the processing is based on two hypotheses:
> 1) no any early page allocations occur before the first PMD or PUD regime
> where the kernel image locate is successfully mapped;

No because we use the kernel load offset to infer the start of RAM
(PHYS_OFFSET). This would define which memory you can allocate.

> 2) there are sufficient available pages in the PMD or PUD regime to satisfy
> the need of page tables from other memory ranges mapping.

I don't fully understand this. Can you be more specific?

> The current SOC or hardware platform designs had not broken this constraint.
> But we can make the software more versatile.

We need to have code readability in mind ;).

> In addition, for the 4K page system, to comply with the constraint No.1, the
> start address of some memory ranges is forced to align at PMD boundary, it
> will make some marginal pages of that ranges are skipped to build the PTE. It
> is not reasonable.

It is reasonable to ask for the start of RAM to be on a PMD (2MB)
boundary.

> This patch will relieve the system from those constraints. You can load the
> kernel image in any memory range, the memory range can be small, can start at
> non-alignment boundary, and so on.

I guess you still depend on the PAGE_OFFSET, TEXT_OFFSET, so it's not
random.

I'm not sure what the end goal is with this patch but my plan is to
entirely decouple TEXT_OFFSET from PAGE_OFFSET (with a duplicate mapping
for the memory covering the kernel text). This would allow us to load
the kernel anywhere in RAM (well, with some sane alignment to benefit
from section mapping) and the PHYS_OFFSET detected from DT at run-time.
Once that's done, I don't think your patch is necessary.

Thanks.

-- 
Catalin
