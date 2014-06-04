Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaFDCUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 22:20:16 -0400
Received: from linuxhacker.ru ([217.76.32.60]:38033 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbaFDCUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 22:20:10 -0400
Subject: Re: [patch] mm, pcp: allow restoring percpu_pagelist_fraction default
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <alpine.DEB.2.02.1406031819580.8682@chino.kir.corp.google.com>
Date: Tue, 3 Jun 2014 22:19:12 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Transfer-Encoding: 8BIT
Message-Id: <85AFB547-D3A1-4818-AD82-FF90909775D2@linuxhacker.ru>
References: <1399166883-514-1-git-send-email-green@linuxhacker.ru> <alpine.DEB.2.02.1406021837490.13072@chino.kir.corp.google.com> <B549468A-10FC-4897-8720-7C9FEC6FD03A@linuxhacker.ru> <alpine.DEB.2.02.1406022056300.20536@chino.kir.corp.google.com> <2C763027-307F-4BC0-8C0A-7E3D5957A4DA@linuxhacker.ru> <alpine.DEB.2.02.1406031819580.8682@chino.kir.corp.google.com>
To: David Rientjes <rientjes@google.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Jun 3, 2014, at 9:22 PM, David Rientjes wrote:
> 
> @@ -5849,21 +5850,32 @@ int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
> int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
> 	void __user *buffer, size_t *length, loff_t *ppos)
> {
> +	const int old_percpu_pagelist_fraction = percpu_pagelist_fraction;
> 	struct zone *zone;
> -	unsigned int cpu;
> 	int ret;
> 
> 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
> -	if (!write || (ret < 0))
> +	if (!write || ret < 0)
> 		return ret;
> 
> +	/* Sanity checking to avoid pcp imbalance */
> +	if (percpu_pagelist_fraction &&
> +	    percpu_pagelist_fraction < MIN_PERCPU_PAGELIST_FRACTION) {
> +		percpu_pagelist_fraction = old_percpu_pagelist_fraction;
> +		return -EINVAL;
> +	}
> +
> +	/* No change? */
> +	if (percpu_pagelist_fraction == old_percpu_pagelist_fraction)
> +		return 0;
> +
> 	mutex_lock(&pcp_batch_high_lock);
> 	for_each_populated_zone(zone) {
> -		unsigned long  high;
> -		high = zone->managed_pages / percpu_pagelist_fraction;
> +		unsigned int cpu;
> +
> 		for_each_possible_cpu(cpu)
> -			pageset_set_high(per_cpu_ptr(zone->pageset, cpu),
> -					 high);
> +			pageset_set_high_and_batch(zone,
> +					per_cpu_ptr(zone->pageset, cpu));

BTW, I just realized this version is racy (as was the previous one). 
A parallel writer could write a value of 0 while we are in the middle of pageset_set_high_and_batch
and it's possible that'll result in division by zero still.
Also it's possible an incorrect value might set for some of the zones.

I imagine we might want to expand the lock area all the way up to before the proc_dointvec_minmax call jsut to be extra safe.

> 	}
> 	mutex_unlock(&pcp_batch_high_lock);
> 	return 0;

Bye,
    Oleg