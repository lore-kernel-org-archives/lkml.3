Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3AWJcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:32:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3AWJcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:32:53 -0500
Message-ID: <1358933555.5752.132.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Wed, 23 Jan 2013 10:32:35 +0100
In-Reply-To: <1358932694.5752.126.camel@marge.simpson.net>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
	 <1358841795.5782.255.camel@marge.simpson.net>
	 <50FE5433.1070801@linux.vnet.ibm.com>
	 <1358865692.5782.420.camel@marge.simpson.net>
	 <50FF4EA0.1070000@linux.vnet.ibm.com>
	 <1358915494.5752.46.camel@marge.simpson.net>
	 <50FF7086.4020509@linux.vnet.ibm.com>
	 <1358922520.5752.91.camel@marge.simpson.net>
	 <50FF8CD8.4060105@linux.vnet.ibm.com>
	 <1358929257.5752.109.camel@marge.simp! son.net>
	 <50FF9F92.60202@linux.vnet.ibm.com>
	 <1358930968.5752.123.camel@marge.simpson.net>
	 <50FFA695.6010407@linux.vnet.ibm.com>
	 <1358932694.5752.126.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:VHGVvbFzrzp70B0pnPF5WE+AAokNIMlUb18GBfQ5V4x
 WMfRRNBYwQIqCZVPR+py7WhYZSB4QWJCDC6X67eVFe2HesbRy0
 y5l0Ml2OlnAGRtEsLaNdObdlJyoWhU08+BzXpB8jVoZqX4jrAP
 e+6ZY4V5nMPly2/qGvkvH8RrRHxvuxpYM5rIpSZV1qL956w1DM
 c/9KghO6hJVtu/OCJfokestt5mtUrPFTi26tayqdly8WU1hD8U
 YSgOa0GvYApfd7UiS/QYIARNPsU9txxBvHdUx00R1jN44wT6GT
 qDytK4e4gyhkqU7vFW4zVhaUKj2GJDn9Bh6CG00evNe2iHbxaW
 VIzVoXHFlo/P9S7o+86SSwMChSpn9NsSkhiUC6sbKaOgk/8Pz+
 QNOqMaUlzSSdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 10:18 +0100, Mike Galbraith wrote: 
> On Wed, 2013-01-23 at 17:00 +0800, Michael Wang wrote: 
> > On 01/23/2013 04:49 PM, Mike Galbraith wrote:
> > > On Wed, 2013-01-23 at 16:30 +0800, Michael Wang wrote: 
> > >> On 01/23/2013 04:20 PM, Mike Galbraith wrote:
> > >>> On Wed, 2013-01-23 at 15:10 +0800, Michael Wang wrote: 
> > >>>> On 01/23/2013 02:28 PM, Mike Galbraith wrote:
> > >>>
> > >>>>> Abbreviated test run:
> > >>>>> Tasks    jobs/min  jti  jobs/min/task      real       cpu
> > >>>>>   640   158044.01   81       246.9438     24.54    577.66   Wed Jan 23 07:14:33 2013
> > >>>>>  1280    50434.33   39        39.4018    153.80   5737.57   Wed Jan 23 07:17:07 2013
> > >>>>>  2560    47214.07   34        18.4430    328.58  12715.56   Wed Jan 23 07:22:36 2013
> > >>>>
> > >>>> So still not works... and not going to balance path while waking up will
> > >>>> fix it, looks like that's the only choice if no error on balance path
> > >>>> could be found...benchmark wins again, I'm feeling bad...
> > >>>>
> > >>>> I will conclude the info we collected and make a v3 later.
> > >>>
> > >>> FWIW, I hacked virgin to do full balance if an idle CPU was not found,
> > >>> leaving the preference to wake cache affine intact though, turned on
> > >>> WAKE_BALANCE in all domains, and it did not collapse.  In fact, the high
> > >>> load end, where the idle search will frequently be a waste of cycles,
> > >>> actually improved a bit.  Things that make ya go hmmm.
> > >>
> > >> Oh, does that means the old balance path is good while the new is really
> > >> broken, I mean, compared this with the previously results, could we say
> > >> that all the collapse was just caused by the change of balance path?
> > > 
> > > That's a good supposition.  I'll see if it holds.
> > 
> > I just notice that there is no sd support the WAKE flag at all according
> > to your debug info, isn't it?
> 
> There is, I turned it on in all domains.

For your patches, I had to turn it on at birth, but doing that, and
restoring the full balance path to original form killed the collapse.

Tasks    jobs/min  jti  jobs/min/task      real       cpu
  640   152452.83   97       238.2075     25.44    613.48   Wed Jan 23 10:22:12 2013
 1280   190491.16   97       148.8212     40.72   1223.74   Wed Jan 23 10:22:53 2013
 2560   219397.54   95        85.7022     70.71   2422.46   Wed Jan 23 10:24:04 2013

---
 include/linux/topology.h |    6 ++---
 kernel/sched/core.c      |   41 ++++++++++++++++++++++++++++++-------
 kernel/sched/fair.c      |   52 +++++++++++++++++++++++++++++------------------
 3 files changed, 70 insertions(+), 29 deletions(-)

--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -95,7 +95,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
@@ -126,7 +126,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
@@ -156,7 +156,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5609,11 +5609,39 @@ static void update_top_cache_domain(int
 static int sbm_max_level;
 DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);
 
