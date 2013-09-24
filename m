Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3IXMl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:41:27 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:50742 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3IXMlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:41:25 -0400
Date: Tue, 24 Sep 2013 08:41:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
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
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: Re: [PATCH 6/6] mem-hotplug: Introduce movablenode boot option
Message-ID: <20130924124121.GG2366@htj.dyndns.org>
References: <524162DA.30004@cn.fujitsu.com>
 <5241655E.1000007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5241655E.1000007@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 24, 2013 at 06:11:42PM +0800, Zhang Yanfei wrote:
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 36cfce3..2cf04fd 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1132,6 +1132,14 @@ void __init setup_arch(char **cmdline_p)
>  	early_acpi_boot_init();
>  
>  	initmem_init();
> +
> +	/*
> +	 * When ACPI SRAT is parsed, which is done in initmem_init(),
> +	 * set memblock back to the top-down direction.
> +	 */
> +	if (memblock_bottom_up())
> +		memblock_set_bottom_up(false);

I don't think you need the if ().  Just call
memblock_set_bottom_up(false).

> +static int __init cmdline_parse_movablenode(char *p)
> +{
> +	/*
> +	 * Memory used by the kernel cannot be hot-removed because Linux
> +	 * cannot migrate the kernel pages. When memory hotplug is
> +	 * enabled, we should prevent memblock from allocating memory
> +	 * for the kernel.
> +	 *
> +	 * ACPI SRAT records all hotpluggable memory ranges. But before
> +	 * SRAT is parsed, we don't know about it.
> +	 *
> +	 * The kernel image is loaded into memory at very early time. We
> +	 * cannot prevent this anyway. So on NUMA system, we set any
> +	 * node the kernel resides in as un-hotpluggable.
> +	 *
> +	 * Since on modern servers, one node could have double-digit
> +	 * gigabytes memory, we can assume the memory around the kernel
> +	 * image is also un-hotpluggable. So before SRAT is parsed, just
> +	 * allocate memory near the kernel image to try the best to keep
> +	 * the kernel away from hotpluggable memory.
> +	 */
> +	memblock_set_bottom_up(true);
> +	return 0;
> +}
> +early_param("movablenode", cmdline_parse_movablenode);

This came up during earlier review but never was addressed.  Is
"movablenode" the right name?  Shouldn't it be something which
explicitly shows that it's to prepare for memory hotplug?  Also, maybe
the above param should generate warning if CONFIG_MOVABLE_NODE isn't
enabled?

Thanks.

-- 
tejun
