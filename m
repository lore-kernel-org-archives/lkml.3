Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3F1PiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:38:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:46822 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3F1PiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:38:15 -0400
Date: Fri, 28 Jun 2013 17:38:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 5/5] x86/xen: sync the CMOS RTC as well as the Xen
 wallclock
In-Reply-To: <1372329348-20841-6-git-send-email-david.vrabel@citrix.com>
Message-ID: <alpine.DEB.2.02.1306281727240.4013@ionos.tec.linutronix.de>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com> <1372329348-20841-6-git-send-email-david.vrabel@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, David Vrabel wrote:

> From: David Vrabel <david.vrabel@citrix.com>
> 
> Adjustments to Xen's persistent clock via update_persistent_clock()
> don't actually persist, as the Xen wallclock is a software only clock
> and modifications to it do not modify the underlying CMOS RTC.
> 
> The x86_platform.set_wallclock hook can be used to keep the hardware
> RTC synchronized (as on bare metal).  Because the Xen wallclock is now
> kept synchronized by pvclock_gtod notifier, xen_set_wallclock() need
> not do this and dom0 can simply use the native implementation.

I can understand that part, but ...
 
>  static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long was_set,
>  				   void *priv)
>  {
> +	static struct timespec next;
>  	struct timespec now;
>  	struct xen_platform_op op;
>  
> -	if (!was_set)
> -		return NOTIFY_OK;
> -
>  	now = __current_kernel_time();
>  
> +	if (!was_set && timespec_compare(&now, &next) < 0)
> +		return NOTIFY_OK;
> +
>  	op.cmd = XENPF_settime;
>  	op.u.settime.secs = now.tv_sec;
>  	op.u.settime.nsecs = now.tv_nsec;
>  	op.u.settime.system_time = xen_clocksource_read();
>  
>  	(void)HYPERVISOR_dom0_op(&op);
> +
> +	/*
> +	 * Don't update the wallclock for another 11 minutes. This is
> +	 * the same period as the sync_cmos_clock() work.
> +	 */
> +	next = now;
> +	next.tv_sec += 11*60;
> +

How is this related to the changelog? /me is confused .....

