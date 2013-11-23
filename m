Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3KWBZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:25:29 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:52333 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3KWBZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:25:26 -0500
MIME-Version: 1.0
In-Reply-To: <1385168197-8612-5-git-send-email-davidlohr@hp.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	<1385168197-8612-5-git-send-email-davidlohr@hp.com>
Date: Fri, 22 Nov 2013 17:25:25 -0800
X-Google-Sender-Auth: iU64uknGF6ZqyiEYtDDbcX3bKQ4
Message-ID: <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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

On Fri, Nov 22, 2013 at 4:56 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> In futex_wake() there is clearly no point in taking the hb->lock if
> we know beforehand that there are no tasks to be woken. This comes
> at the smaller cost of doing some atomic operations to keep track of
> the list's size.

Hmm. Why? Afaik, you only care about "empty or not". And if you don't
need the serialization from locking, then afaik you can just do a
"plist_head_empty()" without holding the lock.

NOTE!

The "list_empty()" function is very much designed to work even without
holding a lock (as long as the head itself exists reliably, of course)
BUT you have to then guarantee yourself that your algorithm doesn't
have any races wrt other CPU's adding an entry to the list at the same
time. Not holding a lock obviously means that you are not serialized
against that.. We've had problems with people doing

    if (!list_empty(waiters))
        wake_up_list(..)

because they wouldn't wake people up who just got added.

But considering that your atomic counter checking has the same lack of
serialization, at least the plist_head_empty() check shouldn't be any
worse than that counter thing.. And doesn't need any steenking atomic
ops or a new counter field.

            Linus
