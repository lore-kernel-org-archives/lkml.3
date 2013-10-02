Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3JBMir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab3JBMio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:38:44 -0400
Date: Wed, 2 Oct 2013 14:38:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf session: Add option to copy events when queueing
Message-ID: <20131002123808.GA20396@krava.brq.redhat.com>
References: <1378496221-61525-1-git-send-email-dsahern@gmail.com>
 <20131002121821.GE10099@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002121821.GE10099@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 02:18:21PM +0200, Jiri Olsa wrote:
> On Fri, Sep 06, 2013 at 01:37:01PM -0600, David Ahern wrote:
> > When processing events the session code has an ordered samples queue which is
> > used to time-sort events coming in across multiple mmaps. At a later point in
> > time samples on the queue are flushed up to some timestamp at which point the
> > event is actually processed.
> > 
> > When analyzing events live (ie., record/analysis path in the same command)
> > there is a race that leads to corrupted events and parse errors which cause
> > perf to terminate. The problem is that when the event is placed in the ordered
> > samples queue it is only a reference to the event which is really sitting in
> > the mmap buffer. Even though the event is queued for later processing the mmap
> > tail pointer is updated which indicates to the kernel that the event has been
> > processed. The race is flushing the event from the queue before it gets
> > overwritten by some other event. For commands trying to process events live
> > (versus just writing to a file) and processing a high rate of events this leads
> > to parse failures and perf terminates.
> 
> hi,
> 'perf top -G dwarf' hit this due to longer callchains
> processing your patch fixed that, thanks! ;-)

ugh... now looking closer on top processing, it does not
seem to use queues ;-\ must be something else then..


> 
> > 
> > Examples hitting this problem are 'perf kvm stat live', especially with nested
> > VMs which generate 100,000+ traces per second, and a command processing
> > scheduling events with a high rate of context switching -- e.g., running
> > 'perf bench sched pipe'.
> >
> > This patch offers live commands an option to copy the event when it is
> > placed in
> > the ordered samples queue.

So I guess you have some other patch that actually sets
session::copy_on_queue?

jirka
