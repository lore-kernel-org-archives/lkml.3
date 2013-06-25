Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3FYSeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3FYSeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 66/95] vhost_net: clear msg.control for non-zerocopy case during tx
Date: Tue, 25 Jun 2013 11:32:53 -0700
Message-Id: <20130625182201.051651141@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 4364d5f96eed7994a2c625bd9216656e55fba0cb ]

When we decide not use zero-copy, msg.control should be set to NULL otherwise
macvtap/tap may set zerocopy callbacks which may decrease the kref of ubufs
wrongly.

Bug were introduced by commit cedb9bdce099206290a2bdd02ce47a7b253b6a84
(vhost-net: skip head management if no outstanding).

This solves the following warnings:

WARNING: at include/linux/kref.h:47 handle_tx+0x477/0x4b0 [vhost_net]()
Modules linked in: vhost_net macvtap macvlan tun nfsd exportfs bridge stp llc openvswitch kvm_amd kvm bnx2 megaraid_sas [last unloaded: tun]
CPU: 5 PID: 8670 Comm: vhost-8668 Not tainted 3.10.0-rc2+ #1566
Hardware name: Dell Inc. PowerEdge R715/00XHKG, BIOS 1.5.2 04/19/2011
ffffffffa0198323 ffff88007c9ebd08 ffffffff81796b73 ffff88007c9ebd48
ffffffff8103d66b 000000007b773e20 ffff8800779f0000 ffff8800779f43f0
ffff8800779f8418 000000000000015c 0000000000000062 ffff88007c9ebd58
Call Trace:
[<ffffffff81796b73>] dump_stack+0x19/0x1e
[<ffffffff8103d66b>] warn_slowpath_common+0x6b/0xa0
[<ffffffff8103d6b5>] warn_slowpath_null+0x15/0x20
[<ffffffffa0197627>] handle_tx+0x477/0x4b0 [vhost_net]
[<ffffffffa0197690>] handle_tx_kick+0x10/0x20 [vhost_net]
[<ffffffffa019541e>] vhost_worker+0xfe/0x1a0 [vhost_net]
[<ffffffffa0195320>] ? vhost_attach_cgroups_work+0x30/0x30 [vhost_net]
[<ffffffffa0195320>] ? vhost_attach_cgroups_work+0x30/0x30 [vhost_net]
[<ffffffff81061f46>] kthread+0xc6/0xd0
[<ffffffff81061e80>] ? kthread_freezable_should_stop+0x70/0x70
[<ffffffff817a1aec>] ret_from_fork+0x7c/0xb0
[<ffffffff81061e80>] ? kthread_freezable_should_stop+0x70/0x70

Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -353,7 +353,8 @@ static void handle_tx(struct vhost_net *
 				kref_get(&ubufs->kref);
 			}
 			vq->upend_idx = (vq->upend_idx + 1) % UIO_MAXIOV;
-		}
+		} else
+			msg.msg_control = NULL;
 		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(NULL, sock, &msg, len);
 		if (unlikely(err < 0)) {


