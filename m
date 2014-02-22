Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaBVILq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 03:11:46 -0500
Received: from relaygw4-2.mclink.it ([213.21.178.145]:40977 "EHLO
	relaygw4-2.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaBVILa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 03:11:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUFAOlaCFNNK3Ai/2dsb2JhbABagwY7wiwWdIImAQUnEz8QAVBXGYgJAcsEF5MjBJg0gTKJHw6HSIMuOw
Date: Sat, 22 Feb 2014 09:11:24 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        Tomasz Wlostowski <tomasz.wlostowski@cern.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] FMC: show_sdb_tree: dump synthesis/commit ID info
Message-ID: <906cfa442d87221ba01cc0d18c5052bc5553dfd6.1393056460.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <70259a54ccd97ec3c1013291ca58e52e4249b882.1393056460.git.rubini@gnudd.com>
In-Reply-To: <70259a54ccd97ec3c1013291ca58e52e4249b882.1393056460.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This completes the show_sdb_tree functionality, with the
new informative fields.  The output for a verbose module is now
like this (long lines are unavoidable):

 SDB: 00000651:e6a542c9 WB4-Crossbar-GSI
 SDB: 0000ce42:00000601 WB-DMA.Control      (00001000-0000103f)
 SDB: 0000ce42:779c5443 WB-OneWire-Master   (00001100-000011ff)
 SDB: 0000ce42:00000603 WB-SPEC-CSR         (00001200-0000121f)
 SDB: 0000ce42:00000013 WB-VIC-Int.Control  (00001300-000013ff)
 SDB: 0000ce42:d5735ab4 WB-DMA.EIC          (00001400-0000140f)
 SDB: 00000651:eef0b198 WB4-Bridge-GSI      (bridge: 00002000)
 SDB:    00000651:e6a542c9 WB4-Crossbar-GSI
 SDB:    0000ce42:123c5443 WB-I2C-Master       (00003000-000030ff)
 SDB:    0000ce42:e503947e WB-SPI.Control      (00003100-0000311f)
 SDB:    0000ce42:123c5443 WB-I2C-Master       (00003200-000032ff)
 SDB:    0000ce42:00000608 WB-FMC-ADC-Core     (00003300-0000337f)
 SDB:    0000ce42:779c5443 WB-OneWire-Master   (00003400-000034ff)
 SDB:    0000ce42:26ec6086 WB-FMC-ADC.EIC      (00003500-0000350f)
 SDB:    0000ce42:00000604 WB-Timetag-Core     (00003600-0000367f)
 SDB: Synthesis repository: git://ohwr.org/fmc-projects/fmc-adc-100m14b4cha.git
 SDB: Bitstream 'spec_top_fmc_adcmc-projects/fmc-adc-100m14b4cha.git' \
         synthesized 20140116 by mcattin (ISE version 133), commit f0a539dffe6d

Signed-off-by: Tomasz Wlostowski <tomasz.wlostowski@cern.ch>
Acked-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
---
 drivers/fmc/fmc-sdb.c   |   34 ++++++++++++++++++++++++++++++----
 include/linux/fmc-sdb.h |    2 ++
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/fmc/fmc-sdb.c b/drivers/fmc/fmc-sdb.c
index 69f42d7..4603fdb 100644
--- a/drivers/fmc/fmc-sdb.c
+++ b/drivers/fmc/fmc-sdb.c
@@ -150,11 +150,27 @@ int fmc_reprogram(struct fmc_device *fmc, struct fmc_driver *d, char *gw,
 }
 EXPORT_SYMBOL(fmc_reprogram);
 
+static char *__strip_trailing_space(char *buf, char *str, int len)
+{
+	int i = len - 1;
+
+	memcpy(buf, str, len);
+	while(i >= 0 && buf[i] == ' ')
+		buf[i--] = '\0';
+	return buf;
+}
+
+#define __sdb_string(buf, field) ({			\
+	BUILD_BUG_ON(sizeof(buf) < sizeof(field));	\
+	__strip_trailing_space(buf, (void *)(field), sizeof(field));	\
+		})
+
 static void __fmc_show_sdb_tree(const struct fmc_device *fmc,
 				const struct sdb_array *arr)
 {
 	unsigned long base = arr->baseaddr;
 	int i, j, n = arr->len, level = arr->level;
+	char buf[64];
 
 	for (i = 0; i < n; i++) {
 		union  sdb_record *r;
@@ -190,8 +206,8 @@ static void __fmc_show_sdb_tree(const struct fmc_device *fmc,
 			       p->name,
 			       __be64_to_cpu(c->addr_first) + base);
 			if (IS_ERR(arr->subtree[i])) {
-				printk(KERN_CONT "(bridge error %li)\n",
-				       PTR_ERR(arr->subtree[i]));
+				dev_info(&fmc->dev, "SDB: (bridge error %li)\n",
+					 PTR_ERR(arr->subtree[i]));
 				break;
 			}
 			__fmc_show_sdb_tree(fmc, arr->subtree[i]);
@@ -200,10 +216,20 @@ static void __fmc_show_sdb_tree(const struct fmc_device *fmc,
 			printk(KERN_CONT "integration\n");
 			break;
 		case sdb_type_repo_url:
-			printk(KERN_CONT "repo-url\n");
+			printk(KERN_CONT "Synthesis repository: %s\n",
+			       __sdb_string(buf, r->repo_url.repo_url));
 			break;
 		case sdb_type_synthesis:
-			printk(KERN_CONT "synthesis-info\n");
+			printk(KERN_CONT "Bitstream '%s' ",
+			       __sdb_string(buf, r->synthesis.syn_name));
+			printk(KERN_CONT "synthesized %08x by %s ",
+			       __be32_to_cpu(r->synthesis.date),
+			       __sdb_string(buf, r->synthesis.user_name));
+			printk(KERN_CONT "(%s version %x), ",
+			       __sdb_string(buf, r->synthesis.tool_name),
+			       __be32_to_cpu(r->synthesis.tool_version));
+			printk(KERN_CONT "commit %pm\n",
+			       r->synthesis.commit_id);
 			break;
 		case sdb_type_empty:
 			printk(KERN_CONT "empty\n");
diff --git a/include/linux/fmc-sdb.h b/include/linux/fmc-sdb.h
index 1974317..599bd6b 100644
--- a/include/linux/fmc-sdb.h
+++ b/include/linux/fmc-sdb.h
@@ -14,6 +14,8 @@ union sdb_record {
 	struct sdb_bridge bridge;
 	struct sdb_integration integr;
 	struct sdb_empty empty;
+	struct sdb_synthesis synthesis;
+	struct sdb_repo_url repo_url;
 };
 
 struct fmc_device;
-- 
1.7.7.2
