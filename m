Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab3HTOG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:06:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3HTOGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:06:55 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=F0my4ousGMIA:10 a=rtmEYS8grzxXBPKPYe4A:9 a=CjuIK1q_8ugA:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 20 Aug 2013 10:06:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        Kent Overstreet <kmo@daterainc.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
Message-ID: <20130820100651.32e1b79c@gandalf.local.home>
In-Reply-To: <52131747.4010105@linutronix.de>
References: <20130812163413.GI23040@linutronix.de>
	<520D212F.7030400@localhost>
	<20130815152210.5ed93696@gandalf.local.home>
	<520DCE5F.1040402@linutronix.de>
	<521254A0.6050603@localhost>
	<20130819202903.692097ea@gandalf.local.home>
	<20130819210208.426e01b3@gandalf.local.home>
	<52131747.4010105@linutronix.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 09:14:15 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 08/20/2013 03:02 AM, Steven Rostedt wrote:
> > Looking at it more, I can now see why they did what they did.
> 
> He is the only user in the whole kernel. It is somehow hard to believe
> that it can't be solved differently.
> 

Perhaps. But if I understand the code, this is what they have.

When a request is sent out, the writes must wait till it is complete
before it can do anything, thus the writers wait. When the request
finishes (by a different thread), it releases the reader, then the
writers can continue.

The problem is that the task that sends the request does not wait for
it to finish. But until the request does finish, all writers must wait.
To complicate the matter, it appears that more than one request can be
in transition at a time. That is, its not just a single request the a
writer must wait for, it could be many.

The only way I can think of at the moment to fix this without
non-owner, is to set up a wait queue, and a ref count. Basically have
this:

writer:

  again:
	down_write(lock);
	if (refcount) {
		up_write(lock);
		wait_event(wq, !refcount);
		goto again;
	}

reader:
	down_read(lock);
	refcount++;
	request();
	up_read(lock);

completion:

	down_read(lock);
	refcount--;
	up_read_(lock);

The refcount would need to be an atomic, but I think this would work.

Maybe I'll submit it to get rid of the one user of non_owner().

-- Steve
