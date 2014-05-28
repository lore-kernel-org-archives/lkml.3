Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaE1OTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:19:55 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:52935 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaE1OTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:19:52 -0400
Message-ID: <5385F089.9080608@cogentembedded.com>
Date: Wed, 28 May 2014 18:19:53 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jon Maxwell <jmaxwell37@gmail.com>, stephen@networkplumber.org
CC: davem@davemloft.net, makita.toshiaki@lab.ntt.co.jp, vyasevic@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com, jmaxwell@redhat.com
Subject: Re: [PATCH net] bridge: notify user space after fdb update
References: <1401230749-19507-1-git-send-email-jmaxwell37@gmail.com>
In-Reply-To: <1401230749-19507-1-git-send-email-jmaxwell37@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/28/2014 02:45 AM, Jon Maxwell wrote:

> There has been a number incidents recently where customers running KVM have
> reported that VM hosts on different Hypervisors are unreachable. Based on
> pcap traces we found that the bridge was broadcasting the ARP request out
> onto the network. However some NICs have an inbuilt switch which on occasions
> were broadcasting the VMs ARP request back through the physical NIC on the
> Hypervisor. This resulted in the bridge changing ports and incorrectly learning
> that the VMs mac address was external. As a result the ARP reply was directed
> back onto the external network and VM never updated it's ARP cache. This patch
> will notify the bridge command, after a fdb has been updated to identify such
> port toggling.

> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> ---
>   net/bridge/br_fdb.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)

> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 9203d5a..f3ee2da 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -487,6 +487,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>   {
>   	struct hlist_head *head = &br->hash[br_mac_hash(addr, vid)];
>   	struct net_bridge_fdb_entry *fdb;
> +	bool fdb_modified = 0;

    s/0/false/.

>
>   	/* some users want to always flood. */
>   	if (hold_time(br) == 0)
> @@ -507,10 +508,15 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>   					source->dev->name);
>   		} else {
>   			/* fastpath: update of existing entry */
> -			fdb->dst = source;
> +			if (unlikely(source != fdb->dst)) {
> +					fdb->dst = source;
> +					fdb_modified = 1;

   s/1/true/.

> +				}
>   			fdb->updated = jiffies;
>   			if (unlikely(added_by_user))
>   				fdb->added_by_user = 1;
> +			if (unlikely(fdb_modified))
> +				fdb_notify(br, fdb, RTM_NEWNEIGH);
>   		}
>   	} else {
>   		spin_lock(&br->hash_lock);

WBR, Sergei


