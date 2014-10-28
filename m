Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaJ1O6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:58:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:8857 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750810AbaJ1O6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:58:46 -0400
Date: Tue, 28 Oct 2014 10:58:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] debugfs: Fix misuse of seq_printf return value
Message-ID: <20141028105831.69a14d4d@gandalf.local.home>
In-Reply-To: <2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 16:08:26 -0700
Joe Perches <joe@perches.com> wrote:

> Adding repeated -1 to the return is not correct.
> 
> Use seq_is_full to test for unnecessary seq_printf uses
> and always return 0.

Actually, debugfs_print_regs32() should return void as well.
I'll update that.

Thanks,

-- Steve

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/debugfs/file.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 76c08c2..c24e578 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -695,15 +695,17 @@ EXPORT_SYMBOL_GPL(debugfs_create_u32_array);
>  int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
>  			   int nregs, void __iomem *base, char *prefix)
>  {
> -	int i, ret = 0;
> +	int i;
>  
>  	for (i = 0; i < nregs; i++, regs++) {
> -		if (prefix)
> -			ret += seq_printf(s, "%s", prefix);
> -		ret += seq_printf(s, "%s = 0x%08x\n", regs->name,
> -				  readl(base + regs->offset));
> +		seq_printf(s, "%s%s = 0x%08x\n",
> +			   prefix ? prefix : "",
> +			   regs->name, readl(base + regs->offset));
> +		if (seq_is_full(s))
> +			break;
>  	}
> -	return ret;
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(debugfs_print_regs32);
>  

