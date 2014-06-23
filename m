Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaFWNFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:05:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaFWNFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kent Overstreet <kmo@daterainc.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 67/93] percpu-refcount: fix usage of this_cpu_ops
Date: Mon, 23 Jun 2014 14:02:46 +0100
Message-Id: <1403528592-2163-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

commit 0c36b390a546055b6815d4b93a2c9fed4d980ffb upstream.

The percpu-refcount infrastructure uses the underscore variants of
this_cpu_ops in order to modify percpu reference counters.
(e.g. __this_cpu_inc()).

However the underscore variants do not atomically update the percpu
variable, instead they may be implemented using read-modify-write
semantics (more than one instruction).  Therefore it is only safe to
use the underscore variant if the context is always the same (process,
softirq, or hardirq). Otherwise it is possible to lose updates.

This problem is something that Sebastian has seen within the aio
subsystem which uses percpu refcounters both in process and softirq
context leading to reference counts that never dropped to zeroes; even
though the number of "get" and "put" calls matched.

Fix this by using the non-underscore this_cpu_ops variant which
provides correct per cpu atomic semantics and fixes the corrupted
reference counts.

Cc: Kent Overstreet <kmo@daterainc.com>
Reported-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
References: http://lkml.kernel.org/g/alpine.LFD.2.11.1406041540520.21183@denkbrett
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/percpu-refcount.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 95961f0bf62d..0afb48fd449d 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -110,7 +110,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 	else
 		atomic_inc(&ref->count);
 
@@ -139,7 +139,7 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 		ret = true;
 	}
 
@@ -164,7 +164,7 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_dec(*pcpu_count);
+		this_cpu_dec(*pcpu_count);
 	else if (unlikely(atomic_dec_and_test(&ref->count)))
 		ref->release(ref);
 
-- 
1.9.1

