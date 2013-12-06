Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab3LFUjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:39:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42333 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3LFUjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:39:46 -0500
Date: Fri, 06 Dec 2013 15:39:44 -0500 (EST)
Message-Id: <20131206.153944.1382127535160341376.davem@davemloft.net>
To: joe@perches.com
Cc: mareklindner@neomailbox.ch, sw@simonwunderlich.de, antonio@meshcoding.com,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] batadv: Slight optimization of batadv_compare_eth
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386317890.31845.26.camel@joe-AO722>
References: <1386317890.31845.26.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 12:39:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 06 Dec 2013 00:18:10 -0800

> @@ -266,7 +266,11 @@ static inline void batadv_dbg(int type __always_unused,
>   */
>  static inline int batadv_compare_eth(const void *data1, const void *data2)
>  {
> -	return (memcmp(data1, data2, ETH_ALEN) == 0 ? 1 : 0);
> +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> +	return ether_addr_equal(data1, data2);
> +#else
> +	return memcmp(data1, data2, ETH_ALEN) == 0;
> +#endif
>  }

Let's not crap up implementations with these ifdefs.

What's the specific situation here?  Is it that 'data1' and/or
'data2' my not be u16 aligned?

If so, make a function for that in linux/etherdevice.h and invoke it
in such places.  You can name it something like
"ether_addr_equal_unaligned()" or similar.

Thanks.
