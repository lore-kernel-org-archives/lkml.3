Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab3CIUod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 15:44:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3CIUoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 15:44:32 -0500
Date: Sat, 9 Mar 2013 21:42:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] Split remaining calls to
	call_usermodehelper_fns()
Message-ID: <20130309204242.GA17303@redhat.com>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi> <1362723313-839-7-git-send-email-lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362723313-839-7-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Lucas De Marchi wrote:
>
> @@ -571,9 +572,17 @@ void do_coredump(siginfo_t *siginfo)
>  			goto fail_dropcount;
>  		}
>
> -		retval = call_usermodehelper_fns(helper_argv[0], helper_argv,
> -					NULL, UMH_WAIT_EXEC, umh_pipe_setup,
> -					NULL, &cprm);
> +		sub_info = call_usermodehelper_setup(helper_argv[0],
> +						helper_argv, NULL, GFP_KERNEL,
> +						umh_pipe_setup, NULL, &cprm);
> +		if (!sub_info) {
> +			printk(KERN_WARNING "%s failed to allocate memory\n",
> +			       __func__);

Why?

> +			argv_free(helper_argv);
> +			goto fail_dropcount;
> +		}
> +
> +		retval = call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);

I do not really like another argv_free() here... How about

		retval = -ENOMEM;
		info = call_usermodehelper_setup(...);
		if (info)
			retval = call_usermodehelper_fns(...);
		argv_free();

?

Oleg.

