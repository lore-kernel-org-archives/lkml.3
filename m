Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaFKJJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:09:27 -0400
Received: from relay.parallels.com ([195.214.232.42]:55042 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbaFKJJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:09:23 -0400
Date: Wed, 11 Jun 2014 13:09:15 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <avagin@openvz.org>,
        <xemul@parallels.com>, <vdavydov@parallels.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] timerfd: Implement write method
Message-ID: <20140611090914.GA12336@paralelels.com>
References: <20140428212517.200264067@openvz.org>
 <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220643170.9695@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1405220656130.9695@ionos.tec.linutronix.de>
 <20140610163530.GF2243@moon>
 <20140611072743.GA10612@paralelels.com>
 <20140611075125.GI2243@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20140611075125.GI2243@moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.24.36.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 11:51:25AM +0400, Cyrill Gorcunov wrote:
> On Wed, Jun 11, 2014 at 11:27:43AM +0400, Andrew Vagin wrote:

...

> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct timerfd_ctx *ctx = file->private_data;
> +	int ret = 0;
> +
> +	switch (cmd) {
> +	case TFD_IOC_SET_TICKS: {
> +		u64 ticks;
> +
> +		if (get_user(ticks, (u64 __user *)arg))
> +			return -EFAULT;
> +		spin_lock_irq(&ctx->wqh.lock);
> +		ctx->ticks = ticks;
> +		if (ticks)
> +			wake_up_locked(&ctx->wqh);

Setting ticks to zero is equivalent to timerfd_read(), isn't it?
So do we need to re-arme the timer, if it's periodic?

> +		spin_unlock_irq(&ctx->wqh.lock);
> +		break;
> +	}
> +	default:
> +		ret = -ENOTTY;
> +		break;
> +	}
> +
> +V	return ret;
> +}
> +#endif
