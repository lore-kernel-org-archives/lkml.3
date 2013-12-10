Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3LJWJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:09:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:2721 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751127Ab3LJWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:09:50 -0500
Date: Tue, 10 Dec 2013 17:09:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210220946.GA6962@home.goodmis.org>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210214143.GG27373@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 04:41:43PM -0500, Dave Jones wrote:
>  > 
>  > OK, thanks. So it doesn't return to user-space.
>  > 
>  > could you do
>  > 
>  > 	cd /sys/kernel/debug/tracing/
>  > 	echo 10818 >> set_ftrace_pid
>  > 	echo function_graph >> current_tracer
>  > 	echo 1 >> tracing_on
>  > 
>  > and look into "trace" file to find out how exactly it loops?
> 
> http://codemonkey.org.uk/junk/trace

Because we are already in the function that is looping, we don't see what
that function is (it's never called).

So you can do either:

trace-cmd record -p function -l get_user_pages_fast --func-stack sleep 5

Which will trace the get_user_pages_fast and spit out a full call trace.

Or if you don't want to use trace-cmd, you can do it by hand.
But be warned! If you don't do this right, you can live lock the system.
Or make it extremely slow. That is, you must have a filter on the
functions you trace before you set the function stack trace flag.
(/me needs to prevent that from happening)

cd /sys/kernel/debug/tracing
echo get_user_pages_fast > set_ftrace_filter
cat set_ftrace_filter
# make sure get_user_pages_fast is there
echo function > current_tracer
echo 1 > options/func_stack_trace

read your trace. Either by:

  cat trace

or

  trace-cmd show

And then after you recorded that.

echo 0 > options/func_stack_trace

to make sure you don't accidently enable stack tracing on *all*
functions. I haven't had that really live lock the system, but
it took about two minutes to disable it again, as each key stroke
took several seconds to compete.

-- Steve

