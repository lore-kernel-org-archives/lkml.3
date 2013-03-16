Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3CPTVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 15:21:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24773 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3CPTVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 15:21:23 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=2s8qfAZQTSAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rUnzm6ZD3sEA:10 a=Cxs8l86nFTuuujnqJi8A:9 a=PUjeQqilurYA:10 a=R1ORBWAdiSl-Xi4k:21 a=j_EV8MX9MOrVHnyr:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363461681.25967.114.camel@gandalf.local.home>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 16 Mar 2013 15:21:21 -0400
In-Reply-To: <20130316180141.GB21522@ZenIV.linux.org.uk>
References: <1363441844.2023.17.camel@joe-AO722>
	 <CAErSpo4xN9K+aasX-3v-1PeAJpF+3Vg1WrxFaAKNUA43N3bWBw@mail.gmail.com>
	 <1363456278.2023.40.camel@joe-AO722>
	 <20130316180141.GB21522@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 18:01 +0000, Al Viro wrote:
> On Sat, Mar 16, 2013 at 10:51:18AM -0700, Joe Perches wrote:
> > > This is certainly a neat trick.
> > > 
> > > But I don't really like the fact that it complicates things for every
> > > future code reader, especially when a trivial change in the caller
> > > would accomplish the same thing.  Do you have any idea how much
> > > performance we would gain in exchange for the complication?
> > 
> > Nope.  I believe it's trivial in any case.
> > I just saw Steven's trace hack and thought of seq_printk.
> > 
> > Is there a real performance sensitive seq_printf anywhere?
> 
> ... and _that_ is the question that should've been asked first.

I totally agree with you. I've been avoiding the "performance
sensitivity" question because of my narcissistic enjoyment of my macro
cleverness ;-)
And also because I have no "F"'n life.

I just figured someone else will point out the lack of clothes the
Emperor has on.

> 
> > It's trivial to replace seq_printf("constant") with
> > seq_puts but there are over a thousand of them.
> > 
> > It may be better to just leave everything as-is.
> 
> Quite.  Note that it's not equivalent to gcc treatment of printf/puts -
> there we have cases when it *is* a real hotpath (and I seriously suspect
> that it's in part driven by desire to discourage people from uglifying
> source by manual equivalents of that micro-optimization).  Moreover,
> glibc printf at least used to be heavy; kernel-side we are nowhere near
> that bad.

It's also a very hot path in tracing. One reason I only implemented the
macro trick with trace_printk() and not printk() nor seq_printk() is
because I knew those were not hot paths. The reason I created
trace_puts() in the first place, is because I had a bug I was trying to
debug where a trace_printk() would actually make the bug go away. It
added too much of an impact to get the race to trigger. But the
trace_puts() was able to do the trace and still have the bug trigger,
and I was able to debug the problem.

But I enjoyed this conversation while it lasted. Sorry it took up your
time. But it did call to attention that these macros that create
variables should probably have a naming policy to avoid macro traps.

-- Steve


