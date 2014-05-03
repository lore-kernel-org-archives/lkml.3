Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaECA6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 20:58:34 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38734 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaECA6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 20:58:32 -0400
MIME-Version: 1.0
In-Reply-To: <5363C545.90600@cogentembedded.com>
References: <1399015092-28643-1-git-send-email-zhouzhouyi@gmail.com>
	<5363C545.90600@cogentembedded.com>
Date: Sat, 3 May 2014 08:58:31 +0800
Message-ID: <CAABZP2z4OQ5fHDDAJPU5RAteBFK9wwmCqRSg8Knp635auCj4ZA@mail.gmail.com>
Subject: Re: [PATCH] netdev: pktgen xmit packet through vlan interface
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: David Miller <davem@davemloft.net>, steffen.klassert@secunet.com,
        fan.du@windriver.com, dborkman@redhat.com,
        Mathias Krause <minipli@googlemail.com>, tgraf@suug.ch,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank Sergei for reviewing.

I think
On Sat, May 3, 2014 at 12:18 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:

>> +
>> +       if (pkt_dev->clone_skb && is_vlan_dev(odev)) {
>> +               nskb = skb_clone(pkt_dev->skb, GFP_ATOMIC);
>> +               ret = -ENOMEM;
>> +               if (nskb)
>> +                       ret = (*xmit)(nskb, odev);
if (is_vlan_dev(odev) && pkt_dev->clone_skb) {
        nskb = skb_clone(pkt_dev->skb, GFP_ATOMIC);
        ret = -ENOMEM;
        if (nskb)
             ret = (*xmit)(nskb, odev);
}
>
and

case NETDEV_TX_LOCKED:
case NETDEV_TX_BUSY:
     /* Retry it next time */
     atomic_dec(&(pkt_dev->skb->users));
     if (is_vlan_dev(odev) && pkt_dev->clone_skb && nskb)
                 kfree_skb(nskb);
     else
                 atomic_dec(&(pkt_dev->skb->users));

is better, because is_vlan_dev(odev) is probably in  read most cache line.

Zhouyi
