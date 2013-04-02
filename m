Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3DBSsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:48:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34913 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab3DBSsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:48:11 -0400
X-Sasl-enc: UAGUwHQ7WiNSLe0IinERtVb/9Ew5zXi5LlhQqre69wu3 1364928490
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 0/6] 802.15.4 and 6LoWPAN Buffering Fixes
Date: Tue,  2 Apr 2013 14:47:55 -0400
Message-Id: <1364928481-1813-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix an issue in the 802.15.4 code where the output buffer
(which prior to this patchset is just a workqueue) can grow to an arbitrary
size.  This is basically fixed as follows:

1. Use netif_stop_queue() and netif_wake_queue() to stop and start the
transmit queue, preventing packets from piling up without bound on the
mac802154 workqueue.

2.  Increase the default tx_buffer_len for mac802154 (wpan) devices from 10
to 300, enabling Qdisc to work properly on the transmit queue.

Additionally the following related issues are fixed:

1. Handle dev_queue_xmit() return values properly in the 6LoWPAN code (and
return the proper errors to the higher layers).  This will cause the higher
layers to retry later if the mac802154 queue is full.

2. Fix the retry of transmit failures in mac802154.

Alan Ott (6):
  mac802154: Immediately retry sending failed packets
  mac802154: Move xmit_attemps to stack
  mac802154: Use netif flow control
  mac802154: Increase tx_buffer_len
  6lowpan: handle dev_queue_xmit error code properly
  6lowpan: return the dev_queue_xmit() return value from lowpan_xmit()

 net/ieee802154/6lowpan.c |  4 ++--
 net/mac802154/tx.c       | 34 ++++++++++++++++++++++++----------
 net/mac802154/wpan.c     |  2 +-
 3 files changed, 27 insertions(+), 13 deletions(-)

-- 
1.7.11.2

