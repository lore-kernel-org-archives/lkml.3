Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab3JRV1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 17:27:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34997 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab3JRV1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 17:27:44 -0400
Date: Fri, 18 Oct 2013 23:27:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20131018212741.GA26049@pd.tnic>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com>
 <20131018125326.GC1007@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31D41E37@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D41E37@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 08:57:22PM +0000, Luck, Tony wrote:
> Long term ... I'd be happy to see mce_log() go away. But we need to
> have a robust, well tested replacement in place for some time before
> such a move is up for discussion.

Basically a userspace daemon consuming the tracepoint or plural,
tracepoints.

> Yes - double error reporting should be avoided.

Right.

> Our first platforms to implement this only do so for memory errors.
> This could change in the future (the UEFI appendix N error record has
> defined sub-sections for lots of types of errors).

Ok.

> Currently EDAC hooked into the mce even notification chain provides a
> return code to indicate whether it completely processed the error, or
> whether to fall through to the rest of mce_log():
> 
> 	if (ret == NOTIFY_STOP)
> 		return;
> 
> Having both EDAC and this new extended error log both registered on this
> chain would probably not be helpful in most cases.

Not only that - you don't need EDAC because all the information is in
the MCA registers and the eMCA supplement, if there is one.

EDAC would be used on older systems which don't sport eMCA.

Now, concerning the current situation, we probably want to do something
like this:

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b1b04123f3d9..382c78eaf474 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -154,6 +154,10 @@ void mce_log(struct mce *mce)
 	/* Emit the trace record: */
 	trace_mce_record(mce);
 
+	if (mce_ext_err_print)
+		if (mce_ext_err_print(NULL, m.extcpu, i))
+			return;
+
 	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
 	if (ret == NOTIFY_STOP)
 		return;
--

Right, we've moved the eMCA print thingie to mce_log so that we get a
chance to run the first TP issuing the raw MCA registers and then run
the eMCA TP as a follow-up.

We've taught mce_ext_err_print() to return a true/false retval to denote:

* true: it has collected data successfully, no need to go down the reporting
  chain

* false: eMCA failed somehow, log the error down and trigger mcelog in
  userspace.

How does that sound?

> Not sure if we should handle that with user education to not load both
> an EDAC and ext_log driver or if there should be some enforcement.

Definitely enforcement. The flags thing I was telling you about recently
could be one way to do it.

> trace_mce_record() dumps the raw data from the machine check banks. I
> think there may still be a case for having this. Analysis tools that
> look at this trace as well should be smart enough to connect the dots.

Yes, sure. The more non-overlaping data we get, the better.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
