Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab3HMXvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:51:11 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62259 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3HMXvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:51:10 -0400
Date: Tue, 13 Aug 2013 19:51:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 2/2] mm: make lru_add_drain_all() selective
Message-ID: <20130813235104.GK28996@mtj.dyndns.org>
References: <520AAF9C.1050702@tilera.com>
 <201308132307.r7DN74M5029053@farm-0021.internal.tilera.com>
 <20130813232904.GJ28996@mtj.dyndns.org>
 <520AC4F7.9090604@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520AC4F7.9090604@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 07:44:55PM -0400, Chris Metcalf wrote:
> int lru_add_drain_all(void)
> {
>         static struct cpumask mask;

Instead of cpumask,

>         static DEFINE_MUTEX(lock);

you can DEFINE_PER_CPU(struct work_struct, ...).

>         for_each_online_cpu(cpu) {
>                 if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
>                     pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
>                     pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
>                     need_activate_page_drain(cpu))
>                         cpumask_set_cpu(cpu, &mask);

and schedule the work items directly.

>         }
> 
>         rc = schedule_on_cpu_mask(lru_add_drain_per_cpu, &mask);

Open coding flushing can be a bit bothersome but you can create a
per-cpu workqueue and schedule work items on it and then flush the
workqueue instead too.

No matter how flushing is implemented, the path wouldn't have any
memory allocation, which I thought was the topic of the thread, no?

Thanks.

-- 
tejun
