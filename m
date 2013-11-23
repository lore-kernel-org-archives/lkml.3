Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3KWEGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 23:06:11 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:30952 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3KWEGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 23:06:07 -0500
Message-ID: <529029A3.4080009@hp.com>
Date: Fri, 22 Nov 2013 23:05:55 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        jeffm@suse.com, "Norton, Scott J" <scott.norton@hp.com>,
        tom.vaden@hp.com, "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com> <1385168197-8612-5-git-send-email-davidlohr@hp.com> <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
In-Reply-To: <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 08:25 PM, Linus Torvalds wrote:
> On Fri, Nov 22, 2013 at 4:56 PM, Davidlohr Bueso<davidlohr@hp.com>  wrote:
>> In futex_wake() there is clearly no point in taking the hb->lock if
>> we know beforehand that there are no tasks to be woken. This comes
>> at the smaller cost of doing some atomic operations to keep track of
>> the list's size.
> Hmm. Why? Afaik, you only care about "empty or not". And if you don't
> need the serialization from locking, then afaik you can just do a
> "plist_head_empty()" without holding the lock.
>
> NOTE!
>
> The "list_empty()" function is very much designed to work even without
> holding a lock (as long as the head itself exists reliably, of course)
> BUT you have to then guarantee yourself that your algorithm doesn't
> have any races wrt other CPU's adding an entry to the list at the same
> time. Not holding a lock obviously means that you are not serialized
> against that.. We've had problems with people doing
>
>      if (!list_empty(waiters))
>          wake_up_list(..)
>
> because they wouldn't wake people up who just got added.
>
> But considering that your atomic counter checking has the same lack of
> serialization, at least the plist_head_empty() check shouldn't be any
> worse than that counter thing.. And doesn't need any steenking atomic
> ops or a new counter field.
>
>              Linus

Before the patch, a waker will wake up one or waiters who call 
spin_lock() before the waker. If we just use plist_head_empty(), we will 
miss waiters who have called spin_lock(), but have not yet got the lock 
or inserted itself into the wait list. By adding atomic counter for 
checking purpose, we again has a single point where any waiters who pass 
that point (inc atomic counter) can be woken up by a waiter who check 
the atomic counter after they inc it. This acts sort of like 
serialization without using a lock.

-Longman
