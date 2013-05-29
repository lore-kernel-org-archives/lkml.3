Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035Ab3E2Hjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:39:46 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41148 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935105Ab3E2Hjo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 29 May 2013 03:39:44 -0400
Message-Id: <51A5CCDB02000078000D9798@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 29 May 2013 08:39:39 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: "John Stultz" <john.stultz@linaro.org>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] x86/xen: sync the wallclock when
 the system time changes
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
 <1369765368-10823-3-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1369765368-10823-3-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.05.13 at 20:22, David Vrabel <david.vrabel@citrix.com> wrote:
> +static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
> +				   void *priv)
> +{
> +	static struct timespec last, next;
> +	struct timespec now;
> +	struct timekeeper *tk = priv;
> +	struct xen_platform_op op;
> +	int ret;
> +
> +	/*
> +	 * Set the Xen wallclock from Linux system time.
> +	 *
> +	 * dom0 hasn't historically maintained a very accurate
> +	 * wallclock so guests don't expect it. We can therefore
> +	 * reduce the number of expensive hypercalls by only updating
> +	 * the wallclock every 0.5 s.
> +	 */
> +
> +	now.tv_sec = tk->xtime_sec;
> +	now.tv_nsec = tk->xtime_nsec >> tk->shift;
> +
> +	if (timespec_compare(&now, &last) > 0
> +	    && timespec_compare(&now, &next) < 0)

Is this really working the first time through (when both last and
next are still all zeros)?

Jan

> +		return 0;
> +
>  	op.cmd = XENPF_settime;
> -	op.u.settime.secs = now->tv_sec;
> -	op.u.settime.nsecs = now->tv_nsec;
> +	op.u.settime.secs = now.tv_sec;
> +	op.u.settime.nsecs = now.tv_nsec;
>  	op.u.settime.system_time = xen_clocksource_read();
>  
>  	ret = HYPERVISOR_dom0_op(&op);
>  	if (ret)
> -		return ret;
> +		return 0;
>  
> -	/* Set the hardware RTC. */
> -	return mach_set_rtc_mmss(now);
> +	last = now;
> +	next = timespec_add(now, ns_to_timespec(NSEC_PER_SEC / 2));
>  
> +	return 0;
>  }


