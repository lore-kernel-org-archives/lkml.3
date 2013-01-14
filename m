Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3ANLBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:01:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50592 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3ANLBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:01:18 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-99-50f3e57c32bc
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: Introducing Aggressive Low Memory Booster [1]
Date: Mon, 14 Jan 2013 12:00:42 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "patches@linaro.org" <patches@linaro.org>,
        Mel Gorman <mgorman@suse.de>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
 <1334842941.92324.YahooMailNeo@web162006.mail.bf1.yahoo.com>
 <1358091177.96940.YahooMailNeo@web160103.mail.bf1.yahoo.com>
In-reply-to: <1358091177.96940.YahooMailNeo@web160103.mail.bf1.yahoo.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201301141200.43240.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jAd2ap58DDGZfNrK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZH/f9Zy1Yr1LxbV0XUwPjZokuRk4OCQETic4L75ggbDGJC/fW
	s3UxcnEICSxilHgzbx87hLOUSeLCjhNsIFVsAlYSE9tXMYLYIgKaEn0vWthBbGGgeNP53WA1
	LAKqElefHGYBsUUFHCQ6p04Am8os8IVZYtu8vVBTjzFKHF/8GKybU8BT4uCkO2A2r4CgxI/J
	98C6mQW0JJrfbGKEsOUlNq95ywxRYylxZ30T2wRGgVlIWmYhaZmFpGUBI/MqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjOAwfCa1g3Flg8UhRgEORiUe3kkRnwOEWBPLiitzDzFKcDArifBO
	Ow0U4k1JrKxKLcqPLyrNSS0+xCjNwaIkzst46kmAkEB6YklqdmpqQWoRTJaJg1OqgdH5k09n
	+VR5aeO0ZZr7i9vYltzR9dN96Je44vkX1v1rWI56VxfnCggqyq6Ij5KslPbbtdjD/JeqblOY
	Cu/DwJXme9K2XSq4aG+Y4B35x3PSgfSlKskR2Qf9330oO2108NS18knJXTsTls2ecPeq0LzE
	VfM3WlVo+N88fmX3pHmG4R865O4xRyixFGckGmoxFxUnAgDtilWoPwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 January 2013 16:32:57 PINTU KUMAR wrote:
> Hi,
> 
> Here I am trying to introduce a new feature in kernel called "Aggressive Low Memory Booster".
> The main advantage of this will be to boost the available free memory of the system to "certain level" during extremely low memory condition.
> 
> Please provide your comments to improve further.

Could you please post the code somewhere so it can be reviewed?

Thanks,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center

> Can it be used along with vmpressure_fd ???
> 
> 
> It can be invoked as follows:
>     a) Automatically by kernel memory management when the memory threshold falls below 10MB.
>     b) From user space program/scripts by passing the "required amount of memory to be reclaimed".
>     Example: echo 100 > /dev/shrinkmem
>     c) using sys interface - /sys/kernel/debug/shrinkallmem
>     d) using an ioctl call and returning number of pages reclaimed.
>     e) using a new system call - shrinkallmem(&nrpages);
>     f) During CMA to reclaim and shrink a specific CMA regions.
> 
> 
> I have developed a kernel module to verify the (b) part.
> 
> Here is the snapshot of the write call:
> +static ssize_t shrinkmem_write(struct file *file, const char *buff,
> +                                size_t length, loff_t *pos)
> +{
> +        int ret = -1;
> +        unsigned long memsize = 0;
> +        unsigned long nr_reclaim = 0;
> +        unsigned long pages = 0;
> +        ret = kstrtoul_from_user(buff, length, 0, &memsize);
> +        if (ret < 0) {
> +                printk(KERN_ERR "[SHRINKMEM]: kstrtoul_from_user: Failed !\n");
> +                return -1;
> +        }
> +        printk(KERN_INFO "[SHRINKMEM]: memsize(in MB) = %ld\n",
> +                                (unsigned long)memsize);
> +        memsize = memsize*(1024UL*1024UL);
> +        nr_reclaim = memsize / PAGE_SIZE;
> +        pages = shrink_all_memory(nr_reclaim);
> +        printk(KERN_INFO "<SHRINKMEM>: Number of Pages Freed: %lu\n", pages);
> +        return pages;
> +}
> Please note: This requires CONFIG_HIBERNATION to be permanently enabled in the kernel.
> 
> 
> Several experiments have been performed on Ubuntu(kernel 3.3) to verify it under low memory conditions.
> 
> Following are some results obtained:
> -------------------------------------
> 
> Node 0, zone      DMA    290    115      0      0      0      0      0      0      0      0      0
> Node 0, zone   Normal    304    540    116     13      2      2      0      0      0      0      0
> =========================
>              total       used       free     shared    buffers     cached
> Mem:           497        487         10          0         63        303
> -/+ buffers/cache:        120        376
> Swap:         1458         34       1424
> Total:        1956        522       1434
> =========================
> Total Memory Freed: 342 MB
> Total Memory Freed: 53 MB
> Total Memory Freed: 23 MB
> Total Memory Freed: 10 MB
> Total Memory Freed: 15 MB
> Total Memory Freed: -1 MB
> Node 0, zone      DMA      6      6      7      8     10      9      7      4      1      0      0
> Node 0, zone   Normal   2129   2612   2166   1723   1260    759    359    108     10      0      0
> =========================
>              total       used       free     shared    buffers     cached
> Mem:           497         47        449          0          0          5
> -/+ buffers/cache:         41        455
> Swap:         1458         97       1361
> Total:        1956        145       1811
> =========================
> 
> It was verified using a sample shell script "reclaim_memory.sh" which keeps recovering memory by doing "echo 500 > /dev/shrinkmem" until no further reclaim is possible.
> 
> The experiments were performed with various scenarios as follows:
> a) Just after the boot up - (could recover around 150MB with 512MB RAM)
> b) After running many applications include youtube videos, large tar files download - 
> 
>    [until free mem becomes < 10MB]
>    [Could recover around 300MB in one shot]
> c) Run reclaim, while download is in progress and video still playing - (Not applications killed)
> 
> d) revoke all background applications again, after running reclaim - (No impact, normal behavior)
>    [Just it took little extra time to launch, as if it was launched for first time]
> 
> 
> Please see more discussions on this in the last year mailing list:
> 
> https://lkml.org/lkml/2012/4/15/35 
> 
> 
> Thank You!
> With regards,
> Pintu Kumar
> Samsung - India
