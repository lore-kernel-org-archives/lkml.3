Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbbAIRZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:25:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:37302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758192AbbAIRZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:25:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,731,1413270000"; 
   d="scan'208";a="635015692"
From: Andi Kleen <andi@firstfloor.org>
To: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mpx: Ensure unused arguments of prctl() MPX requests are 0
References: <54AE5BE8.1050701@gmail.com>
Date: Fri, 09 Jan 2015 09:25:51 -0800
In-Reply-To: <54AE5BE8.1050701@gmail.com> (Michael Kerrisk's message of "Thu,
	08 Jan 2015 11:28:56 +0100")
Message-ID: <87r3v350io.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> From: Michael Kerrisk <mtk.manpages@gmail.com>
>
> commit fe8c7f5cbf91124987106faa3bdf0c8b955c4cf7 added two new prctl()
> operations, PR_MPX_ENABLE_MANAGEMENT and PR_MPX_DISABLE_MANAGEMENT.
> However, no checks were included to ensure that unused arguments
> are zero, as is done in many existing prctl()s and as should be 
> done for all new prctl()s. This patch adds the required checks.

This will break the existing gcc run time, which doesn't zero these
arguments.

-ANdi

>
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
> ---
>  kernel/sys.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index a8c9f5a..ea9c881 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2210,9 +2210,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		up_write(&me->mm->mmap_sem);
>  		break;
>  	case PR_MPX_ENABLE_MANAGEMENT:
> +		if (arg2 || arg3 || arg4 || arg5)
> +			return -EINVAL;
>  		error = MPX_ENABLE_MANAGEMENT(me);
>  		break;
>  	case PR_MPX_DISABLE_MANAGEMENT:
> +		if (arg2 || arg3 || arg4 || arg5)
> +			return -EINVAL;
>  		error = MPX_DISABLE_MANAGEMENT(me);
>  		break;
>  	default:
> -- 
> 1.9.3

-- 
ak@linux.intel.com -- Speaking for myself only
