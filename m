Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaBQIer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:34:47 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:53242 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaBQIel convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Mon, 17 Feb 2014 03:34:41 -0500
Message-Id: <5301D7AA020000780011CBE9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 17 Feb 2014 08:34:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Petr Tesarik" <ptesarik@suse.cz>
Cc: "Borislav Petkov" <bp@alien8.de>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Issue a warning if number of present CPUs >
 maxcpus and CONFIG_HOTPLUG=n
References: <20140215150223.63bb52fb@hananiah.suse.cz>
In-Reply-To: <20140215150223.63bb52fb@hananiah.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.02.14 at 15:02, Petr Tesarik <ptesarik@suse.cz> wrote:
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1226,9 +1226,6 @@ __init void prefill_possible_map(void)
>  #ifdef CONFIG_HOTPLUG_CPU
>  		if (setup_max_cpus)
>  			possible += disabled_cpus;
> -#else
> -		if (possible > i)
> -			possible = i;
>  #endif
>  	} else
>  		possible = setup_possible_cpus;

In between here total_cpus is being set, which now will get a
larger value if !HOTPLUG_CPU. Did you check that this has no
unintended side effect? And even if you did, it would still feel
more safe if you moved that line down after the capping point
below.

Similarly (but perhaps less important, albeit possibly slightly
confusing) the NR_CPUS related warning could now get issued
along with the warning below (when possible > nr_cpu_ids > i).
Hence that may better be moved down too (or then in effect
the if() block you modify below would get moved up). I realize
that two warning instead of just one would also be possible
without any change, so you're not really introducing some
entirely new inconsistency here...

Jan

> @@ -1246,7 +1243,7 @@ __init void prefill_possible_map(void)
>  	if (!setup_max_cpus)
>  #endif
>  	if (possible > i) {
> -		pr_warn("%d Processors exceeds max_cpus limit of %u\n",
> +		pr_warn("%d Processors exceeds maxcpus limit of %u\n",
>  			possible, setup_max_cpus);
>  		possible = i;
>  	}
> -- 
> 1.8.4.5



