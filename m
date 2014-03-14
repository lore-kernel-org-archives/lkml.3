Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaCNKlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:41:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38190 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaCNKlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:41:09 -0400
Date: Fri, 14 Mar 2014 11:41:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140314104100.GR27965@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140217143340.GR27965@twins.programming.kicks-ass.net>
 <530529FC.6080704@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530529FC.6080704@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 02:02:36PM -0800, Dave Hansen wrote:
> On 02/17/2014 06:33 AM, Peter Zijlstra wrote:
> > Then write the PERF_RECORD_DATA structure into the normal ring-buffer
> > location; set data_offset to point to the first page boundary, data_size
> > to 1mb.
> > 
> > Then frob things such that perf_mmap_to_page() for the next 1mb of pages
> > points to your buffer pages and wipe the page-table entries.
> 
> Wouldn't we have to teach a ton of code how to be IRQ safe for this to
> work?  Just step one: how do we go modifying page tables safely from an
> interrupt?  mm->page_table_lock is a plain non-irq spinlock.

One could modify existing page tables the same way we do the lockless
lookup for GUP. But instead of doing the get_page() we do a pte
modification.

But I suppose we can push all that to task context by having the polling
task do it before it gets to userspace again.
