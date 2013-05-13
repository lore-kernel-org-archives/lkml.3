Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3EMMzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:55:20 -0400
Received: from relay3.sgi.com ([192.48.152.1]:43892 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752600Ab3EMMzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:55:16 -0400
Date: Mon, 13 May 2013 07:55:14 -0500
From: Robin Holt <holt@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: Full dynticks needs evtdesc set before marking cpu online.
Message-ID: <20130513125514.GE3658@sgi.com>
References: <20130508235736.GT3658@sgi.com>
 <alpine.LFD.2.02.1305131119180.2863@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305131119180.2863@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:21:00AM +0200, Thomas Gleixner wrote:
> On Wed, 8 May 2013, Robin Holt wrote:
> 
> > Thomas,
> > 
> > We are seeing failures booting medium sized machines which I think is
> > a change in expectations that dyntick put on x86's start_secondary.
> > 
> > During boot of cpus, we see an occassional panic in tick_do_broadcast at
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1305.0/01818.html
> 
> Will hit Linus tree soon.

I think this is really due to a sequence in start_secondary.  The cpu
has been marked as online, but its evtdesc has not been initialized.
I sent a followup to this with a hack/patch.

It was essentially:
--- linux.orig/arch/x86/kernel/smpboot.c
+++ linux/arch/x86/kernel/smpboot.c
@@ -264,6 +264,8 @@ notrace static void __cpuinit start_seco
         */
        check_tsc_sync_target();
 
+       x86_cpuinit.setup_percpu_clockev();
+
        /*
         * We need to hold vector_lock so there the set of online cpus
         * does not change while we are assigning vectors to cpus.  Holding
@@ -281,8 +283,6 @@ notrace static void __cpuinit start_seco
        /* to prevent fake stack check failure in clock setup */
        boot_init_stack_canary();
 
-       x86_cpuinit.setup_percpu_clockev();
-
        wmb();
        cpu_startup_entry(CPUHP_ONLINE);
 }


Robin
