Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3IZPnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:43:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53104 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3IZPnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:43:10 -0400
Date: Thu, 26 Sep 2013 17:43:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
Message-ID: <20130926154303.GA3364@laptop.programming.kicks-ass.net>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
 <1380099377.8523.9.camel@marge.simpson.net>
 <20130926095812.GR3081@twins.programming.kicks-ass.net>
 <CAPM31RL9RGX=ohUVag=tD41MbXs47dDgpndGfjBt68QeL-De7g@mail.gmail.com>
 <20130926111618.GU3081@twins.programming.kicks-ass.net>
 <CAPM31RKvhdDu_NmRd-hv7xBzM6qsS=Y0ey96GpLt36-oBrqdBg@mail.gmail.com>
 <20130926143533.GE3657@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926143533.GE3657@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:35:33PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 26, 2013 at 04:39:30AM -0700, Paul Turner wrote:
> > It is my intuition that there are a few common objects with fairly
> > polarized behavior:  I.e. For condition variables and producer
> > consumer queues, a wakeup strongly predicts blocking.  Whereas for
> > locks protecting objects, e.g. a Mutex, would be expected to have the
> > opposite behavior.
> 
> Agreed; however none of those seem to have the property we're looking
> for.
> 
> Even produces consumer queues on their own don't generate the
> alternating patterns we're looking for with the SYNC hint.
> 
> We need a 'guarantee' that the waker is going to stop until the wakee is
> done.
> 
> What we're looking for is the typical synchronous request-reply like
> pattern -- and that doesn't seem to correlate to any one locking object.
> 
> Rather it is an inter-task relation; so task state does make sense in
> finding them. We could for instance try and infer which task is
> servicing requests; and then we know that requesting tasks will sleep
> until reply.
> 

Oh never mind, I see what you meant, the edges in that graph are the
locks.

Can't use RIPs for futexes though; you'd likely end up in the one
pthread_mutex_lock() implementation or such.
