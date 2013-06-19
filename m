Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934695Ab3FSMZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:25:38 -0400
Received: from liberty.xssl.net ([83.223.124.15]:38116 "EHLO liberty.xssl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934108Ab3FSMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:25:37 -0400
X-Greylist: delayed 4322 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jun 2013 08:25:36 EDT
Message-ID: <51C19258.9070504@keyparts.co.uk>
Date: Wed, 19 Jun 2013 12:13:28 +0100
From: Stephen Moorby <steve@keyparts.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: andrew.hendry@gmail.com, davem@davemloft.net, sasha.levin@oracle.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        jiri@resnulli.us, linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] net/x25: fix address parsing bug in x25_parse_address_block.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - liberty.xssl.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - keyparts.co.uk
X-Get-Message-Sender-Via: liberty.xssl.net: authenticated_id: steve@keyparts.co.uk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 01ba835311f6d2e2bbffc74703d704dc07803b53 Mon Sep 17 00:00:00 2001
From: Stephen Moorby <steve.moorby@ntlworld.com>
Date: Wed, 19 Jun 2013 11:48:53 +0100
Subject: [PATCH 1/1] net/x25: fix address parsing bug in
  x25_parse_address_block.

This problem was discovered when a linux box was incorrectly rejecting
calls from some X.25 equipment.  The problem was diagnosed to an incorrect
address length calculation in 'x25_parse_address_block', the calculation
did not account for the address digits being BCD encoded.  The correct
calculation is already performed on line 155.

Patched on linux-next 18-Jun-2013
Tested on 2.6.32-45-generic

Signed-off-by: Stephen Moorby <steve.moorby@ntlworld.com>
---
  net/x25/af_x25.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 1d964e2..eb6c1f9 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -98,7 +98,8 @@ int x25_parse_address_block(struct sk_buff *skb,
      }

      len = *skb->data;
-    needed = 1 + (len >> 4) + (len & 0x0f);
+    /* need 1 for address length + bytes for BCD encoding of 2 addresses */
+    needed = 1 + (((len >> 4) + (len & 0x0f) + 1) >> 1);

      if (!pskb_may_pull(skb, needed)) {
          /* packet is too short to hold the addresses it claims
-- 
1.8.1.2

