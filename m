Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaBSHqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:46:42 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:33574 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaBSHqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:46:40 -0500
Date: Wed, 19 Feb 2014 08:46:33 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 12/14] r8152: replace netif_rx
 withnetif_receive_skb
Message-ID: <20140219074633.GA26271@electric-eye.fr.zoreil.com>
References: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
 <1392731351-25502-13-git-send-email-hayeswang@realtek.com>
 <20140218232850.GB13394@electric-eye.fr.zoreil.com>
 <79F93FE4FECD48E7B7B6C6EE93151CB6@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79F93FE4FECD48E7B7B6C6EE93151CB6@realtek.com.tw>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> :
>  Francois Romieu [mailto:romieu@fr.zoreil.com] 
> > Hayes Wang <hayeswang@realtek.com> :
> > > Replace netif_rx with netif_receive_skb to avoid disabling irq frequently
> > > for increasing the efficiency.
> > 
> > read_bulk_callback is issued in irq context. It could thus use plain
> > spin_lock / spin_unlock instead of the irq disabling version.
> 
> The rx_bottom() is called in tasklet, so I just think I could use
> netif_receive_skb directly. The netif_rx seems to queue the packet,
> and local_irq_disable() would be called before dequeuing the skb.

The change in rx_bottom is fine. My point is about read_bulk_callback.

rx_bottom races with read_bulk_callback. rx_bottom is issued in
tasklet (softirq) context. read_bulk_callback is issued in irq
context, with irq disabled. read_bulk_callback does not need to
disable irq itself and could go with spin_lock in place of
spin_lock_irqsave (rx_bottom can't, of course).

-- 
Ueimor
