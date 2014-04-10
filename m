Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965785AbaDJPB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:01:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:38150 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965700AbaDJPBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:01:55 -0400
Date: Thu, 10 Apr 2014 11:01:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Clark Williams <williams@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140410110152.0b1e6c48@gandalf.local.home>
In-Reply-To: <20140410094430.56ca9ee1@sluggy.gateway.2wire.net>
References: <20140409151922.5fa5d999@gandalf.local.home>
	<20140410094430.56ca9ee1@sluggy.gateway.2wire.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 09:44:30 -0500
Clark Williams <williams@redhat.com> wrote:

> I wrote a program named whack_mmap_sem which creates a large (4GB)
> buffer, then creates 2 x ncpus threads that are affined across all the
> available cpus. These threads then randomly write into the buffer,
> which should cause page faults galore.
> 
> I then built the following kernel configs:
> 
>   vanilla-3.13.15  - no RT patches applied

 vanilla-3.*12*.15?

>   rt-3.12.15       - PREEMPT_RT patchset
>   rt-3.12.15-fixes - PREEMPT_RT + rwsem fixes
>   rt-3.12.15-multi - PREEMPT_RT + rwsem fixes + rwsem-multi patch
> 
> My test h/w was a Dell R520 with a 6-core Intel(R) Xeon(R) CPU E5-2430
> 0 @ 2.20GHz (hyperthreaded). So whack_mmap_sem created 24 threads
> which all partied in the 4GB address range.
> 
> I ran whack_mmap_sem with the argument -w 100000 which means each
> thread does 100k writes to random locations inside the buffer and then
> did five runs per each kernel. At the end of the run whack_mmap_sem
> prints out the time of the run in microseconds.
> 
> The means of each group of five test runs are:
> 
>   vanilla.log:  1210117
>        rt.log:  17210953 (14.2 x slower than vanilla)
>  rt-fixes.log:  10062027 (8.3 x slower than vanilla)
>  rt-multi.log:  3179582  (2.x x slower than vanilla)
> 
> 
> As expected, vanilla kicked RT's butt when hammering on the
> mmap_sem. But somewhat unexpectedly, your fixups helped quite a bit

That doesn't surprise me too much. As I removed the check for the
nesting, which also shrunk the size of the rwsem itself (removed the
read_depth from the struct). This itself can give a bonus boost.

Now the question is, how much will this affect real use case scenarios?

-- Steve


> and the multi+fixups got RT back into being almost respectable.
> 
