Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3KWDTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 22:19:40 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:48454 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab3KWDTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 22:19:39 -0500
Message-ID: <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        jeffm@suse.com, "Norton, Scott J" <scott.norton@hp.com>,
        tom.vaden@hp.com, "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>
Date: Fri, 22 Nov 2013 19:19:33 -0800
In-Reply-To: <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385168197-8612-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 17:25 -0800, Linus Torvalds wrote:
> On Fri, Nov 22, 2013 at 4:56 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > In futex_wake() there is clearly no point in taking the hb->lock if
> > we know beforehand that there are no tasks to be woken. This comes
> > at the smaller cost of doing some atomic operations to keep track of
> > the list's size.
> 
> Hmm. Why? Afaik, you only care about "empty or not". And if you don't
> need the serialization from locking, then afaik you can just do a
> "plist_head_empty()" without holding the lock.

I remember this being the original approach, but after noticing some
strange behavior we quickly decided it wasn't the path. And sure enough,
I just double checked and tried the patch without atomic ops and can see
things being off: one of the futextest performance cases is stuck
blocked on a futex and I couldn't reboot the machine either -- nothing
apparent in dmesg, just not 100% functional. The thing is, we can only
avoid taking the lock only if nobody else is trying to add itself to the
list.

Thanks,
Davidlohr

