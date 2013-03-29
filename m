Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3C2TgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:36:25 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41839 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3C2TgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:36:23 -0400
Message-ID: <1364585774.31320.9.camel@thor.lan>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Peter Hurley <peter@hurleysoftware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Date: Fri, 29 Mar 2013 15:36:14 -0400
In-Reply-To: <CA+55aFyj2zfumVUJ7JMhJkQY_LiyQYX+tK4Cu4Jg=g72-amC2g@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	 <20130326192852.GA25899@redhat.com>
	 <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	 <20130329161746.GA8391@redhat.com>
	 <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
	 <20130329190642.GC23893@redhat.com>
	 <CA+55aFyj2zfumVUJ7JMhJkQY_LiyQYX+tK4Cu4Jg=g72-amC2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 12:26 -0700, Linus Torvalds wrote:
> On Fri, Mar 29, 2013 at 12:06 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > Here's an oops I just hit..
> >
> > BUG: unable to handle kernel NULL pointer dereference at 000000000000000f
> > IP: [<ffffffff812c24ca>] testmsg.isra.5+0x1a/0x60
> 
> Btw, looking at the code leading up to this, what the f*ck is wrong
> with the IPC stuff?
> 
> It's using the generic list stuff for most of the lists, but then it
> open-codes the accesses.
> 
> So instead of using
> 
>    for_each_entry(walk_msg, &msq->q_messages, m_list) {
>       ..
>    }
> 
> the ipc/msg.c code does all that by hand, with
> 
>    tmp = msq->q_messages.next;
>    while (tmp != &msq->q_messages) {
>       struct msg_msg *walk_msg;
> 
>       walk_msg = list_entry(tmp, struct msg_msg, m_list);
>       ...
>       tmp = tmp->next;
>    }
> 
> Ugh. The code is near unreadable. And then it has magic memory
> barriers etc, implying that it doesn't lock the data structures, but
> no comments about them. See expunge_all() and pipelined_send().
> 
> The code seems entirely random, and it's badly set up (annoyance of
> the day: crazy helper functions in ipc/msgutil.c to make sure that (a)
> you have to spend more effort looking for them, and (b) they won't get
> inlined).
> 
> Clearly nobody has cared for the crazy IPC message code in a long time.

Exactly that's what my patch series does; clean this mess up.

This is what I wrote to Andrew a couple of days ago.

On Tue, 2013-03-26 at 22:33 -0400, Peter Hurley wrote:
I just figured out how the queue is being corrupted and why my series
> fixes it.
> 
> 
> With MSG_COPY set, the queue scan can exit with the local variable
'msg'
> pointing to a real msg if the msg_counter never reaches the
copy_number.
> 
> The remaining execution looks like this:
> 
> 	if (!IS_ERR(msg)) {
> 		....
> 		if (msgflg & MSG_COPY)
> 			goto out_unlock;
> 		....
> 
> out_unlock:
> 			msg_unlock(msq);
> 			break;
> 		}
> 	}
> 	if (IS_ERR(msg))
> 		....
> 
> 	bufsz = msg_handler();
> 	free_msg(msg);			<<---- msg never unlinked
> 
> 
> Since the msg should not have been found (because it failed the match
> criteria), the if (!IS_ERR(msg)) clause should never have executed.
> 
> That's why my refactor fixes resolve this; because msg is not
> inadvertently treated as a found msg.
> 
> But let's be honest; the real bug here is the poor structure of this
> function that even made this possible. The deepest nesting executes a
> goto to a label in the middle of an if clause. Yuck! No wonder this
> thing's fragile.
> 
> So my recommendation still stands. The series that fixes this has been
> getting tested in linux-next for a month. Fixing this some other way
is
> just asking for more trouble.
> 
> But why not just revert MSG_COPY altogether for 3.9?

Regards,
Peter Hurley

