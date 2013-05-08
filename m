Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3EHKkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:40:03 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:65160 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3EHKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:40:00 -0400
Date: Wed, 8 May 2013 12:39:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v8 11/11] Move arch/x86 reboot= handling to generic
 kernel.
Message-ID: <20130508103956.GA7677@gmail.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
 <1367937595-32241-12-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367937595-32241-12-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> Merge together the unicore32, arm, and x86 reboot= command line
> parameter handling.

The series still has this CONFIG_X86 dependency that I inquired about 
previously:

> +static int __init reboot_setup(char *str)
> +{
> +	for (;;) {
> +		/*
> +		 * Having anything passed on the command line via
> +		 * reboot= will cause us to disable DMI checking
> +		 * below.
> +		 */
> +		reboot_default = 0;
> +
> +		switch (*str) {
> +#if defined(CONFIG_X86) || defined(CONFIG_X86_64)
> +		case 'w':
> +			reboot_mode = REBOOT_WARM;
> +			break;
> +
> +		case 'c':
> +			reboot_mode = REBOOT_COLD;
> +			break;
> +
> +#ifdef CONFIG_SMP
> +		case 's':
> +			if (isdigit(*(str+1))) {
> +				reboot_cpu = (int) (*(str+1) - '0');
> +				if (isdigit(*(str+2)))
> +					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
> +			}
> +			/*
> +			 * We will leave sorting out the final value
> +			 * when we are ready to reboot, since we might not
> +			 * have detected BSP APIC ID or smp_num_cpu
> +			 */
> +			break;
> +#endif /* CONFIG_SMP */
> +
> +#else
> +		case 's':
> +			reboot_mode = REBOOT_WARM;
> +		case 'h':
> +			reboot_mode = REBOOT_COLD;
> +		case 'g':
> +			reboot_mode = REBOOT_GPIO;
> +#endif
> +
> +		case 'b':
> +		case 'a':
> +		case 'k':
> +		case 't':
> +		case 'e':
> +		case 'p':
> +			reboot_type = *str;
> +			break;
> +
> +		case 'f':
> +			reboot_force = 1;
> +			break;
> +		}
> +
> +		str = strchr(str, ',');
> +		if (str)
> +			str++;
> +		else
> +			break;
> +	}
> +	return 1;

To explain my concern more verbosely, if we cannot make it 'obviously 
generic' then there's no point in moving it to kernel/reboot.c ...

And yes, I realize that there's an option clash between architectures - 
see below for potential solutions to that.

To generalize it, firstly here's a summary of the existing reboot option 
mappings:

 x86-only:  w, c, s
 non-x86:         s, h, g
 generic:                  b, a, k, t, e, p, f


it appears that 'w', 'c', 'h', and 'g' could be made generic straight 
away.

Which leaves 's' as the only truly problematic option:

 - it means REBOOT_WARM on some non-x86 platform(s?)
 - while it means the SMP-cpu on x86.

Stupid question: which non-x86 platform(s) use 's'?

I think we should either change that platform to have 'w' as the warm 
reboot (and hope that no-one actually relies on the old 's' option: it's a 
truly rare option) - or change the x86 mapping from 's' to 'S' and 
generalize and unify it thusly.

Another cleanliness problem is the duality of reboot_mode and reboot_type. 
We should pick one and use it everywhere consistently.

[ Once these problems are solved and there's no objections from others to 
  this approach, I'd be willing to apply, test and push this series to 
  Linus. ]

Thanks,

	Ingo
