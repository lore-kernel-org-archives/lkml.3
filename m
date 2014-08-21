Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaHUWtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:49:25 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49268 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaHUWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:49:24 -0400
MIME-Version: 1.0
Date: Thu, 21 Aug 2014 16:49:22 -0600
Message-ID: <CAEEmuwRetasGa99PuXAjX5kf1YfJuX442vecyPyH8oU0E_-6iQ@mail.gmail.com>
Subject: question about skb headers repeat changes when receiving a package in linux
From: Tony Sok <suokunjinxing@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Right now I am researching on linux protocol stack:

Before a skb is transferring from L2(ethernet layer) to L3(IP layer),
function __netif_receive_skb_core will be called and skb->data pointer
will point to L3 header in this function like below:

static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc)
{
    ...
    //modify the L2 header, skb->data pointer will point to L3 header
    skb_reset_network_header(skb);
    if (!skb_transport_header_was_set(skb))
        skb_reset_transport_header(skb);
    skb_reset_mac_len(skb);

    ...
    //VLan related code
    //Bridge related code
    //IP protocol related code
    ...
}


When the network device is a network bridge, bridge related code will
be executed. And function call relationship will be like this:
br_handle_frame --> br_handle_frame_finish --> br_forward -->
__br_forward --> br_forward_finish --> br_dev_queue_push_xmit

In br_dev_queue_push_xmit, the skb->data pointer will be restored to
L2 header by skb_push(skb, ETH_HLEN) like the code below:

int br_dev_queue_push_xmit(struct sk_buff *skb)
{
    /* drop mtu oversized packets except gso */
    if (packet_length(skb) > skb->dev->mtu && !skb_is_gso(skb))
        kfree_skb(skb);
    else {
         /* ip_fragment doesn't copy the MAC header */
         if (nf_bridge_maybe_copy_header(skb))
             kfree_skb(skb);
         else {
             skb_push(skb, ETH_HLEN);
             dev_queue_xmit(skb);
         }
    }

    return 0;
}


After another network device received this skb and transferred it into
L3 layer, the skb->data will be adjusted once again and pointed to IP
header.

My question is, why the skb header need to be adjusted so repeatedly?
Can the bridge send modified skb(e.g. skb->data pointed to IP layer,
not the original one) to another network device so they did not need
to do the repeated work?

Thank you very much for answering my question.
