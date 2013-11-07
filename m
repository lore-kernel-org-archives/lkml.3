Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3KGHzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:55:00 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59106 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3KGHyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:54:53 -0500
Date: Thu, 7 Nov 2013 08:54:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Marek Majkowski <marek@cloudflare.com>, Jiri Slaby <jslaby@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wrong symbol resolved for RIP on OOPS/BUG
Message-ID: <20131107075448.GA31926@gmail.com>
References: <1383767997-20765-1-git-send-email-marek@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383767997-20765-1-git-send-email-marek@cloudflare.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marek Majkowski <marek@cloudflare.com> wrote:

> "%pB" is intended for return addresses, and actually resolves the
> address - 1.  So it should only be used for backtraces.  Plain
> instruction addresses should use "%pS", which resolves the given
> address.
> 
> show_regs was using "%pB" to resolve the RIP symbol. This resolved the
> wrong symbol if the first instruction after a symbol created the
> OOPS/BUG. For example:
> 
> 0000000000000049 <before>:
>   49:   90                      nop
>   4a:   90                      nop
>   4b:   90                      nop
>   4c:   90                      nop
> 000000000000004d <suicide>:
>   4d:   ff 14 25 00 00 00 00    callq  *0x0
>   54:   c3                      retq
> 
> Will produce a message saying it's "before" that crashed, not "suicide".
> 
> This problem only happens when the crash occurs in the first instruction
> after a symbol. Therefore it's unlikely to occur on kernels with frame
> pointers (CONFIG_FRAME_POINTER=y).
> 
> Signed-off-by: Marek Majkowski <marek@cloudflare.com>
> 
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index deb6421..4c90013 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -27,6 +27,12 @@ static int die_counter;
>  
>  void printk_address(unsigned long address, int reliable)
>  {
> +	pr_cont(" [<%p>] %s%pS\n",
> +		(void *)address, reliable ? "" : "? ", (void *)address);
> +}
> +
> +static void printk_trace_address(unsigned long address, int reliable)
> +{
>  	pr_cont(" [<%p>] %s%pB\n",
>  		(void *)address, reliable ? "" : "? ", (void *)address);
>  }
> @@ -151,7 +157,7 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
>  {
>  	touch_nmi_watchdog();
>  	printk(data);
> -	printk_address(addr, reliable);
> +	printk_trace_address(addr, reliable);
>  }
>  
>  static const struct stacktrace_ops print_trace_ops = {

There's a recent commit from Jiri Slaby that I think tries to address the 
same problem:

  8d4c812a3e5f x86/dumpstack: Fix printk_address for direct addresses

You can find it in the -tip tree:

  git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

Thanks,

	Ingo
