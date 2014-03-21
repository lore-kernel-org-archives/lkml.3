Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbaCUMmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:42:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759943AbaCUMmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:42:11 -0400
Date: Fri, 21 Mar 2014 08:41:28 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pavel Shilovsky <piastry@etersoft.ru>, LKML <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Message-ID: <20140321084128.3f499e5c@tlielax.poochiereds.net>
In-Reply-To: <20140321081706.271e390c@gandalf.local.home>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
	<20140320170239.51d20a0e@tlielax.poochiereds.net>
	<20140320222343.4faaa137@gandalf.local.home>
	<CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
	<20140321081706.271e390c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 08:17:06 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 21 Mar 2014 12:32:12 +0400
> Pavel Shilovsky <piastry@etersoft.ru> wrote:
> 
> 
> > Read and write codepaths both obtain lock_sem for read and then wait
> > for cifsiod_wq to complete and release lock_sem. They don't do any
> > lock_sem operations inside their work task queued to cifsiod_wq. But
> > oplock code can obtain/release lock_sem in its work task. So, that's
> > why I agree with Jeff and suggest to move the oplock code to a
> > different work queue (cifsioopd_wq?) but leave read and write
> > codepaths use cifsiod_wq.
> 
> OK, how about I submit a second patch that moves the reader and writer
> to its own "safe" workqueue?
> 
> -- Steve
> 

That'd probably work fine too. The main point is to make sure oplock
breaks run on a different workqueue from where read or write completion
jobs run since they are operating on the lock_sem. The other jobs that
get queued to cifsiod_wq don't touch the lock_sem and shouldn't be a
problem.

-- 
Jeff Layton <jlayton@redhat.com>
