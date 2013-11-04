Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3KDUMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:12:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3KDUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:12:35 -0500
Date: Mon, 04 Nov 2013 15:12:30 -0500 (EST)
Message-Id: <20131104.151230.1978898006990867916.davem@davemloft.net>
To: govindarajulu90@gmail.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, IvDoorn@gmail.com, sbhatewara@vmware.com,
        samuel@sortiz.org, chas@cmf.nrl.navy.mil, roland@kernel.org,
        isdn@linux-pingi.de, jcliburn@gmail.com, benve@cisco.com,
        ssujith@cisco.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, shahed.shaikh@qlogic.com, joe@perches.com,
        apw@canonical.com
Subject: Re: [PATCH net-next 02/13] driver: net: remove unnecessary skb
 NULL check before calling dev_kfree_skb_irq
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383400074-30555-3-git-send-email-govindarajulu90@gmail.com>
References: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
	<1383400074-30555-3-git-send-email-govindarajulu90@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 04 Nov 2013 12:12:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Date: Sat,  2 Nov 2013 19:17:43 +0530

> @@ -1030,10 +1030,8 @@ static void ni65_xmit_intr(struct net_device *dev,int csr0)
>  		}
>  
>  #ifdef XMT_VIA_SKB
> -		if(p->tmd_skb[p->tmdlast]) {
> -			 dev_kfree_skb_irq(p->tmd_skb[p->tmdlast]);
> -			 p->tmd_skb[p->tmdlast] = NULL;
> -		}
> +		 dev_kfree_skb_irq(p->tmd_skb[p->tmdlast]);
> +		 p->tmd_skb[p->tmdlast] = NULL;
>  #endif

I absolutely disagree with this kind of change.

There is a non-trivial cost for NULL'ing out that array entry
unconditionally.  It's a dirtied cache line and this is in the
fast path of TX SKB reclaim of this driver.

You've made several changes of this kind.

And it sort-of shows that the places that do check for NULL,
are getting something in return for that test, namely avoidance
of an unnecessary cpu store in the fast path of the driver.

I'm throwing away this series, sorry.
