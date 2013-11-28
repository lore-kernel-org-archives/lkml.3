Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab3K1OyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:54:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3K1Ox7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:53:59 -0500
Date: Thu, 28 Nov 2013 15:53:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128145352.GW10022@twins.programming.kicks-ass.net>
References: <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143857.GU10022@twins.programming.kicks-ass.net>
 <20131128144502.GE3925@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128144502.GE3925@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 09:45:02AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Thu, Nov 28, 2013 at 03:38:57PM +0100, Peter Zijlstra wrote:
> > It seems like a perfectly fine interface to me. And much preferable to
> > creating yet another weird interface to manage tasks.
> 
> The problem with that is it isn't an interface where the user
> specifies what's desired but more of just an exposed facet of
> implementation details and locks us into either keeping that single
> parent model for the eternity or doing a shitty hack like extracing
> attributes from that task if we ever need to change the implementation
> for whatever reason.  In general, it's a much better idea to have an
> interface where the feature supported is represented explicitly and
> finitely.  If this is something which is actually necessary, I'd vote
> for having an explicit interface for the desired feature, whatever
> that may be.

The desired feature is to contain all current and future userspace
helpers.

Having the single parent allows using either cgroups or direct affinity
constraints, depending on whatever the user likes.

Related is the desire to contain all current and future unbound
workqueue threads. Not being able to set affinity (or cpusets for that
matter) on unbound workqueue threads actively breaks these things.

While the current use-cases I'm aware of treat these two groups as one,
I'm not sure we want to merge them.

The problem with yet another interface is that we'll likely expose just
the affinity, which would preclude using cgroups for this task.

Having single parents (even virtual as you propose, where we harvest
context attributes) allows us to easily find the extant child tasks and
set the desired attributes for future children with the full set of task
interfaces we've currently got.


