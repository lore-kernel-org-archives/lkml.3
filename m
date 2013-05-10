Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3EJLrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:47:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39003 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3EJLrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:47:41 -0400
Date: Fri, 10 May 2013 13:46:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130510114605.GA32110@dyad.programming.kicks-ass.net>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-8-git-send-email-sasha.levin@oracle.com>
 <20130510111719.GG31235@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510111719.GG31235@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 01:17:19PM +0200, Peter Zijlstra wrote:
> On Thu, May 09, 2013 at 11:58:07AM -0400, Sasha Levin wrote:
> > +	/*
> > +	 * Some programs attempt to initialize and use locks in their
> > +	 * allocation path. This means that a call to malloc() would
> > +	 * result in locks being initialized and locked.
> > +	 *
> > +	 * Why is it an issue for us? dlsym() below will try allocating to
> > +	 * give us the original function. Since this allocation will result
> > +	 * in a locking operations, we have to let pthread deal with it,
> > +	 * but we can't! we don't have the pointer to the original API
> > +	 * since we're inside dlsym() trying to get it :(
> > +	 *
> > +	 * We can work around it by telling the program that locking was
> > +	 * really okay, and just initialize those locks when we're fully
> > +	 * up and running (this is ok because this all happens during
> > +	 * initialization phase, when we have just one thread). But
> > +	 * this is a big TODO at this point.
> > +	 */
> > +	if (preload_started) {
> > +		printf(
> > +		"LOCKDEP error: It seems that the program you are trying to "
> > +		"debug is initializing locks in it's allocation path.\n"
> > +		"This means that liblockdep cannot reliably analyze this "
> > +		"program since we need the allocator to work before we can "
> > +		"debug locks.\nSorry!\n");
> > +
> > +		exit(1);
> > +	}
> 
> 
> Would something like the below cure things? Obviously this hasn't been near a
> compiler for the entire thing still isn't wanting to compile for me.

OK, that won't do indeed. Not being able to malloc is only part of the problem.

/me goes stare at it more
