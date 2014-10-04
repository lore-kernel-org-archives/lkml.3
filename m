Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaJDOMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 10:12:51 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:53356 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaJDOMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 10:12:50 -0400
Date: Sat, 4 Oct 2014 16:12:44 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slowdown due to threads bouncing between HT cores
Message-ID: <20141004141244.GB27832@sesse.net>
References: <20141003194428.GA27084@sesse.net>
 <87a95cq7es.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a95cq7es.fsf@tassilo.jf.intel.com>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 06:41:15AM -0700, Andi Kleen wrote:
> - something else gets scheduled on these logical CPUs, so
> the scheduler tries to balance to run queue lengths
> 
> You could check that with perf timechart or perf sched record/map
> or kernelshark.

I've never read any of these maps before, but perf sched map really doesn't
indicate to me that there's a lot of other stuff going on. It seems to mainly
show a lot of Stockfish processes bouncing around seemingly randomly with not
much understanding of hyperthread pairs. Of course, there's the odd other
job, including ksoftirq or an RCU process.

I can send you a copy of the map if you want to, but it is of course rather
large.

> - there is some IO or communication which causes wakeup affinity.

There's a fair amount of communication between the threads; I don't know the
architecture very deeply (multithreading in chess is rather nontrivial),
but as far as I know, the worker threads access shared data through shm,
sometimes using pthread mutexes to lock some of it.

This also means, by the way, that occasionally they will sleep. They're not
by default going to hog the CPU 100% of the time, more like 90%.

> You could try disabling WAKEUP_PREEMPTION or NEXT_BUDDY in 
> /sys/kernel/debug/sched_features

NO_NEXT_BUDDY was already set. (Changing it to NEXT_BUDDY didn't seem to help
anything.) I tried setting NO_WAKEUP_PREEMPTION, and it didn't make a
difference that I could see; they still bounce around a lot.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
