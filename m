Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab3CNJNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:13:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab3CNJNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:13:20 -0400
Date: Thu, 14 Mar 2013 10:13:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] sched: Cputime update for 3.10
Message-ID: <20130314091342.GB1377@redhat.com>
References: <1363196663-4258-1-git-send-email-fweisbec@gmail.com>
 <20130314071427.GB7869@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314071427.GB7869@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 08:14:27AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > Please pull the latest cputime accounting updates that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	sched/core
> > 
> > HEAD: d9a3c9823a2e6a543eb7807fb3d15d8233817ec5
> > 
> > Some users are complaining that their threadgroup's runtime accounting 
> > freezes after a week or so of intense cpu-bound workload. This set tries 
> > to fix the issue by reducing the risk of multiplication overflow in the 
> > cputime scaling code.
> 
> Hm, is this a new bug? When was it introduced and is upstream affected as 
> well?

Commit 0cf55e1ec08bb5a22e068309e2d8ba1180ab4239 start to use scalling
for whole thread group, so increase chances of hitting multiplication
overflow, depending on how many CPUs are on the system.

We have multiplication utime * rtime for one thread since commit
b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa. 

Overflow will happen after:

rtime * utime > 0xffffffffffffffff jiffies

if thread utilize 100% of CPU time, that gives:

rtime > sqrt(0xffffffffffffffff) jiffies

ritme > sqrt(0xffffffffffffffff) / (24 * 60 * 60 * HZ) days

For HZ 100 it will be 497 days for HZ 1000 it will be 49 days.

Bug affect only users, who run CPU intensive application for that
long period. Also they have to be interested on utime,stime values,
as bug has no other visible effect as making those values incorrect.

Stanislaw
