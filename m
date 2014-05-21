Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaEUV5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:57:12 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64718 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaEUV5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:57:10 -0400
Date: Thu, 22 May 2014 01:57:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com,
        vdavydov@parallels.com
Subject: Re: [patch 3/3] timerfd: Implement write method
Message-ID: <20140521215707.GH12819@moon>
References: <20140428212517.200264067@openvz.org>
 <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220642100.9695@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405220642100.9695@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 06:43:08AM +0900, Thomas Gleixner wrote:
> On Tue, 29 Apr 2014, Cyrill Gorcunov wrote:
> > +static ssize_t timerfd_write(struct file *file, const char __user *buf,
> > +			     size_t count, loff_t *ppos)
> > +{
> > +	struct timerfd_ctx *ctx = file->private_data;
> > +	u64 ticks = 0;
> > +
> > +	if (count < sizeof(ticks))
> > +		return -EINVAL;
> > +
> > +	if (get_user(ticks, (u64 __user *) buf))
> > +		return -EFAULT;
> > +
> > +	spin_lock_irq(&ctx->wqh.lock);
> > +	ctx->ticks = ticks;
> 
> So what wakes a potential waiter in read/poll?

Why should it? You mean the scenario when timer is armed then
someone writes nonzero @ticks and we should wake waiters?
The idea was to setup this ticks on timer restore without
waking anyone. If it breaks the logic of timerfd in general,
then sure I need to rework. Hm?
