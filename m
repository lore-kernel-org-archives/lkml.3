Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936258Ab3DIUgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:36:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935899Ab3DIUgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:36:48 -0400
Date: Tue, 9 Apr 2013 13:36:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikola Pajkovsky <npajkovs@redhat.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc: use list_for_each_entry for list traversing
Message-Id: <20130409133647.fdb9cd6414ae6da83170fee6@linux-foundation.org>
In-Reply-To: <m3wqsc3ux0.fsf@redhat.com>
References: <63a5135b37c9a45abad27eed9f78d69dd4deba76.1365168828.git.npajkovs@redhat.com>
	<20130408153824.974e9307f83616f90c63e00b@linux-foundation.org>
	<m3wqsc3ux0.fsf@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013 11:39:07 +0200 Nikola Pajkovsky <npajkovs@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > urgh, that code is sick.  What's it doing poking around in the
> > list_head internals?
> 
> No idea, it there from beginning of first kernel importation into
> git. Where is history before git?

The old bitkeeper repo is at
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/old-2.6-bkcvs.git
and goes back to the 2.4->2.5 split iirc.  But this code predates that
- my trusty CVS tree goes back to linux-2.4.2-pre2 (November 2000) and
the list.next hackery is in there.

> >> @@ -253,14 +248,9 @@ static void ss_wakeup(struct list_head *h, int kill)
> >>  
> >>  static void expunge_all(struct msg_queue *msq, int res)
> >>  {
> >> -	struct list_head *tmp;
> >> -
> >> -	tmp = msq->q_receivers.next;
> >> -	while (tmp != &msq->q_receivers) {
> >> -		struct msg_receiver *msr;
> >> +	struct msg_receiver *msr, *t;
> >>  
> >> -		msr = list_entry(tmp, struct msg_receiver, r_list);
> >> -		tmp = tmp->next;
> >> +	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
> >>  		msr->r_msg = NULL;
> >>  		wake_up_process(msr->r_tsk);
> >>  		smp_mb();
> >
> > I think list_for_each_entry() would suffice here.
> 
> I don't know, I found wake_up_sem_queue_do in sem.c and it looks almost same
> except preempt stuff. I'll be dancing around ipc/

wake_up_sem_queue_do() is wrong ;)


