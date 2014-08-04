Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaHDUZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:25:44 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:58750
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaHDUZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:25:43 -0400
Date: Mon, 4 Aug 2014 22:25:41 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tj@kernel.org,
        akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com,
        hpa@zytor.com, serge.hallyn@canonical.com, xemul@parallels.com,
        segoon@openwall.com, kamezawa.hiroyu@jp.fujitsu.com,
        mtk.manpages@gmail.com, jln@google.com
Subject: Re: [patch 1/4] mm: Introduce check_data_rlimit helper, v2
Message-ID: <20140804202541.GB27304@mail.hallyn.com>
References: <20140804172255.109539743@openvz.org>
 <20140804172610.714056240@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804172610.714056240@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> To eliminate code duplication lets introduce check_data_rlimit
> helper which we will use in brk() and prctl() syscalls.
> 
> v2 (serge.hallyn@):
>  - need to check against RLIM_INFINITY rather than RLIMIT_DATA
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Julien Tinnes <jln@google.com>
> ---
>  include/linux/mm.h |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> Index: linux-2.6.git/include/linux/mm.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/mm.h
> +++ linux-2.6.git/include/linux/mm.h
> @@ -18,6 +18,7 @@
>  #include <linux/pfn.h>
>  #include <linux/bit_spinlock.h>
>  #include <linux/shrinker.h>
> +#include <linux/resource.h>
>  
>  struct mempolicy;
>  struct anon_vma;
> @@ -1780,6 +1781,20 @@ extern struct vm_area_struct *copy_vma(s
>  	bool *need_rmap_locks);
>  extern void exit_mmap(struct mm_struct *);
>  
> +static inline int check_data_rlimit(unsigned long rlim,
> +				    unsigned long new,
> +				    unsigned long start,
> +				    unsigned long end_data,
> +				    unsigned long start_data)
> +{
> +	if (rlim < RLIM_INFINITY) {
> +		if (((new - start) + (end_data - start_data)) > rlim)
> +			return -ENOSPC;
> +	}
> +
> +	return 0;
> +}
> +
>  extern int mm_take_all_locks(struct mm_struct *mm);
>  extern void mm_drop_all_locks(struct mm_struct *mm);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
