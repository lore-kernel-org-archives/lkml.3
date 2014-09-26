Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030184AbaIZWYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 18:24:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60349 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755644AbaIZWYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 18:24:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at drivers/cpufreq/cpufreq.c:370
Date: Sat, 27 Sep 2014 00:44:23 +0200
Message-ID: <2457441.tHFXzSCneW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411718040.6005.18.camel@marge.simpson.net>
References: <20140924081845.572814794@infradead.org> <1411712697.6005.7.camel@marge.simpson.net> <1411718040.6005.18.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 26, 2014 09:54:00 AM Mike Galbraith wrote:
> On Fri, 2014-09-26 at 08:24 +0200, Mike Galbraith wrote: 
> > (the hazards of multitasking.. post escaped early, and went to mostly
> > the wrong folks)
> > 
> > 
> > While testing some scheduler patches, the below pcc-cpufreq
> > might_sleep() gripe fell out.
> 
> Because the bits below from 8fec051e didn't make the lock go away first.
> Reverting only pcc-cpufreq back to notifier.. works.
> 
> --------------------- drivers/cpufreq/integrator-cpufreq.c ---------------------

Are you sure this is the right file?

Shouldn't that be pcc-cpufreq.c rather?

Also moving the spin_lock(&pcc_lock) after the cpufreq_freq_transition_begin()
should fix the problem too (like the below).  Have you tried that?


---
 drivers/cpufreq/pcc-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/cpufreq/pcc-cpufreq.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/pcc-cpufreq.c
+++ linux-pm/drivers/cpufreq/pcc-cpufreq.c
@@ -204,7 +204,6 @@ static int pcc_cpufreq_target(struct cpu
 	u32 input_buffer;
 	int cpu;
 
-	spin_lock(&pcc_lock);
 	cpu = policy->cpu;
 	pcc_cpu_data = per_cpu_ptr(pcc_cpu_info, cpu);
 
@@ -216,6 +215,7 @@ static int pcc_cpufreq_target(struct cpu
 	freqs.old = policy->cur;
 	freqs.new = target_freq;
 	cpufreq_freq_transition_begin(policy, &freqs);
+	spin_lock(&pcc_lock);
 
 	input_buffer = 0x1 | (((target_freq * 100)
 			       / (ioread32(&pcch_hdr->nominal) * 1000)) << 8);

