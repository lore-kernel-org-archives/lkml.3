Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3B1WBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:01:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36755 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3B1WBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:01:45 -0500
MIME-Version: 1.0
Message-ID: <0621544c-dbb7-44ff-bfd0-ee623439bd9d@default>
Date: Thu, 28 Feb 2013 14:00:36 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: minchan@kernel.org, sjenning@linux.vnet.ibm.com,
        Nitin Gupta <nitingupta910@gmail.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Bob Liu <lliubbo@gmail.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>
Subject: RE: zsmalloc limitations and related topics
References: <0efe9610-1aa5-4aa9-bde9-227acfa969ca@default>
In-Reply-To: <0efe9610-1aa5-4aa9-bde9-227acfa969ca@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dan Magenheimer
> Subject: zsmalloc limitations and related topics
> 
> WORKLOAD ANALYSIS
>   :
> 1) The average page compressed by almost a factor of six
>    (mean zsize == 694, stddev == 474)
> 2) Almost eleven percent of the pages were zero pages.  A
>    zero page compresses to 28 bytes.
> 3) On average, 77% of the bytes (3156) in the pages-to-be-
>    compressed contained a byte-value of zero.
> 4) Despite the above, mean density of zsmalloc was measured at
>    3.2 zpages/pageframe, presumably losing nearly half of
>    available space to fragmentation.
> 
> I have no clue if these measurements are representative
> of a wide range of workloads over the lifetime of a booted
> machine, but I am suspicious that they are not.  For example,
> the lzo1x compression algorithm claims to compress data by
> about a factor of two.

I realized that with a small hack in zswap, I could simulate the
effect on zsmalloc of a workload with very different zsize
distribution, one with a much higher mean, by simply doubling
(and tripling) the zsize passed to zs_malloc.  The results:

Unchanged: mean=694 stddev=474 -> mean density = 3.2
Doubled:   mean=1340 stddev=842 -> mean density = 1.9
Tripled:   mean=1636 stddev=1031 -> mean density = 1.6

Note that even tripled, the mean of the simulated
distribution is still much lower than PAGE_SIZE/2,
which is roughly the published expected compression for
lzo1x.  So one would still expect a mean density greater
than two but, apparently, one-third of available space is
lost to fragmentation.

Without a "representative" workload, I still have no clue
as to whether this simulated distribution is relevant,
but it is interesting to note that, for a workload with
lower mean compressibility, zsmalloc's reputation as
"high density" may be undeserved.

