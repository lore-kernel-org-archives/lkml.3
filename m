Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaDHGm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:42:28 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63243 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaDHGm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:42:26 -0400
Date: Tue, 8 Apr 2014 10:42:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com, tglx@linutronix.de,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com
Subject: Re: [patch 1/3] timerfd: Implement show_fdinfo method
Message-ID: <20140408064223.GD23983@moon>
References: <20140407174701.734703531@openvz.org>
 <20140407174933.641611536@openvz.org>
 <5343946A.6000601@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5343946A.6000601@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 10:17:14AM +0400, Vladimir Davydov wrote:
...
> > +static int timerfd_show(struct seq_file *m, struct file *file)
> > +{
> > +	struct timerfd_ctx *ctx = file->private_data;
> > +	struct itimerspec t;
> > +
> > +	spin_lock_irq(&ctx->wqh.lock);
> > +	t.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
> > +	t.it_interval = ktime_to_timespec(ctx->tintv);
> > +	spin_unlock_irq(&ctx->wqh.lock);
> > +
> > +	return seq_printf(m,
> > +			  "clockid: %d\n"
> > +			  "ticks: %llu\n"
> > +			  "settime flags: 0%o\n"
> > +			  "it_value: (%llu, %llu)\n"
> > +			  "it_interval: (%llu, %llu)\n",
> 
> IMO, one would expect to setup the timer on restore by passing the
> values of settime_flags, it_value, and it_interval obtained from the
> fdinfo to sys_timerfd_settime, but this will be incorrect, because AFAIU
> the it_value you report here is always relative to the current time, no
> matter whether TFD_TIMER_ABSTIME was set in settime_flags or not. Is it OK?

Hi Vladimir! Well it_value returns remaining time so it's up to user to
adjust this value when restore with abs time. That said one can examinate
if abs flag was set and restore accordingly. If this is vague I'm open
to change it to more clear way. Ideas?
