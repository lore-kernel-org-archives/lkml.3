Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3ARAAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:00:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51212 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab3ARAAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:00:48 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Nathan Lynch <ntl@pobox.com>
CC: Bryan Wu <cooloney@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] leds: simply LED trigger list management
Thread-Topic: [PATCH 1/2] leds: simply LED trigger list management
Thread-Index: Ac30TtaxAtsXlGEuQfKWKcphpn75LQAUbzOAABkoedA=
Date: Fri, 18 Jan 2013 00:00:38 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E19873@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E17700@DQHE02.ent.ti.com>
 <1358448677.26320.22.camel@doorstop.aus.2wire.com>
In-Reply-To: <1358448677.26320.22.camel@doorstop.aus.2wire.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0I011Ia000710

> -----Original Message-----
> From: Nathan Lynch [mailto:ntl@pobox.com]
> 
> On Thu, 2013-01-17 at 01:06 +0000, Kim, Milo wrote:
> > @@ -242,17 +233,15 @@ EXPORT_SYMBOL_GPL(led_trigger_unregister);
> >  void led_trigger_event(struct led_trigger *trig,
> >  			enum led_brightness brightness)
> >  {
> > -	struct list_head *entry;
> > +	struct led_classdev *led_cdev;
> >
> >  	if (!trig)
> >  		return;
> >
> >  	read_lock(&trig->leddev_list_lock);
> > -	list_for_each(entry, &trig->led_cdevs) {
> > -		struct led_classdev *led_cdev;
> > -
> > -		led_cdev = list_entry(entry, struct led_classdev,
> trig_list);
> > -		led_set_brightness(led_cdev, brightness);
> > +	list_for_each_entry(led_cdev, &leds_list, node) {
> > +		if (led_cdev->trigger == trig)
> > +			led_set_brightness(led_cdev, brightness);
> >  	}
> >  	read_unlock(&trig->leddev_list_lock);
> 
> Continuing to use trig->leddev_list_lock doesn't seem right.  Shouldn't
> traversal of leds_list be guarded by the leds_list_lock rwsem?  And if
> so, is it safe to use a potentially-blocking lock in this context?
> 

(Sorry for the typo in title: 'simply' -> 'simplify')

Thanks for your opinion. I agree with you.
The read_lock()/unlock() of 'leddev_list_lock' should be replaced with
down_read()/up_read() of 'leds_list_lock'.
Then, RW lock of led_trigger can be removed also.

BTW, I need more education about the concurrency.
We can see complex RW down/up safe code with list management in LED class driver.
RW semaphores are 'leds_list_lock', 'triggers_list_lock' and 'trigger_lock'.
Are those are safe access in case a user-space via sysfs and driver API calls by
 LED device(s) can happen at the same time?
If so, can we make them more simple?

I think *entry point* of access can be wrapped with semaphores or MUTEX
rather than guard code for accessing LED lists one by one.

I would like to have your opinion and others' too.

Best Regards,
Milo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
