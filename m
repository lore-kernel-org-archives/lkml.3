Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab3HMXo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:44:58 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:43542 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab3HMXo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:44:57 -0400
Message-ID: <520AC4F7.9090604@tilera.com>
Date: Tue, 13 Aug 2013 19:44:55 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 2/2] mm: make lru_add_drain_all() selective
References: <520AAF9C.1050702@tilera.com> <201308132307.r7DN74M5029053@farm-0021.internal.tilera.com> <20130813232904.GJ28996@mtj.dyndns.org>
In-Reply-To: <20130813232904.GJ28996@mtj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2013 7:29 PM, Tejun Heo wrote:
> It won't nest and doing it simultaneously won't buy anything, right?
> Wouldn't it be better to protect it with a mutex and define all
> necessary resources statically (yeah, cpumask is pain in the ass and I
> think we should un-deprecate cpumask_t for static use cases)?  Then,
> there'd be no allocation to worry about on the path.

Here's what lru_add_drain_all() looks like with a guarding mutex.
Pretty much the same code complexity as when we have to allocate the
cpumask, and there really aren't any issues from locking, since we can assume
all is well and return immediately if we fail to get the lock.

int lru_add_drain_all(void)
{
        static struct cpumask mask;
        static DEFINE_MUTEX(lock);
        int cpu, rc;

        if (!mutex_trylock(&lock))
                return 0;  /* already ongoing elsewhere */

        cpumask_clear(&mask);
        get_online_cpus();

        /*
         * Figure out which cpus need flushing.  It's OK if we race
         * with changes to the per-cpu lru pvecs, since it's no worse
         * than if we flushed all cpus, since a cpu could still end
         * up putting pages back on its pvec before we returned.
         * And this avoids interrupting other cpus unnecessarily.
         */
        for_each_online_cpu(cpu) {
                if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
                    pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
                    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
                    need_activate_page_drain(cpu))
                        cpumask_set_cpu(cpu, &mask);
        }

        rc = schedule_on_cpu_mask(lru_add_drain_per_cpu, &mask);

        put_online_cpus();
        mutex_unlock(&lock);
        return rc;
}

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

