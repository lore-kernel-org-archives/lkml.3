Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaEOIkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:40:10 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53183 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaEOIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:40:03 -0400
Date: Thu, 15 May 2014 10:40:55 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-Id: <20140515104055.e91844a5b75529edc560349a@gmail.com>
In-Reply-To: <20140514140034.GM30445@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
	<20140514140034.GM30445@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 14 May 2014 16:00:34 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, May 09, 2014 at 12:04:55PM -0400, Tejun Heo wrote:
> > Hello, guys.
> > 
> > So, after resuming from suspend, I found my build jobs can not migrate
> > away from the CPU it started on and thus just making use of single
> > core.  It turns out the scheduler failed to build sched domains due to
> > order-3 allocation failure.
> > 

[snip]

> 
> Does something like the below help any? I noticed those things (cpudl
> and cpupri) had [NR_CPUS] arrays, which is always 'fun'.
>

Yeah, not nice :/.
 
> The below is a mostly no thought involved conversion of cpudl which
> boots, I'll also do cpupri and then actually stare at the algorithms to
> see if I didn't make any obvious fails.
> 
> Juri?
> 
> ---
>  kernel/sched/cpudeadline.c | 29 +++++++++++++++++++----------
>  kernel/sched/cpudeadline.h |  6 +++---
>  2 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
> index ab001b5d5048..c34ab09a790b 100644
> --- a/kernel/sched/cpudeadline.c
> +++ b/kernel/sched/cpudeadline.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/gfp.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include "cpudeadline.h"
>  
>  static inline int parent(int i)
> @@ -37,10 +38,7 @@ static inline int dl_time_before(u64 a, u64 b)
>  
>  static void cpudl_exchange(struct cpudl *cp, int a, int b)
>  {
> -	int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
> -
>  	swap(cp->elements[a], cp->elements[b]);
> -	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
>  }
>  

I think there is a problem here. Your patch "embeds" cpu_to_idx array
in elements array, but here the swap operates differently on the two.
Let me try to clarify with a simple example.

On a 4CPU system suppose we have this situation:

                      CPU 1
                      DL 50
                    /       \         
                   /         \
                  X           X
                 /
                /
               X

-- orig

elements[dl/cpu] | 50/1  |  0/0  |  0/0  |  0/0  |
                       ^
                        \
                         \
                          \
cpu_to_idx[idx]  |  -1   |   0   |  -1   |   -1  |

-- yours

elements[dl/cpu] | 50/1  |  0/0  |  0/0  |  0/0  |
                       ^
                        \
                         \
                          \
elements[idx]    |  -1   |   0   |  -1   |   -1  |

So since here all is fine.

But, what happens if I call cpudl_set(&cp, 2, 55, 1) ?

No surprises we insert the new element and then we try to bring it to
root (as it has max-dline). New situation is:

                      CPU 1
                      DL 50
                    /       \         
                   /         \
           ^    CPU2          X
           |    DL 55
                 /
                /
               X

-- orig

elements[dl/cpu] | 50/1  |  55/2  |  0/0  |  0/0  |
                       ^       ^
                        \       \
                         \       \
                          \       \
cpu_to_idx[idx]  |  -1   |   0   |  1   |   -1  |

-- yours

elements[dl/cpu] | 50/1  |  55/2  |  0/0  |  0/0  |
                       ^       ^
                        \       \
                         \       \
                          \       \
elements[idx]    |  -1   |   0   |  1   |   -1  |

Now, we do cpudl_exchange(&cp, 1, 0).

In orig we have

static void cpudl_exchange(struct cpudl *cp, int a, int b)
{
        int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;

        swap(cp->elements[a], cp->elements[b]);
        swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
}

note that here a = 1, b = 0, cpu_a = 2 and cpu_b = 1.

While in yours

static void cpudl_exchange(struct cpudl *cp, int a, int b)
{
        swap(cp->elements[a], cp->elements[b]);
}

so we end up with

-- orig

elements[dl/cpu] | 55/2  |  50/1  |  0/0  |  0/0  |
                     ^       ^
                     |       |
                     +-------|------+
                             |      |
cpu_to_idx[idx]  |  -1   |   1   |  0   |   -1  |

-- yours

elements[dl/cpu] | 55/2  |  50/1  |  0/0  |  0/0  |
                     ^        ^
                     |        |
                     |        +------+
                     |               |
elements[idx]    |   0   |   -1   |  1   |   -1  |

and this breaks how the heap works. For example, what if I want to
update CPU1 deadline? In orig I correctly get it at position 1 of
elements array. But with the patch CPU1's idx is IDX_INVALID.

Sorry for this long reply, but I had to convince also myself...

