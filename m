Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3FRLE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:04:59 -0400
Received: from ozlabs.org ([203.10.76.45]:54027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab3FRLE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:04:57 -0400
From: Michael Neuling <mikey@neuling.org>
To: Grant Likely <grant.likely@linaro.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-next <linux-next@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2 08/11] irqdomain: Refactor irq_domain_associate_many()
In-reply-to: <20130618094617.9BFA93E0D88@localhost>
References: <1371244086-9189-1-git-send-email-grant.likely@linaro.org> <1371244086-9189-9-git-send-email-grant.likely@linaro.org> <4521.1371518445@ale.ozlabs.ibm.com> <5220.1371518734@ale.ozlabs.ibm.com> <CACxGe6s+K0xF0pnLjKoKXtz_YNoeM2+erhr_g2dX4ONpddRNGA@mail.gmail.com> <20130618094617.9BFA93E0D88@localhost>
Comments: In-reply-to Grant Likely <grant.likely@linaro.org>
   message dated "Tue, 18 Jun 2013 10:46:17 +0100."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Tue, 18 Jun 2013 21:04:55 +1000
Message-ID: <32351.1371553495@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@linaro.org> wrote:

> On Tue, 18 Jun 2013 10:05:31 +0100, Grant Likely <grant.likely@linaro.org> wrote:
> > On Tue, Jun 18, 2013 at 2:25 AM, Michael Neuling <mikey@neuling.org> wrote:
> > > Michael Neuling <mikey@neuling.org> wrote:
> > >
> > >> Grant,
> > >>
> > >> In next-20130617 we are getting the below crash on POWER7.  Bisecting,
> > >> points to this patch (d39046ec72 in next)
> > >
> > > Also, reverting just d39046ec72 fixes the crash in next-20130617.
> > 
> > Odd. Of all the changes in that series, I would not have expected that
> > one to cause any problems. I'm digging into it now...
> 
> Ugh. I flubbed the commit. Try this patch. It should solve the problem:
> 

Yep, it fixes it.  Thanks.

Mikey

> From b7ba09c29ed36eda8e16453646b55faea7f9c25f Mon Sep 17 00:00:00 2001
> From: Grant Likely <grant.likely@linaro.org>
> Date: Tue, 18 Jun 2013 10:15:19 +0100
> Subject: [PATCH] irqdomain: Fix flubbed irq_domain_associate_many refactoring
> 
> commit d39046ec72, "irqdomain: Refactor irq_domain_associate_many()" was
> missing the following hunk which causes a boot failure on anything using
> irq_domain_add_tree() to allocate an irq domain.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Michael Neuling <mikey@neuling.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
> Cc: Thomas Gleixner <tglx@linutronix.de>,
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/irqdomain.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 02f7658..c983ed1 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -162,7 +162,7 @@ static inline struct irq_domain *irq_domain_add_tree(struct device_node *of_node
>  					 const struct irq_domain_ops *ops,
>  					 void *host_data)
>  {
> -	return irq_domain_add_linear(of_node, 0, ops, host_data);
> +	return __irq_domain_add(of_node, 0, ~0, 0, ops, host_data);
>  }
>  
>  extern void irq_domain_remove(struct irq_domain *host);
> -- 
> 1.8.1.2
> 
