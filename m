Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3LWNeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 08:34:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab3LWNeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 08:34:08 -0500
Date: Mon, 23 Dec 2013 14:34:02 +0100
From: Borislav Petkov <bp@suse.de>
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH v2][TRIVIAL] x86/smpboot: fix cpu bootup message
Message-ID: <20131223133402.GA4487@pd.tnic>
References: <52B7F53C.5020001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52B7F53C.5020001@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 04:33:00PM +0800, Xie XiuQi wrote:
> When CPU0 and CPU1 aren't in same package, we got message
> like this:
> 
> [    0.995698] x86: Booting SMP configuration:
> [    0.999858] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #8
> [    1.201584] .... node  #1, CPUs:    #9 #10 #11 #12 #13 #14 #15 #16
> [    1.402525] .... node  #2, CPUs:   #17 #18 #19 #20 #21 #22 #23 #24
> [    1.603620] .... node  #3, CPUs:   #25 #26 #27 #28 #29 #30 #31 #32
> [    1.804226] .... node  #4, CPUs:   #33 #34 #35 #36 #37 #38 #39
> [    1.914040] .... node  #5, CPUs:   #40 #41 #42 #43 #44 #45 #46 #47
> [    2.115568] .... node  #6, CPUs:   #48 #49 #50 #51 #52 #53 #54 #55
> [    2.316541] .... node  #7, CPUs:   #56 #57 #58 #59 #60 #61 #62 #63
> [    2.517030] x86: Booted up 8 nodes, 64 CPUs
> 
> My box's configuration as below:
> xiexiuqi@localhost:~> lscpu
> [...]
> NUMA node0 CPU(s):     1-8
> NUMA node1 CPU(s):     9-16
> NUMA node2 CPU(s):     17-24
> NUMA node3 CPU(s):     25-32
> NUMA node4 CPU(s):     0,33-39
> NUMA node5 CPU(s):     40-47
> NUMA node6 CPU(s):     48-55
> NUMA node7 CPU(s):     56-63
> 
> With this patch, we'll get message like this:
> 
> [    0.995698] x86: Booting SMP configuration:
> [    0.999858] .... node  #0, CPUs:    #1  #2  #3  #4  #5  #6  #7  #8
> [    1.201584] .... node  #1, CPUs:    #9 #10 #11 #12 #13 #14 #15 #16
> [    1.402525] .... node  #2, CPUs:   #17 #18 #19 #20 #21 #22 #23 #24
> [    1.603620] .... node  #3, CPUs:   #25 #26 #27 #28 #29 #30 #31 #32
> [    1.804226] .... node  #4, CPUs:       #33 #34 #35 #36 #37 #38 #39
> [    1.914040] .... node  #5, CPUs:   #40 #41 #42 #43 #44 #45 #46 #47
> [    2.115568] .... node  #6, CPUs:   #48 #49 #50 #51 #52 #53 #54 #55
> [    2.316541] .... node  #7, CPUs:   #56 #57 #58 #59 #60 #61 #62 #63
> [    2.517030] x86: Booted up 8 nodes, 64 CPUs
> 
> v2:
>  - fix a typo
> 
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> ---
>  arch/x86/kernel/smpboot.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 85dc05a..9e82c1e 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -639,7 +639,7 @@ static void announce_cpu(int cpu, int apicid)
>  {
>  	static int current_node = -1;
>  	int node = early_cpu_to_node(cpu);
> -	static int width, node_width;
> +	static int width, node_width, padding;
> 
>  	if (!width)
>  		width = num_digits(num_possible_cpus()) + 1; /* + '#' sign */
> @@ -658,11 +658,13 @@ static void announce_cpu(int cpu, int apicid)
> 
>  			printk(KERN_INFO ".... node %*s#%d, CPUs:  ",
>  			       node_width - num_digits(node), " ", node);
> -		}
> 
> -		/* Add padding for the BSP */
> -		if (cpu == 1)
> -			pr_cont("%*s", width + 1, " ");
> +			/* Add padding for the BSP */
> +			if (!padding && (early_cpu_to_node(0) == current_node)) {

You don't need "padding".

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
