Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3AWA4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:56:25 -0500
Received: from ozlabs.org ([203.10.76.45]:49382 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3AWA4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:56:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kyle McMartin <kyle@redhat.com>, linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, jstancek@redhat.com
Subject: Re: [PATCH] MODSIGN: only panic in fips mode if sig_enforce is set
In-Reply-To: <20130122184357.GD6538@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 23 Jan 2013 09:47:30 +1030
Message-ID: <87ehhc4xkl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@redhat.com> writes:
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

Seems reasonable, but I'll want David Howells' Ack.

Thanks,
Rusty.

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
