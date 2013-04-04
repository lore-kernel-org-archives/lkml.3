Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763163Ab3DDQdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:33:16 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52371
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762997Ab3DDQdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:33:13 -0400
Message-ID: <1365093180.2609.103.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Date: Thu, 04 Apr 2013 18:33:00 +0200
In-Reply-To: <20130404133123.GW2228@phenom.ffwll.local>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
	 <1364900432.18374.24.camel@laptop> <515AF1C1.7080508@canonical.com>
	 <1364921954.20640.22.camel@laptop> <1365076908.2609.94.camel@laptop>
	 <20130404133123.GW2228@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> We do add some form of owner tracking by storing the reservation
> ticket
> of the current holder into every ww_mutex. So when task-Y in your
> above
> example tries to acquire lock A it notices that it's behind in the
> global
> queue and immedieately returns -EAGAIN to indicate the deadlock.
> 
> Aside, there's a bit of fun in that ttm uses -EDEADLCK for when you
> try to
> reserve the same buffer twice - it can easily detect that by comparing
> the
> lock owner ticket with the provided one and if it matches bail out. 

Sure, but this should bear no influence on the design of the mutex
primitive. At most we should ensure this situation is recognizable.

> Hence we've kept the special -EDEADLCK semantics even for the ww_mutex
> stuff.

There's EDEADLK and EDEADLOCK, EDEADLCK does alas not exist :-)

> > Now this gets a little more interesting if we change the scenario a
> > little:
> > 
> >       task-O  task-Y
> >         A
> >               B
> >         B <-- blocks on Y
> >               * <-- could be A
> 
> The current code at least simple blocks task-O on B until task-Y
> unlocks
> B. Deadlocks cannot happen since if task-Y ever tries to acquire a
> lock
> which is held by an older task (e.g. lock A) it will bail out with
> -EAGAIN.

Agreed, O would have to wait until Y unlocks B. It was a 'detail' I
skimped over for the sake of brevity. I was merely trying to illustrate
the ways in which we must bring Y to return -EDEADLK (or -EAGAIN in
your version).

