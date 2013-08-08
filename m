Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab3HHNHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:07:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211Ab3HHNHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:07:51 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=48llYAvPBHsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=r-PqRJr4KhwA:10 a=8up54zFxcE44aTHxrR4A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375967269.6848.46.camel@gandalf.local.home>
Subject: Re: [BUG] hackbench locks up with perf in 3.11-rc1 and beyond
From: Steven Rostedt <rostedt@goodmis.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameeter <cl@linux.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Date: Thu, 08 Aug 2013 09:07:49 -0400
In-Reply-To: <20130808050441.GA3214@lge.com>
References: <1375934936.6848.41.camel@gandalf.local.home>
	 <20130808050441.GA3214@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 14:04 +0900, Joonsoo Kim wrote:

> Sorry about it.
> Now, I think that this is a buggy commit, so should be reverted.
> 
> For confirm that, could I ask a question about your configuration, Steven?
> I guess, you may set 0 to all kmem caches's cpu_partial via sysfs, doesn't it?

Ah, you're right. As this box is also used to test the -rt patch,
there's a script installed to disable all cpu_partials. This is because
cpu_partials are known to cause non-deterministic behavior in -rt.

I forgot about that script, as this box is used for regular mainline
testing as well.

> 
> In this case, memory leak is possible in following case.
> Code flow of possible leak is follwing case.
> 
> * in __slab_free()
> 1. (!new.inuse || !prior) && !was_frozen
> 2. !kmem_cache_debug && !prior
> 3. new.frozen = 1
> 4. after cmpxchg_double_slab, run the (!n) case with new.frozen=1
> 5. with this patch, put_cpu_partial() doesn't do anything,
> 	because this cache's cpu_partial is 0
> 6. return
> 
> In step 5, leak occur.
> 
> I have a solution to prevent this problem, but in this stage, IMHO,
> reverting it may be better.

Yeah, I would suggest that too. As this seems to be a serious
regression.

Thanks!

-- Steve

