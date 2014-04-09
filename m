Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaDIAqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:46:24 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:47213 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756235AbaDIAqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:46:22 -0400
MIME-Version: 1.0
In-Reply-To: <158dbf4d.1b3c.145301dbf7a.Coremail.asuka.com@163.com>
References: <1396398194-4163-1-git-send-email-asuka.com@163.com>
 <CAEP_g=9WRyaSmRKHDZmWXwzjDyex8NheyveGzfH4qmMbhgGHdQ@mail.gmail.com> <158dbf4d.1b3c.145301dbf7a.Coremail.asuka.com@163.com>
From: Jesse Gross <jesse@nicira.com>
Date: Tue, 8 Apr 2014 17:46:00 -0700
Message-ID: <CAEP_g=8VE8KWu8CqTNeub8rTwiVZD-SWGDr9mZzgAZ-0-T2AMQ@mail.gmail.com>
Subject: Re: [PATCH v2] openvswitch: supply a dummy err_handler of
 gre_cisco_protocol to prevent kernel crash
To: wei zhang <asuka.com@163.com>
Cc: David Miller <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 9:20 PM, wei zhang <asuka.com@163.com> wrote:
> At 2014-04-05 07:05:59,"Jesse Gross" <jesse@nicira.com> wrote:
>>On Tue, Apr 1, 2014 at 5:23 PM, Wei Zhang <asuka.com@163.com> wrote:
>>>
>>> v2 -> v1: use the same logic of the gre_rcv() to distinguish which packet is
>>> intended to us!
>>
>>As a tip on kernel process: if you put the version information after
>>three dashes below the signed-off-by line then git will automatically
>>remove it when the final patch is applied.
>
> Thanks, should I modify it and send a v3 patch?
>
>>
>>> diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
>>> index a3d6951..f391df1 100644
>>> --- a/net/openvswitch/vport-gre.c
>>> +++ b/net/openvswitch/vport-gre.c
>>> @@ -110,6 +110,21 @@ static int gre_rcv(struct sk_buff *skb,
>>>         return PACKET_RCVD;
>>>  }
>>>
>>> +/* Called with rcu_read_lock and BH disabled. */
>>> +static int gre_err(struct sk_buff *skb, u32 info,
>>> +                  const struct tnl_ptk_info *tpi)
>>> +{
>>> +       struct ovs_net *ovs_net;
>>> +       struct vport *vport;
>>> +
>>> +       ovs_net = net_generic(dev_net(skb->dev), ovs_net_id);
>>> +       vport = rcu_dereference(ovs_net->vport_net.gre_vport);
>>> +       if (unlikely(!vport))
>>> +               return PACKET_REJECT;
>>> +       else
>>> +               return PACKET_RCVD;
>>
>>Sorry, I forgot to say this before - if we receive the packet then we
>>should also call consume_skb() on it.
>
> Maybe there is no need to call consume_skb()? The icmp_rcv() would
> call kfree_skb() for us. I also checked the ipgre_err(), it return
> PACKET_RCVD without call consume_skb() too.

Thanks, you are right. I applied your patch as is.
