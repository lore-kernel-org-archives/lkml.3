Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaBFO6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:58:23 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:42460 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaBFO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:58:22 -0500
Message-ID: <52F3A30C.7050205@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 15:58:20 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Meelis Roos <mroos@linux.ee>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.13: BUG: unable to handle kernel paging request at 00000000b4343e88
References: <alpine.SOC.1.00.1401211228410.25614@math.ut.ee> <20140121141037.f76dba61212c5597ff733207@linux-foundation.org> <alpine.SOC.1.00.1401221731150.3033@math.ut.ee> <52E26EF3.1090901@linux.vnet.ibm.com> <alpine.SOC.1.00.1401242249540.16252@math.ut.ee> <52E68111.6010005@linux.vnet.ibm.com> <alpine.SOC.1.00.1401280832500.5459@math.ut.ee> <52E918C9.7030408@linux.vnet.ibm.com> <alpine.SOC.1.00.1401292242390.12718@math.ut.ee> <52EBC65C.5020404@linux.vnet.ibm.com> <52F26E21.8000101@linux.vnet.ibm.com> <52F27683.8090404@zytor.com>
In-Reply-To: <52F27683.8090404@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020614-1948-0000-0000-000007B675F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.02.2014 18:36, H. Peter Anvin wrote:
> On 02/05/2014 09:00 AM, Peter Oberparleiter wrote:
>>
>> Could you give this patch a try? It is a variation of the approach
>> proposed in the discussion mentioned earlier and fixes the problem
>> on my system.
>>
> 
> I would rather suggest that we explicitly disable gcov etc. from these
> kinds of small, magic primitives.  Honestly, you're just trying to put a
> bandaid on a gaping wound.
> 
> The real thing here is that hweight.c is not a normal C file, and we
> shouldn't treat is as such.  It is a constrained environment, and trying
> to tack crap like gcov to it is bound to lose, simply because gcov
> doesn't know the rules it has to play by.
> 
> Even with the below change, if gcov clobbers, say, %rdx we're still screwed.

I'm fine with the proposed alternative of disabling gcov profiling for
lib/hweight.c. The patch below fixes the problem on my test system.

---
x86/hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y

Commit d61931d89b, "x86: Add optimized popcnt variants" introduced
compile flag -fcall-saved-rdi for lib/hweight.c. When combined with
options -fprofile-arcs and -O2, this flag causes gcc to generate broken
constructor code. As a result, a 64 bit x86 kernel compiled with
CONFIG_GCOV_PROFILE_ALL=y prints message "gcov: could not create file"
and runs into sproadic BUGs during boot.

This patch avoids the bug by excluding lib/hweight.o from coverage
profiling.

Reported-by: Meelis Roos <mroos@linux.ee>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)
diff -Naurp a/lib/Makefile b/lib/Makefile
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o

+GCOV_PROFILE_hweight.o := n
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o

