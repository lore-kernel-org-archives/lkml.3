Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3AOQdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:33:15 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40920 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab3AOQdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:33:14 -0500
Date: Tue, 15 Jan 2013 08:32:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Message-ID: <20130115163221.GN3384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1357941108-14138-1-git-send-email-ccross@android.com>
 <CAFTL4hzYkPCmkfqBafkTA5E_snkLoC_y3p9xwumj=L1xWAWK0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzYkPCmkfqBafkTA5E_snkLoC_y3p9xwumj=L1xWAWK0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011516-7182-0000-0000-00000472A429
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 01:13:10AM +0100, Frederic Weisbecker wrote:
> 2013/1/11 Colin Cross <ccross@android.com>:
> > Emulate NMIs on systems where they are not available by using timer
> > interrupts on other cpus.  Each cpu will use its softlockup hrtimer
> > to check that the next cpu is processing hrtimer interrupts by
> > verifying that a counter is increasing.
> >
> > This patch is useful on systems where the hardlockup detector is not
> > available due to a lack of NMIs, for example most ARM SoCs.
> > Without this patch any cpu stuck with interrupts disabled can
> > cause a hardware watchdog reset with no debugging information,
> > but with this patch the kernel can detect the lockup and panic,
> > which can result in useful debugging info.
> >
> > Signed-off-by: Colin Cross <ccross@android.com>
> 
> I believe this is pretty much what the RCU stall detector does
> already: checks for other CPUs being responsive. The only difference
> is on how it checks that. For RCU it's about checking for CPUs
> reporting quiescent states when requested to do so. In your case it's
> about ensuring the hrtimer interrupt is well handled.
> 
> One thing you can do is to enqueue an RCU callback (cal_rcu()) every
> minute so you can force other CPUs to report quiescent states
> periodically and thus check for lockups.

This would work in all but one case, and that is where RCU believes
that the non-responsive CPU is in dyntick-idle mode.  In that case,
RCU would not be expecting it to respond and would therefore ignore
any non-responsiveness.

> Now you'll face the same problem in the end: if you don't have NMIs,
> you won't have a very useful report.

Indeed, I must confess that I have thus far chickened out on solving
the general NMI problem.  The RCU stall detector does try to look at
stacks remotely in some cases, but this is often unreliable, and some
architectures seem to refuse to produce a remote stack trace.

							Thanx, Paul

