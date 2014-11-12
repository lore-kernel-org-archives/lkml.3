Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbaKLCFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:05:23 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48540 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaKLCFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:05:20 -0500
Message-ID: <5462C1D3.3010504@gmail.com>
Date: Wed, 12 Nov 2014 10:11:31 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: cmetcalf@tilera.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: kernel: kgdb.c: Use memcpy() instead of pointer
 copy one by one
References: <5454DD70.6060004@gmail.com>
In-Reply-To: <5454DD70.6060004@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello maintainer:

Please help check this patch, when you have time (sorry for my original
typo for your email address, so maybe you did not notice about the
original mail).

Thanks.

On 11/1/14 21:17, Chen Gang wrote:
> Not only memcpy() is faster than pointer copy, but also let code more
> clearer and simple, which can avoid compiling warning (the original
> implementation copy registers by exceeding member array border).
> 
> The related warning (with allmodconfig under tile):
> 
>     CC      arch/tile/kernel/kgdb.o
>   arch/tile/kernel/kgdb.c: In function 'sleeping_thread_to_gdb_regs':
>   arch/tile/kernel/kgdb.c:140:31: warning: iteration 53u invokes undefined behavior [-Waggressive-loop-optimizations]
>      *(ptr++) = thread_regs->regs[reg];
>                                  ^
>   arch/tile/kernel/kgdb.c:139:2: note: containing loop
>     for (reg = 0; reg <= TREG_LAST_GPR; reg++)
>     ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/tile/kernel/kgdb.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/tile/kernel/kgdb.c b/arch/tile/kernel/kgdb.c
> index 4cd8838..ff5335a 100644
> --- a/arch/tile/kernel/kgdb.c
> +++ b/arch/tile/kernel/kgdb.c
> @@ -125,9 +125,7 @@ int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
>  void
>  sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *task)
>  {
> -	int reg;
>  	struct pt_regs *thread_regs;
> -	unsigned long *ptr = gdb_regs;
>  
>  	if (task == NULL)
>  		return;
> @@ -136,9 +134,7 @@ sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *task)
>  	memset(gdb_regs, 0, NUMREGBYTES);
>  
>  	thread_regs = task_pt_regs(task);
> -	for (reg = 0; reg <= TREG_LAST_GPR; reg++)
> -		*(ptr++) = thread_regs->regs[reg];
> -
> +	memcpy(gdb_regs, thread_regs, TREG_LAST_GPR * sizeof(unsigned long));
>  	gdb_regs[TILEGX_PC_REGNUM] = thread_regs->pc;
>  	gdb_regs[TILEGX_FAULTNUM_REGNUM] = thread_regs->faultnum;
>  }
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
