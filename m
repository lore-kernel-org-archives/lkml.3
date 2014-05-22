Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaEVTHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:07:49 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:46847 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaEVTHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:07:47 -0400
Message-ID: <537E4AFD.20304@mentor.com>
Date: Thu, 22 May 2014 20:07:41 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, <kamal@canonical.com>,
        Ben Hutchings <bhutchings@solarflare.com>, <edumazet@google.com>,
        <mszeredi@suse.cz>, <fw@strlen.de>
Subject: skbuff truesize incorrect.
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 22 May 2014 19:07:43.0788 (UTC) FILETIME=[1C35A6C0:01CF75F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I was hoping you can help me with some questions.

I have been investigating a network issue with bursts of network traffic
over USB CDC-NCM, the issue is that the kernel is dropping packets
because sk_rcvqueues_full() returns true due to skb2->truesize is always
32960 instead of SKB_TRUESIZE(skb2->len) which is about 1800.

The code I am trying to fix is this code below, it is splitting a set of
multiple network packets compressed into a single 16k packet into
individual skb's and sending them up the network stack.

    skb2 = skb_clone(skb, GFP_ATOMIC);
    if (skb2 == NULL)
        goto err;

    if (!skb_pull(skb2, index)) {
        ret = -EOVERFLOW;
        goto err;
    }

    skb_trim(skb2, dg_len - crc_len);

My questions are:

1) Which buffer size does truesize represent, is it the total buffer or
just the data related to the relevant skb?

2) If truesize is for the skb it is contained within should it be
updated during the call to skb_trim?

3) Why does the truesize default to 32960?


Thank you for any help,
Jim Baxter.
