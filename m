Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3EVXRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 19:17:35 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:39260 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3EVXRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 19:17:34 -0400
Message-ID: <519D5206.8080701@gmail.com>
Date: Wed, 22 May 2013 19:17:26 -0400
From: "Matthew O'Connor" <liquidhorse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: f.wiessner@smart-weblications.de
CC: Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        andy@greyhouse.net, fubar@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com, zheng.x.li@oracle.com,
        andy@greyhouse.net
Subject: Re: https://lkml.org/lkml/2013/2/1/531
References: <519CADA9.9060909@smart-weblications.de> <20130522135745.GA14640@kroah.com> <519CEF4B.5090108@smart-weblications.de> <20130522162336.GA5761@kroah.com> <519D0B79.6010307@smart-weblications.de> <20130522190640.GA20276@kroah.com> <519D1DEF.8090206@smart-weblications.de> <20130522200439.GA21367@kroah.com> <519D37F4.2030202@smart-weblications.de>
In-Reply-To: <519D37F4.2030202@smart-weblications.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the backported patch I submitted previously.  Hopefully this
time around it won't be too messed up, I'm using Thunderbird instead of
the web interface.  I have applied it successfully and without warnings
against 3.4.46.  It builds, but is otherwise untested beyond what I did
when I originally submitted back in Feb.  This patch applies only to the
3.4 series kernel, although with minor changes it will work for 3.0,
3.2, and 3.7.  If you're interested, I can submit the other patches
shortly.  If this submission still does not conform to standards, please
let me know where I went wrong.  For what it's worth I dropped the patch
contents directly into the email, but I can attach it instead if that
would work better.


[ Upstream commit 567b871e503316b0927e54a3d7c86d50b722d955 ]

bonding: rlb mode of bond should not alter ARP originating via bridge

Do not modify or load balance ARP packets passing through balance-alb
mode (wherein the ARP did not originate locally, and arrived via a bridge).

Modifying pass-through ARP replies causes an incorrect MAC address
to be placed into the ARP packet, rendering peers unable to communicate
with the actual destination from which the ARP reply originated.

Load balancing pass-through ARP requests causes an entry to be
created for the peer in the rlb table, and bond_alb_monitor will
occasionally issue ARP updates to all peers in the table instrucing them
as to which MAC address they should communicate with; this occurs when
some event sets rx_ntt.  In the bridged case, however, the MAC address
used for the update would be the MAC of the slave, not the actual source
MAC of the originating destination.  This would render peers unable to
communicate with the destinations beyond the bridge.

Signed-off-by: Matthew O'Connor <liquidhorse@gmail.com>
CC: Zheng Li <zheng.x.li@oracle.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>


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




On 05/22/2013 05:26 PM, Smart Weblications GmbH - Florian Wiessner wrote:
> Hi Greg,
>
>
> Am 22.05.2013 22:04, schrieb Greg KH:
>
>
>>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/jkirsher/net-next/+/567b871e503316b0927e54a3d7c86d50b722d955%5E!/
>> Ok, that's what we need.
>>
>> Now, please cc: the developers / maintainers of that patch and ask them
>> to have it included in the 3.4-stable kernel series.
>>
>> Then, if they agree, the network maintainer will pick it up and send it
>> to me for inclusion.
>>
> i set committer	David S. Miller <davem@davemloft.net> in cc already, but do not
> know the network maintainer...
>
> this seems to me that "Matthew O'Connor" <liquidhorse@gmail.com> sent this to
> netdev on 2013-02-01:
>
> http://lists.openwall.net/netdev/2013/02/01/86
>
> but i couldn't find a trace of the patch in 3.4.36?!
>
> Instead, i read another try to get it backported fail:
>
> http://permalink.gmane.org/gmane.linux.network/264198
>
>
>
>
>
>

