Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaAVTJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:09:09 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:36042 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaAVTJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:09:07 -0500
Date: Wed, 22 Jan 2014 20:09:05 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140122190905.GA391@x4>
References: <52DEF495.2020304@oracle.com>
 <20140122104532.GJ31570@twins.programming.kicks-ass.net>
 <20140122120048.GB389@x4>
 <20140122120757.GL31570@twins.programming.kicks-ass.net>
 <20140122122609.GA392@x4>
 <20140122123022.GN31570@twins.programming.kicks-ass.net>
 <20140122131456.GA389@x4>
 <52DFD50E.800@oracle.com>
 <20140122183538.GA389@x4>
 <20140122184253.GN30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122184253.GN30183@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.01.22 at 19:42 +0100, Peter Zijlstra wrote:
> On Wed, Jan 22, 2014 at 07:35:38PM +0100, Markus Trippelsdorf wrote:
> 
> > >FYI it happens on real hardware on my machine:
> 
> > >[   60.375384] process: using AMD E400 aware idle routine
> 
> > But this is a different issue. I've bisected it to:
> > 
> > commit 20d1c86a57762f0a33a78988e3fc8818316badd4
> > Author: Peter Zijlstra <peterz@infradead.org>
> > Date:   Fri Nov 29 15:40:29 2013 +0100
> > 
> >     sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs
> > 
> > Reverting the commit "fixes" the issue:
> 
> Hurm..

Turns out the fix is simple:

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a3acbac2ee72..d90f7a11d573 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1198,8 +1198,8 @@ void __init tsc_init(void)
 	 * up if their speed diverges)
 	 */
 	for_each_possible_cpu(cpu) {
-		cyc2ns_init(cpu);
 		set_cyc2ns_scale(cpu_khz, cpu);
+		cyc2ns_init(cpu);
 	}
 
 	if (tsc_disabled > 0)

-- 
Markus
