Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3JaTql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:46:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7535 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab3JaTqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:46:40 -0400
X-IronPort-AV: E=Sophos;i="4.93,611,1378857600"; 
   d="scan'208";a="69492696"
Message-ID: <5272B39A.7060606@citrix.com>
Date: Thu, 31 Oct 2013 19:46:34 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: <ian.campbell@citrix.com>, <jonathan.davies@citrix.com>,
        <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH net-next RFC 3/5] xen-netback: Remove old
 TX grant copy definitons
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com> <1383094220-14775-4-git-send-email-zoltan.kiss@citrix.com> <5270E1F902000078000FDFCA@nat28.tlf.novell.com>
In-Reply-To: <5270E1F902000078000FDFCA@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/13 09:39, Jan Beulich wrote:
>>>> On 30.10.13 at 01:50, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>> These became obsolate with grant mapping.
>
> I didn't look at this in detail, but I'm surprised you can get away
> without any copying: For one, the header part needs copying
> anyway, so you'd pointlessly map and then copy it if it's small
> enough.
Yep, that's a further plan for optimization. I think I will add that as 
a separate patch to the series later. But that doesn't necessarily needs 
these definitions, let's see that later.

> And second you need to be prepared for the frontend
> to hand you more slots than you can fit in MAX_SKB_FRAGS
> (namely when MAX_SKB_FRAGS < XEN_NETIF_NR_SLOTS_MIN),
> which you can't handle with mapping alone afaict.
Oh, I was not aware of this problem. And indeed, the trivial solution is 
to keep the grant copy methods for such kind of packets, however that 
sounds quite nasty.
My another idea is to use skb_shinfo(skb)->frag_list for such packets, 
so the stack will see it as a fragmented IP packet. It might be less 
efficient than coalescing them into one skb during grant copy at first 
place, but probably a cleaner solution. If we don't care that much about 
the performance of such guests, it might be a better solution.
But I don't know that closely the IP fragmentation ideas, so it might be 
a bad idea. I'm happy to hear comments from people who have more 
experience with that.

Zoli
