Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3FZTci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:32:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9551 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3FZTaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:30:52 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=FVSIjqhOFV4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=e5xMItrDch4A:10 a=TNXbAUmLPXGxtGcW1SMA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130626193050.056722116@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 26 Jun 2013 15:28:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC][PATCH RT 3/6] idr: Use migrate_disable() to stay on the current CPU
References: <20130626192806.107564905@goodmis.org>
Content-Disposition: inline; filename=idr-migrate-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_preload() and idr_preload_end() use preempt_disable() to keep the process
from migrating. For mainline that's fine, but for -rt, that has issues as
the spin_locks in between are changed to mutexes.

Use migrated_disable/enable() instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/include/linux/idr.h
===================================================================
--- linux-rt.git.orig/include/linux/idr.h
+++ linux-rt.git/include/linux/idr.h
@@ -94,7 +94,7 @@ void idr_init(struct idr *idp);
  */
 static inline void idr_preload_end(void)
 {
-	preempt_enable();
+	migrate_enable();
 }
 
 /**
Index: linux-rt.git/lib/idr.c
===================================================================
--- linux-rt.git.orig/lib/idr.c
+++ linux-rt.git/lib/idr.c
@@ -423,7 +423,7 @@ void idr_preload(gfp_t gfp_mask)
 	WARN_ON_ONCE(in_interrupt());
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
-	preempt_disable();
+	migrate_disable();
 
 	/*
 	 * idr_alloc() is likely to succeed w/o full idr_layer buffer and
@@ -435,9 +435,9 @@ void idr_preload(gfp_t gfp_mask)
 	while (__this_cpu_read(idr_preload_cnt) < MAX_IDR_FREE) {
 		struct idr_layer *new;
 
-		preempt_enable();
+		migrate_enable();
 		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
-		preempt_disable();
+		migrate_disable();
 		if (!new)
 			break;
 

