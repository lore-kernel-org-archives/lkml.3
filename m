Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3C0RVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:21:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48002 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab3C0RVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:21:07 -0400
Message-ID: <51532A0F.3010402@linux.vnet.ibm.com>
Date: Wed, 27 Mar 2013 12:19:11 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>
Subject: Re: [RFC] mm: remove swapcache page early
References: <1364350932-12853-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1364350932-12853-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032717-7182-0000-0000-000005F9EFA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 09:22 PM, Minchan Kim wrote:
> Swap subsystem does lazy swap slot free with expecting the page
> would be swapped out again so we can't avoid unnecessary write.
> 
> But the problem in in-memory swap is that it consumes memory space
> until vm_swap_full(ie, used half of all of swap device) condition
> meet. It could be bad if we use multiple swap device, small in-memory swap
> and big storage swap or in-memory swap alone.
> 
> This patch changes vm_swap_full logic slightly so it could free
> swap slot early if the backed device is really fast.

Great idea!

> For it, I used SWP_SOLIDSTATE but It might be controversial.

The comment for SWP_SOLIDSTATE is that "blkdev seeks are cheap". Just
because seeks are cheap doesn't mean the read itself is also cheap.
For example, QUEUE_FLAG_NONROT is set for mmc devices, but some of
them can be pretty slow.

> So let's add Ccing Shaohua and Hugh.
> If it's a problem for SSD, I'd like to create new type SWP_INMEMORY
> or something for z* family.

Afaict, setting SWP_SOLIDSTATE depends on characteristics of the
underlying block device (i.e. blk_queue_nonrot()).  zram is a block
device but zcache and zswap are not.

Any idea by what criteria SWP_INMEMORY would be set?

Also, frontswap backends (zcache and zswap) are a caching layer on top
of the real swap device, which might actually be rotating media.  So
you have the issue of to different characteristics, in-memory caching
on top of rotation media, present in a single swap device.

Thanks,
Seth

