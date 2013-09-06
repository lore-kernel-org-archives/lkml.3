Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab3IFTcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:32:17 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37963 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab3IFTcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:32:15 -0400
Date: Fri, 6 Sep 2013 12:32:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        josh@joshtriplett.org, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        darren@dvhart.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 8/9] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130906193205.GW3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
 <20130906173047.GT3966@linux.vnet.ibm.com>
 <CAMuHMdVS4jGFOuysknJ_4BcdWRrYU=7KVfO8o_gxf-pVg=5gKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVS4jGFOuysknJ_4BcdWRrYU=7KVfO8o_gxf-pVg=5gKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090619-7182-0000-0000-000008532B42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 08:50:41PM +0200, Geert Uytterhoeven wrote:
> On Fri, Sep 6, 2013 at 7:30 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >> Furthermore, it seems only hexagon, metag, mips, and x86 set NR_CPUS to 1
> >> if !SMP. On other architectures, NR_CPUS is not defined and presumed to be 0.
> >
> > Would it make sense to require that NR_CPUS=1 for !SMP?
> 
> Yes, this looks reasonable to me.
> 
> > I tried creating a NR_CPUS_REALLY as follows:
> >
> > config NR_CPUS_REALLY
> >         int "Fixed version of NR_CPUS"
> >         default NR_CPUS if NR_CPUS
> >         default 1 if !NR_CPUS
> >
> > But this still gave a warning on the first "default" even though it
> > was not in effect.  I also tried using Kconfig "if":
> 
> IIRC, it tries to use the first default first, so the below may work
> (the "if SMP" is probably not needed):
> 
> config NR_CPUS_REALLY
>         int "Fixed version of NR_CPUS"
>         default 1 if !SMP
>         default NR_CPUS if SMP

Seemed like a good idea, but I still get:

	make O=/tmp/e ARCH=m68k defconfig
	  GEN     /tmp/e/Makefile
	*** Default configuration is based on 'multi_defconfig'
	kernel/time/Kconfig:140:warning: 'NR_CPUS_REALLY': number is invalid
	#
	# configuration written to .config
	#

Diff below in case I messed something up.

> > Defining NR_CPUS=1 if !SMP is looking pretty good to me just now.
> > This would probably have other benefits -- I cannot be the only
> > person who ever wanted this.  ;-)
> 
> Sure. I just didn't want to create patches for all architectures without
> having a discussion first.
> 
> And it would be nice if it cuould be done in a central place, without
> touching all architectures.

Agreed, should it prove possible.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 3381f09..cb7a932 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -134,6 +134,11 @@ config NO_HZ_FULL_ALL
 	 Note the boot CPU will still be kept outside the range to
 	 handle the timekeeping duty.
 
+config NR_CPUS_REALLY
+	int "Fixed version of NR_CPUS"
+	default 1 if !SMP
+	default NR_CPUS if SMP
+
 config NO_HZ_FULL_SYSIDLE
 	bool "Detect full-system idle state for full dynticks system"
 	depends on NO_HZ_FULL
@@ -160,7 +165,7 @@ config NO_HZ_FULL_SYSIDLE
 config NO_HZ_FULL_SYSIDLE_SMALL
 	int "Number of CPUs above which large-system approach is used"
 	depends on NO_HZ_FULL_SYSIDLE
-	range 1 NR_CPUS
+	range 1 NR_CPUS_REALLY
 	default 8
 	help
 	 The full-system idle detection mechanism takes a lazy approach

