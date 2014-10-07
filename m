Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaJGMsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:48:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:55084 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaJGMsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:48:09 -0400
Date: Tue, 7 Oct 2014 14:47:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, wei@redhat.com, acme@kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86:  Tone down kernel messages when the
 PMU check fails in a virtual environment
Message-ID: <20141007124757.GH19379@twins.programming.kicks-ass.net>
References: <1411617314-24659-1-git-send-email-wei@redhat.com>
 <tip-cc6cd47e7395bc05c5077009808b820633eb3f18@git.kernel.org>
 <5433053F.6020507@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5433053F.6020507@amacapital.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 02:10:23PM -0700, Andy Lutomirski wrote:
> On 10/02/2014 10:28 PM, tip-bot for Wei Huang wrote:
> >  msr_fail:
> >  	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
> > -	printk(KERN_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
> > +	printk(boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR
> > +	       "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
> >  
> 
> This is bogus.  String concatenation doesn't work like that.
> 
> Try "%sFailed...", boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_ERR :
> KERN_INFO), etc.

Haha, indeed. The hypervisor message is empty in this case. Wei, test
this much? ;-)

---
Subject: perf: Fix bogus kernel printk

Andy spotted the fail in what was intended as a conditional printk
level.

Fixes: cc6cd47e7395 ("perf/x86: Tone down kernel messages when the PMU check fails in a virtual environment")
Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -243,8 +243,9 @@ static bool check_hw_exists(void)
 
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
-	printk(boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR
-	       "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
+	printk("%sFailed to access perfctr msr (MSR %x is %Lx)\n",
+		boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR,
+		reg, val_new);
 
 	return false;
 }
