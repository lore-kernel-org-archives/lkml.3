Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaAFTek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:34:40 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:20474
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462AbaAFTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:34:35 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MYZVOP-08-96Q-02
X-M-MSG: 
Subject: [PATCH 6/6] crypto: ccp - CCP device enabled/disabled changes
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jan 2014 13:34:29 -0600
Message-ID: <20140106193429.26918.74497.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
References: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CCP cannot be hot-plugged so it will either be there
or it won't.  Do not allow the driver to stay loaded if the
CCP does not successfully initialize.

Provide stub routines in the ccp.h file that return -ENODEV
if the CCP has not been configured in the build.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c |   15 ++++++++++++++-
 drivers/crypto/ccp/ccp-pci.c |    3 +++
 include/linux/ccp.h          |   12 ++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index b2038a7..c3bc212 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -552,6 +552,7 @@ static const struct x86_cpu_id ccp_support[] = {
 static int __init ccp_mod_init(void)
 {
 	struct cpuinfo_x86 *cpuinfo = &boot_cpu_data;
+	int ret;
 
 	if (!x86_match_cpu(ccp_support))
 		return -ENODEV;
@@ -560,7 +561,19 @@ static int __init ccp_mod_init(void)
 	case 22:
 		if ((cpuinfo->x86_model < 48) || (cpuinfo->x86_model > 63))
 			return -ENODEV;
-		return ccp_pci_init();
+
+		ret = ccp_pci_init();
+		if (ret)
+			return ret;
+
+		/* Don't leave the driver loaded if init failed */
+		if (!ccp_get_device()) {
+			ccp_pci_exit();
+			return -ENODEV;
+		}
+
+		return 0;
+
 		break;
 	}
 
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 1fbeaf1..11836b7 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -268,6 +268,9 @@ static void ccp_pci_remove(struct pci_dev *pdev)
 	struct device *dev = &pdev->dev;
 	struct ccp_device *ccp = dev_get_drvdata(dev);
 
+	if (!ccp)
+		return;
+
 	ccp_destroy(ccp);
 
 	pci_iounmap(pdev, ccp->io_map);
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index 12f1cfd..b941ab9 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -23,6 +23,9 @@
 struct ccp_device;
 struct ccp_cmd;
 
+#if defined(CONFIG_CRYPTO_DEV_CCP_DD) || \
+	defined(CONFIG_CRYPTO_DEV_CCP_DD_MODULE)
+
 /**
  * ccp_enqueue_cmd - queue an operation for processing by the CCP
  *
@@ -48,6 +51,15 @@ struct ccp_cmd;
  */
 int ccp_enqueue_cmd(struct ccp_cmd *cmd);
 
+#else /* CONFIG_CRYPTO_DEV_CCP_DD is not enabled */
+
+static inline int ccp_enqueue_cmd(struct ccp_cmd *cmd)
+{
+	return -ENODEV;
+}
+
+#endif /* CONFIG_CRYPTO_DEV_CCP_DD */
+
 
 /***** AES engine *****/
 /**


