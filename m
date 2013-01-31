Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3AaKqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:46:01 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55260 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3AaKps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:45:48 -0500
Date: Thu, 31 Jan 2013 11:45:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] rwsem-spinlock: let rwsem write lock stealable
Message-ID: <20130131104541.GA2291@gmail.com>
References: <1359537244-20588-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20130131093931.GA398@gmail.com>
 <20130131100927.GY12678@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131100927.GY12678@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> > > output with this patch:
> > > -----------------------
> > > cpu 00:   0   0   ...   1   1   2   1   1   1   2   1   1   1 .... 1   3
> > > cpu 01:   0   0   ...   1   1   1   1   1   1   2   1   1   1 .... 1   3
> > > cpu 02:   0   0   ...   2   2   3   2   0   2   1   2   1   1 .... 1   1
> > > cpu 03:   0   0   ...   2   2   3   2   1   2   1   2   1   1 .... 1   1
> > > cpu 04:   0   1   ...   2   0   0   1   0   1   3   1   1   1 .... 1   1
> > > cpu 05:   0   1   ...   2   0   1   1   0   1   2   1   1   1 .... 1   1
> > > cpu 06:   0   0   ...   2   1   1   2   0   1   2   1   1   1 .... 2   1
> > > cpu 07:   0   0   ...   2   1   1   2   0   1   2   1   1   1 .... 2   1
> > > cpu 08:   0   0   ...   1   1   1   1   1   1   1   1   1   1 .... 0   0
> > > cpu 09:   0   0   ...   1   1   1   1   1   1   1   1   1   1 .... 0   0
> > > cpu 10:   0   0   ...   1   1   1   0   0   1   1   1   1   1 .... 0   0
> > > cpu 11:   0   0   ...   1   1   1   0   0   1   1   1   1   2 .... 1   0
> > > cpu 12:   0   0   ...   1   1   1   0   1   1   0   0   0   1 .... 2   1
> > > cpu 13:   0   0   ...   1   1   1   0   1   1   1   0   1   2 .... 2   0
> > > cpu 14:   0   0   ...   2   0   0   0   0   1   1   1   1   1 .... 2   2
> > > cpu 15:   0   0   ...   2   0   0   1   0   1   1   1   1   1 .... 2   2
> > > ------------------------------------------------------------------------
> > > Where you can see that CPU is much busier with this patch.
> > 
> > That looks really good - quite similar to how it behaved 
> > with mutexes, right?
> 
> Yes :)
> 
> And the result is almost same with mutex lock when MUTEX_SPIN_ON_OWNER
> is disabled, and that's the reason you will see massive processes(about
> 100) queued on each CPU in my last report:
>     https://lkml.org/lkml/2013/1/29/84

Just curious: how does MUTEX_SPIN_ON_OWNER versus 
!MUTEX_SPIN_ON_OWNER compare, for this particular, 
massively-contended anon-vma locks benchmark?

> > Does this recover most of the performance regression?
> 
> Yes, there is only a 10% gap here then. I guess that's because 
> I used the general rwsem lock 
> implementation(lib/rwsem-spinlock.c), but not the XADD 
> one(lib/rwsem.c). I guess the gap may be a little smaller if 
> we do the same thing to lib/rwsem.c.

Is part of the gap due to MUTEX_SPIN_ON_OWNER perhaps?

I'm surprised that rwsem-spinlock versus rwsem.c would show a 
10% performance difference - assuming you have lock 
debugging/tracing disabled in the .config.

( Once the performance regression is fixed, another thing to 
  check would be to reduce anon-vma lock contention. )

Thanks,

	Ingo
