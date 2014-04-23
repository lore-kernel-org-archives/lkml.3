Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaDWMer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:34:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:14287 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaDWMen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:34:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,911,1389744000"; 
   d="scan'208";a="122654571"
Message-ID: <5357B342.9090204@citrix.com>
Date: Wed, 23 Apr 2014 13:34:10 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Luis Henriques <luis.henriques@canonical.com>,
        David Miller <davem@davemloft.net>, <jesse@nicira.com>,
        <pshelar@nicira.com>, <tgraf@redhat.com>, <dev@openvswitch.org>,
        <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>,
        <edumazet@google.com>, <dborkman@redhat.com>, <therbert@google.com>,
        <jasowang@redhat.com>, <fw@strlen.de>, <joe@perches.com>,
        <horms@verge.net.au>, <jiri@resnulli.us>, <mst@redhat.com>,
        <Paul.Durrant@citrix.com>, <JBeulich@suse.com>,
        <herbert@gondor.apana.org.au>, <mszeredi@suse.cz>,
        <netfilter-devel@vger.kernel.org>, <netfilter@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 3.13] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy
 and handle errors
References: <1395873465-22282-1-git-send-email-zoltan.kiss@citrix.com>		 <20140327.152956.1528740039185894234.davem@davemloft.net>		 <20140421112601.GC3200@hercules>	 <1398181118.3624.203.camel@deadeye.wl.decadent.org.uk>	 <5356AEBF.5010505@citrix.com> <1398194284.7767.101.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1398194284.7767.101.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/14 20:18, Ben Hutchings wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
>
> commit 36d5fe6a000790f56039afe26834265db0a3ad4c upstream.
>
> skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
> orphan them. Also, it doesn't handle errors, so this patch takes care of that
> as well, and modify the callers accordingly. skb_tx_error() is also added to
> the callers so they will signal the failed delivery towards the creator of the
> skb.
>
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [bwh: Backported to 3.13: skb_zerocopy() is new in 3.14, but was moved from a
>   static function in nfnetlink_queue.  We need to patch that and its caller, but
>   not openvswitch.]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> On Tue, 2014-04-22 at 19:02 +0100, Zoltan Kiss wrote:
>> On 22/04/14 16:38, Ben Hutchings wrote:
>>> On Mon, 2014-04-21 at 12:26 +0100, Luis Henriques wrote:
>>>> Hi David,
>>>>
>>>> On Thu, Mar 27, 2014 at 03:29:56PM -0400, David Miller wrote:
>>>>> From: Zoltan Kiss <zoltan.kiss@citrix.com>
>>>>> Date: Wed, 26 Mar 2014 22:37:45 +0000
>>>>>
>>>>>> skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
>>>>>> orphan them. Also, it doesn't handle errors, so this patch takes care of that
>>>>>> as well, and modify the callers accordingly. skb_tx_error() is also added to
>>>>>> the callers so they will signal the failed delivery towards the creator of the
>>>>>> skb.
>>>>>>
>>>>>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>>>>>
>>>>> Fingers crossed :-)  Applied, thanks Zoltan.
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>> Could you please queue this for stable as well?  It has CVE-2014-2568
>>>> assigned to it and I believe it is applicable to some of the trees.
>>>
>>> It was applied to 3.13, but needs backporting to earlier versions.  I
>>> posted my attempt in
>>> <1397429860.10849.86.camel@deadeye.wl.decadent.org.uk> but it needs
>>> testing/reviewing.
>>
>> This one is a different issue, although it is very similar.
>
> Sorry for mixing these up.  I believe this bug has been present since
> zerocopy was added to nfqueue in Linux 3.10 (commit ae08ce002108).  This
> is the version I used for Debian's 3.13 branch, which might be usable
> for older stable branches too.
Seems OK, thanks!

>
> Ben.
>
> ---
> --- a/net/netfilter/nfnetlink_queue_core.c
> +++ b/net/netfilter/nfnetlink_queue_core.c
> @@ -235,22 +235,23 @@ nfqnl_flush(struct nfqnl_instance *queue
>   	spin_unlock_bh(&queue->lock);
>   }
>
> -static void
> +static int
>   nfqnl_zcopy(struct sk_buff *to, const struct sk_buff *from, int len, int hlen)
>   {
>   	int i, j = 0;
>   	int plen = 0; /* length of skb->head fragment */
> +	int ret;
>   	struct page *page;
>   	unsigned int offset;
>
>   	/* dont bother with small payloads */
> -	if (len <= skb_tailroom(to)) {
> -		skb_copy_bits(from, 0, skb_put(to, len), len);
> -		return;
> -	}
> +	if (len <= skb_tailroom(to))
> +		return skb_copy_bits(from, 0, skb_put(to, len), len);
>
>   	if (hlen) {
> -		skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
> +		ret = skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
> +		if (unlikely(ret))
> +			return ret;
>   		len -= hlen;
>   	} else {
>   		plen = min_t(int, skb_headlen(from), len);
> @@ -268,6 +269,11 @@ nfqnl_zcopy(struct sk_buff *to, const st
>   	to->len += len + plen;
>   	to->data_len += len + plen;
>
> +	if (unlikely(skb_orphan_frags(from, GFP_ATOMIC))) {
> +		skb_tx_error(from);
> +		return -ENOMEM;
> +	}
> +
>   	for (i = 0; i < skb_shinfo(from)->nr_frags; i++) {
>   		if (!len)
>   			break;
> @@ -278,6 +284,8 @@ nfqnl_zcopy(struct sk_buff *to, const st
>   		j++;
>   	}
>   	skb_shinfo(to)->nr_frags = j;
> +
> +	return 0;
>   }
>
>   static int
> @@ -374,13 +382,16 @@ nfqnl_build_packet_message(struct net *n
>
>   	skb = nfnetlink_alloc_skb(net, size, queue->peer_portid,
>   				  GFP_ATOMIC);
> -	if (!skb)
> +	if (!skb) {
> +		skb_tx_error(entskb);
>   		return NULL;
> +	}
>
>   	nlh = nlmsg_put(skb, 0, 0,
>   			NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_PACKET,
>   			sizeof(struct nfgenmsg), 0);
>   	if (!nlh) {
> +		skb_tx_error(entskb);
>   		kfree_skb(skb);
>   		return NULL;
>   	}
> @@ -504,13 +515,15 @@ nfqnl_build_packet_message(struct net *n
>   		nla->nla_type = NFQA_PAYLOAD;
>   		nla->nla_len = nla_attr_size(data_len);
>
> -		nfqnl_zcopy(skb, entskb, data_len, hlen);
> +		if (nfqnl_zcopy(skb, entskb, data_len, hlen))
> +			goto nla_put_failure;
>   	}
>
>   	nlh->nlmsg_len = skb->len;
>   	return skb;
>
>   nla_put_failure:
> +	skb_tx_error(entskb);
>   	kfree_skb(skb);
>   	net_err_ratelimited("nf_queue: error creating packet message\n");
>   	return NULL;
>

