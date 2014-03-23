Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077AbaCWTyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:54:21 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36610 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCWTyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:54:19 -0400
Message-ID: <1395604457.9117.21.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] drivers/net: Use RCU_INIT_POINTER(x, NULL) in tun.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Monam Agarwal <monamagarwal123@gmail.com>, davem@davemloft.net,
        jasowang@redhat.com, xemul@parallels.com, wuzhy@linux.vnet.ibm.com,
        therbert@google.com, yamato@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Date: Sun, 23 Mar 2014 12:54:17 -0700
In-Reply-To: <20140323194113.GA13633@redhat.com>
References: <1395599552-7486-1-git-send-email-monamagarwal123@gmail.com>
	 <20140323194113.GA13633@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-23 at 21:41 +0200, Michael S. Tsirkin wrote:

> The rcu_assign_pointer() ensures that the initialization of a structure       
> is carried out before storing a pointer to that structure. 
> In the case of the NULL pointer, there is no structure to initialize,
> so we can safely drop smp_wmb in this case.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> --
> 
> Lightly tested.
> v is evaluated twice here but that should be ok since this
> only happens when v is a constant, so evaluating it should
> have no side effects.
> Paul, what do you think?
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 72bf3a0..d33c9ec 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -587,7 +587,8 @@ static inline void rcu_preempt_sleep_check(void)
>   */
>  #define rcu_assign_pointer(p, v) \
>  	do { \
> -		smp_wmb(); \
> +		if (!__builtin_constant_p(v) || (v)) \
> +			smp_wmb(); \
>  		ACCESS_ONCE(p) = RCU_INITIALIZER(v); \
>  	} while (0)
>  

Yeah, I suggest you read d322f45ceed525daa changelog ;)


