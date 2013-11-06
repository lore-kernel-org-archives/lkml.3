Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3KFWHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:07:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56842 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752245Ab3KFWHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:07:01 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Archit Taneja <archit@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: Async runtime put in __device_release_driver()
Date: Wed, 06 Nov 2013 23:19:20 +0100
Message-ID: <1910973.CpzEs44S3m@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1311061656450.1220-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1311061656450.1220-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 06, 2013 05:02:12 PM Alan Stern wrote:
> On Wed, 6 Nov 2013, Rafael J. Wysocki wrote:
> 
> > On Wednesday, November 06, 2013 09:51:42 AM Tomi Valkeinen wrote:
> > > On 2013-11-05 23:29, Ulf Hansson wrote:
> > > > On 23 October 2013 12:11, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> > > >> Hi,
> > > >>
> > > >> I was debugging why clocks were left enabled after removing omapdss
> > > >> driver, and I found this commit:
> > > >>
> > > >> fa180eb448fa263cf18dd930143b515d27d70d7b (PM / Runtime: Idle devices
> > > >> asynchronously after probe|release)
> > > >>
> > > >> I don't understand how that is supposed to work.
> > > >>
> > > >> When a driver is removed, instead of using pm_runtime_put_sync() the
> > > >> commit uses pm_runtime_put(), so the runtime_suspend call is queued. But
> > > >> who is going to handle the queued suspend call, as the driver is already
> > > >> removed? At least in my case, obviously nobody, as I only get
> > > >> runtime_resume call in my driver, never the runtime_suspend.
> > > >>
> > > >> Is there something I need to add to my driver to make this work, or
> > > >> should that part of the patch be reverted?
> > > > 
> > > > I believe it is quite common that a device driver calls
> > > > pm_runtime_get_sync as a part of it's remove callback, then it
> > > > explicitly returns it's resources that has been fetched during probe.
> > > > Like a clk_disable_unprepare for example.
> > > 
> > > I guess you mean the driver calls pm_runtime_get_sync _and_
> > > pm_runtime_put_sync as part of its remove callback?
> > > 
> > > Probably bus drivers need to do that, but for memory mapped devices in a
> > > SoC, I don't think there's normally any need to do
> > > pm_runtime_get/put_sync during the remove callback.
> > > 
> > > > The idea behind the change in __device_release_driver, was to try to
> > > > prevent  devices from going active->idle->active and instead just
> > > > remain active (if possible).
> > > >
> > > > In your case, which seems like a more modern way of implementing
> > > > "remove", you shall call "pm_runtime_suspend" to make sure the
> > > > runtime_suspend callbacks gets called.
> > > 
> > > And as far as I understand, the change creates an explicit requirement
> > > to do either pm_runtime_get/put_sync or pm_runtime_suspend inside
> > > driver's remove callback. If so, that should be mentioned in big red
> > > letters in the pm-runtime documentation.
> > > 
> > > The runtime_pm.txt doc does mention something related to this (and btw,
> > > the doc says pm_runtime_put_sync is being called, which is no longer
> > > true), but nothing clear about how the driver remove callback must be
> > > implemented.
> > 
> > That's correct.
> > 
> > > I tried grepping the kernel sources to find out if pm_runtime_suspend is
> > > widely used to get SoC platform devices to suspend, but it doesn't seem
> > > like it is. I didn't see pm_runtime_get/put_sync being used in remove
> > > callbacks widely either, but that was more difficult one to grep.
> > 
> > I think your observations are valid, which unfortunately means that we'll
> > need to revert the commit in question, because it has changed the behavior
> > that drivers are perfectly fine to expect given the existing documentation
> > etc.  It looks like the change was premature at least.
> > 
> > Greg, I wonder if you can queue up a revert of fa180eb448fa for 3.13, or
> > do you want me to do that?
> 
> Would it be better to leave the runtime-idle callbacks (invoked during
> probe) async and revert only the change to __device_release_driver()?
> 
> Having an async callback after probe shouldn't cause problems, because 
> the driver will then be bound (assuming the probe succeeded).

Right.  OK, I'll prepare a patch.

Thanks,
Rafael

