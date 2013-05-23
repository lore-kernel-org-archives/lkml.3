Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab3EWMfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:35:06 -0400
Received: from mail-gh0-f173.google.com ([209.85.160.173]:50247 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636Ab3EWMfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:35:04 -0400
Message-ID: <519E0CF5.7000308@gmail.com>
Date: Thu, 23 May 2013 08:35:01 -0400
From: "Matthew O'Connor" <liquidhorse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: f.wiessner@smart-weblications.de
CC: Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        andy@greyhouse.net, fubar@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com, zheng.x.li@oracle.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
References: <519CADA9.9060909@smart-weblications.de> <20130522135745.GA14640@kroah.com> <519CEF4B.5090108@smart-weblications.de> <20130522162336.GA5761@kroah.com> <519D0B79.6010307@smart-weblications.de> <20130522190640.GA20276@kroah.com> <519D1DEF.8090206@smart-weblications.de> <20130522200439.GA21367@kroah.com> <519D37F4.2030202@smart-weblications.de> <519D5206.8080701@gmail.com> <519DEE6E.7060700@smart-weblications.de>
In-Reply-To: <519DEE6E.7060700@smart-weblications.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/mixed;
 boundary="------------060400020600070505060008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060400020600070505060008
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 05/23/2013 06:24 AM, Smart Weblications GmbH - Florian Wiessner wrote:
> Hm, i tried to apply it to 3.4.46 but it does not work:
>
> node02:/ocfs2/usr/src/linux-3.4.46# patch -p1 <../bridge-patch-3.4.46
> patching file drivers/net/bonding/bond_alb.c
> Hunk #1 FAILED at 704.
> 1 out of 1 hunk FAILED -- saving rejects to file drivers/net/bonding/bond_alb.c.rej
> patching file drivers/net/bonding/bonding.h
> patching file include/linux/etherdevice.h
> Hunk #1 FAILED at 277.
> 1 out of 1 hunk FAILED -- saving rejects to file include/linux/etherdevice.h.rej
That is extremely odd, considering I applied this to a freshly
downloaded kernel source directly from kernel.org before resubmitting it:

hv11:~/kernel/linux-3.4.46$ patch -p1 <
../balance-alb-patches/balance-alb-3.4.patch
patching file drivers/net/bonding/bond_alb.c
patching file drivers/net/bonding/bonding.h
patching file include/linux/etherdevice.h


Here's the patch as an attachment instead; I suspect it keeps getting
damaged by my method of inclusion.

--------------060400020600070505060008
Content-Type: text/x-patch;
 name="balance-alb-3.4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="balance-alb-3.4.patch"

diff -uprN linux-3.4.28/drivers/net/bonding/bond_alb.c linux-3.4.28-patched/drivers/net/bonding/bond_alb.c
--- linux-3.4.28/drivers/net/bonding/bond_alb.c	2013-01-27 23:51:45.000000000 -0500
+++ linux-3.4.28-patched/drivers/net/bonding/bond_alb.c	2013-01-30 15:37:25.121708311 -0500
@@ -704,6 +704,12 @@ static struct slave *rlb_arp_xmit(struct
 	struct arp_pkt *arp = arp_pkt(skb);
 	struct slave *tx_slave = NULL;
 
+	/* Don't modify or load balance ARPs that do not originate locally
+	 * (e.g.,arrive via a bridge).
+	 */
+	if (!bond_slave_has_mac(bond, arp->mac_src))
+		return NULL;
+
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* the arp must be sent on the selected
 		* rx channel
diff -uprN linux-3.4.28/drivers/net/bonding/bonding.h linux-3.4.28-patched/drivers/net/bonding/bonding.h
--- linux-3.4.28/drivers/net/bonding/bonding.h	2013-01-27 23:51:45.000000000 -0500
+++ linux-3.4.28-patched/drivers/net/bonding/bonding.h	2013-01-30 15:37:25.121708311 -0500
@@ -18,6 +18,7 @@
 #include <linux/timer.h>
 #include <linux/proc_fs.h>
 #include <linux/if_bonding.h>
+#include <linux/etherdevice.h>
 #include <linux/cpumask.h>
 #include <linux/in6.h>
 #include <linux/netpoll.h>
@@ -450,6 +451,18 @@ static inline void bond_destroy_proc_dir
 }
 #endif
 
+static inline struct slave *bond_slave_has_mac(struct bonding *bond,
+					       const u8 *mac)
+{
+	int i = 0;
+	struct slave *tmp;
+
+	bond_for_each_slave(bond, tmp, i)
+		if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
+			return tmp;
+
+	return NULL;
+}
 
 /* exported from bond_main.c */
 extern int bond_net_id;
diff -uprN linux-3.4.28/include/linux/etherdevice.h linux-3.4.28-patched/include/linux/etherdevice.h
--- linux-3.4.28/include/linux/etherdevice.h	2013-01-27 23:51:45.000000000 -0500
+++ linux-3.4.28-patched/include/linux/etherdevice.h	2013-01-30 15:37:25.121708311 -0500
@@ -277,4 +277,37 @@ static inline unsigned long compare_ethe
 #endif
 }
 
+/**
+ * ether_addr_equal_64bits - Compare two Ethernet addresses
+ * @addr1: Pointer to an array of 8 bytes
+ * @addr2: Pointer to an other array of 8 bytes
+ *
+ * Compare two Ethernet addresses, returns true if equal, false otherwise.
+ *
+ * The function doesn't need any conditional branches and possibly uses
+ * word memory accesses on CPU allowing cheap unaligned memory reads.
+ * arrays = { byte1, byte2, byte3, byte4, byte5, byte6, pad1, pad2 }
+ *
+ * Please note that alignment of addr1 & addr2 are only guaranteed to be 16 bits.
+ */
+
+static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
+                                           const u8 addr2[6+2])
+{
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+        unsigned long fold = ((*(unsigned long *)addr1) ^
+                              (*(unsigned long *)addr2));
+
+        if (sizeof(fold) == 8)
+                return zap_last_2bytes(fold) == 0;
+
+        fold |= zap_last_2bytes((*(unsigned long *)(addr1 + 4)) ^
+                                (*(unsigned long *)(addr2 + 4)));
+        return fold == 0;
+#else
+        return ether_addr_equal(addr1, addr2);
+#endif
+}
+
+
 #endif	/* _LINUX_ETHERDEVICE_H */

--------------060400020600070505060008--
