Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3GTAKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 20:10:12 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63975 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3GTAKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 20:10:08 -0400
Message-ID: <1374279005.26476.31.camel@edumazet-glaptop>
Subject: Re: strange crashes in tcp_poll() via epoll_wait
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 19 Jul 2013 17:10:05 -0700
In-Reply-To: <20130719235008.GA4518@dcvr.yhbt.net>
References: <1374251057.26476.17.camel@edumazet-glaptop>
	 <20130719235008.GA4518@dcvr.yhbt.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 23:50 +0000, Eric Wong wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Hi Al
> > 
> > I tried to debug strange crashes in tcp_poll() called from
> > sys_epoll_wait() -> sock_poll()
> > 
> > The symptom is that sock->sk is NULL and we therefore dereference a NULL
> > pointer.
> > 
> > It's really rare crashes but still, it would be nice to understand where
> > is the bug. Presumably latest kernels would crash in sock_poll() because
> > of the sk_can_busy_loop(sock->sk) call.
> > 
> > We do test sock->sk being NULL in sock_fasync(), but epoll should be
> > safe because of existing synchronization (epmutex) ?
> 
> It should be safe because of ep->mtx, actually, as epmutex is not taken
> in sys_epoll_wait.

Hmm, it might be more complex than that for multi threaded programs : 

eventpoll_release_file()

The problem might be because a thread closes a socket while an event
was queued for it.


> 
> I took a look at this but have not found anything.  I've yet to see this
> this on my machines.
> 
> When did you start noticing this?

Hard to say, but we have these crashes on a 3.3+ based kernel.

Probability of said crashes is very very low.


