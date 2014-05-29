Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbaE2N5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:57:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59459 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933461AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy King <acking@vmware.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 090/103] vsock: Make transport the proto owner
Date: Thu, 29 May 2014 15:49:15 +0200
Message-Id: <368986ee10b1739f9c2a400ac0fca0779c8fdc7e.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 2c4a336e0a3e203fab6aa8d8f7bb70a0ad968a6b ]

Right now the core vsock module is the owner of the proto family. This
means there's nothing preventing the transport module from unloading if
there are open sockets, which results in a panic. Fix that by allowing
the transport to be the owner, which will refcount it properly.

Includes version bump to 1.0.1.0-k

Passes checkpatch this time, I swear...

Acked-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andy King <acking@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/net/af_vsock.h   |  6 +++++-
 net/vmw_vsock/af_vsock.c | 47 ++++++++++++++++++++++-------------------------
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 7d64d3609ec9..428277869400 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -155,7 +155,11 @@ struct vsock_transport {
 
 /**** CORE ****/
 
-int vsock_core_init(const struct vsock_transport *t);
+int __vsock_core_init(const struct vsock_transport *t, struct module *owner);
+static inline int vsock_core_init(const struct vsock_transport *t)
+{
+	return __vsock_core_init(t, THIS_MODULE);
+}
 void vsock_core_exit(void);
 
 /**** UTILS ****/
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5adfd94c5b85..85d232bed87d 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1925,9 +1925,23 @@ static struct miscdevice vsock_device = {
 	.fops		= &vsock_device_ops,
 };
 
-static int __vsock_core_init(void)
+int __vsock_core_init(const struct vsock_transport *t, struct module *owner)
 {
-	int err;
+	int err = mutex_lock_interruptible(&vsock_register_mutex);
+
+	if (err)
+		return err;
+
+	if (transport) {
+		err = -EBUSY;
+		goto err_busy;
+	}
+
+	/* Transport must be the owner of the protocol so that it can't
+	 * unload while there are open sockets.
+	 */
+	vsock_proto.owner = owner;
+	transport = t;
 
 	vsock_init_tables();
 
@@ -1951,36 +1965,19 @@ static int __vsock_core_init(void)
 		goto err_unregister_proto;
 	}
 
+	mutex_unlock(&vsock_register_mutex);
 	return 0;
 
 err_unregister_proto:
 	proto_unregister(&vsock_proto);
 err_misc_deregister:
 	misc_deregister(&vsock_device);
-	return err;
-}
-
-int vsock_core_init(const struct vsock_transport *t)
-{
-	int retval = mutex_lock_interruptible(&vsock_register_mutex);
-	if (retval)
-		return retval;
-
-	if (transport) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	transport = t;
-	retval = __vsock_core_init();
-	if (retval)
-		transport = NULL;
-
-out:
+	transport = NULL;
+err_busy:
 	mutex_unlock(&vsock_register_mutex);
-	return retval;
+	return err;
 }
-EXPORT_SYMBOL_GPL(vsock_core_init);
+EXPORT_SYMBOL_GPL(__vsock_core_init);
 
 void vsock_core_exit(void)
 {
@@ -2000,5 +1997,5 @@ EXPORT_SYMBOL_GPL(vsock_core_exit);
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Virtual Socket Family");
-MODULE_VERSION("1.0.0.0-k");
+MODULE_VERSION("1.0.1.0-k");
 MODULE_LICENSE("GPL v2");
-- 
1.9.3

