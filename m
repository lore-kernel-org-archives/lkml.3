Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaENTui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:50:38 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:44843 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaENTug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:50:36 -0400
Message-ID: <1400097031.3865.25.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 5/5] ipc,msg: loosen check for full queue
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: akpm@linux-foundation.org, aswin@hp.com, linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 12:50:31 -0700
In-Reply-To: <5373AF39.7030406@colorfullife.com>
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
	 <1400012857-11733-6-git-send-email-davidlohr@hp.com>
	 <5373AF39.7030406@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manfred,

On Wed, 2014-05-14 at 20:00 +0200, Manfred Spraul wrote:
> Hi Davidlohr, Hi Andrew,
> 
> On 05/13/2014 10:27 PM, Davidlohr Bueso wrote:
> > When sending a message, we must guarantee that there will be
> > enough room in the queue to add it, otherwise wait until space
> > becomes available -- which requires blocking the calling task.
> > Currently, this relies meeting both of the following conditions:
> >
> > (i) The new msg size + current size is lower than the queue's max size.
> > (ii) The current amount of messages in the queue + 1 (this msg) is lower
> >       than the queue's max size.
> >
> > While (i) is obvious and well documented in the msgsnd(2) manpage, the
> > second one is far more ambiguous and does not serve the purpose, as we do
> > not control the amount of messages in the queue (unlike posix queues do).
> > Thus remove (ii) and loosen how we check for space.
> I know that (ii) is undocumented and not part of SUS, but I think it is 
> required:

Yeah, I was kind of expecting something to come up, which is why I
suggested it as an RFC in the cover letter.

> Otherwise it would be possible to use up an infinite amount of locked 
> memory by sending 0-byte messages.

Locked as in unswapable used by the kernel internally, right? I agree,
that would be a bad thing to do.

> I added it some long time ago, and at that time I didn't check what the 
> other sysv msg implementation were doing.
> 
>  From a quick search:
> 
> FreeBSD:
> - Optional: RACCT_MSGQQUEUED
> - Always: The number of messages is limited due to a global array 
> (limited to MSGTQL entries: array msghdrs, free list  free_msghdrs)
> 
> http://fxr.watson.org/fxr/source/kern/sysv_msg.c
> 
> Opensolaris:
> - Also a limit of the number of messages:
> http://fxr.watson.org/fxr/source/common/os/msg.c?v=OPENSOLARIS;im=bigexcerpts#L1166
> 
> - it appears that it is related to MSGTQL:
> http://fxr.watson.org/fxr/source/common/os/msg.c?v=OPENSOLARIS;im=bigexcerpts#L652
> 
> I.e.: We cannot remove the check unless we add another mechanism that 
> limits the number of messages.

Looking further, HP-UX also implements this, so it seems to be quite
common in Unix, ie: http://nixdoc.net/man-pages/HP-UX/man5/msgtql.5.html

I am very aware that sysv ipc is no longer as sexy and popular as it
once was (before my time :-), but I'm wondering if we should actually
implement MSGTQL. The thing is, I really hate how we're mixing things
here, ie: number of msg in a queue vs the size of the queue. That seems
simply wrong and misleading, and I wouldn't mind changing that. On the
other hand, I am not aware of programs using msgq sleeping frequently
because of this.

Do you have any preferences? I can cook up a patch if you think that
this merits Linux having MSGTQL.

Worst case scenario, we should update the msgsnd(2) manpage and document
this unique Linux behavior.

It seems that Linux 3.16 will be the "lets dig around the long forgotten
corners of sysv ipc" release :)

Thanks,
Davidlohr

