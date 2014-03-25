Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaCYSOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:14:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaCYSOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:14:33 -0400
Date: Tue, 25 Mar 2014 11:14:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        andi.kleen@intel.com, rob@landley.net, viro@zeniv.linux.org.uk,
        oleg@redhat.com, gnomes@lxorguk.ukuu.org.uk, riel@redhat.com,
        snorcht@gmail.com, dhowells@redhat.com, luto@amacapital.net,
        daeseok.youn@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Pre-emption control for userspace
Message-Id: <20140325111437.8e7b7c86.akpm@linux-foundation.org>
In-Reply-To: <5331C34F.9020604@oracle.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	<1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
	<20140325104410.25e06c4d.akpm@linux-foundation.org>
	<5331C34F.9020604@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014 11:56:31 -0600 Khalid Aziz <khalid.aziz@oracle.com> wrote:

> On 03/25/2014 11:44 AM, Andrew Morton wrote:
> > So the procfs file is written in binary format and is read back in
> > ascii format.  Seems odd.
> >
> > Perhaps this should all be done as a new syscall rather than some
> > procfs thing.
> >
> 
> I didn't want to add yet another syscall which will then need to be 
> added to glibc, but I am open to doing it through a syscall if that is 
> the consensus.
> 
> >> +	struct preempt_delay {
> >> +		u32 __user *delay_req;		/* delay request flag pointer */
> >> +		unsigned char delay_granted:1;	/* currently in delay */
> >> +		unsigned char yield_penalty:1;	/* failure to yield penalty */
> >> +	} sched_preempt_delay;
> >
> > The problem with bitfields is that a write to one bitfield can corrupt
> > a concurrent write to the other one.  So it's your responsibility to
> > provide locking and/or to describe how this race is avoided.  A comment
> > here in the definition would be a suitable way of addressing this.
> >
> 
> I do not have a strong reason to use a bitfield, just trying to not use 
> any more bytes than I need to. If using a char is safer, I would rather 
> use safer code.

My point is that the locking rules should be documented, via a code comment.

Presumably that rule is "only ever modified by this task".

> >> +	if (delay_req) {
> >> +		int ret;
> >> +
> >> +		pagefault_disable();
> >> +		ret = __copy_from_user_inatomic(&delay_req_flag, delay_req,
> >> +				sizeof(u32));
> >> +		pagefault_enable();
> >
> > This all looks rather hacky and unneccesary.  Can't we somehow use
> > plain old get_user() and avoid such fuss?
> 
> get_user() takes longer and can sleep if page fault occurs. I need this 
> code to be very fast for it to be beneficial and am willing to ignore 
> page faults since page fault would imply the task has not touched 
> pre-emption delay request field and hence we can resched safely.

That's what I meant by "hacky" :)


