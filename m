Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764454Ab3DDSVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:21:46 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:49963 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764368Ab3DDSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:21:45 -0400
X-Greylist: delayed 689 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Apr 2013 14:21:45 EDT
Date: Thu, 4 Apr 2013 18:10:14 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC GIT PULL] nohz: Kconfig layout improvements
In-Reply-To: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
Message-ID: <0000013dd63de989-c6980852-2aac-4597-ba34-3b2efaa24c17-000000@email.amazonses.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.04-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that nohz still has no effect.

3.9-rc5 + patches. Affinity of init set to 0,1 so no
tasks are running on 9. The "latencytest" used here is part of my
lldiag-0.15 toolkit.

First test without any special kernel parameters. nohz off right?

$ nice -5 taskset -c 9 latencytest

CPUs: Freq=2.90Ghz Processors=32 Cores=8 cacheline_size=64 Intel(R)
Xeon(R) CPU E5-2690 0 @ 2.90GHz
16775106 samples below 1000 nsec
13 involuntary context switches
1019 (0.00607411%) variances in 10.00 seconds: minimum 1.07us maximum 12.32us average 3.30us stddev 0.63us

HZ=100 so the 1019 variances are likely timer interrupts.




After nohz setup

/proc/cmdline:

BOOT_IMAGE=/vmlinuz-3.9.0-rc5+ root=/dev/mapper/vg01-root ro console=tty0 console=ttyS0,115200 idle=mwait rcu_nocb_poll rcu_nocbs=2-31 nohz_extended=2-31

$ nice -5 taskset -c 9 latencytest
CPUs: Freq=2.90Ghz Processors=32 Cores=8 cacheline_size=64 Intel(R)
Xeon(R) CPU E5-2690 0 @ 2.90GHz
16779362 samples below 1000 nsec
13 involuntary context switches
1037 (0.00617983%) variances in 10.00 seconds: minimum 1.00us maximum 10.61us average 3.30us stddev 0.98us



If I move the RCU threads off the cpu then I get a slightly better result:

$ nice -5 taskset -c 9 latencytest
CPUs: Freq=2.90Ghz Processors=32 Cores=8 cacheline_size=64 Intel(R)
Xeon(R) CPU E5-2690 0 @ 2.90GHz
16796039 samples below 1000 nsec
12 involuntary context switches
1020 (0.00607249%) variances in 10.00 seconds: minimum 1.00us maximum 11.58us average 2.77us stddev 0.55us



Why is the tick not stopping? How do I diagnose this? (I can start
patching the kernel again like last time but isnt there a better way?)


