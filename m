Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaJCXii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:38:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343AbaJCWDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Scot Doyle <lkml14@scotdoyle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.16 314/357] crypto: ccp - Check for CCP before registering crypto algs
Date: Fri,  3 Oct 2014 14:31:40 -0700
Message-Id: <20141003212942.907463602@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit c9f21cb6388898bfe69886d001316dae7ecc9a4b upstream.

If the ccp is built as a built-in module, then ccp-crypto (whether
built as a module or a built-in module) will be able to load and
it will register its crypto algorithms.  If the system does not have
a CCP this will result in -ENODEV being returned whenever a command
is attempted to be queued by the registered crypto algorithms.

Add an API, ccp_present(), that checks for the presence of a CCP
on the system.  The ccp-crypto module can use this to determine if it
should register it's crypto alogorithms.

Reported-by: Scot Doyle <lkml14@scotdoyle.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Scot Doyle <lkml14@scotdoyle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-crypto-main.c |    4 ++++
 drivers/crypto/ccp/ccp-dev.c         |   14 ++++++++++++++
 include/linux/ccp.h                  |   12 ++++++++++++
 3 files changed, 30 insertions(+)

--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -367,6 +367,10 @@ static int ccp_crypto_init(void)
 {
 	int ret;
 
+	ret = ccp_present();
+	if (ret)
+		return ret;
+
 	spin_lock_init(&req_queue_lock);
 	INIT_LIST_HEAD(&req_queue.cmds);
 	req_queue.backlog = &req_queue.cmds;
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -53,6 +53,20 @@ static inline void ccp_del_device(struct
 }
 
 /**
+ * ccp_present - check if a CCP device is present
+ *
+ * Returns zero if a CCP device is present, -ENODEV otherwise.
+ */
+int ccp_present(void)
+{
+	if (ccp_get_device())
+		return 0;
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(ccp_present);
+
+/**
  * ccp_enqueue_cmd - queue an operation for processing by the CCP
  *
  * @cmd: ccp_cmd struct to be processed
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -27,6 +27,13 @@ struct ccp_cmd;
 	defined(CONFIG_CRYPTO_DEV_CCP_DD_MODULE)
 
 /**
+ * ccp_present - check if a CCP device is present
+ *
+ * Returns zero if a CCP device is present, -ENODEV otherwise.
+ */
+int ccp_present(void);
+
+/**
  * ccp_enqueue_cmd - queue an operation for processing by the CCP
  *
  * @cmd: ccp_cmd struct to be processed
@@ -53,6 +60,11 @@ int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 
 #else /* CONFIG_CRYPTO_DEV_CCP_DD is not enabled */
 
+static inline int ccp_present(void)
+{
+	return -ENODEV;
+}
+
 static inline int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 {
 	return -ENODEV;


