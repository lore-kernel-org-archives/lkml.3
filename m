Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3GCHzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:55:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32798 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3GCHzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:55:49 -0400
Date: Wed, 3 Jul 2013 09:55:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.11
Message-ID: <20130703075542.GF23916@twins.programming.kicks-ass.net>
References: <20130701090356.GA14912@gmail.com>
 <CA+55aFwJwYRbPBBN1ma8TBHuomo_AJjajxT6YDmdGXJdE4EgrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwJwYRbPBBN1ma8TBHuomo_AJjajxT6YDmdGXJdE4EgrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 05:50:29PM -0700, Linus Torvalds wrote:
> On Mon, Jul 1, 2013 at 2:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus
> >
> > Kernel improvements:
> >
> >  * AMD IOMMU uncore PMU support by Suravee Suthikulpanit001a
> 
> This one prints a really annoying error message if you're not on an
> AMD platform:
> 
> +       if (!amd_iommu_pc_supported()) {
> +               pr_err("perf: amd_iommu PMU not installed. No support!\n");
> +               return -ENODEV;
> +       }
> 
> and you know what? That's not acceptable. It damn well is *not* an
> error to not have an AMD IOMMU.
> 
> It should - at most - be a pr_info(). Maybe nothing at all. "pr_err()"
> is just totally out of line.

Quite; it prints enough stuff when it does find one so I'm all for
scrapping that one print when it doesn't find it.

Sorry for not seeing that; when I initially read that code I thought it was for
the case where the hardware was expected to have the device but we couldn't
find it for some weird reason.

---
Subject: perf, amd: Do not print an error when the device is not present

As Linus said its not an error to not have an AMD IOMMU; esp. when you're not
even running on an AMD platform.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event_amd_iommu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.c b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
index 0db655e..639d128 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_iommu.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
@@ -491,10 +491,8 @@ static struct perf_amd_iommu __perf_iommu = {
 static __init int amd_iommu_pc_init(void)
 {
 	/* Make sure the IOMMU PC resource is available */
-	if (!amd_iommu_pc_supported()) {
-		pr_err("perf: amd_iommu PMU not installed. No support!\n");
+	if (!amd_iommu_pc_supported())
 		return -ENODEV;
-	}
 
 	_init_perf_amd_iommu(&__perf_iommu, "amd_iommu");
 

