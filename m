Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaJAQLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:11:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:51741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJAQLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:11:00 -0400
Date: Wed, 1 Oct 2014 18:10:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] sched: Debug nested sleeps
Message-ID: <20141001161058.GE2843@worktop.programming.kicks-ass.net>
References: <20140924081845.572814794@infradead.org>
 <20140924082242.591637616@infradead.org>
 <20140929221344.GB12112@redhat.com>
 <20140930134928.GF4241@worktop.programming.kicks-ass.net>
 <20140930214732.GA31384@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930214732.GA31384@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 11:47:32PM +0200, Oleg Nesterov wrote:

> > > This is minor, but this way CONFIG_DEBUG_ATOMIC_SLEEP will not imply
> > > a subtle behavioural change.
> >
> > You mean the __set_current_state() that's extra?
> 
> Yes, and note that it only does __set_current_state(RUNNING) if
> CONFIG_DEBUG_ATOMIC_SLEEP. This means that disabling/enabling this
> option can, silently hide/uncover a bug.
> 
> > I would actually argue
> > to keep that since it makes the 'problem' much worse.
> 
> OK, I won't insist, but could you explain why the suggested change can
> make the problem (and which problem ;) worse?

Sure, so the trivial problem is not actually going to sleep in the outer
wait primitive because the inner wait primitive reset ->state to
TASK_RUNNING.

So by always setting the ->state to TASK_RUNNING it never goes to sleep
and it'll revert to spinning, causing spikes in CPU usage that should
hopefully be far easier to notice than the occasional funny.
