Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbaE2FQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:16:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611AbaE2Efg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 106/140] vsock: Make transport the proto owner
Date: Wed, 28 May 2014 21:34:05 -0700
Message-Id: <20140529043103.201606102@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy King <acking@vmware.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_vsock.h   |    6 +++++-
 net/vmw_vsock/af_vsock.c |   47 ++++++++++++++++++++++-------------------------
 2 files changed, 27 insertions(+), 26 deletions(-)

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
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1925,9 +1925,23 @@ static struct miscdevice vsock_device =
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


