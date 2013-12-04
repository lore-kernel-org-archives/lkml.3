Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab3LDQqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:46:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab3LDQqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:46:42 -0500
Date: Wed, 4 Dec 2013 08:46:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        David Daney <david.daney@cavium.com>
Cc: linux-kernel@vger.kernel.org
Subject: smp_call_function_single with wait=0 considered harmful
Message-ID: <20131204164627.GA27677@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing my recent work on the generic smp function calls I noticed
that smp_call_function_single without the wait flag can't work, as
it allocates struct call_single_data on stack, and without the wait
flag will happily return before the IPI has been executed.

This affects the following callers:

  arch/ia64/kernel/mca.c:mca_cpu_callback()
  arch/ia64/kernel/smpboot.c:ia64_sync_itc()
  arch/x86/kernel/kvm.c:kvm_cpu_notify()
  arch/x86/oprofile/nmi_int.c:oprofile_cpu_notifier()
  arch/x86/pci/amd_bus.c:amd_cpu_notify()
  drivers/staging/octeon/ethernet-rx.c:cvm_oct_enable_one_cpu()
  kernel/stop_machine.c:stop_two_cpus()

It would be good to get these fixed so that we could remove the
parameter.  Either convert them to wait, or use a preallocated
call_single_data and __smp_call_function_single.

After that I'd like to remove the wait argument to prevent further
abuses.
