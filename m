Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaEUWMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:12:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:45387 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaEUWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:12:23 -0400
Date: Thu, 22 May 2014 07:12:30 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com,
        vdavydov@parallels.com
Subject: Re: [patch 3/3] timerfd: Implement write method
In-Reply-To: <20140521215707.GH12819@moon>
Message-ID: <alpine.DEB.2.02.1405220658530.9695@ionos.tec.linutronix.de>
References: <20140428212517.200264067@openvz.org> <20140428213301.507657833@openvz.org> <alpine.DEB.2.02.1405220642100.9695@ionos.tec.linutronix.de> <20140521215707.GH12819@moon>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Cyrill Gorcunov wrote:
> On Thu, May 22, 2014 at 06:43:08AM +0900, Thomas Gleixner wrote:
> > On Tue, 29 Apr 2014, Cyrill Gorcunov wrote:
> > > +static ssize_t timerfd_write(struct file *file, const char __user *buf,
> > > +			     size_t count, loff_t *ppos)
> > > +{
> > > +	struct timerfd_ctx *ctx = file->private_data;
> > > +	u64 ticks = 0;
> > > +
> > > +	if (count < sizeof(ticks))
> > > +		return -EINVAL;
> > > +
> > > +	if (get_user(ticks, (u64 __user *) buf))
> > > +		return -EFAULT;
> > > +
> > > +	spin_lock_irq(&ctx->wqh.lock);
> > > +	ctx->ticks = ticks;
> > 
> > So what wakes a potential waiter in read/poll?
> 
> Why should it? You mean the scenario when timer is armed then
> someone writes nonzero @ticks and we should wake waiters?
> The idea was to setup this ticks on timer restore without
> waking anyone. If it breaks the logic of timerfd in general,
> then sure I need to rework. Hm?

There is a world outside of checkpoint/restore, really.

So what's the semantics of that write function? We really want to have
that agreed on and documented in the man page.

Right now the write will just update the ticks and nothing else. So
what if there is a waiter already? What if there is a timer armed?

Can you please describe how checkpoint/restore is going to use all of
this. How is the timer restored and how/when is the reader which was
waiting in read/poll at the time of suspend reattached to it.

Thanks,

	tglx
