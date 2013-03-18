Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3CRUUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:20:20 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:60461 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3CRUUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:20:18 -0400
Date: Mon, 18 Mar 2013 20:20:18 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v2] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130318202018.GA17114@dcvr.yhbt.net>
References: <20130314044215.GA27312@dcvr.yhbt.net>
 <20130318110722.GA8798@dcvr.yhbt.net>
 <20130318130649.GA15947@Krystal>
 <20130318173237.GB8798@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318173237.GB8798@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > I'm also not entirely sure why you need to add enum epoll_item_state
> > along with expensive atomic ops to compute the state.  Wouldn't it be
> > enough to know in which queue the nodes are located ? If need be, you
> > could add new queues, e.g. one per state. So instead of marking states,
> > you would simply re-enqueue the nodes into per-state queues. This would
> > simplify zombie management and save a couple of brains in the process. ;-)
> 
> Is there a quick way to know which queue the node is located?
> 
> ep_enqueue may fire from several places at once (ep_poll_callback,
> ep_insert/ep_modify) so I think guarding it with something (currently
> ep_mark_ready) is required.  We used to use ep->lock to protect all the
> "if (!ep_is_linked) list_add_tail" calls, too.

I now think the EP_STATE_DEQUEUE state (and associated loop) is
unnecessary.  I only had it for the EPOLLET case.

Safe usage of EPOLLET requires hitting EAGAIN before expecting an event
anyways (as documented by epoll(7)).  So the potential of "losing" an
event while it is being sent to userspace existed before, and it still
exists now.  For an app which uses EPOLLET improperly (by not relying on
EAGAIN), the window for "losing" an event is slightly larger, but
probably still too small to matter...

This change wouldn't affect level-trigger (most epoll users, I think)
nor EPOLLONESHOT users.  Hopefully I'll be able to test more, soon.
