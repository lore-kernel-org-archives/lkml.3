Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaIYAsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 20:48:46 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42957 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaIYAso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 20:48:44 -0400
Date: Wed, 24 Sep 2014 17:48:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudlx@outlook.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Benson Leung <bleung@google.com>,
        Patrik Fimml <patrikf@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/14] input: cyapa: re-architecture driver to support
 multi-trackpads in one driver
Message-ID: <20140925004838.GB38891@core.coreip.homeip.net>
References: <53c7718c.ae67460a.0495.4979@mx.google.com>
 <20140821182101.GC5854@core.coreip.homeip.net>
 <53f70235.610e450a.3800.ffff83c7@mx.google.com>
 <20140924001839.GA16747@core.coreip.homeip.net>
 <BAY176-DS93497D6BEA95BFE466BC1BDB10@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY176-DS93497D6BEA95BFE466BC1BDB10@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:08:31PM +0800, Dudley Du wrote:
> > > > > +	async_schedule(cyapa_detect_async, cyapa);
> > > >
> > > > I think I already asked this before - why do we need to try and schedule
> > async
> > > > detect from interrupt handler. In what cases we will fail to initialize
> > the
> > > > device during normal probing, but then are fine when stray interrupt
> > arrives?
> > > >
> > >
> > > 1) Because gen5 TP devices use interrupt to sync the command and response,
> > and
> > > in detecting, some commands must be sent and executed in attached devices,
> > so
> > > the interrupt must be usable in detecting.
> > > So if do not schedule async detect from interrupt handler, the interrupt
> > > handler will be taken, and cannot enter again, which will cause the command
> > to
> > > the device failed, it will also cause long time detecting.
> > > 2) detecting will fail when no device attached or the attached device is not
> > > supported gen3 or gen5 TP devices or there is some issue with the device
> > > that cannot enter into active working mode or stay in bootloader mode
> > > for invalid firmware detected.
> > > And it's tested that it's save when stray interrupt arrives in detecting.
> > 
> > 
> > I am sorry, I have trouble parsing this. I understand that you may need
> > interrupt to know when command response is ready, but I do not see how
> > kicking asynchronous detect helps there. During probe you can figure out
> > if you are talking to a Cypress device and whether it is operable. If it
> > is not operable you can try flashing a new firmware and then kick off
> > detection again after flash is successful. But I do not see any reason
> > in trying to re-detect the device after random interrupt arrives in hopes
> > that maybe this time stars will align and we'll be able to work with it.
> 
> Considering two situations:
> 1) For some machines, when system get into sleep mode, the power of the trackpad device
> will be cut off, and after system resumed, the power to trackpad device is on again.

And cyapa_resume() is responsible for bringing the device back into
operational state.

> 2) For the trackpad device itself, if internal error encounter, it will reset itself,
> similar result as power off and power on again.
> When either of above situation happened, for gen3 Cypress trackpad device, it will get
> into bootloader mode (it cannot get into operational mode automatically), and also assert
> interrupts to host.
> So at this time, cyapa driver must kick off the detection again to determine the real status 
> of the trackpad device, and command it go to the operational mode.
> Otherwise, it will be out of work until reboot.

In this case you won't have cyapa_default_irq_handler installed, right?
The specific generation IRQ handler will have to detect this condition
and reinitialize the touchpad.

...

> > > > > @@ -898,8 +528,12 @@ static int cyapa_remove(struct i2c_client *client)
> > > > >  	struct cyapa *cyapa = i2c_get_clientdata(client);
> > > > >
> > > >
> > > > You schedule detect asynchronously so you need to make sure it is not
> > running
> > > > (and will not be running) when you try to unbind the driver here.
> > >
> > > Thanks. I will update it in next release.
> > >
> > > To avoid this problem, a removed flag is introduced and is also synced by
> > the
> > > cyapa->state_sync_lock mutex lock. So when this driver is removing, it's
> > sure
> > > that the detecting asynchronous thread is not running, and if there's any
> > event
> > > cause the asynchronous thread is entered, it will do nothing and will exit
> > immediately.
> > 
> > Peeking at the other version of the patch you do:
> > 
> > cyapa_remove()
> > {
> > 	...
> > 	cyapa->removed = true;
> > 	...
> > 	kfree(cyapa);
> > }
> > 
> > and
> > 
> > void cyapa_detect_async(void *data, async_cookie_t cookie)
> > {
> > 	...
> > 	if (cyapa->removed) {
> > 		mutex_unlock(&cyapa->state_sync_lock);
> > 		return;
> > 	}
> > 	...
> > }
> > 
> > That's not going to work.
> > 
> > Getting asynchronous behavior by individual driver is hard and I believe
> > Luis Rordiguez is working on allowing to do that is the driver core. So
> > I would recommend to switch driver to do synchronous probing, at least
> > for now, and figure out other kinks first.
> > 
> > Thanks.
> > 
> 
> The consideration of the thread asynchronous issue is that:
> The detection thread has been scheduled, but not run yet, and at the time,
> the driver itself has been removed, so when later the detection thread is
> triggered to run, the memory of cyapa driver has been freed, and cause error, right?

Right.

> 
> I have an idea as below, please help review.
> Add variable cyapa->detect_thread_actived to trace the number of the threads were scheduled,
> and when the driver module is in removing, it will wait all scheduled threads has been run.
> That is when a thread is scheduled, cyapa->detect_thread_actived will be increased,
> when the thread is executed and finished, the cyapa->detect_thread_actived  will be decrreased,
> so, when the value of cyapa->detect_thread_actived is 0, it must be no thread scheduled for running.
> So when at this time, if the driver module is marked for removed, the remove() thread that waiting
> on the cyapa->detect_thread_completed will be issue, and then driver is safe to be removed.
> The code is similar as below.
> 
> For each time, before the cyapa_detect_async() function is called or scheduled,
> ... {
> 	...
> 	atomic_inc(&cyapa->detect_thread_actived);
> 	async_schedule(cyapa_detect_async, cyapa);
> 	...
> }
> 
> void cyapa_detect_async(void *data, async_cookie_t cookie)
> {
> 	...
> 	if (cyapa->removed) {
> 		mutex_unlock(&cyapa->state_sync_lock);
> 		return;
> 	}
> 	...
> 	free_irq(cyapa->irq, cyapa);
> 
> 	/* Wait until all scheduled thread exited. */
> 	if (atomic_read(&cyapa->detect_thread_actived)
> 		wait_for_completion_timeout(&cyapa->detect_thread_completed,
> 					msecs_to_jiffies(4000));
> 	...
> }
> 
> void cyapa_detect_async(void *data, async_cookie_t cookie)
> {
> 	struct cyapa *cyapa = (struct cyapa *)data;
> 
> 	mutex_lock(&cyapa->state_sync_lock);
> 	if (cyapa->removed) {
> 		mutex_unlock(&cyapa->state_sync_lock);
> 		if (atomic_dec_and_test(&cyapa->detect_thread_actived)) {
> 			/* Now, no thread runing, safe to remove this driver. */
> 			complete(&cyapa->detect_thread_completed);
> 		}
> 		goto return;
> 	}
> 
> 	/* Keep synchronized with sys interface process threads. */
> 	cyapa_detect(cyapa);
> 
> 	mutex_unlock(&cyapa->state_sync_lock);
> 	atomic_dec(&cyapa->detect_thread_actived);
> }

It can be made to work, but as I mentioned we are working on bringing
asynchronous probing into device core in one form or another so I'd
rather not be doing it in the driver at all at this time.

Thanks.

-- 
Dmitry
