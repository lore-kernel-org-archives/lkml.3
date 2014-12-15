Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaLOOZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:25:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:44375 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaLOOZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:25:43 -0500
Date: Mon, 15 Dec 2014 15:25:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Huang Ying <ying.huang@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>,
        Rick Jones <netperf-feedback@netperf.org>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org
Subject: Re: [LKP] [genirq] c291ee62216:
In-Reply-To: <1418627248.5745.186.camel@intel.com>
Message-ID: <alpine.DEB.2.11.1412151220330.16494@nanos>
References: <1418627248.5745.186.camel@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014, Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/urgent
> commit c291ee622165cb2c8d4e7af63fffd499354a23be ("genirq: Prevent proc race against freeing of irq descriptors")
> 
> testbox/testcase/testparams: lkp-nex04/netperf/performance-300s-200%-SCTP_STREAM

>                            time.voluntary_context_switches
> 
>   100500 ++-----------------------------------------------------------------+
>          O       O                    O          O                          |
>          |  O                            O          O                       |
>   100000 ++           O  O  O O     O          O                            |
>          |    O                  O          O          O                    |
>          |          O                                                       |
>    99500 ++                                                                 |
>          |                                                                  |
>    99000 ++                                                                 |
>          |                                                                  |
>          |                                                                  |
>    98500 ++        .*.*..                          .*.. .*..    .*..*..     |
>          *..*.*..*.      *..*.*..*..*.*..*..*..*.*.    *    *..*       *.*..*
>          |                                                                  |
>    98000 ++-----------------------------------------------------------------+
> 
> 
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample

Cute. Looking at netperf source it seems to do a high frequency
readout of /proc/stat from all involved threads. Which of course
explains that the number of context switches is going up as the stuff
is going to content on the sparse_irq_mutex.

While its possible to fix^W band aid that case, I'm really not too
happy to do so just to please a wreckaged use case. High frequency
polling of /proc/stat is just asking for trouble and on larger
machines it's a complete scalability fail. Especially the interrupt
part is amazingly horrible

      for_each_irq_nr()
	for_each_possible_cpu()

Is it really required for netperf to do that stat poll in a loop or
can it be made smarter?

Btw, in that test scenario runs netserver and the test threads on the
same machine. So the utilization data is pretty useless anyway because
all threads will read more or less the same data which cannot be
correlated to a particular instance.

Thanks,

	tglx