+static void debug_sched_balance_map(int cpu)
+{
+	int i, type, level = 0;
+	struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
+
+	printk("WYT: sbm of cpu %d\n", cpu);
+
+	for (type = 0; type < SBM_MAX_TYPE; type++) {
+		if (type == SBM_EXEC_TYPE)
+			printk("WYT: \t exec map\n");
+		else if (type == SBM_FORK_TYPE)
+			printk("WYT: \t fork map\n");
+		else if (type == SBM_WAKE_TYPE)
+			printk("WYT: \t wake map\n");
+
+		for (level = 0; level < sbm_max_level; level++) {
+			if (sbm->sd[type][level])
+				printk("WYT: \t\t sd %x, idx %d, level %d, weight %d\n", sbm->sd[type][level], level, sbm->sd[type][level]->level, sbm->sd[type][level]->span_weight);
+		}
+	}
+
+	printk("WYT: \t affine map\n");
+
+	for_each_possible_cpu(i) {
+		if (sbm->affine_map[i])
+			printk("WYT: \t\t affine with cpu %x in sd %x, weight %d\n", i, sbm->affine_map[i], sbm->affine_map[i]->span_weight);
+	}
+}
+
 static void build_sched_balance_map(int cpu)
 {
 	struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
 	struct sched_domain *sd = cpu_rq(cpu)->sd;
-	struct sched_domain *top_sd = NULL;
 	int i, type, level = 0;
 
 	memset(sbm->top_level, 0, sizeof((*sbm).top_level));
@@ -5656,11 +5684,9 @@ static void build_sched_balance_map(int
 	 * fill the hole to get lower level sd easily.
 	 */
 	for (type = 0; type < SBM_MAX_TYPE; type++) {
-		level = sbm->top_level[type];
-		top_sd = sbm->sd[type][level];
-		if ((++level != sbm_max_level) && top_sd) {
-			for (; level < sbm_max_level; level++)
-				sbm->sd[type][level] = top_sd;
+		for (level = 1; level < sbm_max_level; level++) {
+			if (!sbm->sd[type][level])
+				sbm->sd[type][level] = sbm->sd[type][level - 1];
 		}
 	}
 }
@@ -5719,6 +5745,7 @@ cpu_attach_domain(struct sched_domain *s
 	 * destroy_sched_domains() already do the work.
 	 */
 	build_sched_balance_map(cpu);
+//MIKE	debug_sched_balance_map(cpu);
 	rcu_assign_pointer(rq->sbm, sbm);
 }
 
@@ -6220,7 +6247,7 @@ sd_numa_init(struct sched_domain_topolog
 					| 1*SD_BALANCE_NEWIDLE
 					| 0*SD_BALANCE_EXEC
 					| 0*SD_BALANCE_FORK
-					| 0*SD_BALANCE_WAKE
+					| 1*SD_BALANCE_WAKE
 					| 0*SD_WAKE_AFFINE
 					| 0*SD_SHARE_CPUPOWER
 					| 0*SD_SHARE_PKG_RESOURCES
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3312,7 +3312,7 @@ static int select_idle_sibling(struct ta
 static int
 select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
-	struct sched_domain *sd = NULL;
+	struct sched_domain *sd = NULL, *tmp;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
@@ -3376,31 +3376,45 @@ select_task_rq_fair(struct task_struct *
 
 balance_path:
 	new_cpu = (sd_flag & SD_BALANCE_WAKE) ? prev_cpu : cpu;
-	sd = sbm->sd[type][sbm->top_level[type]];
+	sd = tmp = sbm->sd[type][sbm->top_level[type]];
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
-		struct sched_group *sg = NULL;
+		struct sched_group *group;
+		int weight;
+
+		if (!(sd->flags & sd_flag)) {
+			sd = sd->child;
+			continue;
+		}
 
 		if (sd_flag & SD_BALANCE_WAKE)
 			load_idx = sd->wake_idx;
 
-		sg = find_idlest_group(sd, p, cpu, load_idx);
-		if (!sg)
-			goto next_sd;
-
-		new_cpu = find_idlest_cpu(sg, p, cpu);
-		if (new_cpu != -1)
-			cpu = new_cpu;
-next_sd:
-		if (!sd->level)
-			break;
-
-		sbm = cpu_rq(cpu)->sbm;
-		if (!sbm)
-			break;
-
-		sd = sbm->sd[type][sd->level - 1];
+		group = find_idlest_group(sd, p, cpu, load_idx);
+		if (!group) {
+			sd = sd->child;
+			continue;
+		}
+
+		new_cpu = find_idlest_cpu(group, p, cpu);
+		if (new_cpu == -1 || new_cpu == cpu) {
+			/* Now try balancing at a lower domain level of cpu */
+			sd = sd->child;
+			continue;
+		}
+
+		/* Now try balancing at a lower domain level of new_cpu */
+		cpu = new_cpu;
+		weight = sd->span_weight;
+		sd = NULL;
+		for_each_domain(cpu, tmp) {
+			if (weight <= tmp->span_weight)
+				break;
+			if (tmp->flags & sd_flag)
+				sd = tmp;
+		}
+		/* while loop will break here if sd == NULL */
 	}
 
 unlock:


