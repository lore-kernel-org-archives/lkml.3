Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3IXVIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:08:52 -0400
Received: from ja.ssi.bg ([178.16.129.10]:32933 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754302Ab3IXVIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:08:51 -0400
Date: Wed, 25 Sep 2013 00:13:57 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Vincent Li <vincent.mc.li@gmail.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] Allow userspace code to use flag IFA_F_SECONDARY to
 specify an ip address to be primary or secondary ip on an interface
In-Reply-To: <1380046281-6012-1-git-send-email-vincent.mc.li@gmail.com>
Message-ID: <alpine.LFD.2.00.1309242255350.1875@ja.ssi.bg>
References: <1380046281-6012-1-git-send-email-vincent.mc.li@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Tue, 24 Sep 2013, Vincent Li wrote:

> the current behavior is when an IP is added to an interface, the primary
> or secondary attributes is depending on the order of ip added to the interface
> the first IP will be primary and second, third,... or alias IP will be secondary
> if the IP subnet matches
> 
> this patch add the flexiblity to allow user to specify an argument 'primary' or 'secondary'
> (use 'ip addr add ip/mask primary|secondary dev ethX ' from iproute2 for example) to specify
> an IP address to be  primary or secondary.
> 
> the reason for this patch is that we have a multi blade cluster platform sharing 'floating management ip'
> and also that each blade has its own management ip on the management interface, so whichever blade in the
> cluster becomes primary blade, the 'floating mangaement ip' follows it, and we want any of our traffic
> originated from the primary blade source from the 'floating management ip' for consistency. but in this
> case, since the local blade management ip is always the primary ip on the mangaement interface and 'floating
> management ip' is always secondary, kernel always choose the primary ip as source ip address. thus we would
> like to add the flexibility in kernel to allow us to specify which ip to be primary or secondary.
> 
> Signed-off-by: Vincent Li <vincent.mc.li@gmail.com>
> ---
>  net/ipv4/devinet.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index a1b5bcb..bfc702a 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -440,9 +440,11 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
>  		return 0;
>  	}
>  
> -	ifa->ifa_flags &= ~IFA_F_SECONDARY;
>  	last_primary = &in_dev->ifa_list;
>  
> +	if((*last_primary) == NULL)
> +		ifa->ifa_flags &= ~IFA_F_SECONDARY;
> +
>  	for (ifap = &in_dev->ifa_list; (ifa1 = *ifap) != NULL;
>  	     ifap = &ifa1->ifa_next) {
>  		if (!(ifa1->ifa_flags & IFA_F_SECONDARY) &&
> @@ -458,7 +460,10 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
>  				inet_free_ifa(ifa);
>  				return -EINVAL;
>  			}
> -			ifa->ifa_flags |= IFA_F_SECONDARY;

	There is some confusion here, when ifa has 
IFA_F_SECONDARY bit set, in the 'else' we set it again.
I guess the 'else' part is not needed.

> +                        if (!(ifa->ifa_flags & IFA_F_SECONDARY))
> +                                ifa1->ifa_flags |= IFA_F_SECONDARY;
> +                        else
> +                                ifa->ifa_flags |= IFA_F_SECONDARY;

	It should not be so simple. You can not
just change the flag of existing address (ifa1) to secondary.
See __inet_del_ifa(), there are many more actions that
follow:

- kernel routes that use this primary address
should be deleted and recreated with the new primary
address as source. This includes local routes to secondary
IPs.

- RTM_NEWADDR should be sent, so that user space see
the IFA_F_SECONDARY flag

	Some questions:

- should we allow adding of secondary IPs when no primary
address exists for the subnet, it can happen when primary
for another subnet already exists

- by default, existing 'ip addr' binaries will provide
address without IFA_F_SECONDARY flag. Before now we added
such addresses as last for the subnet, now the
behaviour changes, we start to add addresses in reverse
order. Is that true? I.e. before now the operation was
APPEND, now we need a way to provide PREPEND operation.

Regards

--
Julian Anastasov <ja@ssi.bg>
