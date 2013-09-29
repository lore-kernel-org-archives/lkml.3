Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3I2JkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 05:40:16 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:54770 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3I2JkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 05:40:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130927170345.GC10343@order.stressinduktion.org>
References: <1380207108-20030-1-git-send-email-oghorbell@gmail.com>
	<20130927083730.GC28287@order.stressinduktion.org>
	<CA+ev270=P9txSvo7AZN0YcsopwhCYtJCgcZCPsdofEJ+BX+EUQ@mail.gmail.com>
	<20130927105856.GF28287@order.stressinduktion.org>
	<CA+ev272+Gp6Kt7S8P-wXxPBh0D8Di9WVH9NDi41HpNakLKC4Dw@mail.gmail.com>
	<20130927170345.GC10343@order.stressinduktion.org>
Date: Sun, 29 Sep 2013 10:40:11 +0100
Message-ID: <CA+ev270d2Ztq9i34Lv9U15y1TbH7W-fioXFn-Q_sJd5F4biHuw@mail.gmail.com>
Subject: Re: [PATCH] IPv6: Allow the MTU of ipip6 tunnel to be set below 1280
From: Oussama Ghorbel <oghorbell@gmail.com>
To: Oussama Ghorbel <oghorbell@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ou.ghorbel@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 6:03 PM, Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> On Fri, Sep 27, 2013 at 05:36:45PM +0100, Oussama Ghorbel wrote:
>> Please see my comments below
>>
>> Regards,
>> Oussama
>>
>> On Fri, Sep 27, 2013 at 11:58 AM, Hannes Frederic Sowa
>> <hannes@stressinduktion.org> wrote:
>> > On Fri, Sep 27, 2013 at 11:45:48AM +0100, Oussama Ghorbel wrote:
>> >> The ip6_tunnel.c module would be then dependent on ip_tunnel.c and may
>> >> be it would not be good thing?
>> >
>> > It could just be a static inline in some shared header. So there would
>> > be no compile-time dependency.
>> >
>>
>> The higher limit of mtu in ip_tunnel_change_mtu() is a calculated value.
>> This high limit is calculated using the netdev priv struct ip_tunnel
>> (field hlen).
>> This netdev priv struct is different in ipv6, it's a ip6_tnl struct.
>> Therefore implementing a beautiful function like
>> ip_tunnel_valid_mtu(struct net_device *dev, int mtu) won't be
>> feasible, unless we implement it in macro or something like like
>> ip_tunnel_valid_mtu(struct net_device *dev, int hlen, int mtu) which
>> seems not very nice ...
>> What do yo think?
>
> Ok, let's go with one function per protocol type. Seems easier.
>
> It seems to get more hairy, because it depends on the tunnel driver if the
> prepended ip header is accounted in hard_header_len. :/
>
> I don't know if it works out cleanly. Otherwise I would be ok if the checks
> just get repeated in ip6_tunnel and leave the rest as-is.
>
Yes, It will be the clean way to do it.
>>
>> >> As I have check in v3.10 there is no call from ip6_tunnel to ip_tunnel...
>> >>
>> >> For information, there is no check for the maximum MTU for ipv4 in the
>> >> patch as this is not done for ipv6.
>> >
>> > I understand, but it would be better to limit the MTU here. There is a
>> > (non-jumo) IPV6_MAXPLEN constant.
>> >
>> > Looking through the source it seems grev6 does actually check this,
>> > so it would not hurt adding them here, too.
>>
>> what if jumbograms is used, in that case, we can't use IPV6_MAXPLEN.
>> the limit would be the the full unsigned int.
>> However checking the higher limit for ipv4 would be useful.
>
> Linux currently cannot create "jumbograms" (only the receiving side
> is supported).
>
I understand, but what are the benefit from this limit or the harm
from not specifying it?
Please check this comment from eth.c

/**
 * eth_change_mtu - set new MTU size
 * @dev: network device
 * @new_mtu: new Maximum Transfer Unit
 *
 * Allow changing MTU size. Needs to be overridden for devices
 * supporting jumbo frames.
 */
int eth_change_mtu(struct net_device *dev, int new_mtu)

So wouldn't be a good idea to let our function open for jumbo frames...?

>> Please also note in case the tunnel mode is any (ipv4 or ipv6 means
>> ip6_tnl.parms.proto = 0), then we will be required to take the most
>> restrict limit from both ipv4 and ipv6 which means the lower limit
>> will be 1280 and the higher limit will be about 65535
>> Do you agree on this?
>
> Agreed, this would be needed for e.g. the sit driver, which now can
> handle both protocols.
>
> Thanks,
>
>   Hannes
>

Thanks,
Oussama
