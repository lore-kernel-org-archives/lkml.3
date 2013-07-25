Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3GYQBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:01:47 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65133 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3GYQBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:01:44 -0400
Date: Thu, 25 Jul 2013 09:01:40 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Linus =?ISO-8859-1?B?TPxzc2luZw==?= <linus.luessing@web.de>
Cc: bridge@lists.linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Cong Wang <amwang@redhat.com>, Adam Baker <linux@baker-net.org.uk>
Subject: Re: [PATCHv2] bridge: disable snooping if there is no querier
Message-ID: <20130725090140.658f33f7@nehalam.linuxnetplumber.net>
In-Reply-To: <1374760580-12920-1-git-send-email-linus.luessing@web.de>
References: <1374757046-12463-1-git-send-email-linus.luessing@web.de>
	<1374760580-12920-1-git-send-email-linus.luessing@web.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 15:56:20 +0200
Linus Lüssing <linus.luessing@web.de> wrote:

>  
> +static void br_multicast_update_querier_timer(struct net_bridge *br,
> +					      unsigned long max_delay)
> +{
> +	if (!timer_pending(&br->multicast_querier_timer))
> +		atomic64_set(&br->multicast_querier_delay_time,
> +			     jiffies + max_delay);
> +
> +	mod_timer(&br->multicast_querier_timer,
> +		  jiffies + br->multicast_querier_interval);
> +}
> +

Isn't this test racing with timer expiration.

static void br_multicast_update_querier_timer(struct net_bridge *br,
					      unsigned long max_delay)
{
	if (!timer_pending(&br->multicast_querier_timer))
		atomic64_set(&br->multicast_querier_delay_time,
			     jiffies + max_delay);
What if timer completes here?

	mod_timer(&br->multicast_querier_timer,
		  jiffies + br->multicast_querier_interval);
}


And another race if timer goes off?

static void br_multicast_update_querier_timer(struct net_bridge *br,
					      unsigned long max_delay)
{
	if (!timer_pending(&br->multicast_querier_timer))
		atomic64_set(&br->multicast_querier_delay_time,
			     jiffies + max_delay);
Timer fires here...?

	mod_timer(&br->multicast_querier_timer,
		  jiffies + br->multicast_querier_interval);
}
