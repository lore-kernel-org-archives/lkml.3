Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaCGQX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:23:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbaCGQXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:23:24 -0500
Message-ID: <5319F272.1070101@redhat.com>
Date: Fri, 07 Mar 2014 17:23:14 +0100
From: Thomas Graf <tgraf@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@citrix.com>, Jesse Gross <jesse@nicira.com>,
        pshelar@nicira.com, dev@openvswitch.org
CC: xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace
 via Netlink to avoid guest stall
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 08:16 PM, Zoltan Kiss wrote:
> The kernel datapath now switched to zerocopy Netlink messages, but that also
> means that the pages on frags array are sent straight to userspace. If those
> pages came outside the kernel, we have to swap them out with local copies.
>
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> ---
>   net/openvswitch/datapath.c |    6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 36f8872..ffb563c 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -464,6 +464,12 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>   	}
>   	nla->nla_len = nla_attr_size(skb->len);
>
> +	if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC))) {
> +		err = -ENOMEM;
> +		skb_tx_error(skb);
> +		goto out;
> +	}
> +
>   	skb_zerocopy(user_skb, skb, skb->len, hlen);
>
>   	/* Pad OVS_PACKET_ATTR_PACKET if linear copy was performed */

How about we move the call to skb_orphan_frags() into skb_zerocopy()
itself and call it before we actually reference the frags?

It's not just OVS affected but nfqueue as well.
