Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbbAZVuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:50:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:33280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbbAZVuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:50:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,470,1418112000"; 
   d="scan'208";a="667856096"
Message-ID: <1422309007.14456.1.camel@theros.lm.intel.com>
Subject: Re: [PATCH v2 0/2] add support for new persistent memory
 instructions
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 26 Jan 2015 14:50:07 -0700
In-Reply-To: <20150126213457.GI1656@pd.tnic>
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
	 <54C2D34D.7010709@intel.com> <20150124111430.GA10084@pd.tnic>
	 <1422302369.13382.3.camel@theros.lm.intel.com>
	 <20150126213457.GI1656@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 22:34 +0100, Borislav Petkov wrote:
> On Mon, Jan 26, 2015 at 12:59:29PM -0700, Ross Zwisler wrote:
> > 		/* 
> > 		 * sfence to order pcommit
> > 		 * mfence via mb() also works 
> > 		 */
> > 		wmb();
> 
> Doc says PCOMMIT is not ordered wrt loads and SFENCE too. Don't we want
> to be absolutely conservative here and use MFENCE both times?

The code, for easy viewing:
	void write_and_commit_buffer(void *vaddr, unsigned int size)
	{
		void *vend = vaddr + size - 1;

		for (; vaddr < vend; vaddr += boot_cpu_data.x86_clflush_size)
			clwb(vaddr);

		/* Flush any possible final partial cacheline */
		clwb(vend);

		/* 
		 * sfence to order clwb/clflushopt/clflush cache flushes
		 * mfence via mb() also works 
		 */
		wmb();

		pcommit();

		/* 
		 * sfence to order pcommit
		 * mfence via mb() also works 
		 */
		wmb();
	}

We can use MFENCE, but I don't think we need to.  With SFENCE we will be
ordered with respect to stores, and the flushes and pcommit will be ordered
with respect to one another.  I think you can sprinkle in loads anywhere you
want in that flow and everything will work. The worst that will happen is
that if you've used clflush or clflushopt you'll have to re-fetch something
you just flushed out of the CPU cache hierarchy, but you'll always get correct
data from your load and you'll always pcommit valid data to the DIMM.


