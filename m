Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaHDMlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:41:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaHDMlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:41:08 -0400
Date: Mon, 4 Aug 2014 14:40:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: lichunhe@huawei.com
Cc: vyasevic@redhat.com, xiyou.wangcong@gmail.com,
        makita.toshiaki@lab.ntt.co.jp, stephen@networkplumber.org,
        ebiederm@xmission.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org, wuyunfei@huawei.com,
        qianhuibin@huawei.com
Subject: Re: [PATCH net/next] bridge:Add rcu read lock when delete br port
Message-ID: <20140804124056.GD15491@redhat.com>
References: <1407123476-9720-1-git-send-email-lichunhe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407123476-9720-1-git-send-email-lichunhe@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 11:37:56AM +0800, lichunhe@huawei.com wrote:
> From: Chunhe Li <lichunhe@huawei.com>
> 
> In the br_hanle_frame function has a bug, when the bridge receive packets
> which go througth the br_handle_frame, get the net_bridge_port pointer "p",
> but don't check NULL pointer to use it. If somebody delete the bridge port
> at the same time, will call a NULL pointer, trigger kernel panic. I see the
> del_nbp comments, call del_nbp should via RCU, but the caller don't do this.

I don't see such a comment there.

Are you talking about this line:
        p = br_port_get_rcu(skb->dev);

this is actually rx_handler_data.
The reason it should not be NULL is
explained here:

void netdev_rx_handler_unregister(struct net_device *dev)
{

        ASSERT_RTNL();
        RCU_INIT_POINTER(dev->rx_handler, NULL);
        /* a reader seeing a non NULL rx_handler in a rcu_read_lock()
         * section has a guarantee to see a non NULL rx_handler_data
         * as well.
         */
        synchronize_net();
        RCU_INIT_POINTER(dev->rx_handler_data, NULL);
}
EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);



> following steps will make bug happened
> 1.start vm and add the vm interface to a bridge br0,for example,
> brctl addbr br0 tap0
> 
> 2.configuer vm interface and br0 same ip subnet, vm ping br0.
> 
> 3.add and delete the vm interface port for endless loop.
> 
> Signed-off-by: Chunhe Li <lichunhe@huawei.com>

OK but apparently something else triggered the bug here.
It might be a good idea to enable lockdep and rcu checks
see if anything suspicious is reported.


> ---
>  net/bridge/br_if.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index 3eca3fd..91c611d 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -274,9 +274,11 @@ void br_dev_delete(struct net_device *dev, struct list_head *head)
>  	struct net_bridge *br = netdev_priv(dev);
>  	struct net_bridge_port *p, *n;
>  
> +	rcu_read_lock();
>  	list_for_each_entry_safe(p, n, &br->port_list, list) {
>  		del_nbp(p);
>  	}
> +	rcu_read_unlock();
>  
>  	br_fdb_delete_by_port(br, NULL, 1);
>  
> @@ -550,7 +552,9 @@ int br_del_if(struct net_bridge *br, struct net_device *dev)
>  	 * there still maybe an alternate path for netconsole to use;
>  	 * therefore there is no reason for a NETDEV_RELEASE event.
>  	 */
> +	rcu_read_lock();
>  	del_nbp(p);
> +	rcu_read_unlock();
>  
>  	spin_lock_bh(&br->lock);
>  	changed_addr = br_stp_recalculate_bridge_id(br);


Does the problem disappear with this applied?
I don't see how this would help. rcu locks do not synchronize
against other readers.


> -- 
> 1.9.2.0
> 
