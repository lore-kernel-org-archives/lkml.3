Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaB1M0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:26:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54710 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaB1M0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:26:38 -0500
Date: Fri, 28 Feb 2014 13:26:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org
Subject: Re: smp_call_function_single with wait=0 considered harmful
Message-ID: <20140228122624.GF9987@twins.programming.kicks-ass.net>
References: <20131204164627.GA27677@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204164627.GA27677@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 08:46:27AM -0800, Christoph Hellwig wrote:
> While doing my recent work on the generic smp function calls I noticed
> that smp_call_function_single without the wait flag can't work, as
> it allocates struct call_single_data on stack, and without the wait
> flag will happily return before the IPI has been executed.

It doesn't actually; it uses a per-cpu one in the !wait case.

The subsequent csd_lock() ensures it will wait for any prior user to
complete, so only if you're doing multiple smp_call_function_single()
invocations back-to-back will they queue up.

> This affects the following callers:

<snip>

>   kernel/stop_machine.c:stop_two_cpus()

That site should work with .wait=1 just fine, but given the above, the
.wait=0 doesn't appear problematic at all.
