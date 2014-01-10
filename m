Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaAJSYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:24:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41559 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906AbaAJSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:24:31 -0500
Date: Fri, 10 Jan 2014 13:24:28 -0500 (EST)
Message-Id: <20140110.132428.2182820842932734377.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com,
        e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH net V3 2/2] net: core: explicitly select a txq before
 doing l2 forwarding
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389341906-2367-2-git-send-email-jasowang@redhat.com>
References: <1389341906-2367-1-git-send-email-jasowang@redhat.com>
	<1389341906-2367-2-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 10 Jan 2014 16:18:26 +0800

> Currently, the tx queue were selected implicitly in ndo_dfwd_start_xmit(). The
> will cause several issues:
> 
> - NETIF_F_LLTX were removed for macvlan, so txq lock were done for macvlan
>   instead of lower device which misses the necessary txq synchronization for
>   lower device such as txq stopping or frozen required by dev watchdog or
>   control path.
> - dev_hard_start_xmit() was called with NULL txq which bypasses the net device
>   watchdog.
> - dev_hard_start_xmit() does not check txq everywhere which will lead a crash
>   when tso is disabled for lower device.
> 
> Fix this by explicitly introducing a new param for .ndo_select_queue() for just
> selecting queues in the case of l2 forwarding offload. netdev_pick_tx() was also
> extended to accept this parameter and dev_queue_xmit_accel() was used to do l2
> forwarding transmission.
> 
> With this fixes, NETIF_F_LLTX could be preserved for macvlan and there's no need
> to check txq against NULL in dev_hard_start_xmit(). Also there's no need to keep
> a dedicated ndo_dfwd_start_xmit() and we can just reuse the code of
> dev_queue_xmit() to do the transmission.
> 
> In the future, it was also required for macvtap l2 forwarding support since it
> provides a necessary synchronization method.
> 
> Cc: John Fastabend <john.r.fastabend@intel.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: e1000-devel@lists.sourceforge.net
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.
