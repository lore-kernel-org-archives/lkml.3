Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaLCJec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:34:32 -0500
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:38890 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751866AbaLCJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:34:29 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2393:2553:2559:2562:2895:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:4605:5007:6261:6690:7576:7875:7903:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12740:13161:13229:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ball84_26dc745781605
X-Filterd-Recvd-Size: 4295
Date: Wed, 3 Dec 2014 04:34:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH 3/3] ftracetests: Add test to test event filter logic
Message-ID: <20141203043423.6c7e4524@gandalf.local.home>
In-Reply-To: <547ED753.3060508@hitachi.com>
References: <20141203031334.174087814@goodmis.org>
	<20141203032106.156623189@goodmis.org>
	<547ED753.3060508@hitachi.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2014 18:26:43 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/12/03 12:13), Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Add a test to test the event filter logic. It currently tests the
> > following filters against sched:sched_switch event.
> > 
> >    ( prev_pid != 0 )
> >    ( prev_pid == 0 )
> >    ( prev_pid < 100 )
> >    ( prev_pid <= $$ )
> >    ( prev_pid > 100 )
> >    ( prev_pid >= $$ )
> >   ! ( prev_pid != 0 )
> >   ! ( prev_pid == 0 )
> >   ! ( prev_pid < 100 )
> >   ! ( prev_pid <= $$ )
> >   ! ( prev_pid > 100 )
> >   ! ( prev_pid >= $$ )
> >    ( prev_pid != 0 && next_pid > 10 )
> >    ( prev_pid != 0 || next_pid > 10 )
> >   ! ( prev_pid != 0 && next_pid > 10 )
> >   ! ( prev_pid != 0 || next_pid > 10 )
> >    ( prev_pid & 1 )
> >    ( prev_pid & 2 )
> >    ( prev_pid & 4 )
> >    ( prev_pid & 8 )
> >    ( prev_pid & 16 )
> >   ! ( prev_pid & 1 )
> >   ! ( prev_pid & 2 )
> >   ! ( prev_pid & 4 )
> >   ! ( prev_pid & 8 )
> >   ! ( prev_pid & 16 )
> >    ( next_comm ~ "ftrace-test-fil" )
> >    ( next_comm != "ftrace-test-fil" )
> >   ! ( next_comm ~ "ftrace-test-fil" )
> >   ! ( next_comm != "ftrace-test-fil" )
> > 
> 
> Hmm, this uses some bash-only syntax, here is the result of checkbashisms.
> 
> # checkbashisms tools/testing/selftests/ftrace/test.d/ftrace/filter.tc
> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 70 (should be 'b = a'):
>             if [ "$not" == '!' ]; then
> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 99 (should be 'b = a'):
>             if [ "$not" == '!' ]; then
> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 137 (let ...):
>     let x=1
> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 148 (let ...):
>             let val="$pid & $x"
> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 155 (should be 'b = a'):
>             elif [ "$not" == '!' ]; then
> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 160 (let ...):
>         let x="$x << 1"
> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 182 (should be 'b = a'):
>             if [ "$not" == '!' ]; then
> 
> to allow run this on busybox or dash, we'd better clean it.

Do you know how to fix this?

> 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> [...]
> > +# Test more complex compares (&& and !!)
> > +test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" ''
> > +test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" ''
> 
> This might better be
> test_cmp2 -ne 0 -a -gt 10 "!= 0" "&&" "> 10" ''
> test_cmp2 -ne 0 -o -gt 10 "!= 0" "||" "> 10" ''
> 
> :-)

Sure.

OK, I'll hold off on sending this patch then till 3.20.

I'll still add the update to the kernel for 3.19, but the testing for
it needs work. It passes my test suite, but I don't know how to handle
the busybox limitations.

-- Steve

> 
> > +
> > +test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" '!'
> > +test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" '!'
> 
> Thank you,
> 
> 

