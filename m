Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3DVJaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:30:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:56785 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3DVJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:30:18 -0400
Date: Mon, 22 Apr 2013 11:30:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rob Herring <robherring2@gmail.com>
cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, netdev@vger.kernel.org,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: tg3: possible irq lock inversion dependency detected
In-Reply-To: <517199A9.7060003@gmail.com>
Message-ID: <alpine.LFD.2.02.1304221128400.21884@ionos>
References: <20130419190150.GA15355@linux.vnet.ibm.com> <517199A9.7060003@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Apr 2013, Rob Herring wrote:
> On 04/19/2013 02:01 PM, Nishanth Aravamudan wrote:
> > Running 3.9-rc7-ish, tripped the following (also being seen in FC19
> > alpha) on ppc64:
> > 
> > [  117.026196] =========================================================
> > [  117.026216] [ INFO: possible irq lock inversion dependency detected ]
> > [  117.026238] 3.9.0-rc7+ #8 Not tainted
> > [  117.026251] ---------------------------------------------------------
> > [  117.026271] swapper/7/0 just changed the state of lock:
> > [  117.026286]  (&(&tp->lock)->rlock){+.-...}, at: [<c00000000064effc>] .tg3_timer+0x9c/0x10f0
> > [  117.026334] but this lock took another, SOFTIRQ-unsafe lock in the past:
> > [  117.026353]  (devtree_lock){+.+...}

Hmm. Looks like a few of the devtree functions do not disable
interrupts. Does the patch below fix the issue?

Thanks,

	tglx

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 321d3ef..a218b4c 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -192,14 +192,15 @@ EXPORT_SYMBOL(of_find_property);
 struct device_node *of_find_all_nodes(struct device_node *prev)
 {
 	struct device_node *np;
+	unsigned long flags;
 
-	raw_spin_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np = prev ? prev->allnext : of_allnodes;
 	for (; np != NULL; np = np->allnext)
 		if (of_node_get(np))
 			break;
 	of_node_put(prev);
-	raw_spin_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_all_nodes);
@@ -420,8 +421,9 @@ struct device_node *of_get_next_available_child(const struct device_node *node,
 	struct device_node *prev)
 {
 	struct device_node *next;
+	unsigned long flags;
 
-	raw_spin_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	next = prev ? prev->sibling : node->child;
 	for (; next; next = next->sibling) {
 		if (!__of_device_is_available(next))
@@ -430,7 +432,7 @@ struct device_node *of_get_next_available_child(const struct device_node *node,
 			break;
 	}
 	of_node_put(prev);
-	raw_spin_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return next;
 }
 EXPORT_SYMBOL(of_get_next_available_child);
@@ -734,13 +736,14 @@ EXPORT_SYMBOL_GPL(of_modalias_node);
 struct device_node *of_find_node_by_phandle(phandle handle)
 {
 	struct device_node *np;
+	unsigned long flags;
 
-	raw_spin_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	for (np = of_allnodes; np; np = np->allnext)
 		if (np->phandle == handle)
 			break;
 	of_node_get(np);
-	raw_spin_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_by_phandle);




