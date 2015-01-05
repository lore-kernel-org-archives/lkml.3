Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbbAENwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:52:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42181 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbbAENwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:52:14 -0500
Message-ID: <54AA9706.5020202@canonical.com>
Date: Mon, 05 Jan 2015 14:52:06 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] unlock rtnl mutex in ic_open_devs while waiting
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a deadlock with alx_link_check, which takes the rtnl_mutex in
a work item to check the link.

I have no idea whether alx should be fixed or ipconfig.c,
but this saves 120 seconds off my boot time. ;-)

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 7fa18bc7e47f..c8aa15a0cdf4 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -270,7 +270,9 @@ static int __init ic_open_devs(void)
 			if (ic_is_init_dev(dev) && netif_carrier_ok(dev))
 				goto have_carrier;
 
+		rtnl_unlock();
 		msleep(1);
+		rtnl_lock();
 
 		if (time_before(jiffies, next_msg))
 			continue;

