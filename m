Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaHMXQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:16:59 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40518 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHMXQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:16:58 -0400
Date: Wed, 13 Aug 2014 16:16:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fengguang Wu <fengguang.wu@intel.com>
cc: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix messed up page fault BUG messages
In-Reply-To: <20140813112724.GA6338@localhost>
Message-ID: <alpine.DEB.2.02.1408131615220.31428@chino.kir.corp.google.com>
References: <20140813112724.GA6338@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014, Fengguang Wu wrote:

> The 0day boot test robot hits messed up BUG lines like
> 
> [   25.732010] BUG: unable to handle kernel paging requestrun: /lkp/wfg/sr at 000000000000d908
> [   24.986598] BUG: unable to handle kernel run: /lkp/wfg/srpaging request at 000000000000d908
> [   24.914406] BUG: unable to handle kernel run: /lkp/wfg/srearly console in decompress_kernel
> 
> Which makes the generated bug ID not stable and hence not bisectable.
> 
> Fix it by printing the BUG message in one shot.
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  arch/x86/mm/fault.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 3664279..f3e0e0a 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -599,13 +599,13 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
>  			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
>  	}
>  
> -	printk(KERN_ALERT "BUG: unable to handle kernel ");
>  	if (address < PAGE_SIZE)
> -		printk(KERN_CONT "NULL pointer dereference");
> +		printk(KERN_ALERT "BUG: unable to handle kernel NULL pointer dereference at %p\n",
> +		       (void *) address);
>  	else
> -		printk(KERN_CONT "paging request");
> +		printk(KERN_ALERT "BUG: unable to handle kernel NULL pointer paging request at %p\n",
> +		       (void *) address);
>  
> -	printk(KERN_CONT " at %p\n", (void *) address);
>  	printk(KERN_ALERT "IP:");
>  	printk_address(regs->ip);
>  

That's been around forever, but I trust that an automated boot testing 
robot would find it more troublesome than most, so I agree it needs to be 
fixed.  One problem: it changes the message from

	BUG: unable to handle kernel paging request at %p

to

	BUG: unable to handle kernel NULL pointer paging request at %p

and the test for address < PAGE_SIZE is supposed to be the determining 
factor on whether it is a "NULL pointer" or not.  When that's fixed:

	Acked-by: David Rientjes <rientjes@google.com>
