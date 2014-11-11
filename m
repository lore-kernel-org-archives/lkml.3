Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaKKI0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:26:14 -0500
Received: from ozlabs.org ([103.22.144.67]:57618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbaKKI0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:26:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3.18-rc3] param: fix crash on bad kernel arguments
In-Reply-To: <1415199890-32413-1-git-send-email-daniel.thompson@linaro.org>
References: <1415199890-32413-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 11 Nov 2014 16:30:47 +1030
Message-ID: <878ujinunk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Thompson <daniel.thompson@linaro.org> writes:
> Currently if the user passes an invalid value on the kernel command line
> then the kernel will crash during argument parsing. On most systems this
> is very hard to debug because the console hasn't been initialized yet.

Good catch, applied!

Thanks,
Rusty.

>
> This is a regression due to commit 51e158c12aca ("param: hand arguments
> after -- straight to init") which, in response to the systemd debug
> controversy, made it possible to explicitly pass arguments to init. To
> achieve this parse_args() was extended from simply returning an error
> code to returning a pointer. Regretably the new init args logic does not
> perform a proper validity check on the pointer resulting in a crash.
>
> This patch fixes the validity check. Should the check fail then no arguments
> will be passed to init. This is reasonable and matches how the kernel treats
> its own arguments (i.e. no error recovery).
>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: stable@vger.kernel.org
> ---
>  init/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/init/main.c b/init/main.c
> index 800a0da..321d0ce 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -544,7 +544,7 @@ asmlinkage __visible void __init start_kernel(void)
>  				  static_command_line, __start___param,
>  				  __stop___param - __start___param,
>  				  -1, -1, &unknown_bootoption);
> -	if (after_dashes)
> +	if (!IS_ERR_OR_NULL(after_dashes))
>  		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
>  			   set_init_arg);
>
> --
> 1.9.3
