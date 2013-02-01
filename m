Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423033Ab3BANPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:15:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:45811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423014Ab3BANP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:15:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miroslav Kratochvil <exa.exa@gmail.com>, Dave Jones <davej@redhat.com>,
        Harald Reindl <h.reindl@thelounge.net>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 84/89] netfilter: xt_recent: avoid high order page allocations
Date: Fri,  1 Feb 2013 14:08:39 +0100
Message-Id: <20130201130213.541910151@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 2727de76041b2064c0b74f00a2a89678fb3efafc upstream.

xt_recent can try high order page allocations and this can fail.

iptables: page allocation failure: order:9, mode:0xc0d0

It also wastes about half the allocated space because of kmalloc()
power-of-two roundups and struct recent_table layout.

Use vmalloc() instead to save space and be less prone to allocation
errors when memory is fragmented.

Reported-by: Miroslav Kratochvil <exa.exa@gmail.com>
Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Harald Reindl <h.reindl@thelounge.net>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_recent.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -29,6 +29,7 @@
 #include <linux/skbuff.h>
 #include <linux/inet.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
@@ -310,6 +311,14 @@ out:
 	return ret;
 }
 
+static void recent_table_free(void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		vfree(addr);
+	else
+		kfree(addr);
+}
+
 static int recent_mt_check(const struct xt_mtchk_param *par,
 			   const struct xt_recent_mtinfo_v1 *info)
 {
@@ -322,6 +331,7 @@ static int recent_mt_check(const struct
 #endif
 	unsigned int i;
 	int ret = -EINVAL;
+	size_t sz;
 
 	if (unlikely(!hash_rnd_inited)) {
 		get_random_bytes(&hash_rnd, sizeof(hash_rnd));
@@ -360,8 +370,11 @@ static int recent_mt_check(const struct
 		goto out;
 	}
 
-	t = kzalloc(sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size,
-		    GFP_KERNEL);
+	sz = sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size;
+	if (sz <= PAGE_SIZE)
+		t = kzalloc(sz, GFP_KERNEL);
+	else
+		t = vzalloc(sz);
 	if (t == NULL) {
 		ret = -ENOMEM;
 		goto out;
@@ -377,14 +390,14 @@ static int recent_mt_check(const struct
 	uid = make_kuid(&init_user_ns, ip_list_uid);
 	gid = make_kgid(&init_user_ns, ip_list_gid);
 	if (!uid_valid(uid) || !gid_valid(gid)) {
-		kfree(t);
+		recent_table_free(t);
 		ret = -EINVAL;
 		goto out;
 	}
 	pde = proc_create_data(t->name, ip_list_perms, recent_net->xt_recent,
 		  &recent_mt_fops, t);
 	if (pde == NULL) {
-		kfree(t);
+		recent_table_free(t);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -435,7 +448,7 @@ static void recent_mt_destroy(const stru
 			remove_proc_entry(t->name, recent_net->xt_recent);
 #endif
 		recent_table_flush(t);
-		kfree(t);
+		recent_table_free(t);
 	}
 	mutex_unlock(&recent_mutex);
 }


