Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaERSQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 14:16:09 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:23018 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaERSQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 14:16:07 -0400
Message-ID: <1400436962.9463.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 5/5] ipc,msg: loosen check for full queue
From: Davidlohr Bueso <davidlohr@hp.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, akpm@linux-foundation.org,
        aswin@hp.com, linux-kernel@vger.kernel.org
Date: Sun, 18 May 2014 11:16:02 -0700
In-Reply-To: <537608D8.7030000@gmail.com>
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
		 <1400012857-11733-6-git-send-email-davidlohr@hp.com>
		 <5373AF39.7030406@colorfullife.com>
		 <1400097031.3865.25.camel@buesod1.americas.hpqcorp.net>
		 <537440A7.2020707@colorfullife.com>
	 <1400168793.6946.10.camel@buesod1.americas.hpqcorp.net>
	 <537608D8.7030000@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 14:47 +0200, Michael Kerrisk (man-pages) wrote:
> Hi Davidlohr,
> 
> On 05/15/2014 05:46 PM, Davidlohr Bueso wrote:
> > On Thu, 2014-05-15 at 06:20 +0200, Manfred Spraul wrote:
> >> Hi Davidlohr,
> >>
> >> On 05/14/2014 09:50 PM, Davidlohr Bueso wrote:
> >>> Do you have any preferences? I can cook up a patch if you think that
> >>> this merits Linux having MSGTQL.
> >> MSGTQL means a global counter - therefore zero scalability. That's why I 
> >> didn't implement it when I noticed the issue with 0-byte messages.
> > 
> > Hmmm so I was actually thinking of calculating it on demand, but after a
> > closer look, we don't track each queue in the system, which would have
> > made this rather trivial.
> > 
> > We do however have plenty of similar counters in the kernel, and the
> > natural way of dealing with the scalability issue is using percpu
> > counters. But I won't argue much if we leave it as it is, it's been like
> > that since almost forever and no one is complaining but me.
> > 
> > Andrew, could you please drop this patch from -mm, I'll send another one
> > to add a comment instead.
> > 
> >>> Worst case scenario, we should update the msgsnd(2) manpage and document
> >>> this unique Linux behavior.
> >> I would document the current behavior.
> > 
> > Cc'ing Michael. Here is a vague attempt to update our manpage, feel free
> > to update it to your taste.
> > 
> > Thanks,
> > Davidlohr
> > 
> > 8<------------------------------------------------------------
> > From: Davidlohr Bueso <davidlohr@hp.com>
> > Subject: [PATCH] msgop.2: Document full queue criteria
> > 
> > Explicitly mention the two conditions we rely on when
> > checking if a message queue is full when calling msgsnd(2).
> > 
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > ---
> >  man2/msgop.2 | 22 +++++++++++++++++++---
> >  1 file changed, 19 insertions(+), 3 deletions(-)
> > 
> > diff --git a/man2/msgop.2 b/man2/msgop.2
> > index 3f5bc36..b4c8c04 100644
> > --- a/man2/msgop.2
> > +++ b/man2/msgop.2
> > @@ -105,13 +105,29 @@ by
> >  If sufficient space is available in the queue,
> >  .BR msgsnd ()
> >  succeeds immediately.
> > -(The queue capacity is defined by the
> > -.I msg_qbytes
> > +The queue capacity is governed by the
> > +.I msg_qbytes 
> >  field in the associated data structure for the message queue.
> >  During queue creation this field is initialized to
> >  .B MSGMNB
> >  bytes, but this limit can be modified using
> > -.BR msgctl (2).)
> > +.BR msgctl (2).
> > +A full queue is defined by two factors :
> > +.IP * 2
> > +The new msg size + current size of the queue is greater than the 
> > +queue's maximum size (the
> > +.I msg_qbytes
> > +field).
> > +.IP *
> > +The current amount of messages in the queue + 1 (the new msg) is 
> > +greater than the queue's maximum size (the
> > +.I msg_qbytes
> > +field). This is necessary to prevent users from using infinite 
> > +amounts of locked memory (used by the kernel for headers) by 
> > +sending 0-byte messages. This is equivalent to the traditional
> > +MSGTQL parameter present in many Unix systems. This behavior
> > +is unique to Linux.
> > +.PP
> >  If insufficient space is available in the queue, then the default
> >  behavior of
> >  .BR msgsnd ()
> 
> 
> I applied, and reworded a little. Also: I dropped the piece about
> MSGTQL, since it is not quite right. As noted elsewhere on the page
> MSGTQL is a *system-wide* (not per-queue) limit on the number of
> messages in all MQs. Also: I dropped the piece saying this is unique
> to Linux. I believe that's true, but it implies there's a lot
> more standardization around these limits than there actually is
> in my observation.
> 
> Thanks for the patch!

Looks good, thanks Michael.

