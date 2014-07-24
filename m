Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbaGXARO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:17:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbaGXARM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:17:12 -0400
Date: Wed, 23 Jul 2014 17:19:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Hyogi Gim <hyogi.gim@lge.com>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] driver/rtc/class.c: check the error after
 rtc_read_time()
Message-Id: <20140723171922.216f55bb.akpm@linux-foundation.org>
In-Reply-To: <2138754.87hr75v6vM@vostro.rjw.lan>
References: <1405412723-10062-1-git-send-email-hyogi.gim@lge.com>
	<20140723145634.656752d0fe2fa124db48b4fc@linux-foundation.org>
	<5828425.VYTqh3MBtu@vostro.rjw.lan>
	<2138754.87hr75v6vM@vostro.rjw.lan>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014 01:49:44 +0200 "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> On Thursday, July 24, 2014 01:47:57 AM Rafael J. Wysocki wrote:
> > On Wednesday, July 23, 2014 02:56:34 PM Andrew Morton wrote:
> > > On Tue, 15 Jul 2014 17:25:23 +0900 Hyogi Gim <hyogi.gim@lge.com> wrote:
> > > 
> > > > In rtc_suspend() and rtc_resume(), the error after rtc_read_time() is not
> > > > checked. If rtc device fail to read time, we cannot guarantee the following
> > > > process.
> > > > 
> > > > Add the verification code for returned rtc_read_time() error.
> > > > 
> > > > ...
> > > >
> > > > --- a/drivers/rtc/class.c
> > > > +++ b/drivers/rtc/class.c
> > > > @@ -53,6 +53,7 @@ static int rtc_suspend(struct device *dev)
> > > >  	struct rtc_device	*rtc = to_rtc_device(dev);
> > > >  	struct rtc_time		tm;
> > > >  	struct timespec		delta, delta_delta;
> > > > +	int err;
> > > >  
> > > >  	if (has_persistent_clock())
> > > >  		return 0;
> > > > @@ -61,7 +62,12 @@ static int rtc_suspend(struct device *dev)
> > > >  		return 0;
> > > >  
> > > >  	/* snapshot the current RTC and system time at suspend*/
> > > > -	rtc_read_time(rtc, &tm);
> > > > +	err = rtc_read_time(rtc, &tm);
> > > > +	if (err < 0) {
> > > > +		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
> > > > +		return 0;
> > > > +	}
> > > 
> > > OK, it makes no sense to go ahead and set the system time from a
> > > garbage rtc_time.
> > > 
> > > But I'm wondering if we should propagate the error back to the
> > > rtc_suspend() caller.  What does the PM core do if a particular
> > > device's ->suspend or ->resume fails?
> > 
> > It aborts the suspend.
> 
> I mean, if ->suspend fails, the suspend is aborted.

So what should rtc do in this case?  At present it pretends the read
succeeded.  Either way, this doesn't seem to be the place to be making
such policy decisions..


