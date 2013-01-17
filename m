Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab3AQRD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:03:59 -0500
Received: from mga05.intel.com ([192.55.52.89]:30887 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755256Ab3AQRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKYHUDj6gxz44_bOe1ggoeqZd2HaA3R34OXgHqGR9X7AcQ@mail.gmail.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	<1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	<1358437021.2689.52.camel@falcor1>
	<20130117155154.GC12165@redhat.com>
	<1358440365.2689.72.camel@falcor1>
	<CALLzPKYHUDj6gxz44_bOe1ggoeqZd2HaA3R34OXgHqGR9X7AcQ@mail.gmail.com>
Date: Thu, 17 Jan 2013 19:03:51 +0200
Message-ID: <CALLzPKZQZwfxHsHN1hbZK6mc6imBTO6Y1EbTYYP2BQWtZTXmpg@mail.gmail.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This is just a quick-patch for IMA to lock digitally signed binaries
in similar manner as the patch of this thread does...

No policy here. No optimization here. Just tests if binary has signature.
Rather simple.

- Dmitry


On Thu, Jan 17, 2013 at 7:01 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> commit f6bf2c4c0339dabac435f518bb1fcb617fdef8f1
> Author: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Date:   Thu Jan 17 18:50:43 2013 +0200
>
>     ima: lock down memory if binary is digitally signed
>
>     This patch set a flag in the linux_binprm structure if binary is
>     digitally signed. The flag is used to lock down memory when loading
>     ELF binary.
>
>     Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 0c42cdb..ba94d13 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -44,6 +44,8 @@
>  #define user_siginfo_t siginfo_t
>  #endif
>
> +#define LSM_UNSAFE_DIGSIG      16
> +
>  static int load_elf_binary(struct linux_binprm *bprm);
>  static int load_elf_library(struct file *);
>  static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
> @@ -788,6 +790,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
>
>                 elf_flags = MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE;
>
> +               if (bprm->unsafe & LSM_UNSAFE_DIGSIG)
> +                       elf_flags |= MAP_LOCKED;
> +
>                 vaddr = elf_ppnt->p_vaddr;
>                 if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
>                         elf_flags |= MAP_FIXED;
> diff --git a/security/integrity/ima/ima_main.c
> b/security/integrity/ima/ima_main.c
> index b359fb5..50d9959 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -27,6 +27,8 @@
>
>  #include "ima.h"
>
> +#define LSM_UNSAFE_DIGSIG      16
> +
>  int ima_initialized;
>
>  #ifdef CONFIG_IMA_APPRAISE
> @@ -315,10 +317,19 @@ int ima_file_mmap(struct file *file, unsigned long prot)
>   */
>  int ima_bprm_check(struct linux_binprm *bprm)
>  {
> -       return process_measurement(bprm->file,
> +       int err;
> +       struct integrity_iint_cache *iint;
> +
> +       err = process_measurement(bprm->file,
>                                  (strcmp(bprm->filename, bprm->interp) == 0) ?
>                                  bprm->filename : bprm->interp,
>                                  MAY_EXEC, BPRM_CHECK);
> +
> +       iint = integrity_iint_find(bprm->file->f_dentry->d_inode);
> +       if (iint && (iint->flags & IMA_DIGSIG))
> +               bprm->unsafe |= LSM_UNSAFE_DIGSIG;
> +
> +       return err;
>  }
>
>  /**
