Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbaFWNn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:43:29 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16419 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbaFWNnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:43:25 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-07-53a82efa5964
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, tetra2005@gmail.com, preobr@google.com,
        dvyukov@google.com, kcc@google.com, koct9i@gmail.com,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] lib: idr: fix out-of-bounds pointer dereference
Date: Mon, 23 Jun 2014 17:37:08 +0400
Message-id: <1403530628-32306-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7q/9FYEGzx8Kmex7dcjNos569ew
	WUx42MZusf3ZWyaLlZ0PWC1WrG5jtbi8aw6bxb6V55ks3j2bzGzxa/lRRgcuj/8HJzF77Jx1
	l91jwaZSj02rOtk8Tsz4zeLRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGe2zdrEXfBev2LXu
	KFMD4wrBLkZODgkBE4k9//8wQdhiEhfurWfrYuTiEBJYyihxY/8bVginj0li6dw7rCBVbAJ6
	Ev9mbWcDsUUEdCVWPd/FDFLELPCeUWLx/7VgRcICDhKX934DK2IRUJXYsrIbyObg4BVwk7jw
	PRlim4LEsuUzWScwci9gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJWX3YwLj5mdYhR
	gINRiYf3htfyYCHWxLLiytxDjBIczEoivI5fgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYbR9c
	W8onrs/EWOJyZq7Xqmk6LbUT5ptIKbGw/9b5JRGdF37Ja+Ge0LA1kwIrFrxeX+wRILTzqVVZ
	ay17yEVLKwah1/5Z8orH0m6/KBE4/uSRduDts/+ixdZJsEj1nbl4Lv9EYkDtlJ+b/qa6LApP
	P+4TtusY77rtP3K8ed6fOa477Yvp1msXlViKMxINtZiLihMBSOMaHwkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on address sanitizer project for kernel. Recently we started
experiments with stack instrumentation, to detect out-of-bounds
read/write bugs on stack.

Just after booting I've hit out-of-bounds read on stack in idr_for_each
(and in __idr_remove_all as well):

	struct idr_layer **paa = &pa[0];

	while (id >= 0 && id <= max) {
		...
		while (n < fls(id)) {
			n += IDR_BITS;
			p = *--paa; <--- here we are reading pa[-1] value.
		}
	}

Despite the fact that after this dereference we are exiting out of loop and
never use p, such behaviour is undefined and should be avoided.

Fix this by moving pointer derference to the beggining of the loop, right
before we will use it.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 lib/idr.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 39158ab..50be3fa 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -590,26 +590,27 @@ static void __idr_remove_all(struct idr *idp)
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
-	p = idp->top;
+	*paa = idp->top;
 	RCU_INIT_POINTER(idp->top, NULL);
 	max = idr_max(idp->layers);
 
 	id = 0;
 	while (id >= 0 && id <= max) {
+		p = *paa;
 		while (n > IDR_BITS && p) {
 			n -= IDR_BITS;
-			*paa++ = p;
 			p = p->ary[(id >> n) & IDR_MASK];
+			*++paa = p;
 		}
 
 		bt_mask = id;
 		id += 1 << n;
 		/* Get the highest bit that the above add changed from 0->1. */
 		while (n < fls(id ^ bt_mask)) {
-			if (p)
-				free_layer(idp, p);
+			if (*paa)
+				free_layer(idp, *paa);
 			n += IDR_BITS;
-			p = *--paa;
+			--paa;
 		}
 	}
 	idp->layers = 0;
@@ -692,15 +693,16 @@ int idr_for_each(struct idr *idp,
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
-	p = rcu_dereference_raw(idp->top);
+	*paa = rcu_dereference_raw(idp->top);
 	max = idr_max(idp->layers);
 
 	id = 0;
 	while (id >= 0 && id <= max) {
+		p = *paa;
 		while (n > 0 && p) {
 			n -= IDR_BITS;
-			*paa++ = p;
 			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
+			*++paa = p;
 		}
 
 		if (p) {
@@ -712,7 +714,7 @@ int idr_for_each(struct idr *idp,
 		id += 1 << n;
 		while (n < fls(id)) {
 			n += IDR_BITS;
-			p = *--paa;
+			--paa;
 		}
 	}
 
@@ -740,17 +742,18 @@ void *idr_get_next(struct idr *idp, int *nextidp)
 	int n, max;
 
 	/* find first ent */
-	p = rcu_dereference_raw(idp->top);
+	p = *paa = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
 	n = (p->layer + 1) * IDR_BITS;
 	max = idr_max(p->layer + 1);
 
 	while (id >= 0 && id <= max) {
+		p = *paa;
 		while (n > 0 && p) {
 			n -= IDR_BITS;
-			*paa++ = p;
 			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
+			*++paa = p;
 		}
 
 		if (p) {
@@ -768,7 +771,7 @@ void *idr_get_next(struct idr *idp, int *nextidp)
 		id = round_up(id + 1, 1 << n);
 		while (n < fls(id)) {
 			n += IDR_BITS;
-			p = *--paa;
+			--paa;
 		}
 	}
 	return NULL;
-- 
1.8.5.5