So, I think that having just one dynamic array is nicer and better, but
we still need to swap things separately. Something like (on top of
yours):

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 60ad0af..10dc7ab 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -36,9 +36,31 @@ static inline int dl_time_before(u64 a, u64 b)
        return (s64)(a - b) < 0;
 }
 
+static inline void swap_element(struct cpudl *cp, int a, int b)
+{
+       int cpu_tmp = cp->elements[a].cpu;
+       u64 dl_tmp = cp->elements[a].dl;
+
+       cp->elements[a].cpu = cp->elements[b].cpu;
+       cp->elements[a].dl = cp->elements[b].dl;
+       cp->elements[b].cpu = cpu_tmp;
+       cp->elements[b].dl = dl_tmp;
+}
+
+static inline void swap_idx(struct cpudl *cp, int a, int b)
+{
+       int idx_tmp = cp->elements[a].idx;
+
+       cp->elements[a].idx = cp->elements[b].idx;
+       cp->elements[b].idx = idx_tmp;
+}
+
 static void cpudl_exchange(struct cpudl *cp, int a, int b)
 {
-       swap(cp->elements[a], cp->elements[b]);
+       int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
+
+       swap_element(cp, a, b);
+       swap_idx(cp, cpu_a, cpu_b);
 }
 
 static void cpudl_heapify(struct cpudl *cp, int idx)
---

But, I don't know if this is too ugly and we better go with two arrays
(or a better solution, as this is the fastest thing I could come up
with :)).

In the meanwhile I'll test this more...

Thanks a lot,

- Juri

>  static void cpudl_heapify(struct cpudl *cp, int idx)
> @@ -140,7 +138,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
>  	WARN_ON(!cpu_present(cpu));
>  
>  	raw_spin_lock_irqsave(&cp->lock, flags);
> -	old_idx = cp->cpu_to_idx[cpu];
> +	old_idx = cp->elements[cpu].idx;
>  	if (!is_valid) {
>  		/* remove item */
>  		if (old_idx == IDX_INVALID) {
> @@ -155,8 +153,8 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
>  		cp->elements[old_idx].dl = cp->elements[cp->size - 1].dl;
>  		cp->elements[old_idx].cpu = new_cpu;
>  		cp->size--;
> -		cp->cpu_to_idx[new_cpu] = old_idx;
> -		cp->cpu_to_idx[cpu] = IDX_INVALID;
> +		cp->elements[new_cpu].idx = old_idx;
> +		cp->elements[cpu].idx = IDX_INVALID;
>  		while (old_idx > 0 && dl_time_before(
>  				cp->elements[parent(old_idx)].dl,
>  				cp->elements[old_idx].dl)) {
> @@ -173,7 +171,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
>  		cp->size++;
>  		cp->elements[cp->size - 1].dl = 0;
>  		cp->elements[cp->size - 1].cpu = cpu;
> -		cp->cpu_to_idx[cpu] = cp->size - 1;
> +		cp->elements[cpu].idx = cp->size - 1;
>  		cpudl_change_key(cp, cp->size - 1, dl);
>  		cpumask_clear_cpu(cpu, cp->free_cpus);
>  	} else {
> @@ -195,10 +193,21 @@ int cpudl_init(struct cpudl *cp)
>  	memset(cp, 0, sizeof(*cp));
>  	raw_spin_lock_init(&cp->lock);
>  	cp->size = 0;
> -	for (i = 0; i < NR_CPUS; i++)
> -		cp->cpu_to_idx[i] = IDX_INVALID;
> -	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL))
> +
> +	cp->elements = kcalloc(num_possible_cpus(),
> +			       sizeof(struct cpudl_item),
> +			       GFP_KERNEL);
> +	if (!cp->elements)
> +		return -ENOMEM;
> +
> +	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
> +		kfree(cp->elements);
>  		return -ENOMEM;
> +	}
> +
> +	for_each_possible_cpu(i)
> +		cp->elements[i].idx = IDX_INVALID;
> +
>  	cpumask_setall(cp->free_cpus);
>  
>  	return 0;
> diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
> index a202789a412c..538c9796ad4a 100644
> --- a/kernel/sched/cpudeadline.h
> +++ b/kernel/sched/cpudeadline.h
> @@ -5,17 +5,17 @@
>  
>  #define IDX_INVALID     -1
>  
> -struct array_item {
> +struct cpudl_item {
>  	u64 dl;
>  	int cpu;
> +	int idx;
>  };
>  
>  struct cpudl {
>  	raw_spinlock_t lock;
>  	int size;
> -	int cpu_to_idx[NR_CPUS];
> -	struct array_item elements[NR_CPUS];
>  	cpumask_var_t free_cpus;
> +	struct cpudl_item *elements;
>  };
>  
>  
