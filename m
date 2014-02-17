Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaBQOou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:44:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43463 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaBQOot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:44:49 -0500
Date: Mon, 17 Feb 2014 15:44:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 07/11] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20140217144436.GS27965@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-8-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391683834-29868-8-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 12:50:30PM +0200, Alexander Shishkin wrote:
> +static int topa_insert_pages(struct pt_buffer *buf, gfp_t gfp,
> +			     enum topa_sz sz)
> +{
> +	struct topa *topa = buf->last;
> +	int node = cpu_to_node(buf->cpu);
> +	int order = get_order(sizes(sz));
> +	struct page *p;
> +	unsigned long pn;
> +
> +	p = alloc_pages_node(node, gfp | GFP_USER | __GFP_ZERO | __GFP_NOWARN | __GFP_NORETRY, order);
> +	if (!p)
> +		return -ENOMEM;

> +
> +	return 0;
> +}
> +
> +static int pt_buffer_init_topa(struct pt_buffer *buf, size_t size, gfp_t gfp)
> +{
> +	struct topa *topa;
> +	int err, region_size;
> +
> +	topa = topa_alloc(buf->cpu, gfp);
> +	if (!topa)
> +		return -ENOMEM;
> +
> +	topa_insert_table(buf, topa);
> +
> +	region_size = pt_get_topa_region_size(buf->snapshot, size);
> +	if (region_size < 0) {
> +		pt_buffer_fini_topa(buf);
> +		return region_size;
> +	}
> +
> +	while (region_size && get_order(sizes(region_size)) > MAX_ORDER)
> +		region_size--;
> +
> +	/* fixup watermark in case of higher order allocations */
> +	if (buf->watermark < (sizes(region_size) >> PAGE_SHIFT))
> +		buf->watermark = sizes(region_size) >> PAGE_SHIFT;
> +
> +	while (buf->size < size) {
> +		err = topa_insert_pages(buf, gfp, region_size);
> +		if (err) {
> +			if (region_size) {
> +				region_size--;
> +				continue;
> +			}
> +			pt_buffer_fini_topa(buf);
> +			return -ENOMEM;
> +		}
> +	}

So MAX_ORDER is 11, which gives us (11+12) 23bit or 8M max allocations, right?

Given this TOPA stuff is completely fucked in the first release, that's
about all we can get it, right?

Now given you said 100s MB/s data rate for this itrace stuff, we're at
~0.1s traces. And that's in the very best case where we can actually get
8M.

Is that a workable amount?

