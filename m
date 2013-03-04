Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab3CDSuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:50:40 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39302 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab3CDSui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:50:38 -0500
Date: Mon, 4 Mar 2013 08:02:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: andi@firstfloor.org, akpm@linux-foundation.org, mel@csn.ul.ie,
        daniel.vetter@ffwll.ch, paul.gortmaker@windriver.com
Subject: [PATCH RFC] vm: Adjust ifdef for TINY_RCU
Message-ID: <20130304160237.GA1430@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030418-7282-0000-0000-000014E625FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an ifdef in page_cache_get_speculative() that checks for !SMP
and TREE_RCU, which has been an impossible combination since the advent
of TINY_RCU.  The ifdef enables a fastpath that is valid when preemption
is disabled by rcu_read_lock() in UP systems, which is the case when
TINY_RCU is enabled.  This commit therefore adjusts the ifdef to generate
the fastpath when TINY_RCU is enabled.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0e38e13..e3dea75 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -149,7 +149,7 @@ static inline int page_cache_get_speculative(struct page *page)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
+#ifdef CONFIG_TINY_RCU
 # ifdef CONFIG_PREEMPT_COUNT
 	VM_BUG_ON(!in_atomic());
 # endif

