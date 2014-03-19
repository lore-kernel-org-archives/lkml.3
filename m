Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaCSTnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:43:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:35088 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751502AbaCSTnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:43:41 -0400
Date: Wed, 19 Mar 2014 15:43:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Message-ID: <20140319154339.44c327e3@gandalf.local.home>
In-Reply-To: <20140319193407.GA11257@laptop.programming.kicks-ass.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140319193407.GA11257@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 20:34:07 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Mar 19, 2014 at 03:12:52PM -0400, Steven Rostedt wrote:
> > My question to Tejun is, if we create another workqueue, to add the
> > rdata->work to, would that prevent the above problem? Or what other
> > fixes can we do?
> 
> The way I understand workqueues is that we cannot guarantee concurrency
> like this. It tries, but there's no guarantee.
> 
> WQ_MAX_ACTIVE seems to be a hard upper limit of concurrent workers. So
> given 511 other blocked works, the described problem will always happen.
> 
> Creating another workqueue doesn't actually create more threads.

But I noticed this:

 Before patch:

# ps aux |grep cifs
root      3119  0.0  0.0      0     0 ?        S<   14:17   0:00 [cifsiod]

 After patch:

# ps aux |grep cifs
root      1109  0.0  0.0      0     0 ?        S<   15:11   0:00 [cifsiod]
root      1111  0.0  0.0      0     0 ?        S<   15:11   0:00 [cifsiord]

It looks to me that it does create new threads.

-- Steve


> 
> There is the kthread_work stuff for if you want a guaranteed worker
> thread.

