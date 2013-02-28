Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750899Ab3B1FM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:12:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:33522 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3B1FM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:12:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,753,1355126400"; 
   d="scan'208";a="292869002"
Subject: [PATCH] n_gsm: Add Mutex to avoid race when net destroy
From: channing <chao.bi@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Feb 2013 13:31:26 +0800
Message-ID: <1362029486.31563.5.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when gsm Net is enabled, data on dlci is transferrd by
gsm_mux_net_start_xmit(), while userspace may trigger
ioctrl to call gsm_destroy_network() during data was
transferring, because there is no mutex protection between
the two functions, following scenario may happen:

1) gsm_mux_net_start_xmit() calls muxnet_get(mux_net);
2) gsm_destroy_network() is called from ioctrl, and it
will not call net_free() to release net device because
net device is still referred in step 1)
3) continue execute step 1), gsm_mux_net_start_xmit()
calls muxnet_put(mux_net), and then calls net_free() to
release net device.
4) if userspace triggers gsm_create_network() at same time
with net_free() in step 3). it will hit race on dlci->net.

This patch is to add a mutex in tx function to avoid race
between it and destroy function.

Signed-off-by: Chao Bi <chao.bi@intel.com>
Signed-off-by: Pillet Vincent <vincentx.pillet@intel.com>
---
 drivers/tty/n_gsm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 4a43ef5..0ca810a 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2660,6 +2660,7 @@ static int gsm_mux_net_start_xmit(struct sk_buff *skb,
 {
 	struct gsm_mux_net *mux_net = (struct gsm_mux_net *)netdev_priv(net);
 	struct gsm_dlci *dlci = mux_net->dlci;
+	mutex_lock(&dlci->mutex);
 	muxnet_get(mux_net);
 
 	skb_queue_head(&dlci->skb_list, skb);
@@ -2669,6 +2670,7 @@ static int gsm_mux_net_start_xmit(struct sk_buff *skb,
 	/* And tell the kernel when the last transmit started. */
 	net->trans_start = jiffies;
 	muxnet_put(mux_net);
+	mutex_unlock(&dlci->mutex);
 	return NETDEV_TX_OK;
 }
 
-- 
1.7.1



