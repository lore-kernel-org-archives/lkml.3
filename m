Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3CSOj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:39:26 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33088 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab3CSOjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:39:23 -0400
Message-ID: <1363703941.2532.27.camel@falcor1>
Subject: Re: [PATCH 4/4] binfmt_elf: Elf executable signature verification
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dmitry.kasatkin@intel.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 19 Mar 2013 10:39:01 -0400
In-Reply-To: <1363379758-10071-5-git-send-email-vgoyal@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
	 <1363379758-10071-5-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031914-7408-0000-0000-00000DF411A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 16:35 -0400, Vivek Goyal wrote:
> Do elf executable signature verification (if one is present). If signature
> is present, it should be valid. Validly signed files are given a capability
> CAP_SIGNED.
> 
> If file is unsigned, it can execute but it does not get the capability
> CAP_SIGNED.
> 
> This is work in progress. This patch is just an RFC to show how one
> can go about making use of IMA APIs for executable signature
> verification.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/Kconfig.binfmt |   12 ++++++++++++
>  fs/binfmt_elf.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
> index 0efd152..cbb1d4a 100644
> --- a/fs/Kconfig.binfmt
> +++ b/fs/Kconfig.binfmt
> @@ -23,6 +23,18 @@ config BINFMT_ELF
>  	  ld.so (check the file <file:Documentation/Changes> for location and
>  	  latest version).
> 
> +config BINFMT_ELF_SIG
> +	bool "ELF binary signature verification"
> +	depends on BINFMT_ELF
> +	select INTEGRITY
> +	select INTEGRITY_SIGNATURE
> +	select INTEGRITY_ASYMMETRIC_KEYS
> +	select IMA
> +	select IMA_APPRAISE
> +	default n
> +	---help---
> +	  Check ELF binary signature verfication.
> +
>  config COMPAT_BINFMT_ELF
>  	bool
>  	depends on COMPAT && BINFMT_ELF
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 3939829..820ceb9 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -34,6 +34,7 @@
>  #include <linux/utsname.h>
>  #include <linux/coredump.h>
>  #include <linux/sched.h>
> +#include <linux/ima.h>
>  #include <asm/uaccess.h>
>  #include <asm/param.h>
>  #include <asm/page.h>
> @@ -581,6 +582,11 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  	int executable_stack = EXSTACK_DEFAULT;
>  	unsigned long def_flags = 0;
>  	struct pt_regs *regs = current_pt_regs();
> +	char *signature = NULL;
> +	unsigned int siglen = 0;
> +	enum evm_ima_xattr_type sig_type;
> +	bool mlock_mappings = false;
> +
>  	struct {
>  		struct elfhdr elf_ex;
>  		struct elfhdr interp_elf_ex;
> @@ -722,6 +728,29 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  	/* OK, This is the point of no return */
>  	current->mm->def_flags = def_flags;
> 
> +#ifdef CONFIG_BINFMT_ELF_SIG
> +	/* If executable is digitally signed. Lock down in memory */
> +	/* Get file signature, if any */
> +	retval = ima_file_signature_alloc(bprm->file, &signature);
> +
> +	/*
> +	 * If there is an error getting signature, bail out. Having
> +	 * no signature is fine though.
> +	 */
> +	if (retval < 0 && retval != -ENODATA && retval != -EOPNOTSUPP)
> +		goto out_free_dentry;
> +
> +	if (signature != NULL) {
> +		siglen = retval;
> +		retval = ima_signature_type(signature, &sig_type);
> +		if (!retval && sig_type == EVM_IMA_XATTR_DIGSIG_ASYMMETRIC)
> +			mlock_mappings = true;
> +	}
> +
> +	if (mlock_mappings)
> +		current->mm->def_flags |= VM_LOCKED;

Vivek, we've already discussed this.  Hard coding policy in the kernel
is unacceptable, whether it is inlined, here, or as part of IMA.
Defining a policy, that mlocks all signed ELF executables, does not
scale.  The 'ima_appraise_tcb' policy requires all files owned by root
to be signed.  Please define some other mechanism, other than a
signature, for identifying files that you want to mlock.
(Recommendations were previously made, which you rejected.)

Lastly, adding 'VM_LOCKED' here seems to change existing, expected
behavior.  According to the mlock(2) man pages, "Memory locks are not
inherited by a child created via fork(2) and are automatically removed
(unlocked) during an execve(2) or when the process terminates."  Someone
else needs to comment on this sort of change.  Andrew?  Al?

thanks,

Mimi

> +
> +#endif
>  	/* Do this immediately, since STACK_TOP as used in setup_arg_pages
>  	   may depend on the personality.  */
>  	SET_PERSONALITY(loc->elf_ex);
> @@ -893,6 +922,18 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  		goto out_free_dentry;
>  	}
> 
> +#ifdef CONFIG_BINFMT_ELF_SIG
> +	if (mlock_mappings) {
> +		retval = ima_appraise_file(bprm->file, signature, siglen);
> +		if (retval) {
> +			send_sig(SIGKILL, current, 0);
> +			goto out_free_dentry;
> +		}
> +		/* Signature verification successful */
> +		cap_raise(bprm->cred->cap_effective, CAP_SIGNED);
> +	}
> +#endif
> +
>  	if (elf_interpreter) {
>  		unsigned long interp_map_addr = 0;
> 
> @@ -986,11 +1027,14 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  	 */
>  	ELF_PLAT_INIT(regs, reloc_func_desc);
>  #endif
> +	if (mlock_mappings)
> +		current->mm->def_flags &= ~VM_LOCKED;
> 
>  	start_thread(regs, elf_entry, bprm->p);
>  	retval = 0;
>  out:
>  	kfree(loc);
> +	kfree(signature);
>  out_ret:
>  	return retval;
> 



