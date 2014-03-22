Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaCVKCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 06:02:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58512 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaCVKBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 06:01:52 -0400
Date: Sat, 22 Mar 2014 11:01:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Wu <peter@lekensteyn.nl>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Message-ID: <20140322100144.GA5617@pd.tnic>
References: <20140321192938.GJ3132@tassilo.jf.intel.com>
 <970fd799-8d4c-4759-8a96-1291b411f307@email.android.com>
 <20140321213753.GK3132@tassilo.jf.intel.com>
 <532CB21B.4040502@zytor.com>
 <8761n7nryi.fsf@tassilo.jf.intel.com>
 <532CB54C.8020003@zytor.com>
 <20140322002244.GP22728@two.firstfloor.org>
 <532CD8A9.5080603@zytor.com>
 <20140322003056.GQ22728@two.firstfloor.org>
 <532CDA92.2080409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <532CDA92.2080409@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 05:34:26PM -0700, H. Peter Anvin wrote:
> It's not just KVM, though.

Right, there's also hw models which don't have a certain MSR all of a
sudden. And yeah yeah, it is architectural so it must be there, yadda,
yadda, we've heard all that already. But we want to be defensive with
our MSR accesses and not explode each time a MSR is missing.

Btw, hpa, I'm looking at the msr_read/msr_write() things now in
arch/x86/lib/msr.c and that second argument "struct msr *m" is kinda
clumsy since all the call sites will need to define a struct msr for
passing which is not intuitive. So I'd rather turn it into u64 so using
those functions would be as simple as possible:

	u64 msrval;
	int ret;

	...

	ret = msr_read(MSR_BLA, &msrval);
	if (ret < 0)
		goto err;

	...

	... msrval ...

and

	ret = msr_write(MSR_DONG, msrval);
	if (ret < 0) {
		pr_err("Error configuring my fancy hw feature.\n");
		goto unwind;
	}

This should be the most intuitive usage, IMO. Agreed?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
