Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934736Ab3BSWPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:15:53 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:57858 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3BSWPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:15:51 -0500
Date: Wed, 20 Feb 2013 02:15:48 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiederm@xmission.com, xemul@parallels.com,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 1/2] kcmp: Make it to depend on CONFIG_KCMP
Message-ID: <20130219221548.GK5627@moon>
References: <20130219064800.719149796@openvz.org>
 <20130219065210.030802820@openvz.org>
 <5123444D.6000806@suse.cz>
 <20130219093154.GF20312@moon>
 <5123BC2B.6000304@zytor.com>
 <20130219182838.GL20312@moon>
 <20130219134256.f4cedf44.akpm@linux-foundation.org>
 <20130219215432.GP20312@moon>
 <20130219140035.373ce4d2.akpm@linux-foundation.org>
 <20130219221146.GR20312@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219221146.GR20312@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 02:11:46AM +0400, Cyrill Gorcunov wrote:
> On Tue, Feb 19, 2013 at 02:00:35PM -0800, Andrew Morton wrote:
> > > 
> > > I think this syscall is usefull even without c/r stuff.
> > > That's why I made it with separate config option.
> > 
> > hm, OK.
> > 
> > But the patch also permits CONFIG_CHECKPOINT_RESTORE=y, CONFIG_KCMP=n
> > which surely isn't something which CRIU wants to support?
> 
> Hmm, yes from one pov this feature is useful for out-of-c/r user,
> from another pov -- we will have to ask users to turn on additional
> CONFIG entries (which i'm sure not set by default in wide range of distros).
> Thus it seems less paiful way is either make it obj-(CHECKPOINT_RESTORE)
> as you proposed, or obj-y by default. The last can't be undone, so I'll
> prepare the patch for obj-(CHECKPOINT_RESTORE) I think.

Here is update. Peter, does it look good for you too?
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: kcmp: Make it to depend on CHECKPOINT_RESTORE

Since kcmp syscall has been implemented (initially on x86
architecture) a number of other archs wire it up as well:
xtensa, sparc, sh, s390, mips, microblaze, m68k (not taking
into account those who uses <asm-generic/unistd.h> for syscall
numbers definitions).

But the Makefile, which turns kcmp.o generation on still
depends on former config-x86. Thus get rid of this
limitation and make kcmp.o depend on CHECKPOINT_RESTORE
option.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: Michal Marek <mmarek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.git/kernel/Makefile
===================================================================
--- linux-2.6.git.orig/kernel/Makefile
+++ linux-2.6.git/kernel/Makefile
@@ -25,9 +25,7 @@ endif
 obj-y += sched/
 obj-y += power/
 
-ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
-obj-$(CONFIG_X86) += kcmp.o
-endif
+obj-$(CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
