Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3LXKgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 05:36:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab3LXKgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 05:36:07 -0500
Date: Tue, 24 Dec 2013 11:35:58 +0100
From: Borislav Petkov <bp@suse.de>
To: Xie XiuQi <xiexiuqi@huawei.com>, Ingo Molnar <mingo@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH v2][TRIVIAL] x86/smpboot: fix cpu bootup message
Message-ID: <20131224103558.GA5520@pd.tnic>
References: <52B7F53C.5020001@huawei.com>
 <20131223133402.GA4487@pd.tnic>
 <52B8DEAE.2040100@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52B8DEAE.2040100@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 09:09:02AM +0800, Xie XiuQi wrote:
> On 2013/12/23 21:34, Borislav Petkov wrote:
> > On Mon, Dec 23, 2013 at 04:33:00PM +0800, Xie XiuQi wrote:
> >> When CPU0 and CPU1 aren't in same package, we got message
> >> like this:
> >>
> 
> [...]
> 
> >>
> >> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> >> index 85dc05a..9e82c1e 100644
> >> --- a/arch/x86/kernel/smpboot.c
> >> +++ b/arch/x86/kernel/smpboot.c
> >> @@ -639,7 +639,7 @@ static void announce_cpu(int cpu, int apicid)
> >>  {
> >>  	static int current_node = -1;
> >>  	int node = early_cpu_to_node(cpu);
> >> -	static int width, node_width;
> >> +	static int width, node_width, padding;
> >>
> >>  	if (!width)
> >>  		width = num_digits(num_possible_cpus()) + 1; /* + '#' sign */
> >> @@ -658,11 +658,13 @@ static void announce_cpu(int cpu, int apicid)
> >>
> >>  			printk(KERN_INFO ".... node %*s#%d, CPUs:  ",
> >>  			       node_width - num_digits(node), " ", node);
> >> -		}
> >>
> >> -		/* Add padding for the BSP */
> >> -		if (cpu == 1)
> >> -			pr_cont("%*s", width + 1, " ");
> >> +			/* Add padding for the BSP */
> >> +			if (!padding && (early_cpu_to_node(0) == current_node)) {
> > 
> > You don't need "padding".
> > 
> 
> On another machine, the configuration is:
> 
> xiexiuqi@localhost:~> lscpu
> [...]
> NUMA node0 CPU(s):     4-7,12-15
> NUMA node1 CPU(s):     0-3,8-11
> 
> Without "padding", we'll get message like this:
> 
> [    0.349339] x86: Booting SMP configuration:
> [    0.353504] .... node  #1, CPUs:        #1  #2  #3
> [    0.398812] .... node  #0, CPUs:    #4  #5  #6  #7
> [    0.535186] .... node  #1, CPUs:        #8  #9 #10 #11
> [    0.594312] .... node  #0, CPUs:   #12 #13 #14 #15
> [    0.652398] x86: Booted up 2 nodes, 16 CPUs

Geez, is that box generating the cores to nodes groups at random during
each boot?!

Gotta admire bios dudes' "inventiveness".

Ok, so Ingo, I guess we can take this -v2 version for now - I need to
think of a way on how to address all that nonsense properly.

Acked-by: Borislav "luvz BIOS people" Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
