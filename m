Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbaHGRII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:08:08 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:60122 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbaHGRIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:08:06 -0400
Date: Thu, 7 Aug 2014 19:08:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kbuild: escape single backslashes in macro make-cmd
Message-ID: <20140807170800.GA1542@ravnborg.org>
References: <20140726163551.19857.17737.stgit@zurg>
 <53E2156E.9060700@suse.cz>
 <CALYGNiO=oiiLgJRrpycO=CWyMMf8-AiDyW=Ch3ajV5W=9dtZfA@mail.gmail.com>
 <53E24365.6020405@suse.cz>
 <20140807160739.GA29726@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807160739.GA29726@sepie.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The problem is that the bash echo does not interpred _any_ \-sequences
> without -e. So the nicely escaped \\ stays a \\ and we get spurious
> rebuilds with bash instead. It previously worked with bash, because the
> backslash escaping was completely broken. You not only moved it up in
> the chain, but also fixed it by removing one superflous level of
> escaping.
> 
> I'm now testing this, i.e. dropping the backslash escaping completely
> and doing a printf '%s\n' instead. Can you try if it works for you?
> 
> 
> diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> index 122f95c..8a9a4e1 100644
> --- a/scripts/Kbuild.include
> +++ b/scripts/Kbuild.include
> @@ -215,11 +215,13 @@ else
>  arg-check = $(if $(strip $(cmd_$@)),,1)
>  endif
>  
> -# >'< substitution is for echo to work,
> -# >$< substitution to preserve $ when reloading .cmd file
> -# note: when using inline perl scripts [perl -e '...$$t=1;...']
> -# in $(cmd_xxx) double $$ your perl vars
> -make-cmd = $(subst \\,\\\\,$(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1))))))
> +# Replace >$< with >$$< to preserve $ when reloading the .cmd file
> +# (needed for make)
> +# Replace >#< with >\#< to avoid starting a comment in the .cmd file
> +# (needed for make)
> +# Replace >'< with >'\''< to be able to enclose the whole string in '...'
> +# (needed for the shell)
> +make-cmd = $(call escsq,$(subst \#,\\\#,$(subst $$,$$$$,$(cmd_$(1)))))
This is simpler and remotely readble - nice!
As a bonus you added more descriptive comments

Looks good.
You may add my:
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
