Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaLPKqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:46:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:46132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaLPKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:46:29 -0500
Date: Tue, 16 Dec 2014 11:46:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Liang, Kan" <kan.liang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        dave.hansen@linux.intel.com
Subject: Re: [BUG] perf: sampling with precise=2 broken in 3.18
Message-ID: <20141216104614.GV3337@twins.programming.kicks-ass.net>
References: <CABPqkBS-iWehgyp0xEkeJLygeTOg7Ci-3jugRNMJ9Medz=2A1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS-iWehgyp0xEkeJLygeTOg7Ci-3jugRNMJ9Medz=2A1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:51:07PM -0500, Stephane Eranian wrote:
> Hi,
> 
> I was running some perf mem test for an upcoming patch when
> I realize that precise=2 was broken on 3.18. It seems it never
> (or extremely rarely) correct the off-by-one error, when until 3.18-rc4
> it was 100% on the same program. So something was introduced
> that broke the asm walker in perf_event_intel_ds.c.
> 
> Looking at the log of that file, I can see one change that could have
> some impact:
> 
> Author: Dave Hansen <dave.hansen@linux.intel.com>
> 6ba48ff x86: Remove arbitrary instruction size limit in instruction decoder
> 
> if I use a kernel without this fix (prior to that commit), then correction
> works. Any kernel after fails. I have not investigated why but may you
> have an idea.
> 
> To reproduce try using perf mem -t load rec my_load_test, then use
> perf report to navigate to the assembly view, the samples should be
> on load instructions, not on the instructions following them. If you use
> perf mem -t load rec -vv you can verify that precise=2. So something
> is not working anymore in the instruction decoder that the fixup routine
> bails out.
> 
> Any clue?

This appears to have fixed it.

---
Subject: x86: Fix off-by-one in instruction decoder

Stephane reported that the PEBS fixup was broken by the recent commit to
the instruction decoder. The thing had an off-by-one which resulted in
not being able to decode the last instruction and always bail.

Reported-by: Stephane Eranian <eranian@google.com>
Fixes: 6ba48ff46f76 ("x86: Remove arbitrary instruction size limit in instruction decoder")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/lib/insn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 2480978..1313ae6 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -28,7 +28,7 @@
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
-	((insn)->next_byte + sizeof(t) + n < (insn)->end_kaddr)
+	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
 	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
