Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaBTJmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:42:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaBTJl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:41:58 -0500
Date: Thu, 20 Feb 2014 10:41:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf test failure on 3.14rc3
Message-ID: <20140220094128.GB2725@krava.brq.redhat.com>
References: <20140220033142.GA7687@redhat.com>
 <20140220085418.GM6835@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220085418.GM6835@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 09:54:18AM +0100, Peter Zijlstra wrote:
> On Wed, Feb 19, 2014 at 10:31:42PM -0500, Dave Jones wrote:
> >  1: vmlinux symtab matches kallsyms                        : Ok
> >  2: detect open syscall event                              : Ok
> >  3: detect open syscall event on all cpus                  : Ok
> >  4: read samples using the mmap interface                  : Ok
> >  5: parse events tests                                     :  Warning: function __le16_to_cpup not defined
> >   Warning: function __le16_to_cpup not defined
> >   Warning: function __le16_to_cpup not defined
> >   Warning: bad op token {
> >   Warning: bad op token {
> >   Warning: bad op token {
> >   Warning: bad op token {
> >   Warning: function is_writable_pte not defined
> >   Warning: function scsi_trace_parse_cdb not defined
> >   Warning: function scsi_trace_parse_cdb not defined
> >   Warning: function scsi_trace_parse_cdb not defined
> >   Warning: function scsi_trace_parse_cdb not defined
> >   Warning: unknown op '->'
> >   Warning: function jiffies_to_msecs not defined
> >   Warning: function jiffies_to_msecs not defined
> >   Warning: unknown op '{'
> >   Warning: unknown op '{'
> >  Ok
> >  6: x86 rdpmc test                                         : Ok
> >  7: Validate PERF_RECORD_* events & perf_sample fields     : Ok
> >  8: Test perf pmu format parsing                           : Ok
> >  9: Test dso data interface                                : Ok
> > 10: roundtrip evsel->name check                            : Ok
> > 11: Check parsing of sched tracepoints fields              : Ok
> > 12: Generate and check syscalls:sys_enter_open event fields: Ok
> > 13: struct perf_event_attr setup                           : Ok
> > 14: Test matching and linking multiple hists               : Ok
> > 15: Try 'use perf' in python, checking link problems       : FAILED!

whats the perf version, from rpm/sources?

> > 16: Test breakpoint overflow signal handler                : Ok
> > 17: Test breakpoint overflow sampling                      : Ok
> > 18: Test number of exit event of a simple workload         : Ok
> > 19: Test software clock events have valid period values    : Ok
> > 20: Test converting perf time to TSC                       : Ok
> > 21: Test object code reading                               : FAILED!
> > 22: Test sample parsing                                    : Ok
> > 23: Test using a dummy software event to keep tracking     : Ok
> > 24: Test parsing with no sample_id_all bit set             : Ok
> > 
> > 
> > I see '5' failing in similar ways in 3.13 too, so it's been broken
> > for a while.

test 5 just emits warnings due to parsing tracepoint formats

it's *almost* cured by traceevents plugins support, which
got in just recently

> 
> We'll have to ask acme and jolsa, I'm sure I've never looked at that
> before.
> 
> > Is 21 due to CONFIG_RANDOMIZE_BASE perhaps ?

21 could fail due to objdump disassebly issue

---
The test fails because of the objdump bug (feature?). I'm getting
following disassembly output:

objdump -z -d --start-address=0xffffffff815cf06e --stop-address=0xffffffff815cf0ee /usr/lib/debug/lib/modules/3.10.0-80.el7perf_test21_1.x86_64/vmlinux

    ffffffff815cf06e <sysret_check+0x4b>:
    ffffffff815cf06e:       24 2f                   and    $0x2f,%al
    ffffffff815cf070:       00 0f                   add    %cl,(%rdi)
     
    ffffffff815cf071 <sysret_careful>:
    ffffffff815cf071:       0f ba e2 03             bt     $0x3,%edx
    ffffffff815cf075:       73 11                   jae    ffffffff815cf088 <sysret_signal>
     
Notice the address '*70:' displaying 2 bytes, while the output
continues with address '*71:'

The perf test 21 reads bytes dump from this output and compares it
to the bytes read from the file in a standard way. This check fails
because of the extra byte being read from the objdump output.
---

there's already BZ filled (internal one)

> > Might that also explain why perf top isn't showing me kernel
> > function names any more ?
> 
> There were some KASLR fails, but I thought most of those were cured, I
> think Adrian was involved.

right, I tested those changes and worked for me

jirka
