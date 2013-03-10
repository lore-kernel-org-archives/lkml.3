Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3CJE7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 23:59:43 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:38644 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3CJE7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 23:59:41 -0500
Message-ID: <1362891577.4051.21.camel@edumazet-glaptop>
Subject: Re: epoll: possible bug from wakeup_source activation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 10 Mar 2013 05:59:37 +0100
In-Reply-To: <20130310011136.GA4815@dcvr.yhbt.net>
References: <20130307112639.GA25130@dcvr.yhbt.net>
	 <20130308013027.GA31830@dcvr.yhbt.net>
	 <CAMP5Xgdsam2DGLshL5Uu5Q4La_nAq=u1YRNBwAxDstgCvJiqfw@mail.gmail.com>
	 <20130308204944.GA27379@dcvr.yhbt.net>
	 <CAMP5Xgc4-oX=-V57Mu5PARCWdfpkjck0VnZNAXH-JisvKi5tAg@mail.gmail.com>
	 <20130309071037.GA13360@dcvr.yhbt.net>
	 <20130310011136.GA4815@dcvr.yhbt.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-10 at 01:11 +0000, Eric Wong wrote:
>  
>  static void ep_destroy_wakeup_source(struct epitem *epi)
>  {
> -	wakeup_source_unregister(epi->ws);
> -	epi->ws = NULL;
> +	struct wakeup_source *ws = epi->ws;
> +
> +	rcu_assign_pointer(epi->ws, NULL);

There is no need to use a memory barrier before setting epi->ws to NULL

You should use RCU_POINTER_INIT()

> +	synchronize_rcu(); /* wait for ep_pm_stay_awake to finish */

Wont this add a significant slowdown ?

> +	wakeup_source_unregister(ws);
>  }

Please add the following in your .config

CONFIG_SPARSE_RCU_POINTER=y

and try :

make C=2 fs/eventpoll.o

And fix all warnings ;)



