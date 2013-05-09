Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3EIW5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:57:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab3EIWcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 19/73] netfilter: ipset: list:set: fix reference counter update
Date: Thu,  9 May 2013 15:31:42 -0700
Message-Id: <20130509222800.036026577@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

commit 02f815cb6d3f57914228be84df9613ee5a01c2e6 upstream.

The last element can be replaced or pushed off and in both
cases the reference counter must be updated.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_list_set.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -174,9 +174,13 @@ list_set_add(struct list_set *map, u32 i
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


