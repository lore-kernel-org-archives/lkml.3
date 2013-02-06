Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab3BFQj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:39:26 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58990 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab3BFQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:39:22 -0500
Date: Wed, 6 Feb 2013 17:39:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
Message-ID: <20130206163917.GA15403@gmail.com>
References: <5111AD8D.1080005@candelatech.com>
 <20130206015430.GA9161@home.goodmis.org>
 <5111BF51.5010607@candelatech.com>
 <1360119124.2621.37.camel@gandalf.local.home>
 <5111CE60.4080403@candelatech.com>
 <1360125419.2621.39.camel@gandalf.local.home>
 <5111F6F6.7010402@candelatech.com>
 <1360156888.2621.42.camel@gandalf.local.home>
 <51127D15.7080503@candelatech.com>
 <1360166840.2621.45.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360166840.2621.45.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2013-02-06 at 07:56 -0800, Ben Greear wrote:
> 
> > > I'm 99% sure that the bug is in your modifications.
> > 
> > I'm sorry, I tried to make that clear.
> 
> You said it was an out of tree module, I didn't realize it had changes
> to the core Linux as well.
> 
> > My tree is here, minus a few debugging patches related to 
> > this bug:
> > 
> > http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.7.dev.y/.git;a=summary
> 
> Here's your bug:
> 
> 3319         list_for_each_entry_rcu(ptype, &ptype_all, list) {
> 3320                 if (!ptype->dev || ptype->dev == skb->dev) {
> 3321                         if (pt_prev) {
> 3322                                 ret = deliver_skb(skb, pt_prev, orig_dev);
> 3323                                 if (ret == NET_RX_CONSUMED) {
> 3324                                         kfree_skb(skb); /* we made a copy in deliver_skb */
> 3325                                         goto out;
> 3326                                 }
> 3327                         }
> 
> One of many. All those "goto out;"s skip the rcu_read_unlock().

Wondering whether we could improve lockdep to detect 'excessive' 
lock nesting and treat it as a bug - the 'ran out of lockdep 
entries' assert might be too detached and it might even trigger 
in innocent, low lesting count contexts.

Thanks,

	Ingo
