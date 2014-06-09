Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbaFIWqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:46:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616AbaFIWpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.14 62/78] percpu-refcount: fix usage of this_cpu_ops
Date: Mon,  9 Jun 2014 15:48:42 -0700
Message-Id: <20140609224815.333089363@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/percpu-refcount.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -110,7 +110,7 @@ static inline void percpu_ref_get(struct
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 	else
 		atomic_inc(&ref->count);
 
@@ -139,7 +139,7 @@ static inline bool percpu_ref_tryget(str
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 		ret = true;
 	}
 
@@ -164,7 +164,7 @@ static inline void percpu_ref_put(struct
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_dec(*pcpu_count);
+		this_cpu_dec(*pcpu_count);
 	else if (unlikely(atomic_dec_and_test(&ref->count)))
 		ref->release(ref);
 


