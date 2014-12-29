Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaL2X7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:59:00 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:40056 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaL2X66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:58:58 -0500
MIME-Version: 1.0
In-Reply-To: <1415313426-9622-107-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
	<1415313426-9622-107-git-send-email-kamal@canonical.com>
Date: Mon, 29 Dec 2014 15:58:57 -0800
Message-ID: <CAHTgTXXWqYd+wuDd+4_SAxFJO-beDrhJffXBB7fGz+PmeA0T3w@mail.gmail.com>
Subject: Re: [PATCH 3.13 106/162] KVM: x86: Fix far-jump to non-canonical check
From: Vinson Lee <vlee@twopensource.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 2:36 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> 3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Nadav Amit <namit@cs.technion.ac.il>
>
> commit 7e46dddd6f6cd5dbf3c7bd04a7e75d19475ac9f2 upstream.
>
> Commit d1442d85cc30 ("KVM: x86: Handle errors when RIP is set during far
> jumps") introduced a bug that caused the fix to be incomplete.  Due to
> incorrect evaluation, far jump to segment with L bit cleared (i.e., 32-bit
> segment) and RIP with any of the high bits set (i.e, RIP[63:32] != 0) set may
> not trigger #GP.  As we know, this imposes a security problem.
>
> In addition, the condition for two warnings was incorrect.
>
> Fixes: d1442d85cc30ea75f7d399474ca738e0bc96f715
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> [Add #ifdef CONFIG_X86_64 to avoid complaints of undefined behavior. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [ kamal: backport to 3.13-stable: omitted WARN_ON fixes (not in 3.13) ]
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  arch/x86/kvm/emulate.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index a440bea..4ae37e7 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -581,12 +581,14 @@ static inline int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst,
>         case 4:
>                 ctxt->_eip = (u32)dst;
>                 break;
> +#ifdef CONFIG_X86_64
>         case 8:
>                 if ((cs_l && is_noncanonical_address(dst)) ||
> -                   (!cs_l && (dst & ~(u32)-1)))
> +                   (!cs_l && (dst >> 32) != 0))
>                         return emulate_gp(ctxt, 0);
>                 ctxt->_eip = dst;
>                 break;
> +#endif
>         default:
>                 WARN(1, "unsupported eip assignment size\n");
>         }
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hi.

Should the WARN_ON fixes have been included as well in 3.13.11.11?

WARN_ON hunks were added with the backport of "KVM: x86: Handle errors
when RIP is set during far jumps" in 3.13.11.11 commit
b8ba339d86fb627d54fea929492114d45f6835c2.

Cheers,
Vinson
