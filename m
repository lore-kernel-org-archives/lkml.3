Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaBGLZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:25:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41167 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaBGLZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:25:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 72/88] target/iscsi: Fix network portal creation race
Date: Fri,  7 Feb 2014 11:23:09 +0000
Message-Id: <1391772205-22239-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Grover <agrover@redhat.com>

commit ee291e63293146db64668e8d65eb35c97e8324f4 upstream.

When creating network portals rapidly, such as when restoring a
configuration, LIO's code to reuse existing portals can return a false
negative if the thread hasn't run yet and set np_thread_state to
ISCSI_NP_THREAD_ACTIVE. This causes an error in the network stack
when attempting to bind to the same address/port.

This patch sets NP_THREAD_ACTIVE before the np is placed on g_np_list,
so even if the thread hasn't run yet, iscsit_get_np will return the
existing np.

Also, convert np_lock -> np_mutex + hold across adding new net portal
to g_np_list to prevent a race where two threads may attempt to create
the same network portal, resulting in one of them failing.

(nab: Add missing mutex_unlocks in iscsit_add_np failure paths)
(DanC: Fix incorrect spin_unlock -> spin_unlock_bh)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 955392e..6e270f9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -52,7 +52,7 @@
 static LIST_HEAD(g_tiqn_list);
 static LIST_HEAD(g_np_list);
 static DEFINE_SPINLOCK(tiqn_lock);
-static DEFINE_SPINLOCK(np_lock);
+static DEFINE_MUTEX(np_lock);
 
 static struct idr tiqn_idr;
 struct idr sess_idr;
@@ -264,6 +264,9 @@ int iscsit_deaccess_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
 	return 0;
 }
 
+/*
+ * Called with mutex np_lock held
+ */
 static struct iscsi_np *iscsit_get_np(
 	struct __kernel_sockaddr_storage *sockaddr,
 	int network_transport)
@@ -274,11 +277,10 @@ static struct iscsi_np *iscsit_get_np(
 	int ip_match = 0;
 	u16 port;
 
-	spin_lock_bh(&np_lock);
 	list_for_each_entry(np, &g_np_list, np_list) {
-		spin_lock(&np->np_thread_lock);
+		spin_lock_bh(&np->np_thread_lock);
 		if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
-			spin_unlock(&np->np_thread_lock);
+			spin_unlock_bh(&np->np_thread_lock);
 			continue;
 		}
 
@@ -311,13 +313,11 @@ static struct iscsi_np *iscsit_get_np(
 			 * while iscsi_tpg_add_network_portal() is called.
 			 */
 			np->np_exports++;
-			spin_unlock(&np->np_thread_lock);
-			spin_unlock_bh(&np_lock);
+			spin_unlock_bh(&np->np_thread_lock);
 			return np;
 		}
-		spin_unlock(&np->np_thread_lock);
+		spin_unlock_bh(&np->np_thread_lock);
 	}
-	spin_unlock_bh(&np_lock);
 
 	return NULL;
 }
@@ -331,16 +331,22 @@ struct iscsi_np *iscsit_add_np(
 	struct sockaddr_in6 *sock_in6;
 	struct iscsi_np *np;
 	int ret;
+
+	mutex_lock(&np_lock);
+
 	/*
 	 * Locate the existing struct iscsi_np if already active..
 	 */
 	np = iscsit_get_np(sockaddr, network_transport);
-	if (np)
+	if (np) {
+		mutex_unlock(&np_lock);
 		return np;
+	}
 
 	np = kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
 	if (!np) {
 		pr_err("Unable to allocate memory for struct iscsi_np\n");
+		mutex_unlock(&np_lock);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -363,6 +369,7 @@ struct iscsi_np *iscsit_add_np(
 	ret = iscsi_target_setup_login_socket(np, sockaddr);
 	if (ret != 0) {
 		kfree(np);
+		mutex_unlock(&np_lock);
 		return ERR_PTR(ret);
 	}
 
@@ -371,6 +378,7 @@ struct iscsi_np *iscsit_add_np(
 		pr_err("Unable to create kthread: iscsi_np\n");
 		ret = PTR_ERR(np->np_thread);
 		kfree(np);
+		mutex_unlock(&np_lock);
 		return ERR_PTR(ret);
 	}
 	/*
@@ -381,10 +389,10 @@ struct iscsi_np *iscsit_add_np(
 	 * point because iscsi_np has not been added to g_np_list yet.
 	 */
 	np->np_exports = 1;
+	np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 
-	spin_lock_bh(&np_lock);
 	list_add_tail(&np->np_list, &g_np_list);
-	spin_unlock_bh(&np_lock);
+	mutex_unlock(&np_lock);
 
 	pr_debug("CORE[0] - Added Network Portal: %s:%hu on %s\n",
 		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
@@ -455,9 +463,9 @@ int iscsit_del_np(struct iscsi_np *np)
 	}
 	iscsit_del_np_comm(np);
 
-	spin_lock_bh(&np_lock);
+	mutex_lock(&np_lock);
 	list_del(&np->np_list);
-	spin_unlock_bh(&np_lock);
+	mutex_unlock(&np_lock);
 
 	pr_debug("CORE[0] - Removed Network Portal: %s:%hu on %s\n",
 		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
-- 
1.8.3.2

