Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbaCUKfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:35:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34385 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391AbaCUKfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:35:19 -0400
X-IronPort-AV: E=Sophos;i="4.97,703,1389744000"; 
   d="scan'208";a="112218793"
Message-ID: <532C15E1.4070501@citrix.com>
Date: Fri, 21 Mar 2014 10:35:13 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@redhat.com>, Jesse Gross <jesse@nicira.com>,
        <pshelar@nicira.com>, <dev@openvswitch.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Tom Herbert <therbert@google.com>, Jason Wang <jasowang@redhat.com>,
        Florian Westphal <fw@strlen.de>, Joe Perches <joe@perches.com>,
        Simon Horman <horms@verge.net.au>, Jiri Pirko <jiri@resnulli.us>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Miklos Szeredi <mszeredi@suse.cz>, <netfilter-devel@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v3] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy
 and handle errors
References: <1395331354-23659-1-git-send-email-zoltan.kiss@citrix.com> <532B6A3D.1060600@redhat.com>
In-Reply-To: <532B6A3D.1060600@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/14 22:22, Thomas Graf wrote:
> On 03/20/2014 05:02 PM, Zoltan Kiss wrote:
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -464,7 +464,9 @@ static int queue_userspace_packet(struct datapath
>> *dp, struct sk_buff *skb,
>>       }
>>       nla->nla_len = nla_attr_size(skb->len);
>>
>> -    skb_zerocopy(user_skb, skb, skb->len, hlen);
>> +    err = skb_zerocopy(user_skb, skb, skb->len, hlen);
>> +    if (err)
>> +        goto out;
>>
>>       /* Pad OVS_PACKET_ATTR_PACKET if linear copy was performed */
>>       if (!(dp->user_features & OVS_DP_F_UNALIGNED)) {
>> @@ -478,6 +480,7 @@ static int queue_userspace_packet(struct datapath
>> *dp, struct sk_buff *skb,
>>
>>       err = genlmsg_unicast(ovs_dp_get_net(dp), user_skb,
>> upcall_info->portid);
>>   out:
>> +    skb_tx_error(skb);
>
> Really sorry to bug you again. We'll get this right ;-)
>
> Patch looks great except for this call to skb_tx_error() which is now
> done in the error *and* success path. Make the call conditional on
> if (err) and we're good.
Ah, sorry, I'm really sloppy with this patch. I've sent a fixed one.

Zoli
