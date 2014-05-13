Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbaEMNs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:48:57 -0400
Received: from relay.parallels.com ([195.214.232.42]:49685 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759846AbaEMNsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:48:55 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <cl@linux-foundation.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH RFC 2/3] percpu-refcount: allow to get dead reference
Date: Tue, 13 May 2014 17:48:52 +0400
Message-ID: <52edf96a623197ed3c947dfa8b216ec0540d6460.1399982635.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1399982635.git.vdavydov@parallels.com>
References: <cover.1399982635.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently percpu_ref_tryget fails after percpu_ref_kill is called, even
if refcnt != 0. In the next patch I need a method to get a ref that will
only fail if refcnt == 0, so let's extend the interface to percpu ref a
bit to allow that.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/percpu-refcount.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 95961f0bf62d..7729e59b9cb7 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -129,7 +129,8 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
  * used.  After the confirm_kill callback is invoked, it's guaranteed that
  * no new reference will be given out by percpu_ref_tryget().
  */
-static inline bool percpu_ref_tryget(struct percpu_ref *ref)
+static inline bool __percpu_ref_tryget(struct percpu_ref *ref,
+				       bool maybe_dead)
 {
 	unsigned __percpu *pcpu_count;
 	int ret = false;
@@ -141,13 +142,19 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
 		__this_cpu_inc(*pcpu_count);
 		ret = true;
-	}
+	} else if (maybe_dead && unlikely(atomic_read(&ref->count)))
+		ret = atomic_inc_not_zero(&ref->count);
 
 	rcu_read_unlock_sched();
 
 	return ret;
 }
 
+static inline bool percpu_ref_tryget(struct percpu_ref *ref)
+{
+	return __percpu_ref_tryget(ref, false);
+}
+
 /**
  * percpu_ref_put - decrement a percpu refcount
  * @ref: percpu_ref to put
-- 
1.7.10.4

