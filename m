Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaEDWxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 18:53:37 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:39212 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaEDWxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 18:53:36 -0400
Date: Sun, 4 May 2014 15:53:31 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jon Maxwell <jmaxwell37@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, makita.toshiaki@lab.ntt.co.jp,
        vyasevic@redhat.com, bridge@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, pirko@redhat.com, jmaxwell@redhat.com
Subject: Re: [PATCH net] bridge: Add port flap detection
Message-ID: <20140504155331.13862a85@nehalam.linuxnetplumber.net>
In-Reply-To: <1399238974-6210-1-git-send-email-jmaxwell@redhat.com>
References: <1399238974-6210-1-git-send-email-jmaxwell@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 May 2014 07:29:34 +1000
Jon Maxwell <jmaxwell37@gmail.com> wrote:

> There has been a number incidents recently where customers running KVM have reported that VM hosts on different Hypervisors are unreachable. Based on pcap traces we found that the bridge was broadcasting the ARP request out onto the network. However some NICs have an inbuilt switch which on occasions were broadcasting the VMs ARP request back through the physical NIC on the Hypervisor. This resulted in the bridge flapping ports and incorrectly learning that the VMs mac address was external. As a result the ARP reply was directed back onto the external network and VM never updated it's ARP cache. This patch will detect port flapping and log a message so that this condition can be detected earlier.
> 
> Signed-off-by: Jon Maxwell <jmaxwell@redhat.com>
> ---
>  net/bridge/br_fdb.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 9203d5a..c08607b 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -507,6 +507,13 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>  					source->dev->name);
>  		} else {
>  			/* fastpath: update of existing entry */
> +			if (source->port_no != fdb->dst->port_no &&
> +				net_ratelimit())
> +				br_warn(br, "Port flapping detected source entry dev = %s mac = %pM, port_no = %d\n existing entry dev = %s mac = %pM, port_no = %d\n",
> +					source->dev->name,
> +					addr, source->port_no,
> +					fdb->dst->dev->name, addr,
> +					fdb->dst->port_no);
>  			fdb->dst = source;
>  			fdb->updated = jiffies;
>  			if (unlikely(added_by_user))

Ok, but please shorten the message to a single line without excess wordage.
Plus flapping to mean means link going up and down. Maybe use same message
as BSD?

