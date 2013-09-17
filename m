Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3IQFGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:06:04 -0400
Received: from ozlabs.org ([203.10.76.45]:39429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab3IQFGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:06:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Guenter Roeck <linux@roeck-us.net>, linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2] modpost: Fix secondary errors seen if a single module build fails
In-Reply-To: <1379356284-15804-1-git-send-email-linux@roeck-us.net>
References: <1379356284-15804-1-git-send-email-linux@roeck-us.net>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 17 Sep 2013 13:38:01 +0930
Message-ID: <87pps8ytsu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:
> Commit ea4054a23 (modpost: handle huge numbers of modules) added
> support for building a large number of modules.
>
> Unfortunately, the commit changed the semantics of the makefile: Instead of
> passing only existing object files to modpost, make now passes all expected
> object files. If make was started with option -i, this results in a modpost
> error if a single file failed to build.
>
> Example with the current btrfs build falure on m68k:
>
> fs/btrfs/btrfs.o: No such file or directory
> make[1]: [__modpost] Error 1 (ignored)
>
> This error is followed by lots of errors such as:
>
> m68k-linux-gcc: error: arch/m68k/emu/nfcon.mod.c: No such file or directory
> m68k-linux-gcc: fatal error: no input files
> compilation terminated.
> make[1]: [arch/m68k/emu/nfcon.mod.o] Error 1 (ignored)
>
> This doesn't matter much for normal builds, but it is annoying for builds
> started with "make -i" due to the large number of secondary errors.
> Those errors unnececessarily clog any error log and make it difficult
> to find the real errors in the build.
>
> Fix the problem by only passing existing object files to modpost.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.

>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Use "xargs -r ls 2>/dev/null" instead of a shell while loop
>     to filter for existing files.
>     Not sure if this is much better, but it is an alternative.
>     If anyone has a better solution, please let me know.
>     [Another option would be to use 'find' (no parameters) instead
>      of 'ls', but that would still require the error redirect.]
>
>  scripts/Makefile.modpost |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index 8dcdca2..edc4394 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -81,7 +81,8 @@ modpost = scripts/mod/modpost                    \
>  
>  # We can go over command line length here, so be careful.
>  quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
> -      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | $(modpost) -s -T -
> +      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | \
> +	xargs -r ls 2>/dev/null | $(modpost) -s -T -
>  
>  PHONY += __modpost
>  __modpost: $(modules:.ko=.o) FORCE
> -- 
> 1.7.9.7
