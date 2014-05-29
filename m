Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbaE2FHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:07:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601AbaE2Efz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergey Popovich <popovich_sergei@mail.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 114/140] ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation
Date: Wed, 28 May 2014 21:34:13 -0700
Message-Id: <20140529043104.261958171@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Popovich <popovich_sergei@mail.ru>

[ Upstream commit aeefa1ecfc799b0ea2c4979617f14cecd5cccbfd ]

Increment fib_info_cnt in fib_create_info() right after successfuly
alllocating fib_info structure, overwise fib_metrics allocation failure
leads to fib_info_cnt incorrectly decremented in free_fib_info(), called
on error path from fib_create_info().

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -820,13 +820,13 @@ struct fib_info *fib_create_info(struct
 	fi = kzalloc(sizeof(*fi)+nhs*sizeof(struct fib_nh), GFP_KERNEL);
 	if (fi == NULL)
 		goto failure;
+	fib_info_cnt++;
 	if (cfg->fc_mx) {
 		fi->fib_metrics = kzalloc(sizeof(u32) * RTAX_MAX, GFP_KERNEL);
 		if (!fi->fib_metrics)
 			goto failure;
 	} else
 		fi->fib_metrics = (u32 *) dst_default_metrics;
-	fib_info_cnt++;
 
 	fi->fib_net = hold_net(net);
 	fi->fib_protocol = cfg->fc_protocol;


