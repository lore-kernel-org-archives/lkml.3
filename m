Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaATNWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:22:35 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:60261 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaATNWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:22:33 -0500
Date: Mon, 20 Jan 2014 10:22:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/3] perf tools: bring back old behavior when NO_DEMAGLE
 doesn't link with libbfd
Message-ID: <20140120132225.GA18862@ghostprotocols.net>
References: <1390217980-22424-1-git-send-email-stfomichev@yandex-team.ru>
 <1390217980-22424-4-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390217980-22424-4-git-send-email-stfomichev@yandex-team.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 20, 2014 at 03:39:40PM +0400, Stanislav Fomichev escreveu:
> This commit reverts part of the 3e6a147deef9 "perf tools: Separate lbfd
> check out of NO_DEMANGLE condition" which always links perf with libbfd.
> I'd like to preserve old behavior when NO_DEMAGLE does not link with
> it, because some machines may contain different versions of binutils
> (hence miss required libbfd version) and I still want an option to build perf
> which works on any machine regardless of binutils version.

This is a tricky part, with another recent patch touching it to make it
work on opensuse, where a linker script is not present to ask for extra
libs.

IIRC Andi's change made the if-else block to be irrelevant, if IIRC from
reading Namhyung and Jiri Olsa comments, so, what were the tests you
performed? I.e. which distros did you test your change on?

For reference, this is the change from Andi to make it work on some
opensuse release:

http://lkml.kernel.org/r/1389661461-18996-2-git-send-email-andi@firstfloor.org

I processed the two other patches, thanks,


- Arnaldo
 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/config/Makefile | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index d604e50fc167..4b76865c9bef 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -477,10 +477,6 @@ else
>    endif
>  endif
>  
> -ifeq ($(feature-libbfd), 1)
> -  EXTLIBS += -lbfd
> -endif
> -
>  ifdef NO_DEMANGLE
>    CFLAGS += -DNO_DEMANGLE
>  else
> @@ -488,7 +484,9 @@ else
>      EXTLIBS += -liberty
>      CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
>    else
> -    ifneq ($(feature-libbfd), 1)
> +    ifeq ($(feature-libbfd), 1)
> +      EXTLIBS += -lbfd
> +    else
>        $(call feature_check,liberty)
>        ifeq ($(feature-liberty), 1)
>          EXTLIBS += -lbfd -liberty
> -- 
> 1.8.3.2
