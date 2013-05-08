Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3EHJty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 05:49:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:32775 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab3EHJtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 05:49:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,632,1363158000"; 
   d="scan'208";a="299314269"
Message-ID: <1368006588.16616.5.camel@intelbox>
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Lukas Czerner <lczerner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 08 May 2013 12:49:48 +0300
In-Reply-To: <20130507161248.aedfde86659ae45cc5390bc4@linux-foundation.org>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
	 <CAKMK7uEL0kbS1j=gEu_GzUevseeKQ6JuZWPptr96JumCYurfnQ@mail.gmail.com>
	 <20130507161248.aedfde86659ae45cc5390bc4@linux-foundation.org>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 16:12 -0700, Andrew Morton wrote:
> On Thu, 2 May 2013 11:36:56 +0200 Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> 
> > On Thu, May 2, 2013 at 10:58 AM, Imre Deak <imre.deak@intel.com> wrote:
> > > Many callers of the wait_event_timeout() and
> > > wait_event_interruptible_timeout() expect that the return value will be
> > > positive if the specified condition becomes true before the timeout
> > > elapses. However, at the moment this isn't guaranteed. If the wake-up
> > > handler is delayed enough, the time remaining until timeout will be
> > > calculated as 0 - and passed back as a return value - even if the
> > > condition became true before the timeout has passed.
> > >
> > > Fix this by returning at least 1 if the condition becomes true. This
> > > semantic is in line with what wait_for_condition_timeout() does; see
> > > commit bb10ed09 - "sched: fix wait_for_completion_timeout() spurious
> > > failure under heavy load".
> > >
> > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > 
> > We have 3 instances of this bug in drm/i915. One case even where we
> > switch between the interruptible and not interruptible
> > wait_event_timeout variants, foolishly presuming they have the same
> > semantics. I very much like this.
> 
> Let's think about scheduling this fix.
> 
> Are any of the bugs which we expect this patch fixes serious enough to
> warrant merging it into 3.10?  And -stable?

There is at least [1], but I'm sure there is more similar reports about
i915. I'd vote for -stable at least.

--Imre

[1] https://bugs.freedesktop.org/show_bug.cgi?id=64133


