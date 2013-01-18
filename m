Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3ARS5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 13:57:50 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:50697 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3ARS5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 13:57:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id
	:subject:from:to:cc:date:in-reply-to:references:content-type
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=vRg1f0
	V4cZR0TYTiTBSquJF7J+7zXFjyCMZ400dYSsDM7o3fkYw13pAyAEnLxJwLE0J95h
	4YcOlkDULhYRuJWMq65eqzwqFo3N3VnlL1goL+IsHEZoI11Jm4RPX3lRm+QsuqOM
	ziDxsrfbSzA1spSi1p728a2V1bqR+kMEgfdys=
Message-ID: <1358535466.23663.40.camel@orca.stoopid.dyndns.org>
Subject: Re: [PATCH 1/2] leds: simply LED trigger list management
From: Nathan Lynch <ntl@pobox.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Jan 2013 12:57:46 -0600
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E19873@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E17700@DQHE02.ent.ti.com>
 <1358448677.26320.22.camel@doorstop.aus.2wire.com>
 <A874F61F95741C4A9BA573A70FE3998F69E19873@DQHE02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: F36375F2-61A0-11E2-9503-0A4F0E5B5709-04752483!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-18 at 00:00 +0000, Kim, Milo wrote:
> > -----Original Message-----
> > From: Nathan Lynch [mailto:ntl@pobox.com]
> > 
> > On Thu, 2013-01-17 at 01:06 +0000, Kim, Milo wrote:
> > > @@ -242,17 +233,15 @@ EXPORT_SYMBOL_GPL(led_trigger_unregister);
> > >  void led_trigger_event(struct led_trigger *trig,
> > >  			enum led_brightness brightness)
> > >  {
> > > -	struct list_head *entry;
> > > +	struct led_classdev *led_cdev;
> > >
> > >  	if (!trig)
> > >  		return;
> > >
> > >  	read_lock(&trig->leddev_list_lock);
> > > -	list_for_each(entry, &trig->led_cdevs) {
> > > -		struct led_classdev *led_cdev;
> > > -
> > > -		led_cdev = list_entry(entry, struct led_classdev,
> > trig_list);
> > > -		led_set_brightness(led_cdev, brightness);
> > > +	list_for_each_entry(led_cdev, &leds_list, node) {
> > > +		if (led_cdev->trigger == trig)
> > > +			led_set_brightness(led_cdev, brightness);
> > >  	}
> > >  	read_unlock(&trig->leddev_list_lock);
> > 
> > Continuing to use trig->leddev_list_lock doesn't seem right.  Shouldn't
> > traversal of leds_list be guarded by the leds_list_lock rwsem?  And if
> > so, is it safe to use a potentially-blocking lock in this context?
> > 
> 
> (Sorry for the typo in title: 'simply' -> 'simplify')
> 
> Thanks for your opinion. I agree with you.
> The read_lock()/unlock() of 'leddev_list_lock' should be replaced with
> down_read()/up_read() of 'leds_list_lock'.
> Then, RW lock of led_trigger can be removed also.

But led_trigger_event() can be called from atomic/interrupt context, no?
We can't use a rwsem in this path.

And I meant to mention earlier -- this change would cause this function
to scan all led devices in the system, whereas right now it consults
only the leds that are associated with the trigger.  That seems like a
step backwards for a potentially performance-sensitive path.


> BTW, I need more education about the concurrency.
> We can see complex RW down/up safe code with list management in LED class driver.
> RW semaphores are 'leds_list_lock', 'triggers_list_lock' and 'trigger_lock'.
> Are those are safe access in case a user-space via sysfs and driver API calls by
>  LED device(s) can happen at the same time?
> If so, can we make them more simple?
>
> I think *entry point* of access can be wrapped with semaphores or MUTEX
> rather than guard code for accessing LED lists one by one.

It seems to me that the relatively fine-grained lists and locks that
exist right now provide a certain level of flexibility and performance
that would be hard to achieve with a coarser model.


