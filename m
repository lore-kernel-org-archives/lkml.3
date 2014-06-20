Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966952AbaFTUkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:40:17 -0400
Received: from www.sr71.net ([198.145.64.142]:56355 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbaFTUkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:40:15 -0400
Message-ID: <53A49C2C.6030303@sr71.net>
Date: Fri, 20 Jun 2014 13:40:12 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [RFC][PATCH 1/3] x86: introduce disabled-features
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
In-Reply-To: <20140620161736.D6AC16FD@viggo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 09:17 AM, Dave Hansen wrote:
> +/* These features, although they might be available in a CPU
> + * will not be used because the compile options to support
> + * them are not present.
> + *
> + * This code allows them to be checked and disabled at
> + * compile time withut an explicit #ifdef.  Simply call
> + * cpu_has() or this_cpu_has().
> + * */
> +
> +#ifdef CONFIG_X86_INTEL_MPX
> +# define HAVE_MPX	(1<<(X86_FEATURE_MPX & 31))
> +#else
> +# define HAVE_MPX	0
> +#endif

Urg.  arch/x86/kvm/vmx.c has:

        if (boot_cpu_has(X86_FEATURE_MPX))
                rdmsrl(MSR_IA32_BNDCFGS, vmx->host_state.msr_host_...

And in that case we really _do_ want to test the actual CPU bit, despite
how we've configured MPX in the host kernel.  We can call test_cpu_cap()
directly, I guess.  But, all these interfaces are getting confusing. :(
