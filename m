Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaBXGKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 01:10:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaBXGKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 01:10:19 -0500
Date: Sun, 23 Feb 2014 22:12:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-Id: <20140223221217.4f09b9d1.akpm@linux-foundation.org>
In-Reply-To: <20140224165621.843089bb746605469e016e5d@canb.auug.org.au>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
	<20140224165621.843089bb746605469e016e5d@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 16:56:21 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> On Mon, 24 Feb 2014 15:17:32 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > I guess that there may be more places where "asmlinkage" is used with
> > "static" - I assume that they are all incorrect?
> > 
> > $ git grep -l 'static.*asmlinkage'
> > arch/x86/crypto/sha1_ssse3_glue.c
> > arch/x86/crypto/sha256_ssse3_glue.c
> > arch/x86/crypto/sha512_ssse3_glue.c
> 
> In fact, my x86_64 allmodconfig build produces these:
> 
> arch/x86/crypto/sha1_ssse3_glue.c:43:1: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]
>  static asmlinkage void (*sha1_transform_asm)(u32 *, const char *, unsigned int);
>  ^
> arch/x86/crypto/sha256_ssse3_glue.c:56:1: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]
>  static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
>  ^
> arch/x86/crypto/sha512_ssse3_glue.c:55:1: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]
>  static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);
>  ^
> mm/process_vm_access.c:422:1: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]
>  {
>  ^
> 
> That last is added by commit 700d00f85598 ("mm/process_vm_access.c: mark
> function as static") from the akpm-current tree.
> 
> So is "static asmlinkage" not allowed?

Doh, I missed that.  I don't know if it's "allowed" or not, but it's
clearly the wrong thing to do - the whole point of asmlinkage is to
export the thing to other compilation units.

So I suppose this:

mm/process_vm_access.c:416:1: warning: no previous prototype for `compat_process_vm_rw' [-Wmissing-prototypes]

should be squashed by giving it a prototype.  Something like

--- a/include/linux/compat.h~a
+++ a/include/linux/compat.h
@@ -644,6 +644,13 @@ asmlinkage ssize_t compat_sys_mq_timedre
 asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
 asmlinkage long compat_sys_sysctl(struct compat_sysctl_args __user *args);
 
+asmlinkage ssize_t compat_process_vm_rw(compat_pid_t pid,
+		     const struct compat_iovec __user *lvec,
+		     unsigned long liovcnt,
+		     const struct compat_iovec __user *rvec,
+		     unsigned long riovcnt,
+		     unsigned long flags, int vm_write);
+
 extern ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector,
 		unsigned long nr_segs,
_


