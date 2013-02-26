Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3BZRoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:44:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:50369 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3BZRoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:44:37 -0500
Date: Tue, 26 Feb 2013 18:44:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sander Eikelenboom <linux@eikelenboom.it>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Regression introduced with 14e568e78f6f80ca1e27256641ddf524c7dbdc51
 (stop_machine: Use smpboot threads)
In-Reply-To: <894977724.20130226140702@eikelenboom.it>
Message-ID: <alpine.LFD.2.02.1302261843240.22263@ionos>
References: <20130223011800.GA2465@phenom.dumpdata.com> <alpine.LFD.2.02.1302261320120.22263@ionos> <894977724.20130226140702@eikelenboom.it>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013, Sander Eikelenboom wrote:
> Tuesday, February 26, 2013, 1:36:36 PM, you wrote:
> > On Fri, 22 Feb 2013, Konrad Rzeszutek Wilk wrote:
> >> 
> >> I don't know if this is b/c the Xen code is missing something or
> >> expects something that never happend. I hadn't looked at your
> >> patch in any detail (was going to do that on Monday).
> >> 
> >> Either way, if I boot a HVM guest with PV extensions (aka PVHVM)
> 
> Hmm i'm seeing this booting on baremetal as well.
> (see http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00836.html)

Ok. I decoded it with the help of Konrad. Does the patch below work
for you as well?

Thanks,

	tglx

Index: linux-2.6/include/linux/smpboot.h
===================================================================
--- linux-2.6.orig/include/linux/smpboot.h
+++ linux-2.6/include/linux/smpboot.h
@@ -24,6 +24,9 @@ struct smpboot_thread_data;
  *			parked (cpu offline)
  * @unpark:		Optional unpark function, called when the thread is
  *			unparked (cpu online)
+ * @pre_unpark:		Optional unpark function, called before the thread is
+ *			unparked (cpu online). This is not guaranteed to be
+ *			called on the target cpu of the thread. Careful!
  * @selfparking:	Thread is not parked by the park function.
  * @thread_comm:	The base name of the thread
  */
@@ -37,6 +40,7 @@ struct smp_hotplug_thread {
 	void				(*cleanup)(unsigned int cpu, bool online);
 	void				(*park)(unsigned int cpu);
 	void				(*unpark)(unsigned int cpu);
+	void				(*pre_unpark)(unsigned int cpu);
 	bool				selfparking;
 	const char			*thread_comm;
 };
Index: linux-2.6/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/kernel/smpboot.c
+++ linux-2.6/kernel/smpboot.c
@@ -209,6 +209,8 @@ static void smpboot_unpark_thread(struct
 {
 	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
 
+	if (ht->pre_unpark)
+		ht->pre_unpark(cpu);
 	kthread_unpark(tsk);
 }
 
Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -336,7 +336,7 @@ static struct smp_hotplug_thread cpu_sto
 	.create			= cpu_stop_create,
 	.setup			= cpu_stop_unpark,
 	.park			= cpu_stop_park,
-	.unpark			= cpu_stop_unpark,
+	.pre_unpark		= cpu_stop_unpark,
 	.selfparking		= true,
 };
 
