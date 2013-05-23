Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3EWKZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:25:39 -0400
Received: from mx02.smart-weblications.de ([188.65.144.37]:60651 "EHLO
	mx02.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757918Ab3EWKZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:25:37 -0400
Message-ID: <519DEE6E.7060700@smart-weblications.de>
Date: Thu, 23 May 2013 12:24:46 +0200
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Matthew O'Connor" <liquidhorse@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        andy@greyhouse.net, fubar@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com, zheng.x.li@oracle.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
References: <519CADA9.9060909@smart-weblications.de> <20130522135745.GA14640@kroah.com> <519CEF4B.5090108@smart-weblications.de> <20130522162336.GA5761@kroah.com> <519D0B79.6010307@smart-weblications.de> <20130522190640.GA20276@kroah.com> <519D1DEF.8090206@smart-weblications.de> <20130522200439.GA21367@kroah.com> <519D37F4.2030202@smart-weblications.de> <519D5206.8080701@gmail.com>
In-Reply-To: <519D5206.8080701@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/mixed;
 boundary="------------050906060005060002040006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050906060005060002040006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Am 23.05.2013 01:17, schrieb Matthew O'Connor:
> This is the backported patch I submitted previously.  Hopefully this
> time around it won't be too messed up, I'm using Thunderbird instead of
> the web interface.  I have applied it successfully and without warnings
> against 3.4.46.  It builds, but is otherwise untested beyond what I did
> when I originally submitted back in Feb.  This patch applies only to the
> 3.4 series kernel, although with minor changes it will work for 3.0,
> 3.2, and 3.7.  If you're interested, I can submit the other patches
> shortly.  If this submission still does not conform to standards, please
> let me know where I went wrong.  For what it's worth I dropped the patch
> contents directly into the email, but I can attach it instead if that
> would work better.
> 


Hm, i tried to apply it to 3.4.46 but it does not work:

node02:/ocfs2/usr/src/linux-3.4.46# patch -p1 <../bridge-patch-3.4.46
patching file drivers/net/bonding/bond_alb.c
Hunk #1 FAILED at 704.
1 out of 1 hunk FAILED -- saving rejects to file drivers/net/bonding/bond_alb.c.rej
patching file drivers/net/bonding/bonding.h
patching file include/linux/etherdevice.h
Hunk #1 FAILED at 277.
1 out of 1 hunk FAILED -- saving rejects to file include/linux/etherdevice.h.rej


node02:/ocfs2/usr/src/linux-3.4.46# cat drivers/net/bonding/bond_alb.c.rej
--- drivers/net/bonding/bond_alb.c 2013-01-27 23:51:45.000000000 -0500
+++ drivers/net/bonding/bond_alb.c 2013-01-30 15:37:25.121708311 -0500
@@ -704,6 +704,12 @@
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


node02:/ocfs2/usr/src/linux-3.4.46# cat include/linux/etherdevice.h.rej
--- include/linux/etherdevice.h 2013-01-27 23:51:45.000000000 -0500
+++ include/linux/etherdevice.h 2013-01-30 15:37:25.121708311 -0500
@@ -277,4 +277,37 @@
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
 #endif    /* _LINUX_ETHERDEVICE_H */


> 
> [ Upstream commit 567b871e503316b0927e54a3d7c86d50b722d955 ]
> 
> bonding: rlb mode of bond should not alter ARP originating via bridge
> 
> Do not modify or load balance ARP packets passing through balance-alb
> mode (wherein the ARP did not originate locally, and arrived via a bridge).
> 
> Modifying pass-through ARP replies causes an incorrect MAC address
> to be placed into the ARP packet, rendering peers unable to communicate
> with the actual destination from which the ARP reply originated.
> 
> Load balancing pass-through ARP requests causes an entry to be
> created for the peer in the rlb table, and bond_alb_monitor will
> occasionally issue ARP updates to all peers in the table instrucing them
> as to which MAC address they should communicate with; this occurs when
> some event sets rx_ntt.  In the bridged case, however, the MAC address
> used for the update would be the MAC of the slave, not the actual source
> MAC of the originating destination.  This would render peers unable to
> communicate with the destinations beyond the bridge.
> 
> Signed-off-by: Matthew O'Connor <liquidhorse@gmail.com>
> CC: Zheng Li <zheng.x.li@oracle.com>
> Cc: Jay Vosburgh <fubar@us.ibm.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> 
> 
> diff -uprN linux-3.4.28/drivers/net/bonding/bond_alb.c
> linux-3.4.28-patched/drivers/net/bonding/bond_alb.c
> --- linux-3.4.28/drivers/net/bonding/bond_alb.c    2013-01-27
> 23:51:45.000000000 -0500
> +++ linux-3.4.28-patched/drivers/net/bonding/bond_alb.c    2013-01-30
> 15:37:25.121708311 -0500
> @@ -704,6 +704,12 @@ static struct slave *rlb_arp_xmit(struct
>      struct arp_pkt *arp = arp_pkt(skb);
>      struct slave *tx_slave = NULL;
>  
> +    /* Don't modify or load balance ARPs that do not originate locally
> +     * (e.g.,arrive via a bridge).
> +     */
> +    if (!bond_slave_has_mac(bond, arp->mac_src))
> +        return NULL;
> +
>      if (arp->op_code == htons(ARPOP_REPLY)) {
>          /* the arp must be sent on the selected
>          * rx channel
> diff -uprN linux-3.4.28/drivers/net/bonding/bonding.h
> linux-3.4.28-patched/drivers/net/bonding/bonding.h
> --- linux-3.4.28/drivers/net/bonding/bonding.h    2013-01-27
> 23:51:45.000000000 -0500
> +++ linux-3.4.28-patched/drivers/net/bonding/bonding.h    2013-01-30
> 15:37:25.121708311 -0500
> @@ -18,6 +18,7 @@
>  #include <linux/timer.h>
>  #include <linux/proc_fs.h>
>  #include <linux/if_bonding.h>
> +#include <linux/etherdevice.h>
>  #include <linux/cpumask.h>
>  #include <linux/in6.h>
>  #include <linux/netpoll.h>
> @@ -450,6 +451,18 @@ static inline void bond_destroy_proc_dir
>  }
>  #endif
>  
> +static inline struct slave *bond_slave_has_mac(struct bonding *bond,
> +                           const u8 *mac)
> +{
> +    int i = 0;
> +    struct slave *tmp;
> +
> +    bond_for_each_slave(bond, tmp, i)
> +        if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
> +            return tmp;
> +
> +    return NULL;
> +}
>  
>  /* exported from bond_main.c */
>  extern int bond_net_id;
> diff -uprN linux-3.4.28/include/linux/etherdevice.h
> linux-3.4.28-patched/include/linux/etherdevice.h
> --- linux-3.4.28/include/linux/etherdevice.h    2013-01-27
> 23:51:45.000000000 -0500
> +++ linux-3.4.28-patched/include/linux/etherdevice.h    2013-01-30
> 15:37:25.121708311 -0500
> @@ -277,4 +277,37 @@ static inline unsigned long compare_ethe
>  #endif
>  }
>  
> +/**
> + * ether_addr_equal_64bits - Compare two Ethernet addresses
> + * @addr1: Pointer to an array of 8 bytes
> + * @addr2: Pointer to an other array of 8 bytes
> + *
> + * Compare two Ethernet addresses, returns true if equal, false otherwise.
> + *
> + * The function doesn't need any conditional branches and possibly uses
> + * word memory accesses on CPU allowing cheap unaligned memory reads.
> + * arrays = { byte1, byte2, byte3, byte4, byte5, byte6, pad1, pad2 }
> + *
> + * Please note that alignment of addr1 & addr2 are only guaranteed to
> be 16 bits.
> + */
> +
> +static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
> +                                           const u8 addr2[6+2])
> +{
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +        unsigned long fold = ((*(unsigned long *)addr1) ^
> +                              (*(unsigned long *)addr2));
> +
> +        if (sizeof(fold) == 8)
> +                return zap_last_2bytes(fold) == 0;
> +
> +        fold |= zap_last_2bytes((*(unsigned long *)(addr1 + 4)) ^
> +                                (*(unsigned long *)(addr2 + 4)));
> +        return fold == 0;
> +#else
> +        return ether_addr_equal(addr1, addr2);
> +#endif
> +}
> +
> +
>  #endif    /* _LINUX_ETHERDEVICE_H */
> 
> 
> 
> 
> On 05/22/2013 05:26 PM, Smart Weblications GmbH - Florian Wiessner wrote:
>> Hi Greg,
>>
>>
>> Am 22.05.2013 22:04, schrieb Greg KH:
>>
>>
>>>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/jkirsher/net-next/+/567b871e503316b0927e54a3d7c86d50b722d955%5E!/
>>> Ok, that's what we need.
>>>
>>> Now, please cc: the developers / maintainers of that patch and ask them
>>> to have it included in the 3.4-stable kernel series.
>>>
>>> Then, if they agree, the network maintainer will pick it up and send it
>>> to me for inclusion.
>>>
>> i set committer	David S. Miller <davem@davemloft.net> in cc already, but do not
>> know the network maintainer...
>>
>> this seems to me that "Matthew O'Connor" <liquidhorse@gmail.com> sent this to
>> netdev on 2013-02-01:
>>
>> http://lists.openwall.net/netdev/2013/02/01/86
>>
>> but i couldn't find a trace of the patch in 3.4.36?!
>>
>> Instead, i read another try to get it backported fail:
>>
>> http://permalink.gmane.org/gmane.linux.network/264198
>>
>>
>>
>>
>>
>>
> 


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

--------------050906060005060002040006
Content-Type: text/plain; charset=windows-1252;
 name="bridge-patch-3.4.46.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bridge-patch-3.4.46.txt"

ZGlmZiAtdXByTiBsaW51eC0zLjQuMjgvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX2FsYi5j
DQpsaW51eC0zLjQuMjgtcGF0Y2hlZC9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfYWxiLmMN
Ci0tLSBsaW51eC0zLjQuMjgvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX2FsYi5jICAgIDIw
MTMtMDEtMjcgMjM6NTE6NDUuMDAwMDAwMDAwIC0wNTAwDQorKysgbGludXgtMy40LjI4LXBh
dGNoZWQvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX2FsYi5jICAgIDIwMTMtMDEtMzAgMTU6
Mzc6MjUuMTIxNzA4MzExIC0wNTAwDQpAQCAtNzA0LDYgKzcwNCwxMiBAQCBzdGF0aWMgc3Ry
dWN0IHNsYXZlICpybGJfYXJwX3htaXQoc3RydWN0DQogICAgIHN0cnVjdCBhcnBfcGt0ICph
cnAgPSBhcnBfcGt0KHNrYik7DQogICAgIHN0cnVjdCBzbGF2ZSAqdHhfc2xhdmUgPSBOVUxM
Ow0KIA0KKyAgICAvKiBEb24ndCBtb2RpZnkgb3IgbG9hZCBiYWxhbmNlIEFSUHMgdGhhdCBk
byBub3Qgb3JpZ2luYXRlIGxvY2FsbHkNCisgICAgICogKGUuZy4sYXJyaXZlIHZpYSBhIGJy
aWRnZSkuDQorICAgICAqLw0KKyAgICBpZiAoIWJvbmRfc2xhdmVfaGFzX21hYyhib25kLCBh
cnAtPm1hY19zcmMpKQ0KKyAgICAgICAgcmV0dXJuIE5VTEw7DQorDQogICAgIGlmIChhcnAt
Pm9wX2NvZGUgPT0gaHRvbnMoQVJQT1BfUkVQTFkpKSB7DQogICAgICAgICAvKiB0aGUgYXJw
IG11c3QgYmUgc2VudCBvbiB0aGUgc2VsZWN0ZWQNCiAgICAgICAgICogcnggY2hhbm5lbA0K
ZGlmZiAtdXByTiBsaW51eC0zLjQuMjgvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kaW5nLmgN
CmxpbnV4LTMuNC4yOC1wYXRjaGVkL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZGluZy5oDQot
LS0gbGludXgtMy40LjI4L2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZGluZy5oICAgIDIwMTMt
MDEtMjcgMjM6NTE6NDUuMDAwMDAwMDAwIC0wNTAwDQorKysgbGludXgtMy40LjI4LXBhdGNo
ZWQvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kaW5nLmggICAgMjAxMy0wMS0zMCAxNTozNzoy
NS4xMjE3MDgzMTEgLTA1MDANCkBAIC0xOCw2ICsxOCw3IEBADQogI2luY2x1ZGUgPGxpbnV4
L3RpbWVyLmg+DQogI2luY2x1ZGUgPGxpbnV4L3Byb2NfZnMuaD4NCiAjaW5jbHVkZSA8bGlu
dXgvaWZfYm9uZGluZy5oPg0KKyNpbmNsdWRlIDxsaW51eC9ldGhlcmRldmljZS5oPg0KICNp
bmNsdWRlIDxsaW51eC9jcHVtYXNrLmg+DQogI2luY2x1ZGUgPGxpbnV4L2luNi5oPg0KICNp
bmNsdWRlIDxsaW51eC9uZXRwb2xsLmg+DQpAQCAtNDUwLDYgKzQ1MSwxOCBAQCBzdGF0aWMg
aW5saW5lIHZvaWQgYm9uZF9kZXN0cm95X3Byb2NfZGlyDQogfQ0KICNlbmRpZg0KIA0KK3N0
YXRpYyBpbmxpbmUgc3RydWN0IHNsYXZlICpib25kX3NsYXZlX2hhc19tYWMoc3RydWN0IGJv
bmRpbmcgKmJvbmQsDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgdTggKm1h
YykNCit7DQorICAgIGludCBpID0gMDsNCisgICAgc3RydWN0IHNsYXZlICp0bXA7DQorDQor
ICAgIGJvbmRfZm9yX2VhY2hfc2xhdmUoYm9uZCwgdG1wLCBpKQ0KKyAgICAgICAgaWYgKGV0
aGVyX2FkZHJfZXF1YWxfNjRiaXRzKG1hYywgdG1wLT5kZXYtPmRldl9hZGRyKSkNCisgICAg
ICAgICAgICByZXR1cm4gdG1wOw0KKw0KKyAgICByZXR1cm4gTlVMTDsNCit9DQogDQogLyog
ZXhwb3J0ZWQgZnJvbSBib25kX21haW4uYyAqLw0KIGV4dGVybiBpbnQgYm9uZF9uZXRfaWQ7
DQpkaWZmIC11cHJOIGxpbnV4LTMuNC4yOC9pbmNsdWRlL2xpbnV4L2V0aGVyZGV2aWNlLmgN
CmxpbnV4LTMuNC4yOC1wYXRjaGVkL2luY2x1ZGUvbGludXgvZXRoZXJkZXZpY2UuaA0KLS0t
IGxpbnV4LTMuNC4yOC9pbmNsdWRlL2xpbnV4L2V0aGVyZGV2aWNlLmggICAgMjAxMy0wMS0y
NyAyMzo1MTo0NS4wMDAwMDAwMDAgLTA1MDANCisrKyBsaW51eC0zLjQuMjgtcGF0Y2hlZC9p
bmNsdWRlL2xpbnV4L2V0aGVyZGV2aWNlLmggICAgMjAxMy0wMS0zMCAxNTozNzoyNS4xMjE3
MDgzMTEgLTA1MDANCkBAIC0yNzcsNCArMjc3LDM3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWdu
ZWQgbG9uZyBjb21wYXJlX2V0aGUNCiAjZW5kaWYNCiB9DQogDQorLyoqDQorICogZXRoZXJf
YWRkcl9lcXVhbF82NGJpdHMgLSBDb21wYXJlIHR3byBFdGhlcm5ldCBhZGRyZXNzZXMNCisg
KiBAYWRkcjE6IFBvaW50ZXIgdG8gYW4gYXJyYXkgb2YgOCBieXRlcw0KKyAqIEBhZGRyMjog
UG9pbnRlciB0byBhbiBvdGhlciBhcnJheSBvZiA4IGJ5dGVzDQorICoNCisgKiBDb21wYXJl
IHR3byBFdGhlcm5ldCBhZGRyZXNzZXMsIHJldHVybnMgdHJ1ZSBpZiBlcXVhbCwgZmFsc2Ug
b3RoZXJ3aXNlLg0KKyAqDQorICogVGhlIGZ1bmN0aW9uIGRvZXNuJ3QgbmVlZCBhbnkgY29u
ZGl0aW9uYWwgYnJhbmNoZXMgYW5kIHBvc3NpYmx5IHVzZXMNCisgKiB3b3JkIG1lbW9yeSBh
Y2Nlc3NlcyBvbiBDUFUgYWxsb3dpbmcgY2hlYXAgdW5hbGlnbmVkIG1lbW9yeSByZWFkcy4N
CisgKiBhcnJheXMgPSB7IGJ5dGUxLCBieXRlMiwgYnl0ZTMsIGJ5dGU0LCBieXRlNSwgYnl0
ZTYsIHBhZDEsIHBhZDIgfQ0KKyAqDQorICogUGxlYXNlIG5vdGUgdGhhdCBhbGlnbm1lbnQg
b2YgYWRkcjEgJiBhZGRyMiBhcmUgb25seSBndWFyYW50ZWVkIHRvIGJlIDE2IGJpdHMuDQor
ICovDQorDQorc3RhdGljIGlubGluZSBib29sIGV0aGVyX2FkZHJfZXF1YWxfNjRiaXRzKGNv
bnN0IHU4IGFkZHIxWzYrMl0sDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGNvbnN0IHU4IGFkZHIyWzYrMl0pDQorew0KKyNpZmRlZiBDT05GSUdfSEFW
RV9FRkZJQ0lFTlRfVU5BTElHTkVEX0FDQ0VTUw0KKyAgICAgICAgdW5zaWduZWQgbG9uZyBm
b2xkID0gKCgqKHVuc2lnbmVkIGxvbmcgKilhZGRyMSkgXg0KKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICgqKHVuc2lnbmVkIGxvbmcgKilhZGRyMikpOw0KKw0KKyAgICAgICAg
aWYgKHNpemVvZihmb2xkKSA9PSA4KQ0KKyAgICAgICAgICAgICAgICByZXR1cm4gemFwX2xh
c3RfMmJ5dGVzKGZvbGQpID09IDA7DQorDQorICAgICAgICBmb2xkIHw9IHphcF9sYXN0XzJi
eXRlcygoKih1bnNpZ25lZCBsb25nICopKGFkZHIxICsgNCkpIF4NCisgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICgqKHVuc2lnbmVkIGxvbmcgKikoYWRkcjIgKyA0KSkpOw0K
KyAgICAgICAgcmV0dXJuIGZvbGQgPT0gMDsNCisjZWxzZQ0KKyAgICAgICAgcmV0dXJuIGV0
aGVyX2FkZHJfZXF1YWwoYWRkcjEsIGFkZHIyKTsNCisjZW5kaWYNCit9DQorDQorDQogI2Vu
ZGlmICAgIC8qIF9MSU5VWF9FVEhFUkRFVklDRV9IICov
--------------050906060005060002040006--
