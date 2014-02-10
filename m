Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBJLa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:30:29 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:43096 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaBJLa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:30:26 -0500
Date: Mon, 10 Feb 2014 12:30:19 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH RFC/RFT v2 3/8] s390: move cacheinfo sysfs to generic
 cacheinfo infrastructure
Message-ID: <20140210113019.GC19013@osiris>
References: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com>
 <1391791763-28518-4-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391791763-28518-4-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021011-8372-0000-0000-0000089B4D73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 04:49:18PM +0000, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> This patch removes the redundant sysfs cacheinfo code by making use of
> the newly introduced generic cacheinfo infrastructure.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>

[...]

> -static ssize_t shared_cpu_map_func(struct kobject *kobj, int type, char *buf)
> -{
> -	struct cache_index_dir *index;
> -	int len;
> +	this_leaf->level = level + 1;
> +	this_leaf->type = type;
> +	this_leaf->coherency_line_size = ecag(EXTRACT_LINE_SIZE, level, ti);
> +	this_leaf->ways_of_associativity = ecag(EXTRACT_ASSOCIATIVITY,
> +						level, ti);
> +	this_leaf->size = ecag(EXTRACT_SIZE, level, ti);
> +	if (private)
> +		cpumask_set_cpu(cpu, &this_leaf->shared_cpu_map);
> +	else /* System wide */
> +		cpumask_copy(&this_leaf->shared_cpu_map, cpu_online_mask);

FWIW, this also seems to be wrong: on s390 we only expose cpu private
caches via sysfs. Shared caches are not exposed (and simply saying they are
system wide would be wrong).
Please have a look at these two commits which should describe why things
are as they are on s390:

881730ad365130f64b5c70c40904b04eb3b79de3
 "s390/cache: expose cpu cache topology via sysfs"
6668022c7bde3fdc96d3d257294a7216c7a46829
 "s390/cache: add cpu cache information to /proc/cpuinfo"

