Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab3ERDA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758733Ab3ERDAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:20 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=K4mWUdzOkQoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=W9CejI3FiaYA:10 a=3HDBlxybAAAA:8 a=WCQTGU7NibcHvBS_UyEA:9 a=m2JXGx9I94EA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021657.273905058@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 097/136 ] netfilter: ipset: list:set: fix reference counter update
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0097-netfilter-ipset-list-set-fix-reference-counter-updat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

[ Upstream commit 02f815cb6d3f57914228be84df9613ee5a01c2e6 ]

The last element can be replaced or pushed off and in both
cases the reference counter must be updated.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/netfilter/ipset/ip_set_list_set.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 6cb1225..19bf0fe 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -171,9 +171,13 @@ list_set_add(struct list_set *map, u32 i, ip_set_id_t id,
 {
 	const struct set_elem *e = list_set_elem(map, i);
 
-	if (i == map->size - 1 && e->id != IPSET_INVALID_ID)
-		/* Last element replaced: e.g. add new,before,last */
-		ip_set_put_byindex(e->id);
+	if (e->id != IPSET_INVALID_ID) {
+		const struct set_elem *x = list_set_elem(map, map->size - 1);
+
+		/* Last element replaced or pushed off */
+		if (x->id != IPSET_INVALID_ID)
+			ip_set_put_byindex(x->id);
+	}
 	if (with_timeout(map->timeout))
 		list_elem_tadd(map, i, id, ip_set_timeout_set(timeout));
 	else
-- 
1.7.10.4


