Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbaCTKFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:05:02 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51521 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaCTKFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:05:00 -0400
Message-ID: <532ABD0D.8020607@oracle.com>
Date: Thu, 20 Mar 2014 18:03:57 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: performance regression due to commit e82e0561("mm: vmscan: obey
 proportional scanning requirements for kswapd")
References: <20140218080122.GO26593@yliu-dev.sh.intel.com>
In-Reply-To: <20140218080122.GO26593@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/2014 04:01 PM, Yuanhan Liu wrote:
> Hi,
> 
> Commit e82e0561("mm: vmscan: obey proportional scanning requirements for
> kswapd") caused a big performance regression(73%) for vm-scalability/
> lru-file-readonce testcase on a system with 256G memory without swap.
> 
> That testcase simply looks like this:
>      truncate -s 1T /tmp/vm-scalability.img
>      mkfs.xfs -q /tmp/vm-scalability.img
>      mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability
> 
>      SPARESE_FILE="/tmp/vm-scalability/sparse-lru-file-readonce"
>      for i in `seq 1 120`; do
>          truncate $SPARESE_FILE-$i -s 36G
>          timeout --foreground -s INT 300 dd bs=4k if=$SPARESE_FILE-$i of=/dev/null
>      done
> 
>      wait
> 
> Actually, it's not the newlly added code(obey proportional scanning)
> in that commit caused the regression. But instead, it's the following
> change:
> +
> +               if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
> +                       continue;
> +
> 
> 
> -               if (nr_reclaimed >= nr_to_reclaim &&
> -                   sc->priority < DEF_PRIORITY)
> +               if (global_reclaim(sc) && !current_is_kswapd())
>                         break;
> 
> The difference is that we might reclaim more than requested before
> in the first round reclaimming(sc->priority == DEF_PRIORITY).
> 

>From my understanding, I also think we used to reclaim more memory if
sc->priority==DEF_PRIORITY. See the while loop:

while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
                                       nr[LRU_INACTIVE_FILE]) {

For kswapd, the loop will continue until nr[LRU_INACTIVE_ANON],
nr[LRU_ACTIVE_FILE] and nr[LRU_INACTIVE_FILE] become zero.

But in commit e82e0561("mm: vmscan: obey proportional scanning
requirements for kswapd"), nr[lru] was set to 0.

/* Stop scanning the smaller of the LRU */
nr[lru] = 0;
nr[lru + LRU_ACTIVE] = 0;

And the other LRU scan count was also recalculated, as a result the
total scan count in this round may less than original code.

So I think this change is reasonable which make the behaviour the same
as before(also no performance drop).

-- 
Regards,
-Bob
