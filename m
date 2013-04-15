Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3DOOGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:06:33 -0400
Received: from endeavour.telenet.dn.ua ([195.39.211.45]:56052 "EHLO
	endeavour.telenet.dn.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3DOOGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:06:32 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Apr 2013 10:06:31 EDT
Message-ID: <516C075E.30105@telenet.dn.ua>
Date: Mon, 15 Apr 2013 16:57:50 +0300
From: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bonding driver has bad load balancing for forwarded traffic, 3.7+
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a bonding device (mode=802.3ad xmit_hash_policy=layer2+3 miimon=300) and
for kernels <3.7 forwarded IPv4 traffic distributed fine across multiple physical
links. Ethernet cards are Intel 82576 with igb driver (various versions).

3.7 and 3.8 kernels tend to fully utilize only one link and leave the others almost idling.

Replacing bond_xmit_hash_policy_* functions with older ones (3.6 kernel) looks like
resolves the issue (but I haven't tested it thoroughly).

So, I added
         printk(KERN_INFO "hash_policy: protocol = %d, skb_network_header_len = %d, %d %d\n",
             skb->protocol, skb_network_header_len(skb),
             skb_headlen(skb), skb_network_offset(skb));
to bond_xmit_hash_policy_l23() of bond_main.c

and got this:
[   65.280831] hash_policy: protocol = 8, skb_network_header_len = 0, 74 14
[   65.280835] hash_policy: protocol = 8, skb_network_header_len = 0, 74 14
[   65.280839] hash_policy: protocol = 8, skb_network_header_len = 0, 74 14
[   65.280843] hash_policy: protocol = 8, skb_network_header_len = 0, 74 14
[   65.280847] hash_policy: protocol = 8, skb_network_header_len = 0, 74 14
[   65.280851] hash_policy: protocol = 8, skb_network_header_len = 0, 74 14

It's clear that the new check condition (skb_network_header_len(skb) >= sizeof(*iph))
fails here and hash policy fallbacks to l2 balancing.

I have no idea how to fix this besides removing this check completely, any
help would be appreciated.

-- 
Thanks
Vitaly
