Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaARAqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 19:46:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:12817 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaARAqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 19:46:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,677,1384329600"; 
   d="scan'208";a="466912362"
Date: Sat, 18 Jan 2014 00:46:08 +0000
From: Tadeusz Struk <tadeusz.struk@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, tadeusz.struk@intel.com
Subject: [PATCH RFC 1/2] crypto: Simple crypto algorithm load balancer
Message-ID: <52d9ced0.jqhVV3OvRxex2A9/%tadeusz.struk@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
In case of multiple crypto devices implementing the same algorithms
the arbitration, which one to use is based on the cra_priority.
Currently the algorithm with the highest priority is always be used.
In case of two algorithms with the same priority the one added last is used.
There is no load balancing and on a busy system there can be a situation when
there more crypto accelerators, but only one is used for all crypto jobs
and the others sit idle.
This patch implements a simple load balancing based on the priority
of an algorithm and its usage refctr. The distribution for 10 algorithms
and 3000000 tfm_alloc allocations is as follows:

 === Algorithm load balancig test results for 3000000 allocatoins ===
 All different alg priorities:
 Algorithm 1 with cra_pri 1 allocated 3 times. That's ~0%
 Algorithm 2 with cra_pri 2 allocated 10 times. That's ~0%
 Algorithm 3 with cra_pri 3 allocated 38 times. That's ~0%
 Algorithm 4 with cra_pri 4 allocated 168 times. That's ~0%
 Algorithm 5 with cra_pri 5 allocated 781 times. That's ~0%
 Algorithm 6 with cra_pri 6 allocated 3757 times. That's ~0%
 Algorithm 7 with cra_pri 7 allocated 18483 times. That's ~0%
 Algorithm 8 with cra_pri 8 allocated 92540 times. That's ~3%
 Algorithm 9 with cra_pri 9 allocated 469918 times. That's ~15%
 Algorithm 10 with cra_pri 10 allocated 2414312 times. That's ~80%

 All the same alg priorities:
 Algorithm 1 with cra_pri 10 allocated 297521 times. That's ~9%
 Algorithm 2 with cra_pri 10 allocated 297521 times. That's ~9%
 Algorithm 3 with cra_pri 10 allocated 297521 times. That's ~9%
 Algorithm 4 with cra_pri 10 allocated 297522 times. That's ~9%
 Algorithm 5 with cra_pri 10 allocated 297522 times. That's ~9%
 Algorithm 6 with cra_pri 10 allocated 297522 times. That's ~9%
 Algorithm 7 with cra_pri 10 allocated 297522 times. That's ~9%
 Algorithm 8 with cra_pri 10 allocated 297522 times. That's ~9%
 Algorithm 9 with cra_pri 10 allocated 297522 times. That's ~9%
 Algorithm 10 with cra_pri 10 allocated 297522 times. That's ~9%

 A mix of alg priorities:
 Algorithm 1 with cra_pri 9 allocated 1938 times. That's ~0%
 Algorithm 2 with cra_pri 4 allocated 8 times. That's ~0%
 Algorithm 3 with cra_pri 1 allocated 2 times. That's ~0%
 Algorithm 4 with cra_pri 4 allocated 9 times. That's ~0%
 Algorithm 5 with cra_pri 5 allocated 62 times. That's ~0%
 Algorithm 6 with cra_pri 20 allocated 157052 times. That's ~5%
 Algorithm 7 with cra_pri 21 allocated 1410070 times. That's ~47%
 Algorithm 8 with cra_pri 10 allocated 10215 times. That's ~0%
 Algorithm 9 with cra_pri 21 allocated 1420284 times. That's ~47%
 Algorithm 10 with cra_pri 7 allocated 370 times. That's ~0%

 A mix of alg priorities with one very big:
 Algorithm 1 with cra_pri 9 allocated 6 times. That's ~0%
 Algorithm 2 with cra_pri 4 allocated 1 times. That's ~0%
 Algorithm 3 with cra_pri 1 allocated 1 times. That's ~0%
 Algorithm 4 with cra_pri 4 allocated 1 times. That's ~0%
 Algorithm 5 with cra_pri 500 allocated 2993808 times. That's ~99%
 Algorithm 6 with cra_pri 20 allocated 346 times. That's ~0%
 Algorithm 7 with cra_pri 21 allocated 2899 times. That's ~0%
 Algorithm 8 with cra_pri 10 allocated 23 times. That's ~0%
 Algorithm 9 with cra_pri 21 allocated 2922 times. That's ~0%
 Algorithm 10 with cra_pri 7 allocated 3 times. That's ~0%

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/api.c           |   25 ++++++++++++++++++++++---
 include/linux/crypto.h |    3 ++-
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index a2b39c5..0c0f1c3 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -63,7 +63,7 @@ static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 	int best = -2;
 
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
-		int exact, fuzzy;
+		int exact, fuzzy, relative_priority;
 
 		if (crypto_is_moribund(q))
 			continue;
@@ -78,13 +78,15 @@ static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 
 		exact = !strcmp(q->cra_driver_name, name);
 		fuzzy = !strcmp(q->cra_name, name);
-		if (!exact && !(fuzzy && q->cra_priority > best))
+		relative_priority = q->cra_priority -
+					atomic_read(&q->cra_lbalance);
+		if (!exact && !(fuzzy && relative_priority > best))
 			continue;
 
 		if (unlikely(!crypto_mod_get(q)))
 			continue;
 
-		best = q->cra_priority;
+		best = relative_priority;
 		if (alg)
 			crypto_mod_put(alg);
 		alg = q;
@@ -92,6 +94,23 @@ static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 		if (exact)
 			break;
 	}
+	if (!alg) {
+		list_for_each_entry(q, &crypto_alg_list, cra_list) {
+			int best = -2;
+			if (best < q->cra_priority) {
+				alg = q;
+				best = q->cra_priority;
+			}
+			atomic_set(&q->cra_lbalance, 0);
+		}
+	}
+	atomic_inc(&alg->cra_lbalance);
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		if (alg == q)
+			continue;
+		if (q->cra_priority > alg->cra_priority)
+			atomic_set(&q->cra_lbalance, 0);
+	}
 
 	return alg;
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b92eadf..6c24b27 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -288,6 +288,7 @@ struct crypto_alg {
 
 	int cra_priority;
 	atomic_t cra_refcnt;
+	atomic_t cra_lbalance;
 
 	char cra_name[CRYPTO_MAX_ALG_NAME];
 	char cra_driver_name[CRYPTO_MAX_ALG_NAME];
@@ -306,7 +307,7 @@ struct crypto_alg {
 	int (*cra_init)(struct crypto_tfm *tfm);
 	void (*cra_exit)(struct crypto_tfm *tfm);
 	void (*cra_destroy)(struct crypto_alg *alg);
-	
+
 	struct module *cra_module;
 };
 
-- 
1.7.10.4

