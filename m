Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbaCTWXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342AbaCTWXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:23:43 -0400
Message-ID: <532B6A3D.1060600@redhat.com>
Date: Thu, 20 Mar 2014 23:22:53 +0100
From: Thomas Graf <tgraf@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@citrix.com>, Jesse Gross <jesse@nicira.com>,
        pshelar@nicira.com, dev@openvswitch.org
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
        Miklos Szeredi <mszeredi@suse.cz>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy
 and handle errors
References: <1395331354-23659-1-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1395331354-23659-1-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 05:02 PM, Zoltan Kiss wrote:
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -464,7 +464,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>   	}
>   	nla->nla_len = nla_attr_size(skb->len);
>
> -	skb_zerocopy(user_skb, skb, skb->len, hlen);
> +	err = skb_zerocopy(user_skb, skb, skb->len, hlen);
> +	if (err)
> +		goto out;
>
>   	/* Pad OVS_PACKET_ATTR_PACKET if linear copy was performed */
>   	if (!(dp->user_features & OVS_DP_F_UNALIGNED)) {
> @@ -478,6 +480,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>
>   	err = genlmsg_unicast(ovs_dp_get_net(dp), user_skb, upcall_info->portid);
>   out:
> +	skb_tx_error(skb);

Really sorry to bug you again. We'll get this right ;-)

Patch looks great except for this call to skb_tx_error() which is now
done in the error *and* success path. Make the call conditional on
if (err) and we're good.
