Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3HZRao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 13:30:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14963 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3HZRan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 13:30:43 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=4YNYSHFQjk8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jyE81Idm5WYA:10 a=VnNF1IyMAAAA:8 a=QpCRJz_wUkxhVmzCEa0A:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 26 Aug 2013 13:30:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130826133041.3d750b1b@gandalf.local.home>
In-Reply-To: <20130826162928.GQ3871@linux.vnet.ibm.com>
References: <20130826145838.GA8377@redhat.com>
	<20130826162928.GQ3871@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 09:29:28 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Mon, Aug 26, 2013 at 10:58:38AM -0400, Dave Jones wrote:
> > Another day, another rcu backtrace..
> > This says rc6, but it's pretty darn close to rc7, I think it was running
> > a build from Friday.
> 
> Could you please send your .config?  Also, were you running ftrace,
> perf, RCU event tracing, or what?
> 
> Looks like you are running ftrace, but I though Steven had set that
> up so that it could be called from an extended quiescent state.
> 

I know exactly what the issue is. Yes ftrace is safe to call even from
these extended quiescent states, the problem is that ftrace is also the
infrastructure of other users, where some of those users are not safe.
Namely, perf.

Right now perf is not safe to trace all functions, as some of those
functions have this issue. I was going to add something like:

FTRACE_NON_SAFE(rcu_eqs_enter);

where it will record locations that are not safe for all users, such
that unless a function registers to ftrace with a flag of
"FTRACE_FL_NON_SAFE_OK", anything that is on the non safe list (from
the macro) will not be traced.

Now, how urgent is this fix? perf can only trace functions as root, and
there's no reason for perf to be tracing all functions at the moment.
But yes, a root user could run that and get this warning. Because I was
going to implement this for 3.12 and not for this release.

-- Steve
