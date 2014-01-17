Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaAQKvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:51:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60981 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051AbaAQKvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:51:41 -0500
Date: Fri, 17 Jan 2014 10:51:07 +0000
From: Will Deacon <will.deacon@arm.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: fix strnlen_user when count <= strlen
Message-ID: <20140117105107.GC16003@mudshark.cambridge.arm.com>
References: <20140116234817.GP18705@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116234817.GP18705@redacted.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyle,

On Thu, Jan 16, 2014 at 11:48:17PM +0000, Kyle McMartin wrote:
> I received a bug report about the ruby test-suite failing on AArch64 when
> attempting to pass MAX_ARG_STRLEN sized args to execv[1]. It was
> expecting an E2BIG returned, but instead was receiving ENOMEM, and
> concatenating the argument strings in funky ways.
> 
> The problem appeared to be in __strnlen_user on arm64, as when
> instrumenting fs/exec.c to compare the results of the asm-generic
> strnlen_user, I noticed an off-by-one on the result:
> long-param-test: optimized strnlen_user (131072) and naive (131073) disagree!
> 
> As a result, fix strnlen_user to match expected behaviour as documented
> in lib/strnlen_user.c, and return count+1 when count would be exceeded.
> 
> I didn't feel comfortable prodding the assembler, so I just worked
> around it in the wrapper.

Actually, I have removed strnlen_user for 3.14. Could you try your test case
with our for-next branch please?

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core

As for the issue you spotted, we probably need a fix for that to go into
stable kernels. Does the following (smaller patch) work for you?

Will

--->8

diff --git a/arch/arm64/lib/strnlen_user.S b/arch/arm64/lib/strnlen_user.S
index 7f7b176a5646..73f3335a2a45 100644
--- a/arch/arm64/lib/strnlen_user.S
+++ b/arch/arm64/lib/strnlen_user.S
@@ -37,6 +37,7 @@ ENTRY(__strnlen_user)
 USER(9f, ldrb	w3, [x0], #1	)
 	cbnz	w3, 1b
 2:	sub	x0, x0, x2
+	cinc	x0, x0, mi
 	ret
 ENDPROC(__strnlen_user)
 
