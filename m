Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab3CSJZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab3CSJZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:25:51 -0400
Message-ID: <51482F14.9030407@redhat.com>
Date: Tue, 19 Mar 2013 17:25:40 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next 1/2] net_sched: don't do precise pkt_len computation
 for untrusted packets
References: <1363333305-54398-1-git-send-email-jasowang@redhat.com> <20130317.121026.733329595817911776.davem@davemloft.net>
In-Reply-To: <20130317.121026.733329595817911776.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 12:10 AM, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Fri, 15 Mar 2013 15:41:44 +0800
>
>> Commit 1def9238d4aa2 (net_sched: more precise pkt_len computation) tries to do
>> precise packet len computation for GSO packets, but it does not check whether
>> the packets were from untrusted source. This is wrong since: we haven't done
>> header check before so both gso_segs and headers may not be correct. So this
>> patch just bypass the precise pkt_len computation for packet from untrusted
>> source (SKB_GSO_DODGY).
>>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> I do not think this is appropriate or even necessary.
>
> All the user can do by reporting an incorrect header size or GSO segs
> is hurt himself, by making his traffic take more packet scheduler
> quota.

I believe before doing header check for untrusted packets, the only
thing we can trust is skb->len and that's we've used before
1def9238d4aa2. But after that, we're trying to use unchecked or
meaningless value (e.g gso_segs were reset to zero in
tun/macvtap/packet), and guest then can utilize this to result a very
huge (-1U) pkt_len by filling evil value in the header. Can all kinds of
packet scheduler survive this kinds of possible DOS?
>
> When we do precise accounting, it increases, never decreases, the
> amount that a packet "costs" as far as the packet scheduler is
> concerned.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

