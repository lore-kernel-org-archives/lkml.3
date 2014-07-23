Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbaGWI22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:28:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51699 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbaGWI2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:28:24 -0400
Date: Wed, 23 Jul 2014 10:28:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723082819.GR3935@laptop>
References: <53C77BB8.6030804@daenzer.net>
 <20140717075820.GE19379@twins.programming.kicks-ass.net>
 <53C8E90F.1010306@daenzer.net>
 <53CE00EF.70108@daenzer.net>
 <53CF31AE.30403@daenzer.net>
 <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
 <20140723064948.GK3935@laptop>
 <53CF6CC4.6090207@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53CF6CC4.6090207@daenzer.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:05:24PM +0900, Michel Dänzer wrote:
> On 23.07.2014 15:49, Peter Zijlstra wrote:
> Attached. No FAIL messages yet.

> [    0.467570] __sdt_alloc: allocated ffff8802155ea4c0 with cpus: 
> [    0.467574] __sdt_alloc: allocated ffff8802155ea3c0 with cpus: 
> [    0.467576] __sdt_alloc: allocated ffff8802155ea2c0 with cpus: 
> [    0.467577] __sdt_alloc: allocated ffff8802155ea1c0 with cpus: 
> [    0.467582] __sdt_alloc: allocated ffff8802155ea0c0 with cpus: 
> [    0.467589] __sdt_alloc: allocated ffff880215798f40 with cpus: 
> [    0.467591] __sdt_alloc: allocated ffff880215798e40 with cpus: 
> [    0.467593] __sdt_alloc: allocated ffff880215798d40 with cpus: 
> [    0.467599] __sdt_alloc: allocated ffff880215798c40 with cpus: 
> [    0.467600] __sdt_alloc: allocated ffff880215798b40 with cpus: 
> [    0.467602] __sdt_alloc: allocated ffff880215798a40 with cpus: 
> [    0.467604] __sdt_alloc: allocated ffff880215798940 with cpus: 
> [    0.467627] build_sched_domain: cpu: 0 level: SMT cpu_map: 0-3 tl->mask: 0-1
> [    0.467629] build_sched_domain: cpu: 0 level: MC cpu_map: 0-3 tl->mask: 0-3
> [    0.467631] build_sched_domain: cpu: 1 level: SMT cpu_map: 0-3 tl->mask: 0-1
> [    0.467632] build_sched_domain: cpu: 1 level: MC cpu_map: 0-3 tl->mask: 0-3
> [    0.467634] build_sched_domain: cpu: 2 level: SMT cpu_map: 0-3 tl->mask: 2-3
> [    0.467635] build_sched_domain: cpu: 2 level: MC cpu_map: 0-3 tl->mask: 0-3
> [    0.467637] build_sched_domain: cpu: 3 level: SMT cpu_map: 0-3 tl->mask: 2-3
> [    0.467638] build_sched_domain: cpu: 3 level: MC cpu_map: 0-3 tl->mask: 0-3
> [    0.467640] build_sched_groups: got group ffff8802155ea4c0 with cpus: 
> [    0.467642] build_sched_groups: got group ffff8802155ea3c0 with cpus: 
> [    0.467643] build_sched_groups: got group ffff8802155ea0c0 with cpus: 
> [    0.467644] build_sched_groups: got group ffff880215798e40 with cpus: 
> [    0.467646] build_sched_groups: got group ffff8802155ea2c0 with cpus: 
> [    0.467647] build_sched_groups: got group ffff8802155ea1c0 with cpus: 

Hmm, indeed. And given that I don't see how the cpumask_clear() can make
any difference for you. And your topology information is 'correct'.

Of course, the other thing that patch did is clear sgp->power (now
sgc->capacity). So does adding that back cure things for you?

If it does, we've got to go figure out what's wrong with the sgc
assignments or so.

---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7bc599dc4aa4..0c83265cf7c6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5857,6 +5857,7 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		group = get_group(i, sdd, &sg);
+		sg->sgc->capacity = 0;
 		cpumask_setall(sched_group_mask(sg));
 
 		for_each_cpu(j, span) {
