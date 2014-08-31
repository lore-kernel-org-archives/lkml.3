Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaHaXko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:40:44 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:39094 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaHaXkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:40:41 -0400
Date: Sun, 31 Aug 2014 19:40:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        falcon@meizu.com, tiwai@suse.de, arjan@linux.intel.com,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831234037.GB30592@mtj.dyndns.org>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <20140831101358.GB19853@htj.dyndns.org>
 <20140831182851.GC17827@core.coreip.homeip.net>
 <20140831220238.GB28690@mtj.dyndns.org>
 <20140831230651.GB20569@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831230651.GB20569@core.coreip.homeip.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dmitry.

On Sun, Aug 31, 2014 at 04:06:51PM -0700, Dmitry Torokhov wrote:
> On Sun, Aug 31, 2014 at 06:02:38PM -0400, Tejun Heo wrote:
> > Hmmm... that is a different case from the one I'm aware of - userland
> > timing out on module probing and sending SIGKILL aborting device
> > probing, which is taking long but still making progress properly.
> 
> Right, it is definitely different use case. Here we just have a touchpad taking
> 1.5-2 secs to initialize and thus stalling the overall boot progress. 

Ah, yeah, that's a completely different issue and what other drivers
solve by using async_schedule() mechanism.

> > Yeah, at first I was applying the async thing to built-in drivers too
> > so the ordering was kinda necessary but I don't think it matters at
> > all for modules.
> 
> Why are we talking about modules? The touchpad driver is built-in in my case.

Because that was the issue which started this patch series.  It wasn't
about speeding up boot process but about probe failure from SIGKILL
from userland after timing out module loading.

> > I don't get this.  The relationship between the driver and its devices
> > is 1:N.  If a driver fails to bind to a device, it should properly
> > unbind from that device but still remain available so that it can be
> > used when another device becomes available.  The two have completely
> > different life cycles.  If you take a look at
> > drivers/base/dd.c::__driver_attach(), the function ignores error
> > return from probing.  The return types are pretty misleading due to
> > historical reasons but we already do not fail module loading after
> > probing failure, so making probing asynchronous shouldn't really
> > change anything.
> 
> I think we are talking about 2 different things. I am talking about probe()

Heh, yeah, we sure are.

> taking too long and stalling overall boot process. Yes, we can change
> individual drivers to use async_schedule() to do longer operations

That's the course we took for all other drivers.

> asynchronously, but if something that was scheduled asynchronously fails we do
> not have a convenient way to signal driver core that bind operation failed. We
> would end up with driver being bound to the device but device would not be
> operational. This is different from synchronous probing where any failure would
> cause probe() to return error and bind operation to fail.

Hmmm... I guess there's genuine difference in probing sequence between
input and scsi / libata.  For scsi / libata, the probing of actual
devices takes place outside the probe function of the controller
itself.  The controller probing is still synchronous but probing of
devices attached to that controller is asynchronous.  I guess the
problem you have is that the controller probe function itself takes
long time and there's no good way to make that asynchronous.  Yeah, I
suppose that can be solved together with the module probing timeout
issue.

Thanks.

-- 
tejun
