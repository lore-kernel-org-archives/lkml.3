Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaHVJc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:32:27 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:37638 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaHVJc0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Fri, 22 Aug 2014 05:32:26 -0400
Message-Id: <53F72A46020000780002C957@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 22 Aug 2014 10:32:22 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Juergen Gross" <JGross@suse.com>
Cc: <stefan.bader@canonical.com>, <toshi.kani@hp.com>, <x86@kernel.org>,
        <ville.syrjala@linux.intel.com>,
        "xen-devel" <xen-devel@lists.xenproject.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH RFC 2/3] x86: Enable PAT to use cache
 mode translation tables
References: <1408454745-32358-1-git-send-email-jgross@suse.com>
 <1408454745-32358-3-git-send-email-jgross@suse.com>
In-Reply-To: <1408454745-32358-3-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.08.14 at 15:25, <JGross@suse.com> wrote:
> @@ -118,8 +167,14 @@ void pat_init(void)
>  	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
>  
>  	/* Boot CPU check */
> -	if (!boot_pat_state)
> +	if (!boot_pat_state) {
>  		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
> +		/*
> +		 * Init cache mode tables before writing MSR to give Xen a
> +		 * chance to correct the changes when doing the write.
> +		 */

This comment seems pretty odd to me: For one, a PV guest on Xen
shouldn't be trying to write PAT MSR at all under the current ABI
(the write will be ignored, yes, but accompanied with a warning
message, which PV kernels - by the mere fact that they're PV -
should try to avoid). And then "correct the changes" both gives
the impression as if they were wrong and as if some of what the
kernel writes may be under the kernel's control. Hence I think this
code and comment should either be consistently assuming that the
kernel has no control at all, or should read back the value after
having written it, and set the internal tables based on the value
read back.

Jan

> +		pat_init_cache_modes(pat);
> +	}
>  
>  	wrmsrl(MSR_IA32_CR_PAT, pat);
>  


