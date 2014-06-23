Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaFWWLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:11:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaFWWLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:11:22 -0400
Date: Mon, 23 Jun 2014 15:11:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Hunt <johunt@akamai.com>
Cc: linux-kernel@vger.kernel.org, jbaron@akamai.com
Subject: Re: [PATCH] panic: add TAINT_SOFTLOCKUP
Message-Id: <20140623151121.44f17779004e94ab620b837c@linux-foundation.org>
In-Reply-To: <1401847955-3345-1-git-send-email-johunt@akamai.com>
References: <1401847955-3345-1-git-send-email-johunt@akamai.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Jun 2014 22:12:35 -0400 Josh Hunt <johunt@akamai.com> wrote:

> This taint flag will be set if the system has ever entered a softlockup
> state. Similar to TAINT_WARN it is useful to know whether or not the system
> has been in a softlockup state when debugging.
> 
> ...
>
> @@ -329,6 +329,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  
>  		if (softlockup_panic)
>  			panic("softlockup: hung tasks");
> +		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
>  		__this_cpu_write(soft_watchdog_warn, true);
>  	} else
>  		__this_cpu_write(soft_watchdog_warn, false);

Would make more sense to have applied the taint *before* calling
panic()?

diff -puN kernel/watchdog.c~panic-add-taint_softlockup-fix kernel/watchdog.c
--- a/kernel/watchdog.c~panic-add-taint_softlockup-fix
+++ a/kernel/watchdog.c
@@ -368,9 +368,9 @@ static enum hrtimer_restart watchdog_tim
 			smp_mb__after_atomic();
 		}
 
+		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
-		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		__this_cpu_write(soft_watchdog_warn, true);
 	} else
 		__this_cpu_write(soft_watchdog_warn, false);

