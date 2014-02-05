Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaBENwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:52:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaBENwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:52:35 -0500
Date: Wed, 5 Feb 2014 14:52:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@parisplace.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] exec: Fix use after free of tracepoint
	trace_sched_process_exec
Message-ID: <20140205135203.GA16229@redhat.com>
References: <20140204120500.041b5175@gandalf.local.home> <CA+55aFyObrVGXqncNboMzybeevPBOtAUcn-zur_B26VHJ1CEcg@mail.gmail.com> <20140204182852.43ffa442@gandalf.local.home> <20140204184208.6f4f22a8@gandalf.local.home> <CA+55aFyTC1UGvRgH5vASh-C3M+GqHPMNGsUq3Q1MuynzkiSaEA@mail.gmail.com> <20140205011028.GM10323@ZenIV.linux.org.uk> <CA+55aFy23NFG6Vw_FRXSALcCeOXF=48iS4s2rDc_0dAONbOETw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy23NFG6Vw_FRXSALcCeOXF=48iS4s2rDc_0dAONbOETw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Linus Torvalds wrote:
>
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -239,7 +239,7 @@ static int ____call_usermodehelper(void *data)
>
>  	commit_creds(new);
>
> -	retval = do_execve(sub_info->path,
> +	retval = do_execve(getname_kernel(sub_info->path),
>  			   (const char __user *const __user *)sub_info->argv,
>  			   (const char __user *const __user *)sub_info->envp);

Great, this naturally duplicates filename unconditionally, and we can
kill bprm->tcomm[].

But,

> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -37,7 +37,7 @@ struct linux_binprm {
>  	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
>  	unsigned int per_clear;	/* bits to clear in current->personality */
>  	int argc, envc;
> -	const char * filename;	/* Name of binary as seen by procps */
> +	struct filename *filename;	/* Name of binary as seen by procps */

Do we really need this change? If not (afaics), the patch can be
much simpler, see below...



> -void free_bprm(struct linux_binprm *bprm)
> +static void free_bprm(struct linux_binprm *bprm)
>  {
>  	free_arg_pages(bprm);
>  	if (bprm->cred) {
> @@ -1174,15 +1179,17 @@ void free_bprm(struct linux_binprm *bprm)
>  		fput(bprm->file);
>  	}
>  	/* If a binfmt changed the interp, free it. */
> -	if (bprm->interp != bprm->filename)
> +	if (bprm->interp != bprm->filename->name)
>  		kfree(bprm->interp);
> +	if (bprm->filename)
> +		putname(bprm->filename);

Even if we actually need to turn bprm->filename into "struct filename"
this free_bprm()->putname() only complicates the code, unless I missed
something. The caller, do_execve(), can do putname() unconditionally and
avoid if/NULL games.

IOW, doesn't the change below (on top of your patch) obviously makes
sense or I am totally confused?

Oleg.

--- x/fs/exec.c
+++ x/fs/exec.c
@@ -1183,8 +1183,6 @@ static void free_bprm(struct linux_binpr
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename->name)
 		kfree(bprm->interp);
-	if (bprm->filename)
-		putname(bprm->filename);
 	kfree(bprm);
 }
 
@@ -1478,9 +1476,6 @@ static int do_execve_common(struct filen
 	if (!bprm)
 		goto out_files;
 
-	bprm->filename = filename;
-	bprm->interp = filename->name;
-
 	retval = prepare_bprm_creds(bprm);
 	if (retval)
 		goto out_free;
@@ -1496,6 +1491,8 @@ static int do_execve_common(struct filen
 	sched_exec();
 
 	bprm->file = file;
+	bprm->filename = filename;
+	bprm->interp = filename->name;
 
 	retval = bprm_mm_init(bprm);
 	if (retval)
@@ -1538,7 +1535,7 @@ static int do_execve_common(struct filen
 	free_bprm(bprm);
 	if (displaced)
 		put_files_struct(displaced);
-	return retval;
+	goto out_ret;
 
 out:
 	if (bprm->mm) {
@@ -1552,14 +1549,12 @@ out_unmark:
 
 out_free:
 	free_bprm(bprm);
-	filename = NULL;
 
 out_files:
 	if (displaced)
 		reset_files_struct(displaced);
 out_ret:
-	if (filename)
-		putname(filename);
+	putname(filename);
 	return retval;
 }
 

