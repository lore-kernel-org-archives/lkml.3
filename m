Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab3HSRrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:47:17 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36072 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab3HSRrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:47:16 -0400
Date: Mon, 19 Aug 2013 12:46:34 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, eternaleye@gmail.com,
        minchan@kernel.org, mgorman@suse.de, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, axboe@kernel.dk, ngupta@vflare.org,
        semenzato@google.com, penberg@iki.fi, sonnyrao@google.com,
        smbarber@google.com, konrad.wilk@oracle.com, riel@redhat.com,
        kmpark@infradead.org, Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH 4/4] mm: zswap: create a pseudo device /dev/zram0
Message-ID: <20130819174634.GB5703@variantweb.net>
References: <1376815249-6611-1-git-send-email-bob.liu@oracle.com>
 <1376815249-6611-5-git-send-email-bob.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376815249-6611-5-git-send-email-bob.liu@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081917-5806-0000-0000-000022797274
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 04:40:49PM +0800, Bob Liu wrote:
> This is used to replace previous zram.
> zram users can enable this feature, then a pseudo device will be created
> automaticlly after kernel boot.
> Just using "mkswp /dev/zram0; swapon /dev/zram0" to use it as a swap disk.
> 
> The size of this pseudeo is controlled by zswap boot parameter
> zswap.max_pool_percent.
> disksize = (totalram_pages * zswap.max_pool_percent/100)*PAGE_SIZE.

This /dev/zram0 will behave nothing like the block device that zram
creates.  It only allows reads/writes to the first PAGE_SIZE area of the
device, for mkswap to work, and then doesn't do anything for all other
accesses.

I guess if you disabled zswap writeback, then... it would somewhat be
the same thing.  We do need to disable zswap writeback in this case so
that zswap does decompressed a ton of pages into the swapcache for
writebacks that will just fail.  Since zsmalloc does not yet support the
reclaim functionality, zswap writeback is implicitly disabled.

But this is really weird conceptually since zswap is a caching layer
that uses frontswap.  If a frontswap store fails, it will try to send
the page to the zram0 device which will fail the write.  Then the page
will be... put back on the active or inactive list?

Also, using the max_pool_percent in calculating the psuedo-device size
isn't right.  Right now, the code makes the device the max size of the
_compressed_ pool, but the underlying swap device size is in
_uncompressed_ pages. So you'll never be able to fill zswap sizing the
device like this, unless every page is highly incompressible to the
point that each compressed page effectively uses a memory pool page, in
which case, the user shouldn't be using memory compression.

This also means that this hasn't been tested in the zswap pool-is-full
case since there is no way, in this code, to hit that case.

In the zbud case the expected compression is 2:1 so you could just
multiply the compressed pool size by 2 and get a good psuedo-device
size.  With zsmalloc the expected compression is harder to determine
since it can achieve very high effective compression ratios on highly
compressible pages.

Seth

