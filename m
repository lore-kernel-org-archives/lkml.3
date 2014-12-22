Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaLVCp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:45:29 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:34600 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLVCp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:45:28 -0500
X-Original-SENDERIP: 165.186.175.61
X-Original-MAILFROM: hyogi.gim@lge.com
Date: Mon, 22 Dec 2014 11:43:25 +0900
From: Hyogi Gim <hyogi.gim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/rtc/interface.c: check the error after
 __rtc_read_time()
Message-ID: <20141222024325.GA2429@lge.com>
References: <20141217031524.GA22361@lge.com>
 <20141217135150.b02a4581cebd819f0f8f078a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217135150.b02a4581cebd819f0f8f078a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 01:51:50PM -0800, Andrew Morton wrote:
> On Wed, 17 Dec 2014 12:15:24 +0900 Hyogi Gim <hyogi.gim@lge.com> wrote:
> 
> > Add the verification code for returned __rtc_read_time() error in
> > rtc_update_irq_enable() and rtc_timer_do_work().
> > 
> > ...
> L
> > --- a/drivers/rtc/interface.c
> > +++ b/drivers/rtc/interface.c
> > @@ -489,7 +489,10 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
> >  		struct rtc_time tm;
> >  		ktime_t now, onesec;
> >  
> > -		__rtc_read_time(rtc, &tm);
> > +		err = __rtc_read_time(rtc, &tm);
> > +		if (err < 0)
> > +			goto out;
> > +
> >  		onesec = ktime_set(1, 0);
> >  		now = rtc_tm_to_ktime(tm);
> >  		rtc->uie_rtctimer.node.expires = ktime_add(now, onesec);
> 
> I'm not sure about this part.  If __rtc_read_time() returns -EINVAL
> (due to !rtc->ops->read_time) then rtc_update_irq_enable() will go and
> call rtc_dev_update_irq_enable_emul(), inappropriately.
> 
> On the other hand, if __rtc_read_time() returns -EINVAL because that's
> what rtc->ops->read_time() returned then perhaps
> rtc_update_irq_enable() *should* call rtc_dev_update_irq_enable_emul().
> 
> Messy.
> 

As you said, if rtc driver has no read_time callback, rtc_read_time()
is failed in rtc_dev_update_irq_enable_emul() anyway.

rtc_dev_update_irq_enable_emul()
 |_ set_uie()
     |_ rtc_read_time()

What I worried about the error from rtc->ops->read_time().
If rtc->ops->read_time() returns another type of error except -EINVAL,
then rtc interface can't run rtc_dev_update_irq_enable_emul().

I think it needs to be changed that check to ensure error for
rtc_dev_update_irq_enable_emul().

