Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab3CZSEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:04:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3CZRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:01 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RGOdwypfkeUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=d467tr5auRgA:10 a=pGLkceISAAAA:8 a=K33ine3eAAAA:8 a=sPyYOCAXAAAA:8 a=J1Y8HTJGAAAA:8 a=VwQbUJbxAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=MSl-tDqOz04A:10 a=o7nkWXKJ22EA:10 a=6UCq8DqREAUA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173600.211530324@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Antonio Quartulli <ordex@autistici.org>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        <b.a.t.m.a.n@lists.open-mesh.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: [PATCH 02/86] batman-adv: fix random jitter calculation
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0002-batman-adv-fix-random-jitter-calculation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit 143cdd8f33909ff5a153e3f02048738c5964ba26 ]

batadv_iv_ogm_emit_send_time() attempts to calculates a random integer
in the range of 'orig_interval +- BATADV_JITTER' by the below lines.

        msecs = atomic_read(&bat_priv->orig_interval) - BATADV_JITTER;
        msecs += (random32() % 2 * BATADV_JITTER);

But it actually gets 'orig_interval' or 'orig_interval - BATADV_JITTER'
because '%' and '*' have same precedence and associativity is
left-to-right.

This adds the parentheses at the appropriate position so that it matches
original intension.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Antonio Quartulli <ordex@autistici.org>
Cc: Marek Lindner <lindner_marek@yahoo.de>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: Antonio Quartulli <ordex@autistici.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/batman-adv/bat_iv_ogm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 469daab..1476f26 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -119,7 +119,7 @@ batadv_iv_ogm_emit_send_time(const struct batadv_priv *bat_priv)
 	unsigned int msecs;
 
 	msecs = atomic_read(&bat_priv->orig_interval) - BATADV_JITTER;
-	msecs += (random32() % 2 * BATADV_JITTER);
+	msecs += random32() % (2 * BATADV_JITTER);
 
 	return jiffies + msecs_to_jiffies(msecs);
 }
-- 
1.7.10.4


