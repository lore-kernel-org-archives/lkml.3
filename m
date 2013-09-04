Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3IDMwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:52:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54967 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab3IDMwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:52:18 -0400
Message-ID: <1378299135.7360.109.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next v2 2/2] net: migrate direct users to
 prandom_u32_max
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 04 Sep 2013 05:52:15 -0700
In-Reply-To: <1378298247-29364-3-git-send-email-dborkman@redhat.com>
References: <1378298247-29364-1-git-send-email-dborkman@redhat.com>
	 <1378298247-29364-3-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-04 at 14:37 +0200, Daniel Borkmann wrote:
> Users that directly use or reimplement what we have in prandom_u32_max()
> can be migrated for now to use it directly, so that we can reduce code size
> and avoid reimplementations. That's obvious, follow-up patches could inspect
> modulo use cases for possible migration as well.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>  drivers/net/team/team_mode_random.c | 8 +-------
>  include/net/red.h                   | 2 +-
>  net/802/garp.c                      | 3 ++-
>  net/802/mrp.c                       | 3 ++-
>  net/packet/af_packet.c              | 2 +-
>  net/sched/sch_choke.c               | 8 +-------
>  6 files changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/team/team_mode_random.c b/drivers/net/team/team_mode_random.c
> index 7f032e2..0dbd1eb 100644
> --- a/drivers/net/team/team_mode_random.c
> +++ b/drivers/net/team/team_mode_random.c
> @@ -13,20 +13,14 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/skbuff.h>
> -#include <linux/reciprocal_div.h>
>  #include <linux/if_team.h>
>  
> -static u32 random_N(unsigned int N)
> -{
> -	return reciprocal_divide(prandom_u32(), N);
> -}
> -
>  static bool rnd_transmit(struct team *team, struct sk_buff *skb)
>  {
>  	struct team_port *port;
>  	int port_index;
>  
> -	port_index = random_N(team->en_port_count);
> +	port_index = prandom_u32_max(team->en_port_count - 1);


Note the random_N(0) gave 0, while prandom_u32_max(0 - 1) can return any
number in [0 ... ~0U]



