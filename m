Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab3HNJzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:55:42 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:55982 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab3HNJzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:55:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Thorsten Glaser <tg@debian.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] m68k/atari: ARAnyM - Always use physical addresses in NatFeat calls
Date: Wed, 14 Aug 2013 11:55:29 +0200
Message-Id: <1376474129-14339-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376474129-14339-1-git-send-email-geert@linux-m68k.org>
References: <1376474129-14339-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointers passed to ARAnyM NatFeat calls should be physical addresses,
not virtual addresses. This worked before because on Atari, physical and
virtual kernel addresses are the same, as long as normal kernel memory
is concerned.

Correct the few remaining places where virtual addresses were used.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/emu/natfeat.c |   14 +++++++-------
 arch/m68k/emu/nfblock.c |    4 ++--
 arch/m68k/emu/nfcon.c   |    8 +++++---
 arch/m68k/emu/nfeth.c   |    7 ++++---
 4 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
index 5a8da88..71b78ec 100644
--- a/arch/m68k/emu/natfeat.c
+++ b/arch/m68k/emu/natfeat.c
@@ -19,11 +19,11 @@
 #include <asm/machdep.h>
 #include <asm/natfeat.h>
 
-extern long nf_get_id2(const char *feature_name);
+extern long nf_get_id_phys(unsigned long feature_name);
 
 asm("\n"
-"	.global nf_get_id2,nf_call\n"
-"nf_get_id2:\n"
+"	.global nf_get_id_phys,nf_call\n"
+"nf_get_id_phys:\n"
 "	.short	0x7300\n"
 "	rts\n"
 "nf_call:\n"
@@ -32,7 +32,7 @@ asm("\n"
 "1:	moveq.l	#0,%d0\n"
 "	rts\n"
 "	.section __ex_table,\"a\"\n"
-"	.long	nf_get_id2,1b\n"
+"	.long	nf_get_id_phys,1b\n"
 "	.long	nf_call,1b\n"
 "	.previous");
 EXPORT_SYMBOL_GPL(nf_call);
@@ -47,7 +47,7 @@ long nf_get_id(const char *feature_name)
 	if (n >= sizeof(name_copy))
 		return 0;
 
-	return nf_get_id2(name_copy);
+	return nf_get_id_phys(virt_to_phys(name_copy));
 }
 EXPORT_SYMBOL_GPL(nf_get_id);
 
@@ -59,7 +59,7 @@ void nfprint(const char *fmt, ...)
 
 	va_start(ap, fmt);
 	n = vsnprintf(buf, 256, fmt, ap);
-	nf_call(nf_get_id("NF_STDERR"), buf);
+	nf_call(nf_get_id("NF_STDERR"), virt_to_phys(buf));
 	va_end(ap);
 }
 
@@ -84,7 +84,7 @@ void __init nf_init(void)
 	id = nf_get_id("NF_NAME");
 	if (!id)
 		return;
-	nf_call(id, buf, 256);
+	nf_call(id, virt_to_phys(buf), 256);
 	buf[255] = 0;
 
 	pr_info("NatFeats found (%s, %lu.%lu)\n", buf, version >> 16,
diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index e301133..0721858 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -41,8 +41,8 @@ static inline s32 nfhd_read_write(u32 major, u32 minor, u32 rwflag, u32 recno,
 static inline s32 nfhd_get_capacity(u32 major, u32 minor, u32 *blocks,
 				    u32 *blocksize)
 {
-	return nf_call(nfhd_id + NFHD_GET_CAPACITY, major, minor, blocks,
-		       blocksize);
+	return nf_call(nfhd_id + NFHD_GET_CAPACITY, major, minor,
+		       virt_to_phys(blocks), virt_to_phys(blocksize));
 }
 
 static LIST_HEAD(nfhd_list);
diff --git a/arch/m68k/emu/nfcon.c b/arch/m68k/emu/nfcon.c
index 6685bf4..57e8c8f 100644
--- a/arch/m68k/emu/nfcon.c
+++ b/arch/m68k/emu/nfcon.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <asm/natfeat.h>
 
@@ -25,17 +26,18 @@ static struct tty_driver *nfcon_tty_driver;
 static void nfputs(const char *str, unsigned int count)
 {
 	char buf[68];
+	unsigned long phys = virt_to_phys(buf);
 
 	buf[64] = 0;
 	while (count > 64) {
 		memcpy(buf, str, 64);
-		nf_call(stderr_id, buf);
+		nf_call(stderr_id, phys);
 		str += 64;
 		count -= 64;
 	}
 	memcpy(buf, str, count);
 	buf[count] = 0;
-	nf_call(stderr_id, buf);
+	nf_call(stderr_id, phys);
 }
 
 static void nfcon_write(struct console *con, const char *str,
@@ -79,7 +81,7 @@ static int nfcon_tty_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	char temp[2] = { ch, 0 };
 
-	nf_call(stderr_id, temp);
+	nf_call(stderr_id, virt_to_phys(temp));
 	return 1;
 }
 
diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
index 695cd73..a0985fd 100644
--- a/arch/m68k/emu/nfeth.c
+++ b/arch/m68k/emu/nfeth.c
@@ -195,7 +195,8 @@ static struct net_device * __init nfeth_probe(int unit)
 	char mac[ETH_ALEN], host_ip[32], local_ip[32];
 	int err;
 
-	if (!nf_call(nfEtherID + XIF_GET_MAC, unit, mac, ETH_ALEN))
+	if (!nf_call(nfEtherID + XIF_GET_MAC, unit, virt_to_phys(mac),
+		     ETH_ALEN))
 		return NULL;
 
 	dev = alloc_etherdev(sizeof(struct nfeth_private));
@@ -217,9 +218,9 @@ static struct net_device * __init nfeth_probe(int unit)
 	}
 
 	nf_call(nfEtherID + XIF_GET_IPHOST, unit,
-		host_ip, sizeof(host_ip));
+		virt_to_phys(host_ip), sizeof(host_ip));
 	nf_call(nfEtherID + XIF_GET_IPATARI, unit,
-		local_ip, sizeof(local_ip));
+		virt_to_phys(local_ip), sizeof(local_ip));
 
 	netdev_info(dev, KBUILD_MODNAME " addr:%s (%s) HWaddr:%pM\n", host_ip,
 		    local_ip, mac);
-- 
1.7.9.5

