Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3LCPdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:33:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:35707 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752731Ab3LCPdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:33:49 -0500
Date: Tue, 3 Dec 2013 10:33:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
Message-ID: <20131203103346.65c744e3@gandalf.local.home>
In-Reply-To: <20131203091655.GB20179@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<20131203091655.GB20179@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013 10:16:55 +0100
Ingo Molnar <mingo@kernel.org> wrote:

 
> So, to do the math:
> 
>    tracing               'all' overhead:   95 nsecs per event
>    tracing 'eth5 + old filter' overhead:  157 nsecs per event
>    tracing 'eth5 + BPF filter' overhead:   54 nsecs per event
> 
> So via BPF and a fairly trivial filter, we are able to reduce tracing 
> overhead for real - while old-style filters.

Yep, seems that BPF can do what I wasn't able to do with the normal
filters. Although, I haven't looked at the code yet, I'm assuming that
the BPF works on the parameters passed into the trace event. The normal
filters can only process the results of the trace (what's being
recorded) not the parameters of the trace event itself. To get what's
recorded, we need to write to the buffer first, and then we decided if
we want to keep the event or not and discard the event from the buffer
if we do not.

That method does not reduce overhead at all, and only adds to it, as
Alexei's tests have shown. The purpose of the filter was not to reduce
overhead, but to reduce filling the buffer with needless data.

It looks as if the BPF filter works on the parameters of the trace
event and not what is written to the buffers (as they can be
different). I've been looking for a way to do just that, and if this
does accomplish it, I'll be very happy :-)

-- Steve
