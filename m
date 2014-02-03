Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaBCEAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 23:00:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaBCEAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 23:00:41 -0500
Message-ID: <1391400037.5357.62.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] irq_work: allow certain work in hard irq context
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
Date: Mon, 03 Feb 2014 05:00:37 +0100
In-Reply-To: <52EEA643.1010200@linutronix.de>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
	 <1391314950.5444.18.camel@marge.simpson.net>
	 <52EEA643.1010200@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:mXyKh+Eb5EZnBu1Yw0RKiUYdA61p3CH1/02qVXQnMxh
 9TxoGDkUP8u9JUAszS3QKXBO+zkCfaC/of01Th60uiyNYmSw6U
 DEkbBMAqw2B64n+3VBgFQ1v4+aMnMUDH5DlqMCPG8njWDsOb+f
 E7tdoaaKKfHO/l0icp6nXE8OxuMn+53ZOqWjE3MeYJoDFTwUzN
 OUURm1IAtpMMTtPUj+QwWxZov0y5ymZ15rlXuUZzAFsR+z87Mm
 0cx5YkiuzCWfR5In++3TFiZuMJaQZrTAVAqlsGUaeOMpEGLogN
 7vfntVHSug045ycWzej2eGuY5bjZ2xWHGTrQ5E/f8HSeFaVNBK
 I6RHk9L9pj2wG5l5NFjfh1/6tc/QpiNAk1mAf+7lF2T25VUeD5
 YKwK4xwHKC3tg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-02 at 21:10 +0100, Sebastian Andrzej Siewior wrote:

> According to the backtrace both of them are trying to access the
> per-cpu hrtimer (sched_timer) in order to cancel but they seem to fail
> to get the timer lock here. They shouldn't spin there for minutes, I
> have no idea why they did so…

Hm. per-cpu...

I've been chasing an rt hotplug heisenbug that is pointing to per-cpu
oddness.  During sched domain re-construction while running Steven's
stress script on 64 core box, we hit a freshly constructed domain with
_no span_, build_sched_groups()->get_group() explodes when we meeting
it.  But if you try to watch the thing appear... it just doesn't.

static int build_sched_domains(const struct cpumask *cpu_map,
                               struct sched_domain_attr *attr)
{
        enum s_alloc alloc_state;
        struct sched_domain *sd;
        struct s_data d;
        int i, ret = -ENOMEM;

        alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
        if (alloc_state != sa_rootdomain)
                goto error;

        /* Set up domains for cpus specified by the cpu_map. */
        for_each_cpu(i, cpu_map) {
                struct sched_domain_topology_level *tl;

                sd = NULL;
                for_each_sd_topology(tl) {
                        sd = build_sched_domain(tl, cpu_map, attr, sd, i);
BUG_ON(sd == spanless-alien) here..
                        if (tl == sched_domain_topology)
                                *per_cpu_ptr(d.sd, i) = sd;
                        if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
                                sd->flags |= SD_OVERLAP;
                        if (cpumask_equal(cpu_map, sched_domain_span(sd)))
                                break;
                }
        }

        /* Build the groups for the domains */
        for_each_cpu(i, cpu_map) {
                for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
                        sd->span_weight = cpumask_weight(sched_domain_span(sd));
                        if (sd->flags & SD_OVERLAP) {
                                if (build_overlap_sched_groups(sd, i))
                                        goto error;
                        } else {
                                if (build_sched_groups(sd, i))
..prevents meeting that alien here.. while hotplug locked.

static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
{
        struct sched_domain *sd = *per_cpu_ptr(sdd->sd, cpu);
        struct sched_domain *child = sd->child;
        if (child)
                cpu = cpumask_first(sched_domain_span(child));
                ^^^nr_cpus
        if (sg) {
                *sg = *per_cpu_ptr(sdd->sg, cpu); BOOM


