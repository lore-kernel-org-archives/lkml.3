Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaHaXG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:06:56 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55683 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHaXGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:06:55 -0400
Date: Sun, 31 Aug 2014 16:06:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        falcon@meizu.com, tiwai@suse.de, arjan@linux.intel.com,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831230651.GB20569@core.coreip.homeip.net>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <20140831101358.GB19853@htj.dyndns.org>
 <20140831182851.GC17827@core.coreip.homeip.net>
 <20140831220238.GB28690@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831220238.GB28690@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 06:02:38PM -0400, Tejun Heo wrote:
> Hello, Dmitry.
> 
> On Sun, Aug 31, 2014 at 11:28:51AM -0700, Dmitry Torokhov wrote:
> > HI Tejun,
> > 
> > On Sun, Aug 31, 2014 at 06:13:58AM -0400, Tejun Heo wrote:
> > > I haven't followed the previous discussions so please let me know if
> > > this has been discussed before.  It looks like you're trying to extend
> > > the async mechanism and applying them to init functions themselves.
> > > That sounds kinda weird to me.  Isn't the root cause of the problem
> > > doing device probings along with driver initilaization on module load?
> > 
> > For my use case it is driver initialization itself (because most of the
> > relevant drivers is compiled in). Although, come to think, if we could do
> 
> Hmmm... that is a different case from the one I'm aware of - userland
> timing out on module probing and sending SIGKILL aborting device
> probing, which is taking long but still making progress properly.

Right, it is definitely different use case. Here we just have a touchpad taking
1.5-2 secs to initialize and thus stalling the overall boot progress. 

> 
> > something about resume that would be nice too: then I'd be able to drop all
> > stuff in serio that lies about device state and marks it as resumed even though
> > mouse/touchpad will be actually reset and operable much later.
> > 
> > > Wouldn't it be more logical to simply make bus_add_driver() ->
> > > driver_attach() invocation asynchronous?  There's no reason to make
> > > them parallel either.  We can use an ordered queue for it so that we
> > > don't lose the probing order we used to have.
> > 
> > Sometimes losing probing order is the desired outcome though. Like with my
> > beloved touchpad :)
> 
> Yeah, at first I was applying the async thing to built-in drivers too
> so the ordering was kinda necessary but I don't think it matters at
> all for modules.

Why are we talking about modules? The touchpad driver is built-in in my case.

> 
> > > Making things go
> > > parallel is the responsibility of each probing function after all and
> > > there isn't much to gain by making attach calls go parallel.
> > 
> > If we make probe function schedule stuff asynchronously, then, in case of
> > failures, we'll end up with half-bound driver. Also drivers would have to have
> > additional code on removal to make sure probe full done before removing. PM
> > methods need to be ready to be called on half-initialized device. It is a mess.
> 
> I don't get this.  The relationship between the driver and its devices
> is 1:N.  If a driver fails to bind to a device, it should properly
> unbind from that device but still remain available so that it can be
> used when another device becomes available.  The two have completely
> different life cycles.  If you take a look at
> drivers/base/dd.c::__driver_attach(), the function ignores error
> return from probing.  The return types are pretty misleading due to
> historical reasons but we already do not fail module loading after
> probing failure, so making probing asynchronous shouldn't really
> change anything.

I think we are talking about 2 different things. I am talking about probe()
taking too long and stalling overall boot process. Yes, we can change
individual drivers to use async_schedule() to do longer operations
asynchronously, but if something that was scheduled asynchronously fails we do
not have a convenient way to signal driver core that bind operation failed. We
would end up with driver being bound to the device but device would not be
operational. This is different from synchronous probing where any failure would
cause probe() to return error and bind operation to fail.

Thanks.

-- 
Dmitry
