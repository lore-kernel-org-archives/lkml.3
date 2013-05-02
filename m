Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3EBIwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:52:49 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53848 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3EBIwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:52:46 -0400
Date: Thu, 2 May 2013 10:52:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH RFC] x86: uaccess s/might_sleep/might_fault/
Message-ID: <20130502085241.GA27969@gmail.com>
References: <20130502022134.GA7700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502022134.GA7700@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@redhat.com> wrote:

> The only reason uaccess routines might sleep
> is if they fault. Make this explicit for
> __copy_from_user_nocache, and consistent with
> copy_from_user and friends.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> I've updated all other arches as well - still
> build-testing. Any objections to the x86 patch?
> 
>  arch/x86/include/asm/uaccess_64.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
> index 142810c..4f7923d 100644
> --- a/arch/x86/include/asm/uaccess_64.h
> +++ b/arch/x86/include/asm/uaccess_64.h
> @@ -235,7 +235,7 @@ extern long __copy_user_nocache(void *dst, const void __user *src,
>  static inline int
>  __copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
>  {
> -	might_sleep();
> +	might_fault();
>  	return __copy_user_nocache(dst, src, size, 1);

Looks good to me:

Acked-by: Ingo Molnar <mingo@kernel.org>


... but while reviewing the effects I noticed a bug in might_fault():

#ifdef CONFIG_PROVE_LOCKING
void might_fault(void)
{
        /*
         * Some code (nfs/sunrpc) uses socket ops on kernel memory while
         * holding the mmap_sem, this is safe because kernel memory doesn't
         * get paged out, therefore we'll never actually fault, and the
         * below annotations will generate false positives.
         */
        if (segment_eq(get_fs(), KERNEL_DS))
                return;

        might_sleep();

the might_sleep() call should come first. With the current code 
might_fault() schedules differently depending on CONFIG_PROVE_LOCKING, 
which is an undesired semantical side effect ...

So please fix that too while at it.

Thanks,

	Ingo
