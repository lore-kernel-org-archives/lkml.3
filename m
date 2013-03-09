Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3CIUZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 15:25:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab3CIUZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 15:25:18 -0500
Date: Sat, 9 Mar 2013 21:23:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] kmod: split call to call_usermodehelper_fns()
Message-ID: <20130309202329.GC16399@redhat.com>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi> <1362723313-839-4-git-send-email-lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362723313-839-4-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Lucas De Marchi wrote:
>
> Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
> calling call_usermodehelper_fns(). In case the latter returns -ENOMEM
> the cleanup function may had not been called - in this case we would
> not free argv and module_name.
>
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>

Thanks!

looks correct, but...

> @@ -98,8 +100,17 @@ static int call_modprobe(char *module_name, int wait)
>  	argv[3] = module_name;	/* check free_modprobe_argv() */
>  	argv[4] = NULL;
>
> -	return call_usermodehelper_fns(modprobe_path, argv, envp,
> -		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
> +	gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;

Why? it is never called with UMH_NO_WAIT,

> +	info = call_usermodehelper_setup(modprobe_path, argv, envp,
> +					 gfp_mask, NULL, free_modprobe_argv,

can't we simply use GFP_KERNEL?

Oleg.

