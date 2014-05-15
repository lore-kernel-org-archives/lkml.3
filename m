Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaEOUuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:50:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:48637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbaEOUuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:50:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1061,1389772800"; 
   d="scan'208";a="541210592"
Message-ID: <53752885.5080306@intel.com>
Date: Thu, 15 May 2014 13:50:13 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] x86: skip check for spurious faults for non-present faults
References: <1399890550-26475-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1399890550-26475-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 03:29 AM, David Vrabel wrote:
> -	/* Reserved-bit violation or user access to kernel space? */
> -	if (error_code & (PF_USER | PF_RSVD))
> +	/* Only check for spurious faults on supervisor write or
> +	   instruction faults. */
> +	if (error_code != (PF_WRITE | PF_PROT)
> +	    && error_code != (PF_INSTR | PF_PROT))
>  		return 0;

This changes the semantics a bit too much for me to feel happy about it.
 This is at best missing quite a bit of detail from the changelog.

 1. 'return 0' means "this was not a spurious fault"
 2. We used to check for the presence of PF_USER|PF_RSVD
 3. This patch checks now for two _explicit_ conditions, which
    implicitly check for the _absence_ of the two bits we checked for
    before.

I do believe your patch is correct, but it took me a bit to convince
myself that it was the right thing.  Please be explicit (in the comment)
about the exact PTE transitions that you expect to get you here.

Also, I have to wonder if you can just leave the original if() in there.
 You're making this _more_ restrictive than it was before, and I wonder
if it might just be more clear if you have both checks.  The compiler
might even compile it down to the same code, just changing the immediate
that was generated for the mask that you're checking.
