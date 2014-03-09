Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaCIW4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 18:56:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36845 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaCIW4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 18:56:15 -0400
Date: Sun, 09 Mar 2014 18:56:14 -0400 (EDT)
Message-Id: <20140309.185614.1584225198974026118.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: hayeswang@realtek.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 10/13] r8152: support IPv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394394475.15968.25.camel@deadeye.wl.decadent.org.uk>
References: <1394002168-3193-1-git-send-email-hayeswang@realtek.com>
	<1394002168-3193-11-git-send-email-hayeswang@realtek.com>
	<1394394475.15968.25.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Mar 2014 15:56:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 09 Mar 2014 19:47:55 +0000

> On Wed, 2014-03-05 at 14:49 +0800, Hayes Wang wrote:
>> Support hw IPv6 checksum for TCP and UDP packets.
>> 
>> Note that the hw has the limitation of the range of the transport
>> offset. Besides, the TCP Pseudo Header of the IPv6 TSO of the hw
>> bases on the Microsoft document which excludes the packet length.
>> 
>> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
>> ---
>>  drivers/net/usb/r8152.c | 107 ++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 104 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
>> index 8f6d0f8..8e208f30 100644
>> --- a/drivers/net/usb/r8152.c
>> +++ b/drivers/net/usb/r8152.c
> [...]
>> +static int msdn_giant_send_check(struct sk_buff *skb)
>> +{
>> +	const struct ipv6hdr *ipv6h;
>> +	struct tcphdr *th;
>> +
>> +	ipv6h = ipv6_hdr(skb);
>> +	th = tcp_hdr(skb);
>> +
>> +	th->check = 0;
>> +	th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
> [...]
> 
> I think you need to call skb_cow_head() before editing the header here.

This made me notice that several drivers open-code this:

		if (skb_header_cloned(skb) &&
		    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
			goto drop;

If someone is looking for a quick cleanup, transforming these
to use skb_cow_head() would be nice.  That way other driver
authors will be less likely to copy the expanded code.
