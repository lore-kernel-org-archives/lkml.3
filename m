Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaGFAgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 20:36:47 -0400
Received: from mail.eperm.de ([89.247.134.16]:53346 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaGFAgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 20:36:45 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: herbert@gondor.apana.org.au
Cc: joe@perches.com, dan.carpenter@oracle.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, fengguang.wu@intel.com,
        Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>, aris@redhat.com
Subject: [PATCH 5/6] DRBG: Mix a time stamp into DRBG state
Date: Sun, 06 Jul 2014 02:25:36 +0200
Message-ID: <2806743.Dj8rGesvFc@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <2266932.bfVPMOTOeI@myon.chronox.de>
References: <2266932.bfVPMOTOeI@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current locking approach of the DRBG tries to keep the protected
code paths very minimal. It is therefore possible that two threads query
one DRBG instance at the same time. When thread A requests random
numbers, a shadow copy of the DRBG state is created upon which the
request for A is processed. After finishing the state for A's request is
merged back into the DRBG state. If now thread B requests random numbers
from the same DRBG after the request for thread A is received, but
before A's shadow state is merged back, the random numbers for B will be
identical to the ones for A. Please note that the time window is very
small for this scenario.

To prevent that there is even a theoretical chance for thread A and B
having the same DRBG state, the current time stamp is provided as
additional information string for each new request.

The addition of the time stamp as additional information string implies
that now all generate functions must be capable to process a linked
list with additional information strings instead of a scalar.

CC: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 59 ++++++++++++++++++++++++++++++---------------------
 include/crypto/drbg.h |  2 +-
 2 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 2a7860f..a76b3cb 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -646,7 +646,7 @@ out:
 /* Generate function of CTR DRBG as defined in 10.2.1.5.2 */
 static int drbg_ctr_generate(struct drbg_state *drbg,
 			     unsigned char *buf, unsigned int buflen,
-			     struct drbg_string *addtl)
+			     struct list_head *addtl)
 {
 	int len = 0;
 	int ret = 0;
@@ -656,11 +656,8 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
 
 	/* 10.2.1.5.2 step 2 */
-	if (addtl && 0 < addtl->len) {
-		LIST_HEAD(addtllist);
-
-		list_add_tail(&addtl->list, &addtllist);
-		ret = drbg_ctr_update(drbg, &addtllist, 2);
+	if (addtl && !list_empty(addtl)) {
+		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
 			return 0;
 	}
@@ -777,7 +774,7 @@ static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
 static int drbg_hmac_generate(struct drbg_state *drbg,
 			      unsigned char *buf,
 			      unsigned int buflen,
-			      struct drbg_string *addtl)
+			      struct list_head *addtl)
 {
 	int len = 0;
 	int ret = 0;
@@ -785,11 +782,8 @@ static int drbg_hmac_generate(struct drbg_state *drbg,
 	LIST_HEAD(datalist);
 
 	/* 10.1.2.5 step 2 */
-	if (addtl && 0 < addtl->len) {
-		LIST_HEAD(addtllist);
-
-		list_add_tail(&addtl->list, &addtllist);
-		ret = drbg_hmac_update(drbg, &addtllist, 1);
+	if (addtl && !list_empty(addtl)) {
+		ret = drbg_hmac_update(drbg, addtl, 1);
 		if (ret)
 			return ret;
 	}
@@ -813,14 +807,10 @@ static int drbg_hmac_generate(struct drbg_state *drbg,
 	}
 
 	/* 10.1.2.5 step 6 */
-	if (addtl && 0 < addtl->len) {
-		LIST_HEAD(addtllist);
-
-		list_add_tail(&addtl->list, &addtllist);
-		ret = drbg_hmac_update(drbg, &addtllist, 1);
-	} else {
+	if (addtl && !list_empty(addtl))
+		ret = drbg_hmac_update(drbg, addtl, 1);
+	else
 		ret = drbg_hmac_update(drbg, NULL, 1);
-	}
 	if (ret)
 		return ret;
 
@@ -944,7 +934,7 @@ out:
 
 /* processing of additional information string for Hash DRBG */
 static int drbg_hash_process_addtl(struct drbg_state *drbg,
-				   struct drbg_string *addtl)
+				   struct list_head *addtl)
 {
 	int ret = 0;
 	struct drbg_string data1, data2;
@@ -955,7 +945,7 @@ static int drbg_hash_process_addtl(struct drbg_state *drbg,
 	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
 
 	/* 10.1.1.4 step 2 */
-	if (!addtl || 0 == addtl->len)
+	if (!addtl || list_empty(addtl))
 		return 0;
 
 	/* 10.1.1.4 step 2a */
@@ -963,7 +953,7 @@ static int drbg_hash_process_addtl(struct drbg_state *drbg,
 	drbg_string_fill(&data2, drbg->V, drbg_statelen(drbg));
 	list_add_tail(&data1.list, &datalist);
 	list_add_tail(&data2.list, &datalist);
-	list_add_tail(&addtl->list, &datalist);
+	list_splice_tail(addtl, &datalist);
 	ret = drbg_kcapi_hash(drbg, NULL, drbg->scratchpad, &datalist);
 	if (ret)
 		goto out;
@@ -1029,7 +1019,7 @@ out:
 /* generate function for Hash DRBG as defined in  10.1.1.4 */
 static int drbg_hash_generate(struct drbg_state *drbg,
 			      unsigned char *buf, unsigned int buflen,
-			      struct drbg_string *addtl)
+			      struct list_head *addtl)
 {
 	int len = 0;
 	int ret = 0;
@@ -1347,6 +1337,12 @@ static int drbg_generate(struct drbg_state *drbg,
 {
 	int len = 0;
 	struct drbg_state *shadow = NULL;
+	LIST_HEAD(addtllist);
+	struct drbg_string timestamp;
+	union {
+		cycles_t cycles;
+		unsigned char char_cycles[sizeof(cycles_t)];
+	} now;
 
 	if (0 == buflen || !buf) {
 		pr_devel("DRBG: no output buffer provided\n");
@@ -1407,8 +1403,23 @@ static int drbg_generate(struct drbg_state *drbg,
 		/* 9.3.1 step 7.4 */
 		addtl = NULL;
 	}
+
+	/*
+	 * Mix the time stamp into the DRBG state if the DRBG is not in
+	 * test mode. If there are two callers invoking the DRBG at the same
+	 * time, i.e. before the first caller merges its shadow state back,
+	 * both callers would obtain the same random number stream without
+	 * changing the state here.
+	 */
+	if (!drbg->test_data) {
+		now.cycles = random_get_entropy();
+		drbg_string_fill(&timestamp, now.char_cycles, sizeof(cycles_t));
+		list_add_tail(&timestamp.list, &addtllist);
+	}
+	if (addtl && 0 < addtl->len)
+		list_add_tail(&addtl->list, &addtllist);
 	/* 9.3.1 step 8 and 10 */
-	len = shadow->d_ops->generate(shadow, buf, buflen, addtl);
+	len = shadow->d_ops->generate(shadow, buf, buflen, &addtllist);
 
 	/* 10.1.1.4 step 6, 10.1.2.5 step 7, 10.2.1.5.2 step 7 */
 	shadow->reseed_ctr++;
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 4065dfc..831d786 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -102,7 +102,7 @@ struct drbg_state_ops {
 		      int reseed);
 	int (*generate)(struct drbg_state *drbg,
 			unsigned char *buf, unsigned int buflen,
-			struct drbg_string *addtl);
+			struct list_head *addtl);
 	int (*crypto_init)(struct drbg_state *drbg);
 	int (*crypto_fini)(struct drbg_state *drbg);
 
-- 
1.9.3


