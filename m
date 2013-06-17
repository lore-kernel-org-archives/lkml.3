Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3FQUa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:30:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3FQUa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:30:57 -0400
Date: Mon, 17 Jun 2013 13:30:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        David Daney <david.daney@cavium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: Linux 3.10-rc6
Message-Id: <20130617133055.20463ce157e104af15ef60a1@linux-foundation.org>
In-Reply-To: <CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com>
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com>
	<CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com>
	<CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jun 2013 08:01:44 -1000 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Jun 15, 2013 at 10:36 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> >
> > On Sun, Jun 16, 2013 at 12:12 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > David Daney (3):
> > >       smp.h: Use local_irq_{save,restore}() in !SMP version of on_each_cpu().
> >
> > This change (commit f21afc25f9ed45b8ffe200d0f071b0caec3ed2ef, which hasn't
> > been in linux-next), broke at least mn10300 and ia64:
> >
> > include/linux/smp.h:148:2: error: implicit declaration of function 'local_irq_save' [-Werror=implicit-function-declaration]
> 
> Hmm. DavidD already added the include for <linux/irqflags.h>, I wonder
> why that doesn't end up working. Do we have some silly header file
> circular include that means that we're already half-way through that
> irqflags.h file and thus will skip it the second time we see it, or
> why does it end up being undeclared?

Heaven knows; I don't think now is the time to try to fix this.

If I'd thought for two seconds I wouldn't have sent that patch at this
time - additional low-level includes in low-level header files are
often problematic.

> Anyway, I see a few options:
> 
>  - we could just make it a macro like it used to be (keeping the
> include and assuming that will sort out any circular include mess) and
> use a rare name for the internal "flags" variable (just prepending
> double underscores is the common one we tend to use in situations like
> this)
> 
>  - we could just make it a real function, the way the SMP one is, and
> take the extra call overhead (it's not like this should be all that
> critical in an UP environment).
> 
>  - somebody figures out why the <linux/irqflags.h> include ends up not
> working on nm10300 and ia64..

Methinks we should fight this battle at a later date.  I queued this:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/smp.h:on_each_cpu(): switch back to a macro

f21afc25f9ed4 ("smp.h: Use local_irq_{save,restore}() in !SMP version of
on_each_cpu()") converted on_each_cpu() to a C function.  This required
inclusion of irqflags.h, which broke ia64 and mn10300 (at least) due to
header ordering hell.

Switch on_each_cpu() back to a macro to fix this.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Daney <david.daney@cavium.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN include/linux/smp.h~include-linux-smph-on_each_cpu-switch-back-to-a-macro include/linux/smp.h
--- a/include/linux/smp.h~include-linux-smph-on_each_cpu-switch-back-to-a-macro
+++ a/include/linux/smp.h
@@ -11,7 +11,6 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
-#include <linux/irqflags.h>
 
 extern void cpu_idle(void);
 
@@ -140,17 +139,14 @@ static inline int up_smp_call_function(s
 }
 #define smp_call_function(func, info, wait) \
 			(up_smp_call_function(func, info))
-
-static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	func(info);
-	local_irq_restore(flags);
-	return 0;
-}
-
+#define on_each_cpu(func,info,wait)		\
+	({					\
+		unsigned long flags;		\
+		local_irq_save(flags);		\
+		func(info);			\
+		local_irq_restore(flags);	\
+		0;				\
+	})
 /*
  * Note we still need to test the mask even for UP
  * because we actually can get an empty mask from
_

