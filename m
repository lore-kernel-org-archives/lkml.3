Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab3BSS2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:28:44 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:65134 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab3BSS2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:28:42 -0500
Date: Tue, 19 Feb 2013 22:28:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ebiederm@xmission.com,
        xemul@parallels.com, akpm@linux-foundation.org,
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
Message-ID: <20130219182838.GL20312@moon>
References: <20130219064800.719149796@openvz.org>
 <20130219065210.030802820@openvz.org>
 <5123444D.6000806@suse.cz>
 <20130219093154.GF20312@moon>
 <5123BC2B.6000304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5123BC2B.6000304@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 09:53:47AM -0800, H. Peter Anvin wrote:
> On 02/19/2013 01:31 AM, Cyrill Gorcunov wrote:
> >+
> >+	  If unsure, say N.
> >+
> 
> Wrong advice.  In this particular case, Y is the safe alternative.
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: kcmp: Make it to depend on CONFIG_KCMP

Since kcmp syscall has been implemented (initially on
x86 architecture) a number of other archs wire it up
as well: xtensa, sparc, sh, s390, mips, microblaze,
m68k (not taking into account those who uses
<asm-generic/unistd.h> for syscall numbers
definitions).

But the Makefile, which turns kcmp.o generation on
still depends on former config-x86. Thus get rid
of this limitation and make kcmp.o depend on CONFIG_KCMP
option.

v2:
 - As Michal pointed the old configs might already use of
   CHECKPOINT_RESTORE, so make "default" accordingly.
 - Advice Y if unsure

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
 init/Kconfig    |    9 +++++++++
 kernel/Makefile |    4 +---
 2 files changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6.git/init/Kconfig
===================================================================
--- linux-2.6.git.orig/init/Kconfig
+++ linux-2.6.git/init/Kconfig
@@ -279,6 +279,15 @@ config FHANDLE
 	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
 	  syscalls.
 
+config KCMP
+	bool "kcmp syscall"
+	default CHECKPOINT_RESTORE
+	help
+	  If you say Y here, a user level program will be able to use
+	  kcmp(2) syscall.
+
+	  If unsure, say Y.
+
 config AUDIT
 	bool "Auditing support"
 	depends on NET
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
+obj-$(CONFIG_KCMP) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
