Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967622Ab3HIGY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:24:27 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53312 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967319Ab3HIGYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:24:25 -0400
Date: Fri, 9 Aug 2013 02:24:05 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Dan Aloni <alonid@postram.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] netconsole: avoid a crash with multiple sysfs writers
Message-ID: <20130809062405.GA8031@neilslaptop.think-freely.org>
References: <1375866164-21933-1-git-send-email-alonid@postram.com>
 <20130808055032.GA3898@neilslaptop.think-freely.org>
 <CAOE7D0tj3suE8bnpd4ijL1zVLr83OB28KdRR7OOLkEnDOCM4_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOE7D0tj3suE8bnpd4ijL1zVLr83OB28KdRR7OOLkEnDOCM4_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 09:14:31AM +0300, Dan Aloni wrote:
> On Thu, Aug 8, 2013 at 8:50 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Wed, Aug 07, 2013 at 12:02:44PM +0300, Dan Aloni wrote:
> [..]
> >
> > > When my 'ifup eth' script was fired multiple times and ran concurrent o> @@ -682,7 +689,11 @@ restart:
> > >                                * we might sleep in __netpoll_cleanup()
> > >                                */
> > >                               spin_unlock_irqrestore(&target_list_lock, flags);
> > > +
> > > +                             mutex_lock(&nt->mutex);
> > >                               __netpoll_cleanup(&nt->np);
> > > +                             mutex_unlock(&nt->mutex);
> > > +
> > NAK, you can't hold a mutex while calling __netpoll_cleanup.  __netpoll_cleanup
> > may sleep and its illegal to hold a mutex while doing so.
> > Neil
> >
> 
> To my understanding, it mostly depends on locking order, and having
> sleeplocks in the outer order and spinlocks in the inner order is
> valid as long the locking order is not reversed.
> 
> Also, drivers/net/team/team.c - another netpoll user, already does the
> same thing I intended in this patch - it locks the outer team->lock
> mutex in team_uninit() while calling team_port_del() and then
> team_port_disable_netpoll() calls __netpoll_cleanup().
> 
Sorry, you're right, I was under the impression that you were already in atomic
context, but as long as you don't have preempt disabled when you try to take the
mutex in any path, you should be ok.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

