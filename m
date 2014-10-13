Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaJMJqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:46:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaJMJqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:46:12 -0400
Message-ID: <543B9F5A.8070909@redhat.com>
Date: Mon, 13 Oct 2014 11:46:02 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH] ipv6: notify userspace when we added or changed an ipv6
 token
References: <1412950112-15593-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1412950112-15593-1-git-send-email-lkundrak@v3.sk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 04:08 PM, Lubomir Rintel wrote:
> NetworkManager might want to know that it changed when the router advertisement
> arrives.
>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Daniel Borkmann <dborkman@redhat.com>
> ---
>   net/ipv6/addrconf.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 3e118df..3d11390 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -4528,6 +4528,7 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
>   	}
>
>   	write_unlock_bh(&idev->lock);
> +	netdev_state_change(dev);

I'm wondering why netdev_state_change()? You are probably
only after the netlink notification that is being invoked,
i.e. rtmsg_ifinfo(RTM_NEWLINK, ...), and don't strictly want
to call the device notifier chain.

Perhaps it might be better to define a new RTM_SETTOKEN, and
just call inet6_ifinfo_notify(RTM_SETTOKEN, idev) as this is
only idev specific anyway?

>   	addrconf_verify_rtnl();
>   	return 0;
>   }
>
