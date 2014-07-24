Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392AbaGXTS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:18:58 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:46575 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbaGXTS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140724165047.437075575@openvz.org>
References: <20140724164657.452106845@openvz.org>
	<20140724165047.437075575@openvz.org>
Date: Thu, 24 Jul 2014 12:18:56 -0700
X-Google-Sender-Auth: RJxd8U0DjcGf1SlZuNugQJI-7f8
Message-ID: <CAGXu5j+QHcrYjT8F9TZLA8YbJzZed28scp2y22QNO20sRF8Ndw@mail.gmail.com>
Subject: Re: [rfc 1/4] mm: Introduce may_adjust_brk helper
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 9:46 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> To eliminate code duplication lets introduce may_adjust_brk
> helper which we will use in brk() and prctl() syscalls.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Julien Tinnes <jln@google.com>
> ---
>  include/linux/mm.h |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
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
> @@ -1780,6 +1781,19 @@ extern struct vm_area_struct *copy_vma(s
>         bool *need_rmap_locks);
>  extern void exit_mmap(struct mm_struct *);
>
> +static inline int may_adjust_brk(unsigned long rlim,
> +                                unsigned long new_brk,
> +                                unsigned long start_brk,
> +                                unsigned long end_data,
> +                                unsigned long start_data)
> +{
> +       if (rlim < RLIMIT_DATA) {

Won't rlim always be the value from a call to rlimit(RLIMIT_DATA)? Is
there a good reason to not just put the rlimit() call in
may_adjust_brk()? This would actually be an optimization in the
prctl_set_mm case, since now it calls rlimit() unconditionally, but
doesn't need to.

-Kees

> +               if (((new_brk - start_brk) + (end_data - start_data)) > rlim)
> +                       return -ENOSPC;
> +       }
> +       return 0;
> +}
> +
>  extern int mm_take_all_locks(struct mm_struct *mm);
>  extern void mm_drop_all_locks(struct mm_struct *mm);
>
>



-- 
Kees Cook
Chrome OS Security
