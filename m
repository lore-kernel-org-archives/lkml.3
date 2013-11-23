Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3KWDDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 22:03:44 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51150 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3KWDDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 22:03:41 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	<1385168197-8612-5-git-send-email-davidlohr@hp.com>
	<CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
Date: Fri, 22 Nov 2013 19:03:40 -0800
X-Google-Sender-Auth: g3BIJaO9NKS8X7RPNAkZifHzZ8o
Message-ID: <CAGQ1y=6qQ4SbyRKuKxp0TBQBS4O5NniHN12RL_aePG01xCtZFw@mail.gmail.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Jason Low <jason.low2@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        jeffm@suse.com, "Norton, Scott J" <scott.norton@hp.com>,
        tom.vaden@hp.com, "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 5:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 22, 2013 at 4:56 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> In futex_wake() there is clearly no point in taking the hb->lock if
>> we know beforehand that there are no tasks to be woken. This comes
>> at the smaller cost of doing some atomic operations to keep track of
>> the list's size.
>
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
>     if (!list_empty(waiters))
>         wake_up_list(..)
>
> because they wouldn't wake people up who just got added.
>
> But considering that your atomic counter checking has the same lack of
> serialization, at least the plist_head_empty() check shouldn't be any
> worse than that counter thing.. And doesn't need any steenking atomic
> ops or a new counter field.

Hi Linus,

In this patch, since we do the atomic increments before holding the
hb->lock during situations where we may potentially add a task to the
list, then we would only skip attempting the wake up if no other
thread has already held the hb->lock and is in the process of adding a
task to the list, in addition to the list being empty. Would this be
enough to protect it from any race condition?

Thanks,
Jason
