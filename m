Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaFLUZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:25:37 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43646 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFLUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:25:35 -0400
Date: Thu, 12 Jun 2014 13:26:02 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        RT <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2] rt/aio: fix rcu garbage collection might_sleep()
 splat
Message-ID: <20140612202602.GI10871@kmo-pixel>
References: <1402216538.31630.7.camel@marge.simpson.net>
 <5395172E.4010007@cn.fujitsu.com>
 <1402372048.5124.20.camel@marge.simpson.net>
 <20140610175001.GF27015@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610175001.GF27015@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 01:50:01PM -0400, Benjamin LaHaise wrote:
> On Tue, Jun 10, 2014 at 05:47:28AM +0200, Mike Galbraith wrote:
> > On Mon, 2014-06-09 at 10:08 +0800, Lai Jiangshan wrote: 
> > > Hi, rt-people
> > > 
> > > I don't think it is the correct direction.
> > > Softirq (including local_bh_disable()) in RT kernel should be preemptible.
> > 
> > How about the below then?
> > 
> > I was sorely tempted to post a tiny variant that dropped taking ctx_lock
> > in free_ioctx_users() entirely, as someone diddling with no reference
> > didn't make sense.  Cc Ben, he would know.
> 
> That should be okay...  Let's ask Kent to chime in on whether this looks 
> safe to him on the percpu ref front as well, since he's the one who wrote 
> this code.

Ok, finally got around to reading the whole thread - honestly, I would just punt
to workqueue to do the free_ioctx_users(). AFAICT that should be perfectly safe
and even aside from rt it would be good change so we're not cancelling an
arbitrary number of kiocbs from rcu callback context.

Kind of a related change, it should be possible to just grab the entire list of
kiocbs with ctx_lock held (remove them all at once from ctx->active_reqs), then
cancel them without ctx_lock held.
