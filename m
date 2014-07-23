Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbaGWX3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:29:33 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53049 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757992AbaGWX3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:29:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hyogi Gim <hyogi.gim@lge.com>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] driver/rtc/class.c: check the error after rtc_read_time()
Date: Thu, 24 Jul 2014 01:47:57 +0200
Message-ID: <5828425.VYTqh3MBtu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140723145634.656752d0fe2fa124db48b4fc@linux-foundation.org>
References: <1405412723-10062-1-git-send-email-hyogi.gim@lge.com> <20140723145634.656752d0fe2fa124db48b4fc@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2014 02:56:34 PM Andrew Morton wrote:
> On Tue, 15 Jul 2014 17:25:23 +0900 Hyogi Gim <hyogi.gim@lge.com> wrote:
> 
> > In rtc_suspend() and rtc_resume(), the error after rtc_read_time() is not
> > checked. If rtc device fail to read time, we cannot guarantee the following
> > process.
> > 
> > Add the verification code for returned rtc_read_time() error.
> > 
> > ...
> >
> > --- a/drivers/rtc/class.c
> > +++ b/drivers/rtc/class.c
> > @@ -53,6 +53,7 @@ static int rtc_suspend(struct device *dev)
> >  	struct rtc_device	*rtc = to_rtc_device(dev);
> >  	struct rtc_time		tm;
> >  	struct timespec		delta, delta_delta;
> > +	int err;
> >  
> >  	if (has_persistent_clock())
> >  		return 0;
> > @@ -61,7 +62,12 @@ static int rtc_suspend(struct device *dev)
> >  		return 0;
> >  
> >  	/* snapshot the current RTC and system time at suspend*/
> > -	rtc_read_time(rtc, &tm);
> > +	err = rtc_read_time(rtc, &tm);
> > +	if (err < 0) {
> > +		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
> > +		return 0;
> > +	}
> 
> OK, it makes no sense to go ahead and set the system time from a
> garbage rtc_time.
> 
> But I'm wondering if we should propagate the error back to the
> rtc_suspend() caller.  What does the PM core do if a particular
> device's ->suspend or ->resume fails?

It aborts the suspend.

Rafael

