Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaFCOfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:35:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:5921 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753928AbaFCOfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:35:48 -0400
Date: Tue, 3 Jun 2014 10:35:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140603103544.207eaa6e@gandalf.local.home>
In-Reply-To: <20140603083606.GA15476@gchen.bj.intel.com>
References: <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
	<20140528112832.5f83c66b@gandalf.local.home>
	<20140528163452.GF17196@pd.tnic>
	<20140528125625.6f6dcf7f@gandalf.local.home>
	<20140530092232.GA13495@gchen.bj.intel.com>
	<20140530100716.GE28131@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
	<20140530210759.267a854e@gandalf.local.home>
	<3908561D78D1C84285E8C5FCA982C28F3282545B@ORSMSX114.amr.corp.intel.com>
	<20140602125748.7093ced8@gandalf.local.home>
	<20140603083606.GA15476@gchen.bj.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 04:36:07 -0400
"Chen, Gong" <gong.chen@linux.intel.com> wrote:

> On Mon, Jun 02, 2014 at 12:57:48PM -0400, Steven Rostedt wrote:
> > Also matters how big you expect these events to be. If you get a
> > "christmas tree" set of flags, how big will that event grow with all
> > the descriptions attached?
> > 
> > The max event size after all headers is 4056 bytes. If you go over
> > that, the event is ignored.
> > 
> Hi, Steven
> 
> Normally, the length of one eMCA trace record is between 200 and 256 bytes.
> Once CMCI storm happens, before it is turned into poll mode, there are
> about ~15 CMCI events are recorded, because I don't use rate limit for
> trace so they should be recorded so seriously, some records will be lost.
> But they are repeated and similar records so maybe the *lost* is not a 
> big issue.
> 
> Return to how to print trace record. To avoid buffer waste, I need to
> print data when TP_printk called, in the meanwhile, the print content
> is an array of [name, value], but we don't know how many items are
> valid. Here is the question: I can't create a dynamic printk format
> like "%s %d, %s %d, ..." in TP_printk. So the only way to me is
> printking them all, even some of them are invalid, which means an 12
> group "%s %d", or somthing like "%.*s" to make output format graceful.
> This is what we want?

You can create a helper function to call (needs to be placed in a .c
file).

Note, there's a pointer to a trace_seq structure "p" that is available.
Hmm, I should add a get_dynamic_array_len(field), to give you the
length. I'll add that now. I also don't like the trace_seq being "p" as
that is too generic. Maybe I'll change that to "__trace_seq" or
something not so generic.


Anyway, have something like this:


	TP_printk("%s", emca_parse_events(p, __get_dynamic_array(field),
			__get_dynamic_array_len(field)));

I'll still need to add that __get_dynamic_array_len() helper. I'll send
you something tonight.

Then you write the emca_parse_events() as:


const char *emca_parse_events(struct trace_seq *p,
		struct cper_sec_mem_rec *data, int len)
{
	const char *ret = p->buffer + p->len;
	int i;

	len = len / sizeof(struct cper_sec_mem_rec);
	for (i = 0; i < len; i++) {
		switch (data[i].type) {
		case FOO:
			trace_seq_printf(p, "BAR: %d\n", data[i].data);
			break;
		[..]
		}
	}
	trace_seq_putc('\0');

	return ret;
}

-- Steve
