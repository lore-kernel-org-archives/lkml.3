Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936679AbaBDXMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:12:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbaBDVAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:00:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 31/37] net,via-rhine: Fix tx_timeout handling
Date: Tue,  4 Feb 2014 13:01:07 -0800
Message-Id: <20140204210056.894225818@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210055.992134150@linuxfoundation.org>
References: <20140204210055.992134150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

[ Upstream commit a926592f5e4e900f3fa903298c4619a131e60963 ]

rhine_reset_task() misses to disable the tx scheduler upon reset,
this can lead to a crash if work is still scheduled while we're resetting
the tx queue.

Fixes:
[   93.591707] BUG: unable to handle kernel NULL pointer dereference at 0000004c
[   93.595514] IP: [<c119d10d>] rhine_napipoll+0x491/0x6

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/via/via-rhine.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1601,6 +1601,7 @@ static void rhine_reset_task(struct work
 		goto out_unlock;
 
 	napi_disable(&rp->napi);
+	netif_tx_disable(dev);
 	spin_lock_bh(&rp->lock);
 
 	/* clear all descriptors */


