Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaDEEVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 00:21:04 -0400
Received: from m13-72.163.com ([220.181.13.72]:47186 "EHLO m13-72.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbaDEEVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 00:21:02 -0400
X-Originating-IP: [124.193.170.118]
Date: Sat, 5 Apr 2014 12:20:27 +0800 (CST)
From: "wei zhang" <asuka.com@163.com>
To: "Jesse Gross" <jesse@nicira.com>
Cc: "David Miller" <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] openvswitch: supply a dummy err_handler of
 gre_cisco_protocol to prevent kernel crash
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20131204(24406.5820.5783) Copyright (c) 2002-2014 www.mailtech.cn 163com
In-Reply-To: <CAEP_g=9WRyaSmRKHDZmWXwzjDyex8NheyveGzfH4qmMbhgGHdQ@mail.gmail.com>
References: <1396398194-4163-1-git-send-email-asuka.com@163.com>
 <CAEP_g=9WRyaSmRKHDZmWXwzjDyex8NheyveGzfH4qmMbhgGHdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <158dbf4d.1b3c.145301dbf7a.Coremail.asuka.com@163.com>
X-CM-TRANSID: SMGowACXDjWMhD9Tdy4MAA--.5430W
X-CM-SenderInfo: 5dvxytoofrzqqrwthudrp/1tbiMhZk1lD-r0lyagABsG
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s354LNXE028159

At 2014-04-05 07:05:59,"Jesse Gross" <jesse@nicira.com> wrote:
>On Tue, Apr 1, 2014 at 5:23 PM, Wei Zhang <asuka.com@163.com> wrote:
>>
>> v2 -> v1: use the same logic of the gre_rcv() to distinguish which packet is
>> intended to us!
>
>As a tip on kernel process: if you put the version information after
>three dashes below the signed-off-by line then git will automatically
>remove it when the final patch is applied.

Thanks, should I modify it and send a v3 patch?

>
>> diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
>> index a3d6951..f391df1 100644
>> --- a/net/openvswitch/vport-gre.c
>> +++ b/net/openvswitch/vport-gre.c
>> @@ -110,6 +110,21 @@ static int gre_rcv(struct sk_buff *skb,
>>         return PACKET_RCVD;
>>  }
>>
>> +/* Called with rcu_read_lock and BH disabled. */
>> +static int gre_err(struct sk_buff *skb, u32 info,
>> +                  const struct tnl_ptk_info *tpi)
>> +{
>> +       struct ovs_net *ovs_net;
>> +       struct vport *vport;
>> +
>> +       ovs_net = net_generic(dev_net(skb->dev), ovs_net_id);
>> +       vport = rcu_dereference(ovs_net->vport_net.gre_vport);
>> +       if (unlikely(!vport))
>> +               return PACKET_REJECT;
>> +       else
>> +               return PACKET_RCVD;
>
>Sorry, I forgot to say this before - if we receive the packet then we
>should also call consume_skb() on it.

Maybe there is no need to call consume_skb()? The icmp_rcv() would
call kfree_skb() for us. I also checked the ipgre_err(), it return 
PACKET_RCVD without call consume_skb() too.

Regards,
Wei Zhang���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
