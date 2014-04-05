Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaDELxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 07:53:20 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63324 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaDELxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 07:53:18 -0400
Message-ID: <533FEE9B.5090806@gmail.com>
Date: Sat, 05 Apr 2014 17:22:59 +0530
From: Balakumaran Kannan <kumaran.4353@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net IPv6]: Fix maximum IPv6 address limit violation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel doesn't check with max IPv6 address limit before adding IPv6 temporary
address.

Security fix CVE-2013-0343 removes max_addresses check from ipv6_create_tempaddr
function as this is handled before in addrconf_prefix_rcv function. But
addrconf_prefix_rcv does max_addresses check only before adding MAC based RA
address and if limit is already reached, it stops processing the prefix.

When IPv6 privacy extension is enabled, two addresses will be created for a
new prefix received through RA. So if a machine has (max_addresses - 1) number
of  IPv6 addresses, after receiving an RA with new prefix the machine will have
(max_addresses + 1) number of IPv6 addresses.

So it is better to use a new prefix only if two IPv6 address slots available
in case IPv6 privacy extension is enabled.

Severity: Less

Signed-off-by: Balakumaran Kannan <kumaran.4353@gmail.com>
---
How to reproduce:
        1. Enable IPv6 privacy extension by setting value of
           /proc/sys/net/ipv6/conf/<iface>/use_tempaddr to 2.
        2. Flood RA with different prefixes.
        3. Check total number of IPv6 address assigned for your iface.
           By default max_addresses will be 16. So after receiving 8 RAs, there
           will be 17 IPv6 addresses including link-local address.
---
 net/ipv6/addrconf.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6c7fa08..8a7e4ba 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2278,6 +2278,15 @@ ok:
            /* Do not allow to create too much of autoconfigured
             * addresses; this would be too easy way to crash kernel.
             */
+#ifdef CONFIG_IPV6_PRIVACY
+           /* When IPv6 privacy extension is enabled, there must
+            * be two IPv6 address slots available.
+            * - One for MAC based address
+            * - Another for temporary address
+            */
+           if (max_addresses > 1)
+               max_addresses--;
+#endif
            if (!max_addresses ||
                ipv6_count_addresses(in6_dev) < max_addresses)
                ifp = ipv6_add_addr(in6_dev, &addr, NULL,
-- 
1.7.9.5

