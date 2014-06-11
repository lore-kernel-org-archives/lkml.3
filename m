Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaFKMnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:43:53 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:55373 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaFKMnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:43:52 -0400
Date: Wed, 11 Jun 2014 16:43:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, avagin@openvz.org,
        xemul@parallels.com, vdavydov@parallels.com,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] timerfd: Implement write method
Message-ID: <20140611124348.GE15786@moon>
References: <20140428212517.200264067@openvz.org>
 <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220643170.9695@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1405220656130.9695@ionos.tec.linutronix.de>
 <20140610163530.GF2243@moon>
 <20140611072743.GA10612@paralelels.com>
 <20140611075125.GI2243@moon>
 <20140611090914.GA12336@paralelels.com>
 <20140611095246.GJ2243@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611095246.GJ2243@moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 01:52:46PM +0400, Cyrill Gorcunov wrote:
> On Wed, Jun 11, 2014 at 01:09:15PM +0400, Andrew Vagin wrote:
> > On Wed, Jun 11, 2014 at 11:51:25AM +0400, Cyrill Gorcunov wrote:
> > > On Wed, Jun 11, 2014 at 11:27:43AM +0400, Andrew Vagin wrote:
> > 
> > Setting ticks to zero is equivalent to timerfd_read(), isn't it?
> > So do we need to re-arme the timer, if it's periodic?
> 
> I must admit I'm not really sure if we should rearm it in such
> case. In general @ticks are zeroified in case of timer-setup/cancel/read.
> 
>  - lets consider someone armed the timer it triggered but no read done
>    yet, instead ioctl called and @ticks are set to zero, then call for
>    read() and it returns zero to caller not rearming the timer (in
>    current patch approach and non-block read)
> 
>  - in turn if we rearm timer on @ticks = 0 in ioctl this makes it
>    close to behaviour of read() function (which in turn look to
>    me as a duplication of read() interface).
> 
> That said, I'm not sure yet...

What if we prohibit setting non-zero values here? @ticks are set to
zero on timerfd_setup thus there is always a way to create a timer
with fields zeroified. Something like

	case TFD_IOC_SET_TICKS: {
		u64 ticks;

		if (get_user(ticks, (u64 __user *)arg))
			return -EFAULT;
		if (!ticks)
			return -EINVAL;

		spin_lock_irq(&ctx->wqh.lock);
		if (!timerfd_canceled(ctx)) {
			ctx->ticks = ticks;
			if (ticks)
				wake_up_locked(&ctx->wqh);
			else
		} else
			ret = -ECANCELED;
		spin_unlock_irq(&ctx->wqh.lock);
		break;
	}
?
