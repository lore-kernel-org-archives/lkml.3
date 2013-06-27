Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3F0O5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:57:23 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:16129 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3F0O5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:57:22 -0400
Message-ID: <51CC528A.4000001@hp.com>
Date: Thu, 27 Jun 2013 10:56:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <20130626201713.GH6123@two.firstfloor.org> <51CB57F6.6010003@hp.com> <20130626212221.GI6123@two.firstfloor.org> <51CB7898.5070206@hp.com> <20130627010658.GL6123@two.firstfloor.org> <51CB9233.7020508@hp.com> <51CB9450.80601@hp.com> <20130627013714.GM6123@two.firstfloor.org>
In-Reply-To: <20130627013714.GM6123@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 09:37 PM, Andi Kleen wrote:
>> It will be hard to know what changes will be needed without knowing
>> the exact semantics of the spinlock functions with lock elision. Can
>> you explain a little more what bizarre semantics you are referring
>> to?
> Totally independent of elision.
>
> For example, what semantics does spin_unlock_wait() have with a ticket
> lock. Where in the queue does it wait?
> It doesn't really make sense with a ticket lock.
>
> What semantics would lockdep put on it?
>
> -Andi

Calling spin_unlock_wait() doesn't put the caller into a queue. It just 
wait until the lock is no longer held by any thread. Yes, there is a 
possibility that the lock can be so busy that it may be hold by various 
threads continuously for a long time making it hard for those who wait 
to proceed. Perhaps, I should change the code to abandon the use of 
spin_unlock_wait(). Instead, I can make it wait for the lock to be free 
with some kind of timeout to make sure that it won't wait too long.

With this timeout mechanism, additional lockdep code shouldn't be needed 
as the code will eventually call spin_lock() if the lock is really busy.

Regards,
Longman
