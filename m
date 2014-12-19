Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaLSRHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:07:53 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:52533 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbaLSRHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:07:51 -0500
Message-ID: <1419008868.5912.23.camel@x220>
Subject: Re: [PATCH] kconfig: improve handling EOF
From: Paul Bolle <pebolle@tiscali.nl>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-kbuild@vger.kernel.org, yann.morin.1998@free.fr,
        alexander.shishkin@linux.intel.com, linux-kernel@vger.kernel.org
Date: Fri, 19 Dec 2014 18:07:48 +0100
In-Reply-To: <1419002430-164635-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419002430-164635-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2014 17:07:48.0816 (UTC) FILETIME=[50D54D00:01D01BAE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-19 at 17:20 +0200, Kirill A. Shutemov wrote:
> The patch fixes two EOF-related issues in kconfig lexer:
> 
> 1. End of file is not valid end of string token. Currently we happily
>    accept something like
> 
> 	config FOO
> 		bool "Bar
> 
>    If there's EOF just after '"Bar' without newline.
> 
> 2. Kconfig produces obscure error message if we miss newline at the end
>    of file. Testcase:
> 
> 	% echo -n 'if FOO\nendif' >> drivers/Kconfig
> 	% make allmodconfig
> 	...
> 	drivers/Kconfig:191: 'endif' in different file than 'if'
> 	drivers/Kconfig:191: location of the 'if'
> 	scripts/kconfig/Makefile:80: recipe for target 'allmodconfig' failed
> 	make[1]: *** [allmodconfig] Error 1
> 	Makefile:558: recipe for target 'allmodconfig' failed
> 	make: *** [allmodconfig] Error 2
> 
>    We can fix it if forbid EOF form <PARAM> context.

s/form/in/?

> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  kernel/Kconfig.preempt  | 2 +-

This is actually the only Kconfig file that doesn't end in a newline,
isn't it?

>  scripts/kconfig/zconf.l | 8 ++++++--

Could you please regenerate the _shipped file too?

>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> index 3f9c97419f02..037284c5f723 100644
> --- a/kernel/Kconfig.preempt
> +++ b/kernel/Kconfig.preempt
> @@ -55,4 +55,4 @@ config PREEMPT
>  endchoice
>  
>  config PREEMPT_COUNT
> -       bool
> \ No newline at end of file
> +       bool

This hunk is not described in the commit explanation. Besides, you
should do one thing per patch, so I think this should be a separate
patch. Trivial as it is (and non urgent, since this apparently never
broke the build.)

> diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
> index 6c62d93b4ffb..001abe8df6ce 100644
> --- a/scripts/kconfig/zconf.l
> +++ b/scripts/kconfig/zconf.l
> @@ -143,7 +143,9 @@ n	[A-Za-z0-9_]
>  	\\\n	current_file->lineno++;
>  	.
>  	<<EOF>> {
> -		BEGIN(INITIAL);
> +		printf("%s:%d: no newline at end of file\n",
> +				zconf_curname(), zconf_lineno());

Pet peeve of mine: warnings and errors should go to stderr.

> +		exit(1);

Not all missing newline-before-EOF are currently fatal, see
kernel/Kconfig.preempt above. So would this break the build even in
cases like that? That would mean one ill considered commit would break
the build. Perhaps we should warn and see whether we still can finish
the parse instead.

>  	}
>  }
>  
> @@ -179,7 +181,9 @@ n	[A-Za-z0-9_]
>  		return T_EOL;
>  	}
>  	<<EOF>>	{
> -		BEGIN(INITIAL);
> +		printf("%s:%d: unexpected end of file\n",
> +				zconf_curname(), zconf_lineno());

See above.

> +		exit(1);
>  	}
>  }
>  

See above.


Paul Bolle

