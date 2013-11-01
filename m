Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3KAXe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 19:34:56 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:30689 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3KAXez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 19:34:55 -0400
Message-ID: <1383348890.1737.40.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH] bnx2: Use dev_kfree_skb_any() in bnx2_tx_int()
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
CC: <xiyou.wangcong@gmail.com>, <mchan@broadcom.com>,
        <tdmackey@booleanhaiku.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 1 Nov 2013 23:34:50 +0000
In-Reply-To: <20131101.180147.629210014672277622.davem@davemloft.net>
References: <CAM_iQpWAbSWVeAMwhQADTwO_RdYUXfog-wG9gs4+Zek0g_5Oyg@mail.gmail.com>
	 <20131031.002602.2030884257299947291.davem@davemloft.net>
	 <CAM_iQpXPrEj619=PRaKN4PxgOoEB96U0mLFS65AzXOezSWvhxQ@mail.gmail.com>
	 <20131101.180147.629210014672277622.davem@davemloft.net>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20260.002
X-TM-AS-Result: No--28.390000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 18:01 -0400, David Miller wrote:
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Thu, 31 Oct 2013 21:19:16 -0700
> 
> > 2013年10月30日 下午9:26于 "David Miller" <davem@davemloft.net>写道：
> >>
> >> We have to provide a softint compatible environment for this callback
> >> to run in else everything is completely broken.
> >>
> >> All these drivers can safely assume softirq safe locking is
> >> sufficient, you're suggesting we need to take this hardirq safety and
> >> I'm really not willing to allow things to go that far.  A lot of
> >> effort has been expended precisely to avoid that kind of overhead and
> >> cost.
> > 
> > Alright, I am thinking to move netpoll_poll_dev() to a delayed work.
>  
> What if the printk is outputting a message that will help us discover
> that work queues are deadlocked?
> 
> You can't delay the message, because every layer of indirection you
> add increases the possibility that the message it never seen.  You
> have to do it synchronously.

As you've said, the ndo_start_xmit and NAPI poll operations are intended
to be called in softirq context, so everything that interlocks with them
will use spin_lock_bh().  Calling them from hardirq context obviously
opens the possibility of a deadlock.  How do you expect anyone to solve
that?

I think that most of the time netpoll doesn't actually call the NAPI
poll function, and the driver ndo_start_xmit function doesn't take any
locks, so we don't actually hit the deadlock in practice (on mainline
kernels - RT is a different story).

Obviously, the less machinery netpoll relies on continuing to work, the
better, so it should preferably defer to sofirq context rather than
workqueue context.  I think this means hooking queue_process() into
net_tx_action(), and then cutting out much of the rest of netpoll.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

