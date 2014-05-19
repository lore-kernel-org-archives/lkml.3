Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaESOs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:48:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:56754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaESOs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:48:56 -0400
Date: Mon, 19 May 2014 16:48:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: perf: fuzzer induced mutex_lock_nested BUG
Message-ID: <20140519144851.GO2485@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405191026400.15561@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.10.1405191026400.15561@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:37:11AM -0400, Vince Weaver wrote:
> 
> When sorting through the logs of the weekend's fuzzing I found a bunch of 
> these errors which apparently were not fatal.
> 
> This is a Haswell machine running 3.15-rc5 plus a number of PeterZ 
> patches, so sorry if the results are meaningless due to the extra patches.  
> I was hoping some of the fixes would show up in the mainline at some 
> point, running latest -git is enough of a pain, I don't really have the 
> cycles to be running -next or -tip kernels.
> 
> If you look up the faulting IP it's actually happening at this line in
> lockdep.c __lock_acquire()
> 
> 	if (subclass < NR_LOCKDEP_CACHING_CLASSES)
> 		class = lock->class_cache[subclass];
> 

Yeah, that's a popular place to crash if you feed it garbage. Nothing
lockdep can do about that.

> [ 3884.569315] BUG: unable to handle kernel NULL pointer dereference at 00000000000000b8

> [ 4014.688350]  [<ffffffff810b15be>] lock_acquire+0x9e/0x120
> [ 4014.688353]  [<ffffffff8164f7e0>] mutex_lock_nested+0x50/0x360
> [ 4014.688357]  [<ffffffff8113b62c>] perf_event_init_context+0x8c/0x250
> [ 4014.688358]  [<ffffffff8113b85d>] perf_event_init_task+0x6d/0x70
> [ 4014.688359]  [<ffffffff81062165>] copy_process.part.23+0x6b5/0x1c60
> [ 4014.688362]  [<ffffffff810638e5>] do_fork+0xd5/0x330
> [ 4014.688366]  [<ffffffff81063bc6>] SyS_clone+0x16/0x20
> [ 4014.688367]  [<ffffffff8165b999>] stub_clone+0x69/0x90

Cute, I had not seen that one yet...
