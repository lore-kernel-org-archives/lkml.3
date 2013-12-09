Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772Ab3LIGVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:21:50 -0500
Received: from ozlabs.org ([203.10.76.45]:51281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760407Ab3LIGVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:21:47 -0500
In-Reply-To: <1386153162-11225-8-git-send-email-khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        khandual@linux.vnet.ibm.com
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: mikey@neuling.org, ak@linux.intel.com, eranian@google.com,
        acme@ghostprotocols.net, sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH V4 07/10] powerpc, lib: Add new branch instruction analysis support functions
Message-Id: <20131209062146.6D5C12C00BF@ozlabs.org>
Date: Mon,  9 Dec 2013 17:21:46 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-12 at 10:32:39 UTC, Anshuman Khandual wrote:
> Generic powerpc branch instruction analysis support added in the code
> patching library which will help the subsequent patch on SW based
> filtering of branch records in perf. This patch also converts and
> exports some of the existing local static functions through the header
> file to be used else where.
> 
> diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
> index a6f8c7a..8bab417 100644
> --- a/arch/powerpc/include/asm/code-patching.h
> +++ b/arch/powerpc/include/asm/code-patching.h
> @@ -22,6 +22,36 @@
>  #define BRANCH_SET_LINK	0x1
>  #define BRANCH_ABSOLUTE	0x2
>  
> +#define XL_FORM_LR  0x4C000020
> +#define XL_FORM_CTR 0x4C000420
> +#define XL_FORM_TAR 0x4C000460
> +
> +#define BO_ALWAYS    0x02800000
> +#define BO_CTR       0x02000000
> +#define BO_CRBI_OFF  0x00800000
> +#define BO_CRBI_ON   0x01800000
> +#define BO_CRBI_HINT 0x00400000
> +
> +/* Forms of branch instruction */
> +int instr_is_branch_iform(unsigned int instr);
> +int instr_is_branch_bform(unsigned int instr);
> +int instr_is_branch_xlform(unsigned int instr);
> +
> +/* Classification of XL-form instruction */
> +int is_xlform_lr(unsigned int instr);
> +int is_xlform_ctr(unsigned int instr);
> +int is_xlform_tar(unsigned int instr);
> +
> +/* Branch instruction is a call */
> +int is_branch_link_set(unsigned int instr);
> +
> +/* BO field analysis (B-form or XL-form) */
> +int is_bo_always(unsigned int instr);
> +int is_bo_ctr(unsigned int instr);
> +int is_bo_crbi_off(unsigned int instr);
> +int is_bo_crbi_on(unsigned int instr);
> +int is_bo_crbi_hint(unsigned int instr);


I think this is the wrong API.

We end up with all these micro checks, which don't actually encapsulate much,
and don't implement the logic perf needs. If we had another user for this level
of detail then it might make sense, but for a single user I think we're better
off just implementing the semantics it wants.

So that would be something more like:

bool instr_is_return_branch(unsigned int instr);
bool instr_is_conditional_branch(unsigned int instr);
bool instr_is_func_call(unsigned int instr);
bool instr_is_indirect_func_call(unsigned int instr);


These would then encapsulate something like the logic in your 8/10 patch. You
can hopefully also optimise the checking logic in each routine because you know
the exact semantics you're implementing.

cheers
