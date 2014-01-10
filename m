Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbaAJX75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 18:59:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaAJX7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 18:59:55 -0500
Date: Fri, 10 Jan 2014 15:59:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: pavel@ucw.cz, joe@perches.com, keescook@chromium.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
Message-Id: <20140110155952.b376106ab7b76403af99111b@linux-foundation.org>
In-Reply-To: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014 21:52:00 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Hello.
> 
> Since addition of %pT itself seems to be agreed,

sort-of.  The reason I suggested inventing a new token was code
density: avoid pointlessly passing current all the time.

Oh well, whatever - this patch has other intentions.
	
> I refreshed this patch using
> linux-next-20140109. Please pick up if this patch is OK for you; I will start
> making patches for killing most of direct ->comm readers.
> 
> Regards.
> ----------------------------------------
> >From 0d1f03d59a477459f3d3c190593d9e78f5d67de8 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Thu, 9 Jan 2014 21:32:22 +0900
> Subject: [PATCH] lib/vsprintf: add %pT format specifier
> 
> Since task_struct->comm can be modified by other threads while the current
> thread is reading it, it is recommended to use get_task_comm() for reading it.
> 
> However, since get_task_comm() holds task_struct->alloc_lock spinlock,
> some users cannot use get_task_comm(). Also, a lot of users are directly
> reading from task_struct->comm even if they can use get_task_comm().
> Such users might obtain inconsistent result.
> 
> This patch introduces %pT format specifier for printing task_struct->comm.
> Currently %pT does not provide consistency. I'm planning to change to use RCU
> in the future. By using RCU, the comm name read from task_struct->comm will be
> guaranteed to be consistent.

Not completely accurate - RCU won't protect code which accesses ->comm
from interrupts.  Printing current->comm from irq is quite daft, but I
bet there's code that does it :(

As long as the kernel doesn't crash or otherwise misbehave when this
happens, I think we're OK.

(And I guess there's also non-daft code which accesses current->comm
from interrupt context: oops, panic, etc).

> But before modifying set_task_comm() to use RCU,
> we need to kill direct ->comm users who do not use get_task_comm().
> 
> An example for converting direct ->comm users is shown below. Since many debug
> printings use p == current, you can pass NULL instead of p if p == current.
> 
>   pr_info("comm=%s\n", p->comm);       => pr_info("comm=%pT\n", p);
>   pr_info("comm=%s\n", current->comm); => pr_info("comm=%pT\n", NULL);
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
> ---
>  Documentation/printk-formats.txt |    6 ++++++
>  lib/vsprintf.c                   |   20 +++++++++++++++++++-
>  2 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 6f4eb32..94459b4 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -184,6 +184,12 @@ dentry names:
>  	equivalent of %s dentry->d_name.name we used to use, %pd<n> prints
>  	n last components.  %pD does the same thing for struct file.
>  
> +task_struct comm name:
> +
> +        %pT
> +
> +        For printing task_struct->comm.
> +
>  struct va_format:
>  
>  	%pV
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 185b6d3..a97f18b 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1179,6 +1179,21 @@ char *address_val(char *buf, char *end, const void *addr,
>  	return number(buf, end, num, spec);
>  }
>  
> +static noinline_for_stack

hm, does noinline_for_stack actually do anything useful here?  I
suspect it *increases* stack depth in the way comm_name() is used here.

> +char *comm_name(char *buf, char *end, struct task_struct *tsk,
> +		struct printf_spec spec, const char *fmt)
> +{
> +	char name[TASK_COMM_LEN];
> +
> +	/* Caller can pass NULL instead of current. */
> +	if (!tsk)
> +		tsk = current;
> +	/* Not using get_task_comm() in case I'm in IRQ context. */
> +	memcpy(name, tsk->comm, TASK_COMM_LEN);
> +	name[sizeof(name) - 1] = '\0';

get_task_comm() uses strncpy()?

> +	return string(buf, end, name, spec);
> +}
> +

