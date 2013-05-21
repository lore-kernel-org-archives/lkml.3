Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3EUSNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:13:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab3EUSNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:13:13 -0400
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] ktap 0.1 released
References: <519AF05E.1050808@huawei.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 21 May 2013 14:13:09 -0400
In-Reply-To: <519AF05E.1050808@huawei.com> (jovi.zhangwei@huawei.com's message of "Tue, 21 May 2013 11:56:14 +0800")
Message-ID: <y0m8v38jj62.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"zhangwei(Jovi)" <jovi.zhangwei@huawei.com> writes:

> I'm pleased to announce that ktap release v0.1, this is the first official
> release of ktap project [...]

Congrats.


> = what's ktap?
>
>    Because this is the first release, so there wouldn't include too
>    much features, just contain several basic features about tracing,
>    [...]

Nice progress.  Reviewing the safety/security items from
https://lkml.org/lkml/2013/1/17/623, I see improvement in most.

For example, you seem to be using GFP_ATOMIC for run-time memory
allocation, which is safer than before (though still could exhaust
resources).  OTOH your code doesn't handle *failure* of such
allocation attempts (see call sites to kp_*alloc).

There still doesn't seem to be safety constraints on the incoming
byte code (like jump ranges, or loop counts).

It's nice to see some arithmetic OP_* checks, and the user_string
function is probably safe enough now.  You'll need something analogous
for kernel space (and possibly as verification for the various %s
kp_printfs).  The hash tables might be susceptible to the deliberate
hash collision attacks from last year.

It's nice to see the *_STACK_SIZE constraints in the bytecode
interpreter; is there any C-level recursion remaining to consume
excessive kernel stack?

Exposing os.sleep/os.wait (or general kernel functions) to become
callable from the scripts is fraught with danger.  You just can't call
the underlying functions from random kernel context (imagine from the
most pessimal possible kprobe or tracepoint, somewhere within an
atomic section), and you'll get crashes.

You should write several time/space/invasivity stress-tests to help
see how future progress improves the code's performance/safety on
these and other problem areas.


> = Planned Changes
>
>    we are planning to enable more kernel ineroperability into ktap [...]

As per the above, you'll want to be extremely careful about the idea
to export FFI to let the lua scripts call into arbitrary kernel
functions.  Perhaps wrap it into a 'guru' mode flag?


- FChE
