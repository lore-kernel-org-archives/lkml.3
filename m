Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161AbaFCXBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:01:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:45985 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964824AbaFCXBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:01:53 -0400
Date: Tue, 3 Jun 2014 19:01:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH] ftrace/x86: Call text_ip_addr() instead of the
 duplicated code
Message-ID: <20140603190151.0f8e2087@gandalf.local.home>
In-Reply-To: <1401812601-2359-1-git-send-email-pmladek@suse.cz>
References: <1401812601-2359-1-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Jun 2014 18:23:21 +0200
Petr Mladek <pmladek@suse.cz> wrote:

> I just went over this when looking at some Xen-related ftrace initialization
> problems. They were related to Xen code that is not upstream but this clean up
> would make sense here.
> 
> I think that this was already the intention when text_ip_addr() was introduced
> in the commit 87fbb2ac6073a703930 (ftrace/x86: Use breakpoints for converting
> function graph caller). Anyway, better do it now before it shots people into
> their leg ;-)

You know, I made this change. It somehow got lost :-/

I better analyze this a bit to make sure it was just lost and I didn't
find some odd ball reason not to apply it. But I doubt I'll find
anything. If not, I'll get it enqueued for 3.16.

Thanks!

-- Steve


> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  arch/x86/kernel/ftrace.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 89de3eaf8772..cbc4a91b131e 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -297,16 +297,7 @@ int ftrace_int3_handler(struct pt_regs *regs)
>  
>  static int ftrace_write(unsigned long ip, const char *val, int size)
>  {
> -	/*
> -	 * On x86_64, kernel text mappings are mapped read-only with
> -	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
> -	 * of the kernel text mapping to modify the kernel text.
> -	 *
> -	 * For 32bit kernels, these mappings are same and we can use
> -	 * kernel identity mapping to modify code.
> -	 */
> -	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
> -		ip = (unsigned long)__va(__pa_symbol(ip));
> +	ip = text_ip_addr(ip);
>  
>  	if (probe_kernel_write((void *)ip, val, size))
>  		return -EPERM;

