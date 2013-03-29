Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3C2T0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:26:47 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:38670 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3C2T0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:26:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130329190642.GC23893@redhat.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
	<20130329190642.GC23893@redhat.com>
Date: Fri, 29 Mar 2013 12:26:45 -0700
X-Google-Sender-Auth: Wn9MrUwBS8vIGCEoLXpg3JpcDZg
Message-ID: <CA+55aFyj2zfumVUJ7JMhJkQY_LiyQYX+tK4Cu4Jg=g72-amC2g@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 12:06 PM, Dave Jones <davej@redhat.com> wrote:
>
> Here's an oops I just hit..
>
> BUG: unable to handle kernel NULL pointer dereference at 000000000000000f
> IP: [<ffffffff812c24ca>] testmsg.isra.5+0x1a/0x60

Btw, looking at the code leading up to this, what the f*ck is wrong
with the IPC stuff?

It's using the generic list stuff for most of the lists, but then it
open-codes the accesses.

So instead of using

   for_each_entry(walk_msg, &msq->q_messages, m_list) {
      ..
   }

the ipc/msg.c code does all that by hand, with

   tmp = msq->q_messages.next;
   while (tmp != &msq->q_messages) {
      struct msg_msg *walk_msg;

      walk_msg = list_entry(tmp, struct msg_msg, m_list);
      ...
      tmp = tmp->next;
   }

Ugh. The code is near unreadable. And then it has magic memory
barriers etc, implying that it doesn't lock the data structures, but
no comments about them. See expunge_all() and pipelined_send().

The code seems entirely random, and it's badly set up (annoyance of
the day: crazy helper functions in ipc/msgutil.c to make sure that (a)
you have to spend more effort looking for them, and (b) they won't get
inlined).

Clearly nobody has cared for the crazy IPC message code in a long time.

              Linus
