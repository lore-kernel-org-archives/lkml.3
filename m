Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaIBOGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:06:15 -0400
Received: from mx12.pku.edu.cn ([162.105.129.175]:57603 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963AbaIBOGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:06:14 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.176
Date: Tue, 2 Sep 2014 22:06:01 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Message-ID: <741768080.30946.1409666761782.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <20140831181426.GA27355@roeck-us.net>
Subject: =?gbk?B?UmU6IFtQQVRDSCBSRVNFTkRdIHVuaWNvcmUzMjogRml4IGJ1aWxkIGVycm9y?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

----- Guenter Roeck <linux@roeck-us.net> 写道：
> unicore32 builds fail with
> 
> arch/unicore32/kernel/signal.c: In function ‘setup_frame’:
> arch/unicore32/kernel/signal.c:257: error:
> 			‘usig’ undeclared (first use in this function)
> arch/unicore32/kernel/signal.c:279: error:
> 			‘usig’ undeclared (first use in this function)
> arch/unicore32/kernel/signal.c: In function ‘handle_signal’:
> arch/unicore32/kernel/signal.c:306: warning: unused variable ‘tsk’
> arch/unicore32/kernel/signal.c: In function ‘do_signal’:
> arch/unicore32/kernel/signal.c:376: error:
> 			implicit declaration of function ‘get_signsl’
> make[1]: *** [arch/unicore32/kernel/signal.o] Error 1
> make: *** [arch/unicore32/kernel/signal.o] Error 2
> 
> Bisect points to commit 649671c90eaf ("unicore32: Use get_signal()
> signal_setup_done()").
> 
> This code never even compiled. Reverting the patch does not work,
> since previously used functions no longer exist, so try to fix it up.
> Compile tested only.
> 
> Fixes: 649671c90eaf ("unicore32: Use get_signal() signal_setup_done()")
> Cc: Richard Weinberger <richard@nod.at>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Resending after rebase to current upstream kernel.
> 
> Linus, please consider adding this patch directly to your tree.
> This is the one remaining build failure regression in the upstream kernel.
> 
>  arch/unicore32/kernel/signal.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
> index 780d773..7c8fb70 100644
> --- a/arch/unicore32/kernel/signal.c
> +++ b/arch/unicore32/kernel/signal.c
> @@ -254,7 +254,8 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
>  
>  	err |= setup_sigframe(frame, regs, set);
>  	if (err == 0)
> -		err |= setup_return(regs, &ksig->ka, frame->retcode, frame, usig);
> +		err |= setup_return(regs, &ksig->ka, frame->retcode, frame,
> +				    ksig->sig);
>  
>  	return err;
>  }
> @@ -276,7 +277,8 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
>  	err |= __save_altstack(&frame->sig.uc.uc_stack, regs->UCreg_sp);
>  	err |= setup_sigframe(&frame->sig, regs, set);
>  	if (err == 0)
> -		err |= setup_return(regs, &ksig->ka, frame->sig.retcode, frame, usig);
> +		err |= setup_return(regs, &ksig->ka, frame->sig.retcode, frame,
> +				    ksig->sig);
>  
>  	if (err == 0) {
>  		/*
> @@ -303,7 +305,6 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs,
>  			  int syscall)
>  {
>  	struct thread_info *thread = current_thread_info();
> -	struct task_struct *tsk = current;
>  	sigset_t *oldset = sigmask_to_save();
>  	int usig = ksig->sig;
>  	int ret;
> @@ -373,7 +374,7 @@ static void do_signal(struct pt_regs *regs, int syscall)
>  	if (!user_mode(regs))
>  		return;
>  
> -	if (get_signsl(&ksig)) {
> +	if (get_signal(&ksig)) {
>  		handle_signal(&ksig, regs, syscall);
>  		return;
>  	}
> -- 
> 1.9.1
> 

