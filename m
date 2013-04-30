Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab3D3T0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:26:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45089 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab3D3T0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:26:03 -0400
Date: Tue, 30 Apr 2013 12:25:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        paul.mckenney@linaro.org
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: rcu: Provide compile-time control for no-CBs CPUs
Message-ID: <20130430192541.GE3780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130430152126.0C564660906@gitolite.kernel.org>
 <20130430184612.GA14568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430184612.GA14568@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13043019-3620-0000-0000-00000243FAE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:46:12PM -0400, Dave Jones wrote:
> On Tue, Apr 30, 2013 at 03:21:26PM +0000, Linux Kernel wrote:
> 
>  > +choice
>  > +	prompt "Build-forced no-CBs CPUs"
>  > +	default RCU_NOCB_CPU_NONE
>  > +	help
>  > +	  This option allows no-CBs CPUs to be specified at build time.
>  > +	  Additional no-CBs CPUs may be specified by the rcu_nocbs=
>  > +	  boot parameter.
>  > +
>  > +config RCU_NOCB_CPU_NONE
>  > +	bool "No build_forced no-CBs CPUs"
>  > +	depends on RCU_NOCB_CPU
>  > +	help
>  > +	  This option does not force any of the CPUs to be no-CBs CPUs.
>  > +	  Only CPUs designated by the rcu_nocbs= boot parameter will be
>  > +	  no-CBs CPUs.
>  > +
>  > +config RCU_NOCB_CPU_ZERO
>  > +	bool "CPU 0 is a build_forced no-CBs CPU"
>  > +	depends on RCU_NOCB_CPU
>  > +	help
>  > +	  This option forces CPU 0 to be a no-CBs CPU.  Additional CPUs
>  > +	  may be designated as no-CBs CPUs using the rcu_nocbs= boot
>  > +	  parameter will be no-CBs CPUs.
>  > +
>  > +	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
>  > +	  or energy-efficiency reasons.
>  > +
>  > +config RCU_NOCB_CPU_ALL
>  > +	bool "All CPUs are build_forced no-CBs CPUs"
>  > +	depends on RCU_NOCB_CPU
>  > +	help
>  > +	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
>  > +	  boot parameter will be ignored.
>  > +
>  > +	  Select this if all CPUs need to be no-CBs CPUs for real-time
>  > +	  or energy-efficiency reasons.
> 
> Note that entering '?' when prompted in oldconfig only outputs the help
> parameter from the choice section.

I must defer to the Kconfig experts on this issue.  I have added them on CC.

> Additionally, nowhere in any of this text does it say what a "no-CB CPU" is,
> or why I would care, or even what the downsides are for each option.

In the absence of any Kconfig change, would the following be more helpful?

+choice
+	prompt "Build-forced no-CBs CPUs"
+	default RCU_NOCB_CPU_NONE
+	help
+	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
+	  from kthreads rather than from softirq context) to be specified
+	  at build time.  Additional no-CBs CPUs may be specified by
+	  the rcu_nocbs= boot parameter.
+
+config RCU_NOCB_CPU_NONE
+	bool "No build_forced no-CBs CPUs"
+	depends on RCU_NOCB_CPU
+	help
+	  This option does not force any of the CPUs to be no-CBs CPUs.
+	  Only CPUs designated by the rcu_nocbs= boot parameter will be
+	  no-CBs CPUs, whose RCU callbacks will be invoked by per-CPU
+	  rcuo kthreads.  All other CPUs will invoke their own RCU
+	  callbacks in softirq context.
+
+config RCU_NOCB_CPU_ZERO
+	bool "CPU 0 is a build_forced no-CBs CPU"
+	depends on RCU_NOCB_CPU
+	help
+	  This option forces CPU 0 to be a no-CBs CPU, so that its
+	  RCU callbacks are invoked by a per-CPU rcuo kthread.
+	  Additional CPUs may be designated as no-CBs CPUs using the
+	  rcu_nocbs= boot parameter will be no-CBs CPUs.  All other CPUs
+	  will invoke their own RCU callbacks in softirq context.
+
+	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
+	  or energy-efficiency reasons.
+
+config RCU_NOCB_CPU_ALL
+	bool "All CPUs are build_forced no-CBs CPUs"
+	depends on RCU_NOCB_CPU
+	help
+	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
+	  boot parameter will be ignored.  All CPUs' RCU callbacks will
+	  be executed in the context of per-CPU rcuo kthreads created
+	  for this purpose.
+
+	  Select this if all CPUs need to be no-CBs CPUs for real-time
+	  or energy-efficiency reasons.

> I nominate this changeset for an award for most obtuse kconfig text in 3.10 (so far)

Woo-hoo!!!  An award!  ;-)

							Thanx, Paul

