Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaFEAq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:46:58 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47130 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204AbaFEAqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:46:55 -0400
Subject: Re: [patch v2] mm, pcp: allow restoring percpu_pagelist_fraction default
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <alpine.DEB.2.02.1406041734150.17045@chino.kir.corp.google.com>
Date: Wed, 4 Jun 2014 20:46:05 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FB428F94-91FA-4E4F-8DA3-060C3C41F261@linuxhacker.ru>
References: <1399166883-514-1-git-send-email-green@linuxhacker.ru> <alpine.DEB.2.02.1406021837490.13072@chino.kir.corp.google.com> <B549468A-10FC-4897-8720-7C9FEC6FD03A@linuxhacker.ru> <alpine.DEB.2.02.1406022056300.20536@chino.kir.corp.google.com> <2C763027-307F-4BC0-8C0A-7E3D5957A4DA@linuxhacker.ru> <alpine.DEB.2.02.1406031819580.8682@chino.kir.corp.google.com> <85AFB547-D3A1-4818-AD82-FF90909775D2@linuxhacker.ru> <alpine.DEB.2.02.1406041734150.17045@chino.kir.corp.google.com>
To: David Rientjes <rientjes@google.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Jun 4, 2014, at 8:34 PM, David Rientjes wrote:
> @@ -5850,23 +5851,39 @@ int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
> 	void __user *buffer, size_t *length, loff_t *ppos)
> {
> 	struct zone *zone;
> -	unsigned int cpu;
> +	int old_percpu_pagelist_fraction;
> 	int ret;
> 
> +	mutex_lock(&pcp_batch_high_lock);
> +	old_percpu_pagelist_fraction = percpu_pagelist_fraction;
> +
> 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
> -	if (!write || (ret < 0))
> -		return ret;
> +	if (!write || ret < 0)
> +		goto out;
> +
> +	/* Sanity checking to avoid pcp imbalance */
> +	if (percpu_pagelist_fraction &&
> +	    percpu_pagelist_fraction < MIN_PERCPU_PAGELIST_FRACTION) {
> +		percpu_pagelist_fraction = old_percpu_pagelist_fraction;
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = 0;

Minor nitpick I guess, but ret cannot be anything but 0 here I think (until somebody changes the way proc_dointvec_minmax for write=true operates)?

The patch is good otherwise.

Thanks.