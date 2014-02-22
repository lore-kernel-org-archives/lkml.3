Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaBVRSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:18:45 -0500
Received: from forward5h.mail.yandex.net ([84.201.186.23]:60170 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaBVRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:18:39 -0500
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Feb 2014 12:18:38 EST
From: =?koi8-r?B?69XMxdvP1yDhzMXL08XK?= <rndfax@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: sk_buff: why field 'head' contains skb_shared_info?
MIME-Version: 1.0
Message-Id: <317951393088907@web3h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 22 Feb 2014 21:08:27 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subj.

Look at this core function:
net/core/skbuff.c: __alloc_skb
...
        size = SKB_DATA_ALIGN(size);
        size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
        data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
...
        shinfo = skb_shinfo(skb);
        memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
...

It looks like it was made purposely, but for what?

Why this question has risen.
I found for my needs a very nice (for the first look) function <build_skb> from skbuff.c:
>  * build_skb - build a network buffer
>  * @data: data buffer provided by caller
> ...
>  * Notes :
>  *  Before IO, driver allocates only data buffer where NIC put incoming frame

Everything looks delicious, until this place:
>  *  Driver should add room at head (NET_SKB_PAD) and
>  *  MUST add room at tail (SKB_DATA_ALIGN(skb_shared_info))

And what if NIC is not a regular net_device and it doesn't need sk_buff at all.
But for virtual ethernet device "Ethernet-over-NIC" sk_buff is crucial.
So driver for NIC can't just kmalloc(NICs_RCV_BUF_SIZE, ...) for incoming buffers,
it has to kmalloc(NICs_RCV_BUF_SIZE + <skb_shared_info>, ...) to cover
attached (if any) to NIC virtual ethernet device needs.
Or virtual ethernet device has to do netdev_alloc_skb + memcpy,
which is obviously not so good.
