Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3DXWd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:33:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3DXWdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:33:25 -0400
Date: Wed, 24 Apr 2013 15:33:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Mircea Gherzan <mgherzan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/3] seccomp: add generic code for jitted seccomp
 filters.
Message-Id: <20130424153323.73901c8e026580dc279329b0@linux-foundation.org>
In-Reply-To: <5177FFC2.5020102@freebox.fr>
References: <1363618233-6375-1-git-send-email-nschichan@freebox.fr>
	<1363618233-6375-2-git-send-email-nschichan@freebox.fr>
	<20130417145628.88058f0f3104ab9ae551ddd3@linux-foundation.org>
	<51752D98.8070709@freebox.fr>
	<20130423164303.d2eb663c4a1becea4a185087@linux-foundation.org>
	<5177FFC2.5020102@freebox.fr>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 17:52:34 +0200 Nicolas Schichan <nschichan@freebox.fr> wrote:

> > btw, what on earth is going on with seccomp_jit_free()?  It does
> > disturbing undocumented typecasting and it punts the module_free into a
> > kernel thread for mysterious, undocumented and possibly buggy reasons.
> >
> > I realize it just copies bpf_jit_free().  The same observations apply there.
> 
> The reason for this hack for both seccomp filters and socket filters is that 
> {seccomp,bpf}_jit_free are called from a softirq. module_free() cannot be 
> called directly from softirq, as it will in turn call vfree() which will 
> BUG_ON() if in_interrupt() is non zero. So to call module_free(), it is 
> therefore required to be in a process context, which is provided by the work 
> struct.

Well let's explain this to the next sucker who comes along.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: bpf: add comments explaining the schedule_work() operation

Cc: Will Drewry <wad@chromium.org>
Cc: Mircea Gherzan <mgherzan@gmail.com>
Cc: Nicolas Schichan <nschichan@freebox.fr>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/net/bpf_jit_32.c       |    8 ++++++++
 arch/powerpc/net/bpf_jit_comp.c |    4 ++++
 arch/s390/net/bpf_jit_comp.c    |    4 ++++
 arch/sparc/net/bpf_jit_comp.c   |    4 ++++
 arch/x86/net/bpf_jit_comp.c     |    4 ++++
 5 files changed, 24 insertions(+)

diff -puN arch/arm/net/bpf_jit_32.c~a arch/arm/net/bpf_jit_32.c
--- a/arch/arm/net/bpf_jit_32.c~a
+++ a/arch/arm/net/bpf_jit_32.c
@@ -958,6 +958,10 @@ void bpf_jit_free(struct sk_filter *fp)
 	struct work_struct *work;
 
 	if (fp->bpf_func != sk_run_filter) {
+		/*
+		 * bpf_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		work = (struct work_struct *)fp->bpf_func;
 
 		INIT_WORK(work, bpf_jit_free_worker);
@@ -985,6 +989,10 @@ void seccomp_jit_free(struct seccomp_fil
 	void *bpf_func = seccomp_filter_get_bpf_func(fp);
 
 	if (bpf_func != sk_run_filter) {
+		/*
+		 * seccomp_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		work = (struct work_struct *)bpf_func;
 
 		INIT_WORK(work, bpf_jit_free_worker);
diff -puN arch/sparc/net/bpf_jit_comp.c~a arch/sparc/net/bpf_jit_comp.c
--- a/arch/sparc/net/bpf_jit_comp.c~a
+++ a/arch/sparc/net/bpf_jit_comp.c
@@ -817,6 +817,10 @@ static void jit_free_defer(struct work_s
 void bpf_jit_free(struct sk_filter *fp)
 {
 	if (fp->bpf_func != sk_run_filter) {
+		/*
+		 * bpf_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		struct work_struct *work = (struct work_struct *)fp->bpf_func;
 
 		INIT_WORK(work, jit_free_defer);
diff -puN arch/powerpc/net/bpf_jit_comp.c~a arch/powerpc/net/bpf_jit_comp.c
--- a/arch/powerpc/net/bpf_jit_comp.c~a
+++ a/arch/powerpc/net/bpf_jit_comp.c
@@ -699,6 +699,10 @@ static void jit_free_defer(struct work_s
 void bpf_jit_free(struct sk_filter *fp)
 {
 	if (fp->bpf_func != sk_run_filter) {
+		/*
+		 * bpf_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		struct work_struct *work = (struct work_struct *)fp->bpf_func;
 
 		INIT_WORK(work, jit_free_defer);
diff -puN arch/s390/net/bpf_jit_comp.c~a arch/s390/net/bpf_jit_comp.c
--- a/arch/s390/net/bpf_jit_comp.c~a
+++ a/arch/s390/net/bpf_jit_comp.c
@@ -818,6 +818,10 @@ void bpf_jit_free(struct sk_filter *fp)
 
 	if (fp->bpf_func == sk_run_filter)
 		return;
+	/*
+	 * bpf_jit_free() can be called from softirq; module_free() requires
+	 * process context.
+	 */
 	work = (struct work_struct *)fp->bpf_func;
 	INIT_WORK(work, jit_free_defer);
 	schedule_work(work);
diff -puN arch/x86/net/bpf_jit_comp.c~a arch/x86/net/bpf_jit_comp.c
--- a/arch/x86/net/bpf_jit_comp.c~a
+++ a/arch/x86/net/bpf_jit_comp.c
@@ -749,6 +749,10 @@ static void jit_free_defer(struct work_s
 void bpf_jit_free(struct sk_filter *fp)
 {
 	if (fp->bpf_func != sk_run_filter) {
+		/*
+		 * bpf_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		struct work_struct *work = (struct work_struct *)fp->bpf_func;
 
 		INIT_WORK(work, jit_free_defer);
diff -puN include/linux/filter.h~a include/linux/filter.h
diff -puN net/core/filter.c~a net/core/filter.c
_

