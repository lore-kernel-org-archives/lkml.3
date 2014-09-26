Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaIZKsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:48:18 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37859 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaIZKsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:48:16 -0400
Message-ID: <1411728487.3852.9.camel@hornet>
Subject: Re: [PATCH 2/2] perf: Userspace software event and ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Fri, 26 Sep 2014 11:48:07 +0100
In-Reply-To: <20140925183342.GB6854@gmail.com>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
	 <1411050873-9310-3-git-send-email-pawel.moll@arm.com>
	 <1411491764.3922.46.camel@hornet> <20140924074942.GB3797@gmail.com>
	 <1411665649.4768.84.camel@hornet> <20140925183342.GB6854@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 19:33 +0100, Ingo Molnar wrote:
> > How would we select tasks that can write to a given buffer? Maybe an
> > ioctl() on a perf fd? Something like this?
> > 
> > 	ioctl(perf_fd, PERF_EVENT_IOC_ENABLE_UEVENT, pid);
> > 	ioctl(perf_fd, PERF_EVENT_IOC_DISABLE_UEVENT, pid);
> 
> No, I think there's a simpler way: this should be a regular 
> perf_attr flag, which defaults to '0' (tasks cannot do this), but 
> which can be set to 1 if the profiler explicitly allows such 
> event injection.

As in: allows *all* tasks to inject the data? Are you sure we don't want
more fine-grained control, in particular per task?

If we have two buffers, both created with the "injecting allowed" flag,
do we inject a given uevent into both of them?

> I.e. whether user-events are allowed is controlled by the 
> profiling/tracing context, via the regular perf syscall. It would 
> propagate into the perf context, so it would be easy to check at 
> event generation time.

It would definitely be the profiling/tracing tools that would decide if
the injection is allowed, no question about that. I just feel that it
should be able to select the tasks that can do that, not just flip a big
switch saying "everyone is welcome". Other question is: should a
non-root context be able to receive events from root processes? Wouldn't
it be a security hole (for example, it could be used as a kind of covert
channel)? Maybe we should do what ptrace does? As in: if a task can
ptrace another task, it can also receive uevents from it.

Pawel



