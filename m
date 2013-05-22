Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3EVLnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:43:19 -0400
Received: from mx03.smart-weblications.de ([188.65.144.38]:39115 "EHLO
	mx03.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab3EVLnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:43:15 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 May 2013 07:43:15 EDT
Message-ID: <519CADA9.9060909@smart-weblications.de>
Date: Wed, 22 May 2013 13:36:09 +0200
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: davem@davemloft.net, liquidhorse@gmail.com
CC: andy@greyhouse.net, fubar@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, nikolay@redhat.com, vfalico@redhat.com,
        gregkh@linuxfoundation.org
Subject: https://lkml.org/lkml/2013/2/1/531
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


why is this patch still not backported to 3.4?

I today tried 3.4.46 from kernel.org, but the patch STILL seems _NOT_ included?


WHY IS THAT?


====== 3.4 Series ======
diff -uprN linux-3.4.28/drivers/net/bonding/bond_alb.c
linux-3.4.28-patched/drivers/net/bonding/bond_alb.c
--- linux-3.4.28/drivers/net/bonding/bond_alb.c    2013-01-27
23:51:45.000000000 -0500
+++ linux-3.4.28-patched/drivers/net/bonding/bond_alb.c    2013-01-30
15:37:25.121708311 -0500
@@ -704,6 +704,12 @@ static struct slave *rlb_arp_xmit(struct
     struct arp_pkt *arp = arp_pkt(skb);
     struct slave *tx_slave = NULL;

+    /* Don't modify or load balance ARPs that do not originate locally
+     * (e.g.,arrive via a bridge).
+     */
+    if (!bond_slave_has_mac(bond, arp->mac_src))
+        return NULL;
+
     if (arp->op_code == htons(ARPOP_REPLY)) {
         /* the arp must be sent on the selected
         * rx channel
diff -uprN linux-3.4.28/drivers/net/bonding/bonding.h
linux-3.4.28-patched/drivers/net/bonding/bonding.h
--- linux-3.4.28/drivers/net/bonding/bonding.h    2013-01-27
23:51:45.000000000 -0500
+++ linux-3.4.28-patched/drivers/net/bonding/bonding.h    2013-01-30
15:37:25.121708311 -0500
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
+                           const u8 *mac)
+{
+    int i = 0;
+    struct slave *tmp;
+
+    bond_for_each_slave(bond, tmp, i)
+        if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
+            return tmp;
+
+    return NULL;
+}

 /* exported from bond_main.c */
 extern int bond_net_id;
diff -uprN linux-3.4.28/include/linux/etherdevice.h
linux-3.4.28-patched/include/linux/etherdevice.h
--- linux-3.4.28/include/linux/etherdevice.h    2013-01-27
23:51:45.000000000 -0500
+++ linux-3.4.28-patched/include/linux/etherdevice.h    2013-01-30
15:37:25.121708311 -0500
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
+ * Please note that alignment of addr1 & addr2 are only guaranteed to
be 16 bits.
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
 #endif    /* _LINUX_ETHERDEVICE_H */




-- 

Mit freundlichen Grüßen,

Florian Wiessner

Smart Weblications GmbH
Martinsberger Str. 1
D-95119 Naila

fon.: +49 9282 9638 200
fax.: +49 9282 9638 205
24/7: +49 900 144 000 00 - 0,99 EUR/Min*
http://www.smart-weblications.de

--
Sitz der Gesellschaft: Naila
Geschäftsführer: Florian Wiessner
HRB-Nr.: HRB 3840 Amtsgericht Hof
*aus dem dt. Festnetz, ggf. abweichende Preise aus dem Mobilfunknetz
