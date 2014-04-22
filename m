Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbaDVQcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:32:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316AbaDVQco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:32:44 -0400
Message-ID: <1398184360.2596.7.camel@flatline.rdu.redhat.com>
Subject: Re: linux-next: build failure after merge of the audit tree
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Briggs <rgb@redhat.com>, sparclinux@vger.kernel.org
Date: Tue, 22 Apr 2014 12:32:40 -0400
In-Reply-To: <20140422162207.55e3d9f09244de281b9798cc@canb.auug.org.au>
References: <20140422162207.55e3d9f09244de281b9798cc@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 16:22 +1000, Stephen Rothwell wrote:
> Hi Eric,
> 
> After merging the audit tree, today's linux-next build (sparc defconfig)
> failed like this:
> 
> In file included from include/linux/audit.h:29:0,
>                  from mm/mmap.c:33:
> arch/sparc/include/asm/syscall.h: In function 'syscall_get_arch':
> arch/sparc/include/asm/syscall.h:131:9: error: 'TIF_32BIT' undeclared (first use in this function)
> arch/sparc/include/asm/syscall.h:131:9: note: each undeclared identifier is reported only once for each function it appears in
> 
> And many more ...
> 
> Caused by commit 374c0c054122 ("ARCH: AUDIT: implement syscall_get_arch
> for all arches").
> 
> I applied this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 22 Apr 2014 16:18:53 +1000
> Subject: [PATCH] fix ARCH: AUDIT: implement syscall_get_arch for all arches
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/include/asm/syscall.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/sparc/include/asm/syscall.h b/arch/sparc/include/asm/syscall.h
> index fed3d511b108..a5a8153766b3 100644
> --- a/arch/sparc/include/asm/syscall.h
> +++ b/arch/sparc/include/asm/syscall.h
> @@ -128,8 +128,12 @@ static inline void syscall_set_arguments(struct task_struct *task,
>  
>  static inline int syscall_get_arch(void)
>  {
> +#if defined(__sparc__) && defined(__arch64__)
>  	return test_thread_flag(TIF_32BIT) ? AUDIT_ARCH_SPARC
>  					   : AUDIT_ARCH_SPARC64;
> +#else
> +	return AUDIT_ARCH_SPARC;
> +#endif
>  }
>  
>  #endif /* __ASM_SPARC_SYSCALL_H */
> -- 

I swear I saw this and I fixed it.  Drat.  Do we want to do it this way?
Above in syscall_get_arguments() they use

#ifdef CONFIG_SPARC64
        if (test_tsk_thread_flag(task, TIF_32BIT))
                zero_extend = 1;
#endif

Is CONFIG_SPARC64 a better choice than:
   defined(__sparc__) && defined(__arch64__)

Maybe even better would be to copy what you suggested in powerpc:

---

diff --git a/arch/sparc/include/asm/syscall.h b/arch/sparc/include/asm/syscall.h
index fed3d51..49f71fd 100644
--- a/arch/sparc/include/asm/syscall.h
+++ b/arch/sparc/include/asm/syscall.h
@@ -128,8 +128,7 @@ static inline void syscall_set_arguments(struct task_struct *task,
 
 static inline int syscall_get_arch(void)
 {
-	return test_thread_flag(TIF_32BIT) ? AUDIT_ARCH_SPARC
-					   : AUDIT_ARCH_SPARC64;
+	return is_32bit_task() ? AUDIT_ARCH_SPARC : AUDIT_ARCH_SPARC64;
 }
 
 #endif /* __ASM_SPARC_SYSCALL_H */
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index 96efa7a..acd2be0 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -130,6 +130,8 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
 					 _TIF_SIGPENDING)
 
+#define is_32bit_task()	(0)
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index a5f01ac..5a4f660 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -219,6 +219,8 @@ register struct thread_info *current_thread_info_reg asm("g6");
 				 _TIF_NEED_RESCHED)
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING)
 
+#define is_32bit_task()	(test_thread_flag(TIF_32BIT))
+
 /*
  * Thread-synchronous status.
  *


