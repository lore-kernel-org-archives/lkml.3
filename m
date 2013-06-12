Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3FLN4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:56:37 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34868 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3FLN4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:56:35 -0400
Message-ID: <51B87E0D.8040009@cogentembedded.com>
Date: Wed, 12 Jun 2013 17:56:29 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roprabhu@cisco.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] macvlan: don't touch promisc without passthrough
References: <1371035949-29471-1-git-send-email-mst@redhat.com>
In-Reply-To: <1371035949-29471-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-06-2013 15:34, Michael S. Tsirkin wrote:

> commit df8ef8f3aaa6692970a436204c4429210addb23a in linux 3.5 added a way

    Please also specify that commit's summary line in parens.

> to control NOPROMISC macvlan flag through netlink.

> However, with a non passthrough device we don't set promisc on open or
> clear it on stop, even if NOPROMISC is off.  As a result:

> If userspace clears NOPROMISC on open, then does not clear it on a
> netlink command, promisc counter is not decremented on stop and there
> will be no way to clear it once macvlan is detached.

> If userspace does not clear NOPROMISC on open, then sets NOPROMISC on a
> netlink command, promisc counter will be decremented from 0 and overflow
> to fffffffff with no way to clear promisc afterwards.

> To fix, simply ignore NOPROMISC flag in a netlink command for
> non-passthrough devices, same as we do at open/stop.

> While at it - since we touch this code anyway - check
> dev_set_promiscuity return code and pass it to users (though an error
> here is unlikely).

> Cc: "David S. Miller" <davem@davemloft.net>
> CC: Roopa Prabhu <roprabhu@cisco.com>
> Cc: John Fastabend <john.r.fastabend@intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

> Please review, and consider for 3.10 and -stable.

>   drivers/net/macvlan.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)

> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index 1c502bb..8812402 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -853,18 +853,23 @@ static int macvlan_changelink(struct net_device *dev,
>   		struct nlattr *tb[], struct nlattr *data[])
>   {
>   	struct macvlan_dev *vlan = netdev_priv(dev);
> -	if (data && data[IFLA_MACVLAN_MODE])
> -		vlan->mode = nla_get_u32(data[IFLA_MACVLAN_MODE]);
> +
>   	if (data && data[IFLA_MACVLAN_FLAGS]) {
>   		__u16 flags = nla_get_u16(data[IFLA_MACVLAN_FLAGS]);
>   		bool promisc = (flags ^ vlan->flags) & MACVLAN_FLAG_NOPROMISC;
> -
> -		if (promisc && (flags & MACVLAN_FLAG_NOPROMISC))
> -			dev_set_promiscuity(vlan->lowerdev, -1);
> -		else if (promisc && !(flags & MACVLAN_FLAG_NOPROMISC))
> -			dev_set_promiscuity(vlan->lowerdev, 1);
> +		if (vlan->port->passthru && promisc) {
> +			int err;

    Emoty line, like you did abobe, wouldn't hurt here, after declaration.

> +			if (flags & MACVLAN_FLAG_NOPROMISC)
> +				err = dev_set_promiscuity(vlan->lowerdev, -1);
> +			else
> +				err = dev_set_promiscuity(vlan->lowerdev, 1);
> +			if (err < 0)
> +				return err;
> +		}

WBR, Sergei

