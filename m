Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbbAEWKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:10:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbbAEWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:10:00 -0500
Date: Mon, 5 Jan 2015 14:09:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyril Bur <cyrilbur@gmail.com>
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, drjones@redhat.com,
        dzickus@redhat.com, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, cl@linu.com, fabf@skynet.be,
        atomlin@redhat.com, benzh@chromium.org
Subject: Re: [PATCH 1/2] Add another clock for use with the soft lockup
 watchdog.
Message-Id: <20150105140959.5fe2c0e243f834896199a418@linux-foundation.org>
In-Reply-To: <1419224764-11384-2-git-send-email-cyrilbur@gmail.com>
References: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
	<1419224764-11384-2-git-send-email-cyrilbur@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014 16:06:03 +1100 Cyril Bur <cyrilbur@gmail.com> wrote:

> This permits the use of arch specific clocks for which virtualised kernels can
> use their notion of 'running' time, not the elpased wall time which will
> include host execution time.
> 
> ...
>
> --- a/kernel/sched/clock.c
> +++ b/kernel/sched/clock.c
> @@ -74,6 +74,20 @@ unsigned long long __weak sched_clock(void)
>  }
>  EXPORT_SYMBOL_GPL(sched_clock);
>  
> +/*
> + * Running clock - returns the time that has elapsed while a guest has been
> + * running.
> + * On a guest this value should be sched_clock minus the time the
> + * guest was suspended by the hypervisor (for any reason).
> + * On bare metal this function should return the same as sched_clock.
> + * Architectures and sub-architectures can override this.
> + */
> +unsigned long long __weak running_clock(void)
> +{
> +	return sched_clock();
> +}
> +EXPORT_SYMBOL_GPL(running_clock);

Exporting a weak symbol seems a bit strange, but I guess it will work. 
However nothing *uses* this export and it seems unlikely to me that
anything will do so.

So I'm inclined to zap it, OK?

--- a/kernel/sched/clock.c~add-another-clock-for-use-with-the-soft-lockup-watchdog-fix
+++ a/kernel/sched/clock.c
@@ -86,7 +86,6 @@ unsigned long long __weak running_clock(
 {
 	return sched_clock();
 }
-EXPORT_SYMBOL_GPL(running_clock);
 
 __read_mostly int sched_clock_running;
 
_

