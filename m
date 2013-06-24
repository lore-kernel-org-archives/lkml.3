Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3FXRA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:00:26 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:40856 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3FXRAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:00:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,929,1363132800"; 
   d="scan'208";a="31500351"
Message-ID: <51C87B26.3010904@citrix.com>
Date: Mon, 24 Jun 2013 18:00:22 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-3-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de> <51C44A09.9010402@citrix.com> <alpine.DEB.2.02.1306212328350.4013@ionos.tec.linutronix.de> <51C824A8.1080305@citrix.com> <alpine.DEB.2.02.1306241753080.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306241753080.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/13 17:30, Thomas Gleixner wrote:
> 
> We already have a synchronous notifier in place and the notifier call
> itself is not expensive. What's expensive is the hypercall and there
> is no way at the moment to figure out whether the update is relevant
> for you or just a tick. Though that's trivial information to provide
> without imposing another notifier including the surrounding mess on
> the core code.

This looks good, thanks.

> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
[...]
> @@ -508,7 +509,7 @@ int do_settimeofday(const struct timespec *tv)
>  
>  	tk_set_xtime(tk, tv);
>  
> -	timekeeping_update(tk, true, true);
> +	timekeeping_update(tk, true, true, true);

These three booleans in a row is getting a bit opaque. How about I also
change it to a set of flags?  e.g.,

timekeeping_updated(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);

David
