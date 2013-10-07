Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab3JGR7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:59:41 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:52330 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3JGR7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:59:39 -0400
MIME-Version: 1.0
In-Reply-To: <20131007020218.GF9295@order.stressinduktion.org>
References: <1380880333-3546-1-git-send-email-ou.ghorbel@gmail.com>
	<20131005140636.GA25076@order.stressinduktion.org>
	<CABfLueFYZkzpEpDJ7YcHJaXfm-=QcgnL3-Es8gybea2cAacQQw@mail.gmail.com>
	<20131006151351.GB9295@order.stressinduktion.org>
	<CABfLueGefWM6m6h44yAMBo7=BMUcA=OvcFVYka06QvsxXUAJtw@mail.gmail.com>
	<20131006161910.GC9295@order.stressinduktion.org>
	<CABfLueGW34XnTEJWsb5FA=pWfwwKqTTj31xCZyr78CNtTZWx6Q@mail.gmail.com>
	<20131007020218.GF9295@order.stressinduktion.org>
Date: Mon, 7 Oct 2013 18:59:39 +0100
Message-ID: <CABfLueEhNN4oCChP9N92r=NAfiNvOX3ihvitRfNPrYFhfGebvQ@mail.gmail.com>
Subject: Re: [PATCH] Fix the upper MTU limit in ipv6 GRE tunnel
From: Oussama Ghorbel <ou.ghorbel@gmail.com>
To: Oussama Ghorbel <ou.ghorbel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 3:02 AM, Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> On Sun, Oct 06, 2013 at 08:18:15PM +0100, Oussama Ghorbel wrote:
>> Yes, to summarize, the idea of this patch was to fix the incoherence
>> in the condition of ip6gre_tunnel_change_mtu function
>>
>>   if (new_mtu < 68 ||
>>    new_mtu > 0xFFF8 - dev->hard_header_len - tunnel->hlen)
>>
>> From the ip6gre_tnl_link_config function we can see that:
>> The variable addend is equal the ipv6 header + gre header (including
>> the gre options)
>> On the other hand hard_header_len equal to the header of the lower
>> layer + addend.
>> So the quantity - (dev->hard_header_len + tunnel->hlen) equals - (eth
>> header + ipv6 header + gre header + ipv6 header + gre header) which by
>> no means this would represent anything!  (I've just taken ipv6 over
>> ethernet as example)
>>
>> As we have seen there is another approach to fix this issue is to
>> re-factor the hlen to hold only the length of gre as it's done for
>> ipv4 gre, however the solution provided in the patch seems to be
>> regression risk-less.
>
> I agree, it actually does not worsen the situation:
>
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
>
>> Although the value hold by hlen is not coherent with the variable name
>> nor with ipv4, I think there is an advantage of the current approach
>> of ipv6 hlen over ipv4 hlen, because we save the calculation of ipv6
>> header each time. Ex:
>> In ipv4 gre and in the function ipgre_header:
>> iph = (struct iphdr *)skb_push(skb, t->hlen + sizeof(*iph));
>> In ipv6 and in the function ip6gre_header
>> ipv6h = (struct ipv6hdr *)skb_push(skb, t->hlen);
>
> I see your point. But we should take care that t->hlen is always initialized,
> regardless if we got a route and outgoing device or not.
>

OK, I'll investigate on this and I'll open a dedicated thread mail/send patch...

> Greetings,
>
>   Hannes
>
Thanks,
Oussama
