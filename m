Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaC3M2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 08:28:36 -0400
Received: from m13-61.163.com ([220.181.13.61]:35237 "EHLO m13-61.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaC3M2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:28:35 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Mar 2014 08:28:34 EDT
X-Originating-IP: [124.193.170.118]
Date: Sun, 30 Mar 2014 20:12:53 +0800 (CST)
From: "wei zhang" <asuka.com@163.com>
To: "Jesse Gross" <jesse@nicira.com>
Cc: "David Miller" <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] openvswitch: supply a dummy err_handler of
 gre_cisco_protocol to prevent kernel crash
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20131204(24406.5820.5783) Copyright (c) 2002-2014 www.mailtech.cn 163com
In-Reply-To: <CAEP_g=_qJ1uHKZmZdkUrT+NUkzbRgaHfShZoMbnnCb+LwjOneQ@mail.gmail.com>
References: <1395957398-24546-1-git-send-email-asuka.com@163.com>
 <CAEP_g=_qJ1uHKZmZdkUrT+NUkzbRgaHfShZoMbnnCb+LwjOneQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4fd27e6c.c96a.14512e82018.Coremail.asuka.com@163.com>
X-CM-TRANSID: PcGowABXEipGCjhTpg4EAA--.17378W
X-CM-SenderInfo: 5dvxytoofrzqqrwthudrp/1tbiMgpe1lD-rrw87AABsc
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2UCSrDJ020800

At 2014-03-29 06:02:25,"Jesse Gross" <jesse@nicira.com> wrote:

>I'm not sure that rejecting all ICMP packets is the correct thing do
>here since it means that we could pass them onto a later caller even
>though they are intended for us. We should probably use the same logic
>as for receiving packets and just discard them here.

Thank you very much for your advice, did you mean this logic? Â 

diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
index a3d6951..c183a56 100644
--- a/net/openvswitch/vport-gre.c
+++ b/net/openvswitch/vport-gre.c
@@ -110,6 +110,21 @@ static int gre_rcv(struct sk_buff *skb,
Â  Â  Â  Â  return PACKET_RCVD;
Â }
Â 
+/* Called with rcu_read_lock and BH disabled. */
+static int gre_err(struct sk_buff *skb, u32 info,
+ Â  Â  Â  Â  Â  Â  Â  Â  Â const struct tnl_ptk_info *tpi)
+{
+ Â  Â  Â  struct ovs_net *ovs_net;
+ Â  Â  Â  struct vport *vport;
+
+ Â  Â  Â  ovs_net = net_generic(dev_net(skb->dev), ovs_net_id);
+ Â  Â  Â  vport = rcu_dereference(ovs_net->vport_net.gre_vport);
+ Â  Â  Â  if (unlikely(!vport))
+ Â  Â  Â  Â  Â  Â  Â  return PACKET_REJECT;
+ Â  Â  Â  else
+ Â  Â  Â  Â  Â  Â  Â  return PACKET_RCVD;
+}

Maybe I misunderstand something? I think if we discard all packet pass to us
when we use gre vport, new gre_cisco_protocol which has lower priority could
not see the packetÂ intended to it.

I checked the implementation of the ipgre_err(), which has be called before
the err_handler of gre vport. It use theÂ the (local address, remote address, key)
to distinguish the packet whichÂ is realy intended to it,Â although it could not 
always get the key from the icmpÂ packet. Should we do as the same as it?
I'm not sure this is feasible, any advice is appreciate.

Regards,
Wei Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
