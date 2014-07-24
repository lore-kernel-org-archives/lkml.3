Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbaGXORd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:17:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889AbaGXORc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:17:32 -0400
Date: Thu, 24 Jul 2014 10:16:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: akpm@linux-foundation.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, bp@alien8.de,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 1/1] kexec: Verify the signature of signed PE bzImage
Message-ID: <20140724141642.GI8573@redhat.com>
References: <1404930247-7546-1-git-send-email-vgoyal@redhat.com>
 <1404930247-7546-2-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404930247-7546-2-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:24:07PM -0400, Vivek Goyal wrote:
> Well all the hard work is done in previous patches. Now bzImage loader
> has just call into that code and verify whether bzImage signature are
> valid or not.
> 
> Also create two config options. First one is CONFIG_KEXEC_VERIFY_SIG.
> This option enforces that kernel has to be validly signed otherwise
> kernel load will fail. If this option is not set, no signature verification
> will be done. Only exception will be when secureboot is enabled. In that
> case signature verification should be automatically enforced when secureboot
> is enabled. But that will happen when secureboot patches are merged.
> 
> Second config option is CONFIG_KEXEC_BZIMAGE_VERIFY_SIG. This option
> enables signature verification support on bzImage. If this option is
> not set and previous one is set, kernel image loading will fail because
> kernel does not have support to verify signature of bzImage.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi Andrew,

I am wondering how this final kexec patch should be routed. Issue here is that
this patch depends on David Howells's PKCS7 and PEFILE patches. Which are now
sitting in security tree. (security/next).

http://git.kernel.org/cgit/linux/kernel/git/jmorris/linux-security.git/log/?h=next

Not sure how to handle this dependency issue.

Thanks
Vivek 


> ---
>  arch/x86/Kconfig                   | 22 ++++++++++++++++++++++
>  arch/x86/kernel/kexec-bzimage64.c  | 21 +++++++++++++++++++++
>  arch/x86/kernel/machine_kexec_64.c | 11 +++++++++++
>  include/linux/kexec.h              |  3 +++
>  kernel/kexec.c                     | 15 +++++++++++++++
>  5 files changed, 72 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 2cee2a6..1c1d3a9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1593,6 +1593,28 @@ config KEXEC
>  	  interface is strongly in flux, so no good recommendation can be
>  	  made.
>  
> +config KEXEC_VERIFY_SIG
> +	bool "Verify kernel signature during kexec_file_load() syscall"
> +	depends on KEXEC
> +	---help---
> +	  This option makes kernel signature verification mandatory for
> +	  kexec_file_load() syscall. If kernel is signature can not be
> +	  verified, kexec_file_load() will fail.
> +
> +	  This option enforces signature verification at generic level.
> +	  One needs to enable signature verification for type of kernel
> +	  image being loaded to make sure it works. For example, enable
> +	  bzImage signature verification option to be able to load and
> +	  verify signatures of bzImage. Otherwise kernel loading will fail.
> +
> +config KEXEC_BZIMAGE_VERIFY_SIG
> +	bool "Enable bzImage signature verification support"
> +	depends on KEXEC_VERIFY_SIG
> +	depends on SIGNED_PE_FILE_VERIFICATION
> +	select SYSTEM_TRUSTED_KEYRING
> +	---help---
> +	  Enable bzImage signature verification support.
> +
>  config CRASH_DUMP
>  	bool "kernel crash dumps"
>  	depends on X86_64 || (X86_32 && HIGHMEM)
> diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
> index 623e6c5..9642b9b 100644
> --- a/arch/x86/kernel/kexec-bzimage64.c
> +++ b/arch/x86/kernel/kexec-bzimage64.c
> @@ -19,6 +19,8 @@
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/efi.h>
> +#include <linux/verify_pefile.h>
> +#include <keys/system_keyring.h>
>  
>  #include <asm/bootparam.h>
>  #include <asm/setup.h>
> @@ -525,8 +527,27 @@ int bzImage64_cleanup(void *loader_data)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
> +int bzImage64_verify_sig(const char *kernel, unsigned long kernel_len)
> +{
> +	bool trusted;
> +	int ret;
> +
> +	ret = verify_pefile_signature(kernel, kernel_len,
> +				      system_trusted_keyring, &trusted);
> +	if (ret < 0)
> +		return ret;
> +	if (!trusted)
> +		return -EKEYREJECTED;
> +	return 0;
> +}
> +#endif
> +
>  struct kexec_file_ops kexec_bzImage64_ops = {
>  	.probe = bzImage64_probe,
>  	.load = bzImage64_load,
>  	.cleanup = bzImage64_cleanup,
> +#ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
> +	.verify_sig = bzImage64_verify_sig,
> +#endif
>  };
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index 9330434..8b04018 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -372,6 +372,17 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
>  	return image->fops->cleanup(image->image_loader_data);
>  }
>  
> +int arch_kexec_kernel_verify_sig(struct kimage *image, void *kernel,
> +				 unsigned long kernel_len)
> +{
> +	if (!image->fops || !image->fops->verify_sig) {
> +		pr_debug("kernel loader does not support signature verification.");
> +		return -EKEYREJECTED;
> +	}
> +
> +	return image->fops->verify_sig(kernel, kernel_len);
> +}
> +
>  /*
>   * Apply purgatory relocations.
>   *
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 9481703..4b2a0e1 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -191,11 +191,14 @@ typedef void *(kexec_load_t)(struct kimage *image, char *kernel_buf,
>  			     unsigned long initrd_len, char *cmdline,
>  			     unsigned long cmdline_len);
>  typedef int (kexec_cleanup_t)(void *loader_data);
> +typedef int (kexec_verify_sig_t)(const char *kernel_buf,
> +				 unsigned long kernel_len);
>  
>  struct kexec_file_ops {
>  	kexec_probe_t *probe;
>  	kexec_load_t *load;
>  	kexec_cleanup_t *cleanup;
> +	kexec_verify_sig_t *verify_sig;
>  };
>  
>  /* kexec interface functions */
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 3cd56af..564432a 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -415,6 +415,12 @@ void __weak arch_kimage_file_post_load_cleanup(struct kimage *image)
>  {
>  }
>  
> +int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
> +					unsigned long buf_len)
> +{
> +	return -EKEYREJECTED;
> +}
> +
>  /* Apply relocations of type RELA */
>  int __weak
>  arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
> @@ -493,6 +499,15 @@ kimage_file_prepare_segments(struct kimage *image, int kernel_fd, int initrd_fd,
>  	if (ret)
>  		goto out;
>  
> +#ifdef CONFIG_KEXEC_VERIFY_SIG
> +	ret = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
> +					   image->kernel_buf_len);
> +	if (ret) {
> +		pr_debug("kernel signature verification failed.\n");
> +		goto out;
> +	}
> +	pr_debug("kernel signature verification successful.\n");
> +#endif
>  	/* It is possible that there no initramfs is being loaded */
>  	if (!(flags & KEXEC_FILE_NO_INITRAMFS)) {
>  		ret = copy_file_from_fd(initrd_fd, &image->initrd_buf,
> -- 
> 1.9.0
