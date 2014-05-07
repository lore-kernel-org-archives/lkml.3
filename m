Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbaEGPpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:45:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:61277 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933336AbaEGPpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:45:36 -0400
Date: Wed, 7 May 2014 11:45:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Javi Merino <javi.merino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH v2] tracing: Add __bitmask() macro to trace events
 to cpumasks and other bitmasks
Message-ID: <20140507114533.5bcf2fc2@gandalf.local.home>
In-Reply-To: <293434008.12520.1399462821986.JavaMail.zimbra@efficios.com>
References: <1399377998-14870-1-git-send-email-javi.merino@arm.com>
	<1399377998-14870-6-git-send-email-javi.merino@arm.com>
	<20140506132238.22e136d1@gandalf.local.home>
	<484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
	<20140506231238.246c7d3e@gandalf.local.home>
	<293434008.12520.1399462821986.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 11:40:21 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Steven Rostedt" <rostedt@goodmis.org>
> > To: "LKML" <linux-kernel@vger.kernel.org>
> > Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Javi Merino" <javi.merino@arm.com>, "Andrew Morton"
> > <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Jiri Olsa"
> > <jolsa@redhat.com>
> > Sent: Tuesday, May 6, 2014 11:12:38 PM
> > Subject: [RFC][PATCH v2] tracing: Add __bitmask() macro to trace events to cpumasks and other bitmasks
> > 
> > 
> > Being able to show a cpumask of events can be useful as some events
> > may affect only some CPUs. There is no standard way to record the
> > cpumask and converting it to a string is rather expensive during
> > the trace as traces happen in hotpaths. It would be better to record
> > the raw event mask and be able to parse it at print time.
> 
> Hi Steven,
> 
> OK. Changing cpumask into bitmask helps making this more generic. Now
> I'm concerned about another topic: the type backing the bitmask, as well
> as its endianness, have an important impact when storing and reading
> the trace on different machines. This is not a problem cpumask typically
> has, because the test_bit() and set bit APIs are always used from within
> the kernel.
> 
> Looking at:
> 
> /**
>  * test_bit - Determine whether a bit is set
>  * @nr: bit number to test
>  * @addr: Address to start counting from
>  */
> static inline int test_bit(int nr, const volatile unsigned long *addr)
> {
>         return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
> }
> 
> We notice that the kernel's bit operations use an unsigned long
> as "backing type" for the bitfield, with a native kernel endianness.
> 
> Therefore, the trace reader needs to take into account those two
> informations (backing type size, and endianness) in order to get the
> bit order right.
> 
> I remember that you made sure Ftrace's event description files expose
> the endianness of the kernel, which partially takes care of this
> concern, but how do you plan exposing the bitmask backing type size ?
> (unsigned long maps to 32-bit or 64-bit depending on the architecture).

Well, actually, the files don't expose endianess, but that is done by
the userspace tracer running on the machine. I'm not sure of any
machine that would have userspace and kernel space endianess different.

But the 32-bit vs 64-bit is exposed. Not really directly, but the way
traceevent finds this out is with pevent->header_page_size_size. That
is, in /debug/tracing/events/header_page the field "commit" is of size
long in the kernel. It's 8 for 64bit and 4 for 32bit.

This works even if userspace is 32 and kernel is 64.

With both endian and long size, it should be trivial for the reader to
be able to parse the cpumask on any machine.

-- Steve
