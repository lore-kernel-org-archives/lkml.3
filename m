Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaCLPqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:46:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:29579 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754464AbaCLPqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:46:15 -0400
Date: Wed, 12 Mar 2014 11:46:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140312114611.43547df7@gandalf.local.home>
In-Reply-To: <20140312111100.42ea41c2@gandalf.local.home>
References: <20140307150920.881849073@goodmis.org>
	<y0mr469e9t0.fsf@fche.csb>
	<20140310225820.0f02025d@gandalf.local.home>
	<20140311142650.GB13756@redhat.com>
	<1448078225.73.1394550382164.JavaMail.zimbra@efficios.com>
	<20140311114023.02fcf639@gandalf.local.home>
	<1752080128.130.1394559263621.JavaMail.zimbra@efficios.com>
	<20140311151357.077c5a68@gandalf.local.home>
	<1501695915.977.1394634294978.JavaMail.zimbra@efficios.com>
	<20140312111100.42ea41c2@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To sum up this thread, and get the signal vs noise ratio up.

On Wed, 12 Mar 2014 11:11:00 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> The solution I like the most that I believe will work for both of us,
> is to to move this magic "enable tracepoint in the future" to your
> LTTng module. Have your module register a module load and unload handler
> to be able to see the tracepoints that exist in the module, and you can
> enable them then. When a module is unloaded, your module can do the
> accounting to record that, and the state of its tracepoints. 

This is my final proposal.

I'll add the patch that removes the tracepoint on failure along with
returning -ENODEV. That way, there will be no registered tracepoints
that do not exist.

I'll also make sure that on module unload, the tracepoints are disabled
for the module as well.

Then, you can simply add a module notifier that does the work that you
like, and save and restore the state of named tracepoints and enabled
them on module load. Just set the priority of the notifier to 1
so that it runs after the tracepoint notifier that adds the new
tracepoints to the system.

> 
> Looks like we can have it both ways. A way that works well for the
> kernel, and a way that works well for you. But your module will need to
> do the heavy work for what you want.
> 
> To me, a tracepoint should only be enabled when it exists. If it is
> enabled in module when the module is unloaded, then it should be
> removed after the module has left. If the module is loaded again, it is
> up to the user (or your module) to enable that tracepoint again.

I want to point out that LTTng should not be dictating the way the
kernel works, but it should be the other way around.

-- Steve
