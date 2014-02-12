Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaBLEwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 23:52:24 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37769 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaBLEwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 23:52:22 -0500
Message-ID: <52FAFD2D.2090306@linux.vnet.ibm.com>
Date: Wed, 12 Feb 2014 10:18:45 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: linux-next: build failure after merge of the tip tree
References: <20140212134127.2c049bb94175e12201b257ef@canb.auug.org.au>
In-Reply-To: <20140212134127.2c049bb94175e12201b257ef@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021204-5816-0000-0000-00000C391D0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 02/12/2014 08:11 AM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/cpuidle/cpuidle-pseries.c: In function 'idle_loop_prolog':
> drivers/cpuidle/cpuidle-pseries.c:32:2: error: implicit declaration of function 'ppc64_runlatch_off' [-Werror=implicit-function-declaration]
>   ppc64_runlatch_off();
>   ^
> drivers/cpuidle/cpuidle-pseries.c: In function 'idle_loop_epilog':
> drivers/cpuidle/cpuidle-pseries.c:52:2: error: implicit declaration of function 'ppc64_runlatch_on' [-Werror=implicit-function-declaration]
>   ppc64_runlatch_on();
>   ^
> 
> Caused by commit d8c6ad3184ca ("sched/idle, PPC: Remove redundant
> cpuidle_idle_call()").

Ok so after the commit

d8c6ad3184ca651:sched/idle, PPC: Remove redundant cpuidle_idle_call()
reintroduced ppc64_runlatch_off/on() in drivers/cpuidle/cpuidle-pseries.c
the cleanup caused by the commit "c0c4301c54adde05:pseries/cpuidle:
Remove redundant call to ppc64_runlatch_off() in cpu idle routines"
now needs to be introduced in part.

Below is the patch which should fix this. This is based on top of tip-tree.

Thanks

Regards
Preeti U Murthy

---------------------------------------------------------------------------------

cpuidle/pseries: Fix fallout caused due to cleanup in pseries cpuidle backend driver

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Commit "d8c6ad3184ca651:sched/idle, PPC: Remove redundant cpuidle_idle_call()"
reintroduced ppc64_runlatch_off/on() in the pseries cpuidle backend driver.
Hence the cleanup caused by the commit "c0c4301c54adde05:pseries/cpuidle:
Remove redundant call to ppc64_runlatch_off() in cpu idle routines"  in
conjuction with the commit d8c6ad3184ca651 causes a build failure.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-pseries.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index d486489..6f7b019 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -17,6 +17,7 @@
 #include <asm/reg.h>
 #include <asm/machdep.h>
 #include <asm/firmware.h>
+#include <asm/runlatch.h>
 #include <asm/plpar_wrappers.h>
 
 struct cpuidle_driver pseries_idle_driver = {


> 
> I have used the tip tree from next-20140210 again today (since
> next-20140211 was broken differently).
> 

