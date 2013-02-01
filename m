Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3BADER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:04:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:45488 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3BADEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:04:15 -0500
Message-ID: <510B22C2.90606@windriver.com>
Date: Thu, 31 Jan 2013 20:04:50 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Michael Neuling <mikey@neuling.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: kernel/kgdb.c: fix memory leakage
References: <1358184395-31418-1-git-send-email-dinggnu@gmail.com>
In-Reply-To: <1358184395-31418-1-git-send-email-dinggnu@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 11:26 AM, Cong Ding wrote:
> the variable backup_current_thread_info isn't freed before existing the
> function.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  arch/powerpc/kernel/kgdb.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index 8747447..5ca82cd 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -154,12 +154,12 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
>  static int kgdb_singlestep(struct pt_regs *regs)
>  {
>  	struct thread_info *thread_info, *exception_thread_info;
> -	struct thread_info *backup_current_thread_info = \
> -		(struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
> +	struct thread_info *backup_current_thread_info;



Woh...  This is definitely wrong.  You have found a problem for sure,
but this is not the right way to fix it.

It is not a good idea to kmalloc while single stepping because you can
hang the kernel if you single step any operation in kmalloc().

I am in the process of going through all the kgdb mails from the last
few months while I had been away from the project, so I didn't catch
this one and I see it has upstream commit (fefd9e6f8).  I'll submit
another patch to fix this the right way and use a static variable.
This is ok to use a static variable here because this is not something
we can recursively call at a single CPU level.

If Ben prefers we not burn the memory unless kgdb is active we can
kmalloc / kfree the space we need at the time that kgdb is
initialized.  Else we can go with this patch you see below.  We'll see
what Ben desires.

-----
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index a7bc752..bb12c8b 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -151,15 +151,16 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 	return 1;
 }
 
+static struct thread_info kgdb_backup_thread_info[NR_CPUS];
+
 static int kgdb_singlestep(struct pt_regs *regs)
 {
 	struct thread_info *thread_info, *exception_thread_info;
-	struct thread_info *backup_current_thread_info;
+	int cpu = raw_smp_processor_id();
 
 	if (user_mode(regs))
 		return 0;
 
-	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
 	/*
 	 * On Book E and perhaps other processors, singlestep is handled on
 	 * the critical exception stack.  This causes current_thread_info()
@@ -175,7 +176,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
 
 	if (thread_info != exception_thread_info) {
 		/* Save the original current_thread_info. */
-		memcpy(backup_current_thread_info, exception_thread_info, sizeof *thread_info);
+		memcpy(&kgdb_backup_thread_info[cpu], exception_thread_info, sizeof *thread_info);
 		memcpy(exception_thread_info, thread_info, sizeof *thread_info);
 	}
 
@@ -183,9 +184,8 @@ static int kgdb_singlestep(struct pt_regs *regs)
 
 	if (thread_info != exception_thread_info)
 		/* Restore current_thread_info lastly. */
-		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
+		memcpy(exception_thread_info, &kgdb_backup_thread_info[cpu], sizeof *thread_info);
 
-	kfree(backup_current_thread_info);
 	return 1;
 }
 

-----


Thanks,
Jason.


>  
>  	if (user_mode(regs))
>  		return 0;
>  
> +	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
>  	/*
>  	 * On Book E and perhaps other processors, singlestep is handled on
>  	 * the critical exception stack.  This causes current_thread_info()
> @@ -185,6 +185,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
>  		/* Restore current_thread_info lastly. */
>  		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
>  
> +	kfree(backup_current_thread_info);
>  	return 1;
>  }
>  
> 

