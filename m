Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab3BHCll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:41:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:38044 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759207Ab3BHClj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:41:39 -0500
Message-ID: <1360291273.2650.52.camel@pasglop>
Subject: Re: [PATCH] powerpc: kernel/kgdb.c: fix memory leakage
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Cong Ding <dinggnu@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Michael Neuling <mikey@neuling.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2013 13:41:13 +1100
In-Reply-To: <510B22C2.90606@windriver.com>
References: <1358184395-31418-1-git-send-email-dinggnu@gmail.com>
	 <510B22C2.90606@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-31 at 20:04 -0600, Jason Wessel wrote:

> > diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> > index 8747447..5ca82cd 100644
> > --- a/arch/powerpc/kernel/kgdb.c
> > +++ b/arch/powerpc/kernel/kgdb.c
> > @@ -154,12 +154,12 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
> >  static int kgdb_singlestep(struct pt_regs *regs)
> >  {
> >  	struct thread_info *thread_info, *exception_thread_info;
> > -	struct thread_info *backup_current_thread_info = \
> > -		(struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
> > +	struct thread_info *backup_current_thread_info;
> 
> 
> 
> Woh...  This is definitely wrong.  You have found a problem for sure,
> but this is not the right way to fix it.
>
> It is not a good idea to kmalloc while single stepping because you can
> hang the kernel if you single step any operation in kmalloc().

Ok. I applied the fix because it was obviously correct vs. the previous
version of the code (ie. the kmalloc was already there)

> I am in the process of going through all the kgdb mails from the last
> few months while I had been away from the project, so I didn't catch
> this one and I see it has upstream commit (fefd9e6f8).  I'll submit
> another patch to fix this the right way and use a static variable.
> This is ok to use a static variable here because this is not something
> we can recursively call at a single CPU level.

But a static will be shared by all CPUs or do you mean a per-cpu one ?

> If Ben prefers we not burn the memory unless kgdb is active we can
> kmalloc / kfree the space we need at the time that kgdb is
> initialized.  Else we can go with this patch you see below.  We'll see
> what Ben desires.

What about the stack ? thread info isn't very big...

Cheers,
Ben.

> -----
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index a7bc752..bb12c8b 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -151,15 +151,16 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
>  	return 1;
>  }
>  
> +static struct thread_info kgdb_backup_thread_info[NR_CPUS];
> +
>  static int kgdb_singlestep(struct pt_regs *regs)
>  {
>  	struct thread_info *thread_info, *exception_thread_info;
> -	struct thread_info *backup_current_thread_info;
> +	int cpu = raw_smp_processor_id();
>  
>  	if (user_mode(regs))
>  		return 0;
>  
> -	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
>  	/*
>  	 * On Book E and perhaps other processors, singlestep is handled on
>  	 * the critical exception stack.  This causes current_thread_info()
> @@ -175,7 +176,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
>  
>  	if (thread_info != exception_thread_info) {
>  		/* Save the original current_thread_info. */
> -		memcpy(backup_current_thread_info, exception_thread_info, sizeof *thread_info);
> +		memcpy(&kgdb_backup_thread_info[cpu], exception_thread_info, sizeof *thread_info);
>  		memcpy(exception_thread_info, thread_info, sizeof *thread_info);
>  	}
>  
> @@ -183,9 +184,8 @@ static int kgdb_singlestep(struct pt_regs *regs)
>  
>  	if (thread_info != exception_thread_info)
>  		/* Restore current_thread_info lastly. */
> -		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
> +		memcpy(exception_thread_info, &kgdb_backup_thread_info[cpu], sizeof *thread_info);
>  
> -	kfree(backup_current_thread_info);
>  	return 1;
>  }
>  
> 
> -----
> 
> 
> Thanks,
> Jason.
> 
> 
> >  
> >  	if (user_mode(regs))
> >  		return 0;
> >  
> > +	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
> >  	/*
> >  	 * On Book E and perhaps other processors, singlestep is handled on
> >  	 * the critical exception stack.  This causes current_thread_info()
> > @@ -185,6 +185,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
> >  		/* Restore current_thread_info lastly. */
> >  		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
> >  
> > +	kfree(backup_current_thread_info);
> >  	return 1;
> >  }
> >  
> > 


