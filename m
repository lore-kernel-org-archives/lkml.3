Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3AQRp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:45:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3AQRp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:45:57 -0500
Date: Thu, 17 Jan 2013 12:42:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130117174237.GC2237@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
 <1358437021.2689.52.camel@falcor1>
 <20130117155154.GC12165@redhat.com>
 <1358440365.2689.72.camel@falcor1>
 <CALLzPKYHUDj6gxz44_bOe1ggoeqZd2HaA3R34OXgHqGR9X7AcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKYHUDj6gxz44_bOe1ggoeqZd2HaA3R34OXgHqGR9X7AcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 07:01:40PM +0200, Kasatkin, Dmitry wrote:
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
> +#define LSM_UNSAFE_DIGSIG	16
> +
>  static int load_elf_binary(struct linux_binprm *bprm);
>  static int load_elf_library(struct file *);
>  static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
> @@ -788,6 +790,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
> 
>  		elf_flags = MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE;
> 
> +		if (bprm->unsafe & LSM_UNSAFE_DIGSIG)
> +			elf_flags |= MAP_LOCKED;
> +

Couple of thoughts.

- I think my patch does not take care of locking down future mappings. I
  think we might have to do.

	current->mm->def_flags = VM_LOCKED;	

 Along the lines of do_mlockall().

- Also there is still a small window open where changes to file contents
  by directly writing to block will not be detected. We are doing IMA
  check first and then faulting in pages in memory. It might have happend
  that write to disk block happened after IMA check but before page was
  read back from disk.

  so some kind of post verification also is probably needed. Or just map
  it first and then do the verification.

Thanks
Vivek
