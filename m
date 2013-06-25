Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3FYTBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:01:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3FYSeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        Li RongQing <roy.qing.li@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 53/95] xfrm: properly handle invalid states as an error
Date: Tue, 25 Jun 2013 11:32:40 -0700
Message-Id: <20130625182159.627976050@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timo Teräs <timo.teras@iki.fi>

[ Upstream commit 497574c72c9922cf20c12aed15313c389f722fa0 ]

The error exit path needs err explicitly set. Otherwise it
returns success and the only caller, xfrm_output_resume(),
would oops in skb_dst(skb)->ops derefence as skb_dst(skb) is
NULL.

Bug introduced in commit bb65a9cb (xfrm: removes a superfluous
check and add a statistic).

Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Cc: Li RongQing <roy.qing.li@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_output.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -64,6 +64,7 @@ static int xfrm_output_one(struct sk_buf
 
 		if (unlikely(x->km.state != XFRM_STATE_VALID)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTSTATEINVALID);
+			err = -EINVAL;
 			goto error;
 		}
 


