Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaAVTSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:18:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbaAVTSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:18:36 -0500
Date: Wed, 22 Jan 2014 20:18:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        Michel Lespinasse <walken@google.com>, ego@linux.vnet.ibm.com,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Deadlock between cpu_hotplug_begin and cpu_add_remove_lock
Message-ID: <20140122191820.GA32127@redhat.com>
References: <20140122055239.GA29418@iris.ozlabs.ibm.com> <52DF81B0.7020700@linux.vnet.ibm.com> <52DF8C59.1090702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DF8C59.1090702@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Srivatsa S. Bhat wrote:
>
> Wait a min, that _will_ actually work for all cases because I have provided
> an option to invoke _any_ arbitrary function as the "setup" routine.

And probably the generic solution makes sense. I am not sure I actually
understand the semantics of register_allcpu_notifier(), but the problem
it tries to solve looks clear/valid.

But as for a quick fix for raid5_alloc_percpu(), can't it simply call
register_cpu_notifier() before get_online_cpus/for_each_present_cpu ?

This probably means that raid456_cpu_notify() should be modified because
it obviously can be called before get_online_cpus(). Hmm, it already
has safe_put_page(), so this looks really simple? Something like below,
although of course I can miss easily something.

Oleg.


--- x/drivers/md/raid5.c
+++ x/drivers/md/raid5.c
@@ -5542,6 +5542,24 @@ static void free_conf(struct r5conf *con
 	kfree(conf);
 }
 
+static int alloc_xxx(struct r5conf *conf, struct raid5_percpu *percpu)
+{
+	if (conf->level == 6 && !percpu->spare_page)
+		percpu->spare_page = alloc_page(GFP_KERNEL);
+	if (!percpu->scribble)
+		percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
+
+	if (!percpu->scribble || (conf->level == 6 && !percpu->spare_page)) {
+		safe_put_page(percpu->spare_page);
+		kfree(percpu->scribble);
+		pr_err("%s: failed memory allocation for cpu%ld\n",
+		       __func__, cpu);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 			      void *hcpu)
@@ -5553,19 +5571,8 @@ static int raid456_cpu_notify(struct not
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (conf->level == 6 && !percpu->spare_page)
-			percpu->spare_page = alloc_page(GFP_KERNEL);
-		if (!percpu->scribble)
-			percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
-
-		if (!percpu->scribble ||
-		    (conf->level == 6 && !percpu->spare_page)) {
-			safe_put_page(percpu->spare_page);
-			kfree(percpu->scribble);
-			pr_err("%s: failed memory allocation for cpu%ld\n",
-			       __func__, cpu);
+		if (alloc_xxx(conf, percpu))
 			return notifier_from_errno(-ENOMEM);
-		}
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -5585,39 +5592,27 @@ static int raid5_alloc_percpu(struct r5c
 {
 	unsigned long cpu;
 	struct page *spare_page;
-	struct raid5_percpu __percpu *allcpus;
 	void *scribble;
-	int err;
+	int err = 0;
 
-	allcpus = alloc_percpu(struct raid5_percpu);
-	if (!allcpus)
+	conf->percpu = alloc_percpu(struct raid5_percpu);
+	if (!conf->percpu)
 		return -ENOMEM;
-	conf->percpu = allcpus;
 
-	get_online_cpus();
-	err = 0;
-	for_each_present_cpu(cpu) {
-		if (conf->level == 6) {
-			spare_page = alloc_page(GFP_KERNEL);
-			if (!spare_page) {
-				err = -ENOMEM;
-				break;
-			}
-			per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
-		}
-		scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
-		if (!scribble) {
-			err = -ENOMEM;
-			break;
-		}
-		per_cpu_ptr(conf->percpu, cpu)->scribble = scribble;
-	}
 #ifdef CONFIG_HOTPLUG_CPU
 	conf->cpu_notify.notifier_call = raid456_cpu_notify;
 	conf->cpu_notify.priority = 0;
-	if (err == 0)
-		err = register_cpu_notifier(&conf->cpu_notify);
+	err = register_cpu_notifier(&conf->cpu_notify);
+	if (err)
+		return err;
 #endif
+
+	get_online_cpus();
+	for_each_present_cpu(cpu) {
+		err = alloc_xxx(conf, per_cpu_ptr(conf->percpu, cpu));
+		if (err)
+			break;
+	}
 	put_online_cpus();
 
 	return err;

