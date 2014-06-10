Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaFJQMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:12:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:7777 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751771AbaFJQMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:12:32 -0400
Date: Tue, 10 Jun 2014 12:12:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 3/6] tracing: Only calculate stats of
 tracepoint benchmarks for 2^32 times
Message-ID: <20140610121230.368a62a9@gandalf.local.home>
In-Reply-To: <20140610094206.51ab5c02@gandalf.local.home>
References: <20140606163034.516780857@goodmis.org>
	<20140606172104.552734596@goodmis.org>
	<87sindbawt.fsf@sejong.aot.lge.com>
	<20140610094206.51ab5c02@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 09:42:06 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 10 Jun 2014 14:17:54 +0900
> Namhyung Kim <namhyung@gmail.com> wrote:
> 
> > Hi Steve,
> > 
> > On Fri, 06 Jun 2014 12:30:37 -0400, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > >
> > > When calculating the average and standard deviation, it is required that
> > > the count be less than UINT_MAX, otherwise the do_div() will get
> > > undefined results. After 2^32 counts of data, the average and standard
> > > deviation should pretty much be set anyway.
> > 
> > [SNIP]
> > >  	if (bm_cnt > 1) {
> > >  		/*
> > >  		 * Apply Welford's method to calculate standard deviation:
> > >  		 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
> > >  		 */
> > >  		stddev = (u64)bm_cnt * bm_totalsq - bm_total * bm_total;
> > > -		do_div(stddev, bm_cnt);
> > > -		do_div(stddev, bm_cnt - 1);
> > > +		do_div(stddev, (u32)bm_cnt);
> > > +		do_div(stddev, (u32)bm_cnt - 1);
> > >  	} else
> > >  		stddev = 0;
> > 
> > I also think that this if-else can go as it checks bm_cnt == 1 above.
> > 
> 
> I noticed this too, but just to keep gcc from complaining, I left it in.
> 

Oh, and you are talking about the entire if () else block. Yeah, I
thought about that as well, but I'm paranoid about doing a divide by
zero ;-)

It's code for testing purposes only. A fringe of the kernel base. Not a
hot path. Slowness isn't an issue here, but correctness is.

Thanks,

-- Steve
