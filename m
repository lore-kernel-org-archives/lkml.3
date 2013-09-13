Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3IMCrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 22:47:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3IMCrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 22:47:21 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=WdtGxyUilqkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=sv7EFDIe1RgA:10 a=yPCof4ZbAAAA:8 a=lMAOUChJ9jCPmaHkO1oA:9 a=CjuIK1q_8ugA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 12 Sep 2013 22:47:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: hpa@linux.intel.com, david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        Stefano.Stabellini@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] xen: Do not enable spinlocks before jump_label_init()
 has executed
Message-ID: <20130912224719.5a4a81da@gandalf.local.home>
In-Reply-To: <1379039384-1568-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1379039384-1568-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013 22:29:44 -0400
Boris Ostrovsky <boris.ostrovsky@oracle.com> wrote:

> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> xen_init_spinlocks() currently calls static_key_slow_inc() before
> jump_label_init() is invoked. When CONFIG_JUMP_LABEL is set (which usually is
> the case) the effect of this static_key_slow_inc() is deferred until after
> jump_label_init(). This is different from when CONFIG_JUMP_LABEL is not set, in
> which case the key is set immediately. Thus, depending on the value of config
> option, we may observe different behavior.
> 
> In addition, when we come to __jump_label_transform() from jump_label_init(),
> the key (paravirt_ticketlocks_enabled) is already enabled. On processors where
> ideal_nop is not the same as default_nop this will cause a BUG() since it is
> expected that before a key is enabled the latter is replaced by the former
> during initialization.
> 
> To address this problem we need to move
> static_key_slow_inc(&paravirt_ticketlocks_enabled) so that it is called
> after jump_label_init(). We also need to make sure that this is done before
> other cpus start to boot. early_initcall appears to be  a good place to do so.
> (Note that we cannot move whole xen_init_spinlocks() there since pv_lock_ops
> need to be set before alternative_instructions() runs.)
> 

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Peter,

This fixes a regression in 3.12 against xen. Please pull and push to
Linus sometime soon.

Thanks,

-- Steve

> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/xen/spinlock.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index 253f63f..d90628d 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -267,11 +267,18 @@ void __init xen_init_spinlocks(void)
>  		return;
>  	}
>  
> -	static_key_slow_inc(&paravirt_ticketlocks_enabled);
> -
>  	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
>  	pv_lock_ops.unlock_kick = xen_unlock_kick;
>  }
> +static __init int xen_init_spinlocks_jump(void)
> +{
> +	if (!xen_pvspin)
> +		return 0;
> +
> +	static_key_slow_inc(&paravirt_ticketlocks_enabled);
> +	return 0;
> +}
> +early_initcall(xen_init_spinlocks_jump);
>  
>  static __init int xen_parse_nopvspin(char *arg)
>  {

