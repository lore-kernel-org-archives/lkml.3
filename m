Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaCZW4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:56:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:35312 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaCZWz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:55:59 -0400
Date: Wed, 26 Mar 2014 23:56:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        "David S. Miller" <davem@davemloft.net>,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] atm: replace del_timer by del_timer_sync
In-Reply-To: <1395872545.12610.262.camel@edumazet-glaptop2.roam.corp.google.com>
Message-ID: <alpine.DEB.2.02.1403262344060.7710@ionos.tec.linutronix.de>
References: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>   <1395869625-15209-3-git-send-email-Julia.Lawall@lip6.fr>  <1395871015.12610.254.camel@edumazet-glaptop2.roam.corp.google.com>  <alpine.DEB.2.02.1403262301171.31401@ionos.tec.linutronix.de>
 <1395872545.12610.262.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Mar 2014, Eric Dumazet wrote:

> On Wed, 2014-03-26 at 23:02 +0100, Thomas Gleixner wrote:
> 
> > That's why you need del_timer_sync() it waits for the timer handler to
> > complete and then removes it.
> 
> Interesting... So maybe some comment is stale ?
> 
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index accfd241b9e5..c948fa2fc065 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1011,10 +1011,10 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
>   * the timer it also makes sure the handler has finished executing on other
>   * CPUs.
>   *
> - * Synchronization rules: Callers must prevent restarting of the timer,
> - * otherwise this function is meaningless. It must not be called from

We still need to prevent restarting from some other site,
i.e. interrupt. It's fine if the timer handler itself restarts the
timer, as del_timer_sync() wait for the handler to finish and then
delete the timer.

I can't find the reason why it can't call add_timer_on(). We
lock/unlock the timer base in every try_to_del_timer_sync() loop so we
detect the base change.

Thanks,

	tglx
