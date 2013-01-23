Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3AWL0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:26:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab3AWL0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:26:23 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130122184357.GD6538@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        jstancek@redhat.com, Stephan Mueller <stephan.mueller@atsec.com>
Subject: Re: [PATCH] MODSIGN: only panic in fips mode if sig_enforce is set
Date: Wed, 23 Jan 2013 11:26:15 +0000
Message-ID: <8615.1358940375@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@redhat.com> wrote:

> Commit 1d0059f3a added a test to check if the system is booted in fips
> mode, and if so, panic the system if an unsigned module is loaded.
> However the wording of the changelog "in signature enforcing mode" leads
> one to assume that sig_enforce should be set for the panic to occur and
> that these two tests are transposed.
> 
> Move the test for -ENOKEY && !sig_enforce before the test of fips_mode,
> so that err will be 0, and the panic will not trigger unless we've
> explicitly disabled unsigned modules with sig_enforce set, so that
> systemtap and 3rd party modules will work in fips mode. (This also
> matches the behaviour by Red Hat Enterprise Linux 6.)
> 
> Things which need to deny module loading such as secure boot already set
> sig_enforce, so there's no issue here.
> 
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Fine by me, but adding Stephan Mueller for his input.

David

> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2460,11 +2460,11 @@ static int module_sig_check(struct load_info *info)
>  	}
>  
>  	/* Not having a signature is only an error if we're strict. */
> +	if (err == -ENOKEY && !sig_enforce)
> +		err = 0;
>  	if (err < 0 && fips_enabled)
>  		panic("Module verification failed with error %d in FIPS mode\n",
>  		      err);
> -	if (err == -ENOKEY && !sig_enforce)
> -		err = 0;
>  
>  	return err;
>  }
