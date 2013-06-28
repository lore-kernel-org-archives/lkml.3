Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3F1NrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:47:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:46327 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab3F1NrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:47:02 -0400
Date: Fri, 28 Jun 2013 15:46:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <waiman.long@hp.com>
cc: Andi Kleen <andi@firstfloor.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
In-Reply-To: <51CC528A.4000001@hp.com>
Message-ID: <alpine.DEB.2.02.1306281536020.4013@ionos.tec.linutronix.de>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <20130626201713.GH6123@two.firstfloor.org> <51CB57F6.6010003@hp.com> <20130626212221.GI6123@two.firstfloor.org> <51CB7898.5070206@hp.com>
 <20130627010658.GL6123@two.firstfloor.org> <51CB9233.7020508@hp.com> <51CB9450.80601@hp.com> <20130627013714.GM6123@two.firstfloor.org> <51CC528A.4000001@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Waiman Long wrote:
> On 06/26/2013 09:37 PM, Andi Kleen wrote:
> > > It will be hard to know what changes will be needed without knowing
> > > the exact semantics of the spinlock functions with lock elision. Can
> > > you explain a little more what bizarre semantics you are referring
> > > to?
> > Totally independent of elision.
> > 
> > For example, what semantics does spin_unlock_wait() have with a ticket
> > lock. Where in the queue does it wait?
> > It doesn't really make sense with a ticket lock.
> > 
> > What semantics would lockdep put on it?
> > 
> > -Andi
> 
> Calling spin_unlock_wait() doesn't put the caller into a queue. It just wait
> until the lock is no longer held by any thread. Yes, there is a possibility
> that the lock can be so busy that it may be hold by various threads
> continuously for a long time making it hard for those who wait to proceed.
> Perhaps, I should change the code to abandon the use of spin_unlock_wait().
> Instead, I can make it wait for the lock to be free with some kind of timeout
> to make sure that it won't wait too long.

Please no timeout heuristics. They are bound to be wrong.

If the lock is held by some other cpu, then waiting for it with
unlock_wait() or a magic timeout is probably equally expensive as just
going into the slow path right away.

Thanks,

	tglx
