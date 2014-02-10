Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaBJRFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:05:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53237 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaBJRFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:05:32 -0500
Date: Mon, 10 Feb 2014 18:05:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dzickus@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86/nmi: Push duration printk() to irq context
Message-ID: <20140210170526.GP9987@twins.programming.kicks-ass.net>
References: <tip-rdw0au56a5ymis1u8p48c12d@git.kernel.org>
 <52F9021C.1030801@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F9021C.1030801@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 08:45:16AM -0800, Dave Hansen wrote:
> On 02/10/2014 05:29 AM, tip-bot for Peter Zijlstra wrote:
> > x86/nmi: Push duration printk() to irq context
> > 
> > Calling printk() from NMI context is bad (TM), so move it to IRQ
> > context.
> 
> Bad since the I/O device that we're doing it to may be slow and make the
> NMI painfully long?
> 
> I can see why it might be a bad idea, but I'm unsold that it is
> *universally* a bad idea.

printk() takes locks, NMI interrupts printk lock and tries to printk.
you get to keep pieces.



> > In doing so we slightly change (probably wreck) the debugfs
> > nmi_longest_ns thingy, in that it doesn't update to reflect the
> > longest, nor does writing to it reset the count.
> 
> The reason I coded this up was that NMIs were firing off so fast that
> nothing else was getting a chance to run.  With this patch, at least the
> printk() would come out and I'd have some idea what was going on.

Ah indeed, in which case you don't get to run the irq_work. But you
really shouldn't do printk() from NMI and esp. not in a case that
regularly and reliably triggers for everyone and is not a hardware
error.
