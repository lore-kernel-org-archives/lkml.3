Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029Ab3HNRSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:18:35 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:21178 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3HNRSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:18:34 -0400
Message-ID: <520BBBE7.7020302@tilera.com>
Date: Wed, 14 Aug 2013 13:18:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 2/2] mm: make lru_add_drain_all() selective
References: <520AAF9C.1050702@tilera.com> <201308132307.r7DN74M5029053@farm-0021.internal.tilera.com> <20130813232904.GJ28996@mtj.dyndns.org> <520AC215.4050803@tilera.com> <20130813234629.4ce2ec70.akpm@linux-foundation.org> <520BAA5B.9070407@tilera.com> <20130814165723.GE28628@htj.dyndns.org>
In-Reply-To: <20130814165723.GE28628@htj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2013 12:57 PM, Tejun Heo wrote:
> Hello, Chris.
>
> On Wed, Aug 14, 2013 at 12:03:39PM -0400, Chris Metcalf wrote:
>> Tejun, I don't know if you have a better idea for how to mark a
>> work_struct as being "not used" so we can set and test it here.
>> Is setting entry.next to NULL good?  Should we offer it as an API
>> in the workqueue header?
> Maybe simply defining a static cpumask would be cleaner?

I think you're right, actually.  Andrew, Tejun, how does this look?


static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);

void lru_add_drain_all(void)
{
        static DEFINE_MUTEX(lock);
        static struct cpumask has_work;
        int cpu;

        mutex_lock(&lock);
        get_online_cpus();
        cpumask_clear(&has_work);

        for_each_online_cpu(cpu) {
                struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);

                if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
                    pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
                    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
                    need_activate_page_drain(cpu)) {
                        INIT_WORK(work, lru_add_drain_per_cpu);
                        schedule_work_on(cpu, work);
                        cpumask_set_cpu(cpu, &has_work);
                }
        }

        for_each_cpu(cpu, &has_work)
                flush_work(&per_cpu(lru_add_drain_work, cpu));

        put_online_cpus();
        mutex_unlock(&lock);
}

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

