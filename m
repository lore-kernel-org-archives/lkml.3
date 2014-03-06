Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbaCFFoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:44:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:36791 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaCFFoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:44:11 -0500
Message-ID: <1394084634.26321.23.camel@pasglop>
Subject: Re: [PATCH] powerpc/le: fix endianness of the arguments passed to
 the ppc_rtas() syscall
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: paulus@samba.org, linuxppc-dev@lists.ozlabs.org, anton@samba.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 16:43:54 +1100
In-Reply-To: <20140305172006.26117.57219.stgit@bahia.local>
References: <20140305172006.26117.57219.stgit@bahia.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 18:20 +0100, Greg Kurz wrote:
> RTAS manipulates its input and output arguments in big endian order.
> 
> I have looked at factoring some lines with rtas_call() but it is not really
> worth it because of the variable arguments.

I'm not sure about that one ...

So this assumes that userspace will pass the RTAS arguments LE...

This will work only as long as the arguments are indeed just an array
of u32's. The minute userspace tries to crap something like two u16's
in one argument or a u64 accross two arguments, it has the potential
to be broken depending on how it has been done.

I would have done it the other way around which is to define that
ppc_rtas takes a BE structure since this is what RTAS expects (and
the bit of RMA memory we expose to userspace for communicating with
it also has to be handled BE so userspace has to know anyway).

That means that the only things we need to fix here is when we interpret
the args.nargs etc... we need a be32_to_cpu

Cheers,
Ben.

> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> ---
>  arch/powerpc/kernel/rtas.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
> index 4cf674d..00dbe36 100644
> --- a/arch/powerpc/kernel/rtas.c
> +++ b/arch/powerpc/kernel/rtas.c
> @@ -1020,6 +1020,7 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
>  	char *buff_copy, *errbuf = NULL;
>  	int nargs;
>  	int rc;
> +	int i;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -1056,9 +1057,19 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
>  
>  	flags = lock_rtas();
>  
> -	rtas.args = args;
> +	rtas.args.token = cpu_to_be32(args.token);
> +	rtas.args.nargs = cpu_to_be32(args.nargs);
> +	rtas.args.nret  = cpu_to_be32(args.nret);
> +	for (i = 0; i < nargs; ++i)
> +		rtas.args.args[i] = cpu_to_be32(args.args[i]);
> +	rtas.args.rets  = &rtas.args.args[nargs];
> +	for (i = 0; i < args.nret; ++i)
> +		rtas.args.rets[i] = 0;
> +
>  	enter_rtas(__pa(&rtas.args));
> -	args = rtas.args;
> +
> +	for (i = 0; i < args.nret; ++i)
> +		args.rets[i] = be32_to_cpu(rtas.args.rets[i]);
>  
>  	/* A -1 return code indicates that the last command couldn't
>  	   be completed due to a hardware error. */


