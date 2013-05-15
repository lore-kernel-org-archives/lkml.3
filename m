Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab3EOIht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:37:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52412
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757466Ab3EOIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:37:47 -0400
Date: Wed, 15 May 2013 10:37:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        dzickus@redhat.com
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130515083729.GC10510@laptop.programming.kicks-ass.net>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 06:02:51PM +0200, Frederic Weisbecker wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Trying to test the nohz_full code, I was not able to get it to work.
> Finally I enabled the tick_stop tracepoint and it showed:
> 
>  tick_stop:            success=no msg=perf events running
> 
> I talked to Frederic Weisbecker about this and he informed me that
> perf is used by the lockup detector. I checked the code, and sure
> enough it is.
> 
> As perf is always running when LOCKUP_DETECTOR is enabled, which
> will always disable nohz_full from working, instead of confusing
> users, disable LOCKUP_DETECTOR when NO_HZ_FULL is enabled.
> 
> When perf is changed such that it does not prevent nohz_full from
> working, then we can and should remove this constraint.

That's a bit contradictory in function, you want the NMI watchdog to
cover all code, so disabling whilst entering NO_HZ state is going to
make it not cover some code - *fail*.

Rather I would suggest disabling the NMI watchdog's runtime default; so
you can still enable it with something like: 

  echo 1 > /proc/sys/kernel/nmi_watchdog

