Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3KWHXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 02:23:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:23681 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3KWHXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 02:23:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,757,1378882800"; 
   d="scan'208";a="440352229"
Message-ID: <1385191391.29354.211.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        jeffm@suse.com, "Norton, Scott J" <scott.norton@hp.com>,
        tom.vaden@hp.com, "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>
Date: Fri, 22 Nov 2013 23:23:11 -0800
In-Reply-To: <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385168197-8612-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
	 <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 19:19 -0800, Davidlohr Bueso wrote:
> On Fri, 2013-11-22 at 17:25 -0800, Linus Torvalds wrote:
> > On Fri, Nov 22, 2013 at 4:56 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > > In futex_wake() there is clearly no point in taking the hb->lock if
> > > we know beforehand that there are no tasks to be woken. This comes
> > > at the smaller cost of doing some atomic operations to keep track of
> > > the list's size.
> > 
> > Hmm. Why? Afaik, you only care about "empty or not". And if you don't
> > need the serialization from locking, then afaik you can just do a
> > "plist_head_empty()" without holding the lock.
> 
> I remember this being the original approach, but after noticing some
> strange behavior we quickly decided it wasn't the path. And sure enough,
> I just double checked and tried the patch without atomic ops and can see
> things being off: one of the futextest performance cases is stuck
> blocked on a futex and I couldn't reboot the machine either -- nothing
> apparent in dmesg, just not 100% functional. The thing is, we can only
> avoid taking the lock only if nobody else is trying to add itself to the
> list.

In your usage, the worst case scenario is that you detect 0 when locking
may have blocked and found a waiter. Correct?

In this case, you return 0, instead of 1 (or more).

This suggests to me a bug in the futextest testcase. Which test
specifically hung up waiting?

Futex hangs are almost always bad userspace code (my bad userspace code
in this case ;-)

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


