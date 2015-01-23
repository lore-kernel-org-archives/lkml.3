Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbbAWXDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:03:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:5046 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbbAWXDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:03:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,456,1418112000"; 
   d="scan'208";a="655716324"
Message-ID: <54C2D34D.7010709@intel.com>
Date: Fri, 23 Jan 2015 15:03:41 -0800
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 0/2] add support for new persistent memory instructions
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 12:40 PM, Ross Zwisler wrote:
> This patch set adds support for two new persistent memory instructions, pcommit
> and clwb.  These instructions were announced in the document "Intel
> Architecture Instruction Set Extensions Programming Reference" with reference
> number 319433-022.
> 
> https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf
> 

Please explain in these patch descriptions what the instructions
actually do.

+	volatile struct { char x[64]; } *p = __p;
+
+	asm volatile(ALTERNATIVE_2(
+		".byte " __stringify(NOP_DS_PREFIX) "; clflush (%[pax])",
+		".byte 0x66; clflush (%[pax])", /* clflushopt (%%rax) */
+		X86_FEATURE_CLFLUSHOPT,
+		".byte 0x66, 0x0f, 0xae, 0x30",  /* clwb (%%rax) */
+		X86_FEATURE_CLWB)
+		: [p] "+m" (*p)
+		: [pax] "a" (p));

For the specific case of CLWB, we can use an "m" input rather than a
"+m" output, simply because CLWB (or CLFLUSH* used as a standin for CLWB
doesn't need to be ordered with respect to loads (whereas CLFLUSH* do).

Now, one can argue that for performance reasons we should should still
use "+m" in case we use the CLFLUSH* standin, to avoid flushing a cache
line to memory just to bring it back in.

+static inline void pcommit(void)
+{
+	alternative(ASM_NOP4, ".byte 0x66, 0x0f, 0xae, 0xf8",
+		    X86_FEATURE_PCOMMIT);
+}
+

Should we use an SFENCE as a standin if pcommit is unavailable, in case
we end up using CLFLUSHOPT?

	-hpa


