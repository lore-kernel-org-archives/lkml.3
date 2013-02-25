Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774Ab3BYCyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:54:08 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48396 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759581Ab3BYCyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:54:06 -0500
X-AuditID: 9c930179-b7b61ae000004061-64-512ad24ccd13
Date: Mon, 25 Feb 2013 11:54:03 +0900
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv5 7/8] zswap: add swap page writeback support
Message-ID: <20130225025403.GB6498@blaptop>
References: <1360780731-11708-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1360780731-11708-8-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360780731-11708-8-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Wed, Feb 13, 2013 at 12:38:50PM -0600, Seth Jennings wrote:
> This patch adds support for evicting swap pages that are currently
> compressed in zswap to the swap device.  This functionality is very
> important and make zswap a true cache in that, once the cache is full
> or can't grow due to memory pressure, the oldest pages can be moved
> out of zswap to the swap device so newer pages can be compressed and
> stored in zswap.
> 
> This introduces a good amount of new code to guarantee coherency.
> Most notably, and LRU list is added to the zswap_tree structure,
> and refcounts are added to each entry to ensure that one code path
> doesn't free then entry while another code path is operating on it.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

In this time, I didn't review the code in detail yet but it seems
resolve of all review point in previous interation. Thanks!
But unfortunately, I couldn't find anything related to tmppage handling
so I'd like to ask.

The reason of tmppage is temporal buffer to keep compressed data during
writeback to avoid unnecessary compressing again when we retry?
Is it really critical about performance? What's the wrong if we remove
tmppage handling?

zswap_frontswap_store
retry:
        get_cpu_var(zswap_dstmem);
        zswap_com_op(COMPRESS)
        zs_malloc()
        if (!handle) {
                put_cpu_var(zswap_dstmem);
                if (retry > MAX_RETRY)
                        goto error_nomem;
                zswap_flush_entries()
                goto retry;
        }


-- 
Kind regards,
Minchan Kim
