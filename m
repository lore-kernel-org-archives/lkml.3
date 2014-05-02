Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaEBOsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:48:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53444 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbaEBOsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:48:40 -0400
Message-ID: <1399042116.2202.1.camel@dabdike>
Subject: Re: [PATCH] parisc,metag: Do not hardcode maximum userspace stack
 size
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        linux-metag@vger.kernel.org
Date: Fri, 02 May 2014 07:48:36 -0700
In-Reply-To: <5363876A.2030709@imgtec.com>
References: <20140430212602.GA20601@p100.fritz.box>
		 <53622DBA.807@imgtec.com> <1398966636.2174.21.camel@dabdike>
	 <5363876A.2030709@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 12:54 +0100, James Hogan wrote:
> On 01/05/14 18:50, James Bottomley wrote:
> > 
> >> +
> >> +config MAX_STACK_SIZE_MB
> >> +	int "Maximum user stack size (MB)"
> >> +	default 80
> >> +	range 8 256 if METAG
> >> +	range 8 2048
> >> +	depends on STACK_GROWSUP
> >> +	help
> >> +	  This is the maximum stack size in Megabytes in the VM layout of user
> >> +	  processes when the stack grows upwards (currently only on parisc and
> >> +	  metag arch). The stack will be located at the highest memory address
> >> +	  minus the given value, unless the RLIMIT_STACK hard limit is changed
> >> +	  to a smaller value in which case that is used.
> >> +
> >> +	  A sane initial value is 80 MB.
> > 
> > There's one final issue with this: placement of the stack only really
> > matters on 32 bits.  We have three expanding memory areas: stack, heap
> > and maps.  On 64 bits these are placed well separated from each other on
> > 64 bits, so an artificial limit like this doesn't matter.
> 
> Does the following fixup diff look reasonable? It forces
> MAX_STACK_SIZE_MB to 1024 and hides the Kconfig option for 64BIT,
> effectively leaving the behaviour unchanged in that case.
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e80075979530..b0307f737bd7 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -583,7 +583,8 @@ config GENERIC_EARLY_IOREMAP
>  	bool
> 
>  config MAX_STACK_SIZE_MB
> -	int "Maximum user stack size (MB)"
> +	int "Maximum user stack size (MB)" if !64BIT
> +	default 1024 if 64BIT
>  	default 80
>  	range 8 256 if METAG
>  	range 8 2048

Yes, I think that's probably correct ... parisc doesn't actually have
anything other than a testbed 64 bit userspace, so this is a bit
theoretical for us.

James


