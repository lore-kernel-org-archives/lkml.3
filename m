Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3KLRkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:40:46 -0500
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:42954
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932188Ab3KLRkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:40:04 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h1155h)
X-WSS-ID: 0MW5VOR-08-4X7-02
X-M-MSG: 
Subject: [PATCH 09/10] crytpo: CCP device driver build files
To: <davem@davemloft.net>, <linux-crytpo@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:39:53 -0600
Message-ID: <20131112173953.18862.34075.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131112173900.18862.68623.stgit@tlendack-t1.amdoffice.net>
References: <20131112173900.18862.68623.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files provide the ability to configure and build the
AMD CCP device driver and crypto API support.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig      |   12 ++++++++++++
 drivers/crypto/Makefile     |    1 +
 drivers/crypto/ccp/Kconfig  |   23 +++++++++++++++++++++++
 drivers/crypto/ccp/Makefile |   10 ++++++++++
 4 files changed, 46 insertions(+)
 create mode 100644 drivers/crypto/ccp/Kconfig
 create mode 100644 drivers/crypto/ccp/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f4fd837..4954d75 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -399,4 +399,16 @@ config CRYPTO_DEV_ATMEL_SHA
 	  To compile this driver as a module, choose M here: the module
 	  will be called atmel-sha.
 
+config CRYPTO_DEV_CCP
+	bool "Support for AMD Cryptographic Coprocessor"
+	depends on X86
+	default n
+	help
+	  The AMD Cryptographic Coprocessor provides hardware support
+	  for encryption, hashing and related operations.
+
+if CRYPTO_DEV_CCP
+	source "drivers/crypto/ccp/Kconfig"
+endif
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index b4946dd..8a6c86a 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_CRYPTO_DEV_NX) += nx/
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) += atmel-aes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
+obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
new file mode 100644
index 0000000..335ed5c
--- /dev/null
+++ b/drivers/crypto/ccp/Kconfig
@@ -0,0 +1,23 @@
+config CRYPTO_DEV_CCP_DD
+	tristate "Cryptographic Coprocessor device driver"
+	depends on CRYPTO_DEV_CCP
+	default m
+	help
+	  Provides the interface to use the AMD Cryptographic Coprocessor
+	  which can be used to accelerate or offload encryption operations
+	  such as SHA, AES and more. If you choose 'M' here, this module
+	  will be called ccp.
+
+config CRYPTO_DEV_CCP_CRYPTO
+	tristate "Encryption and hashing acceleration support"
+	depends on CRYPTO_DEV_CCP_DD
+	default m
+	select CRYPTO_ALGAPI
+	select CRYPTO_HASH
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_AUTHENC
+	help
+	  Support for using the cryptographic API with the AMD Cryptographic
+	  Coprocessor. This module supports acceleration and offload of SHA
+	  and AES algorithms.  If you choose 'M' here, this module will be
+	  called ccp_crypto.
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
new file mode 100644
index 0000000..d3505a0
--- /dev/null
+++ b/drivers/crypto/ccp/Makefile
@@ -0,0 +1,10 @@
+obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
+ccp-objs := ccp-dev.o ccp-ops.o
+ccp-objs += ccp-pci.o
+
+obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
+ccp-crypto-objs := ccp-crypto-main.o \
+		   ccp-crypto-aes.o \
+		   ccp-crypto-aes-cmac.o \
+		   ccp-crypto-aes-xts.o \
+		   ccp-crypto-sha.o


