Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3IZOtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:49:03 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:38111 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3IZOs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:48:57 -0400
Date: Thu, 26 Sep 2013 10:48:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com,
        "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 4/6] x86/mem-hotplug: Support initialize page tables
 in bottom-up
Message-ID: <20130926144851.GF3482@htj.dyndns.org>
References: <5241D897.1090905@gmail.com>
 <5241DA5B.8000909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5241DA5B.8000909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 25, 2013 at 02:30:51AM +0800, Zhang Yanfei wrote:
> +/**
> + * memory_map_bottom_up - Map [map_start, map_end) bottom up
> + * @map_start: start address of the target memory range
> + * @map_end: end address of the target memory range
> + *
> + * This function will setup direct mapping for memory range
> + * [map_start, map_end) in bottom-up.

Ditto about the comment.

> + */
> +static void __init memory_map_bottom_up(unsigned long map_start,
> +					unsigned long map_end)
> +{
> +	unsigned long next, new_mapped_ram_size, start;
> +	unsigned long mapped_ram_size = 0;
> +	/* step_size need to be small so pgt_buf from BRK could cover it */
> +	unsigned long step_size = PMD_SIZE;
> +
> +	start = map_start;
> +	min_pfn_mapped = start >> PAGE_SHIFT;
> +
> +	/*
> +	 * We start from the bottom (@map_start) and go to the top (@map_end).
> +	 * The memblock_find_in_range() gets us a block of RAM from the
> +	 * end of RAM in [min_pfn_mapped, max_pfn_mapped) used as new pages
> +	 * for page table.
> +	 */
> +	while (start < map_end) {
> +		if (map_end - start > step_size) {
> +			next = round_up(start + 1, step_size);
> +			if (next > map_end)
> +				next = map_end;
> +		} else
> +			next = map_end;
> +
> +		new_mapped_ram_size = init_range_memory_mapping(start, next);
> +		start = next;
> +
> +		if (new_mapped_ram_size > mapped_ram_size)
> +			step_size <<= STEP_SIZE_SHIFT;
> +		mapped_ram_size += new_mapped_ram_size;
> +	}
> +}

As Yinghai pointed out in another thread, do we need to worry about
falling back to top-down?

Thanks.

-- 
tejun
