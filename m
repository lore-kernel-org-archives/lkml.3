Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaIHXHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:07:41 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57681 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaIHXHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:07:39 -0400
Date: Tue, 9 Sep 2014 08:07:34 +0900
From: Tejun Heo <tj@kernel.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH percpu/for-3.18] percpu: fix locking regression in the
 failure path of pcpu_alloc()
Message-ID: <20140908230734.GF3806@mtj.dyndns.org>
References: <540d6d8e.bX1TYtX2p4laJeSu%fengguang.wu@intel.com>
 <alpine.DEB.2.10.1409081121210.2406@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409081121210.2406@hadrien>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 23cb8981ed929b4dd48141401cd0fd31e0fa4ed0 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 9 Sep 2014 08:02:45 +0900

While updating locking, b38d08f3181c ("percpu: restructure locking")
broke pcpu_create_chunk() creation path in pcpu_alloc().  It returns
without releasing pcpu_alloc_mutex.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
---
Applied to percpu/for-3.18.

Thanks a lot!

 mm/percpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index 867efd3..af3dd27 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -974,6 +974,7 @@ restart:
 	if (list_empty(&pcpu_slot[pcpu_nr_slots - 1])) {
 		chunk = pcpu_create_chunk();
 		if (!chunk) {
+			mutex_unlock(&pcpu_alloc_mutex);
 			err = "failed to allocate new chunk";
 			goto fail;
 		}
-- 
1.9.3

