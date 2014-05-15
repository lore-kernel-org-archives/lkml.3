Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaEOTEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:04:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbaEOTEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:04:02 -0400
Date: Thu, 15 May 2014 15:03:53 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: sds@tycho.nsa.gov, pmoore@redhat.com, eparis@redhat.com
Subject: [2/2] conditionally reschedule in hashtab_insert while loading
 selinux policy.
Message-ID: <20140515190353.GB16816@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, sds@tycho.nsa.gov,
	pmoore@redhat.com, eparis@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After silencing the sleeping warning in mls_convert_context() I started
seeing similar traces from hashtab_insert. Do a cond_resched there too.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/security/selinux/ss/hashtab.c b/security/selinux/ss/hashtab.c
index 933e735bb185..2cc496149842 100644
--- a/security/selinux/ss/hashtab.c
+++ b/security/selinux/ss/hashtab.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include "hashtab.h"
 
 struct hashtab *hashtab_create(u32 (*hash_value)(struct hashtab *h, const void *key),
@@ -40,6 +41,8 @@ int hashtab_insert(struct hashtab *h, void *key, void *datum)
 	u32 hvalue;
 	struct hashtab_node *prev, *cur, *newnode;
 
+	cond_resched();
+
 	if (!h || h->nel == HASHTAB_MAX_NODES)
 		return -EINVAL;
 
-- 
1.9.0

