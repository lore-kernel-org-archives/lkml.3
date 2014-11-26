Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaKZSoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:44:25 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:59084 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaKZSoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:44:24 -0500
Message-ID: <1417027459.29427.63.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] r8152: drop the tx packet with invalid length
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: hayeswang@realtek.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Wed, 26 Nov 2014 10:44:19 -0800
In-Reply-To: <20141126.120658.498602780456343676.davem@davemloft.net>
References: <1394712342-15778-104-Taiwan-albertk@realtek.com>
	 <1417020748.29427.59.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141126.120658.498602780456343676.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 12:06 -0500, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 26 Nov 2014 08:52:28 -0800
> 
> > On Wed, 2014-11-26 at 17:56 +0800, Hayes Wang wrote:
> >> Drop the tx packet which is more than the size of agg_buf_sz. When
> >> creating a bridge with the device, we may get the tx packet with
> >> TSO and the length is more than the gso_max_size which is set by
> >> the driver through netif_set_gso_max_size(). Such packets couldn't
> >> be transmitted and should be dropped directly.
> >> 
> >> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
>  ...
> > Looks like a candidate for ndo_gso_check(), so that we do not drop, but
> > instead segment from netif_needs_gso()/validate_xmit_skb()
> 
> You mean have the bridge implement the ndo_gso_check() method right?

No, I meant this particular driver.

Note that netif_skb_features() does only this check :

if (gso_segs > dev->gso_max_segs || gso_segs < dev->gso_min_segs)
      features &= ~NETIF_F_GSO_MASK;


Ie not testing gso_max_size

It looks like all these particular tests should be moved on
ndo_gso_check(), to remove code from netif_skb_features()



