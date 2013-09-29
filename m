Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab3I2GwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:52:17 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33017 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3I2GwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:52:13 -0400
Subject: Re: [PATCH 1/3] perf tools: Separate lbfd check out of NO_DEMANGLE
 condition
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
In-Reply-To: <1380292332-6518-1-git-send-email-jolsa@redhat.com>
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
	 <1380292332-6518-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Sep 2013 15:52:06 +0900
Message-ID: <1380437526.1727.10.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2013-09-27 (금), 16:32 +0200, Jiri Olsa:
> We fail build with NO_DEMANGLE with missing -lbfd externals error.
> The reason is that we now use bfd code in srcline object:
>   perf tools: Implement addr2line directly using libbfd
> 
> So we need to check/add -lbfd always now.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/config/Makefile | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 8b49a00..40a41c6 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -360,6 +360,13 @@ else
>    endif
>  endif
>  
> +FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
> +has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
> +ifeq ($(has_bfd),y)
> +  EXTLIBS += -lbfd
> +  CFLAGS += -DLIBBFD_SUPPORT
> +endif
> +
>  ifdef NO_DEMANGLE
>    CFLAGS += -DNO_DEMANGLE
>  else
> @@ -367,11 +374,7 @@ else
>      EXTLIBS += -liberty
>      CFLAGS += -DHAVE_CPLUS_DEMANGLE
>    else
> -    FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
> -    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
> -    ifeq ($(has_bfd),y)
> -      EXTLIBS += -lbfd
> -    else
> +    ifneq ($(has_bfd),y)
>        FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
>        has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
>        ifeq ($(has_bfd_iberty),y)
> @@ -397,10 +400,6 @@ else
>    endif
>  endif
>  
> -ifndef ($(filter -lbfd,$(EXTLIBS)),)
> -  CFLAGS += -DLIBBFD_SUPPORT
> -endif
> -
>  ifndef NO_STRLCPY
>    ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
>      CFLAGS += -DHAVE_STRLCPY

Is it enough to check on -lbfd only?  I guess libbfd can have additional
dependencies to libiberty and libz.  If so, this patch can fail to set
-DLIBBFD_SUPPORT, right?

Thanks,
Namhyung


