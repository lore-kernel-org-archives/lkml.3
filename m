Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3EGXMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:12:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3EGXMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:12:50 -0400
Date: Tue, 7 May 2013 16:12:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Imre Deak <imre.deak@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Lukas Czerner <lczerner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wait: fix false timeouts when using
 wait_event_timeout()
Message-Id: <20130507161248.aedfde86659ae45cc5390bc4@linux-foundation.org>
In-Reply-To: <CAKMK7uEL0kbS1j=gEu_GzUevseeKQ6JuZWPptr96JumCYurfnQ@mail.gmail.com>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
	<CAKMK7uEL0kbS1j=gEu_GzUevseeKQ6JuZWPptr96JumCYurfnQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013 11:36:56 +0200 Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> On Thu, May 2, 2013 at 10:58 AM, Imre Deak <imre.deak@intel.com> wrote:
> > Many callers of the wait_event_timeout() and
> > wait_event_interruptible_timeout() expect that the return value will be
> > positive if the specified condition becomes true before the timeout
> > elapses. However, at the moment this isn't guaranteed. If the wake-up
> > handler is delayed enough, the time remaining until timeout will be
> > calculated as 0 - and passed back as a return value - even if the
> > condition became true before the timeout has passed.
> >
> > Fix this by returning at least 1 if the condition becomes true. This
> > semantic is in line with what wait_for_condition_timeout() does; see
> > commit bb10ed09 - "sched: fix wait_for_completion_timeout() spurious
> > failure under heavy load".
> >
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> 
> We have 3 instances of this bug in drm/i915. One case even where we
> switch between the interruptible and not interruptible
> wait_event_timeout variants, foolishly presuming they have the same
> semantics. I very much like this.

Let's think about scheduling this fix.

Are any of the bugs which we expect this patch fixes serious enough to
warrant merging it into 3.10?  And -stable?
