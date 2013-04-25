Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3DYJP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:15:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59251 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3DYJP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:15:56 -0400
X-AuditID: 9c93016f-b7c3dae000000592-25-5178f4489e4b
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 03/26] perf tools: Move arch check into config/Makefile
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
	<1366796273-4780-4-git-send-email-jolsa@redhat.com>
Date: Thu, 25 Apr 2013 18:15:52 +0900
In-Reply-To: <1366796273-4780-4-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 24 Apr 2013 11:37:30 +0200")
Message-ID: <87vc7b7yyf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 11:37:30 +0200, Jiri Olsa wrote:
> Moving arch check into config/Makefile.
>
[SNIP]
> +# include config/Makefile by default and rule out
> +# non-config cases
> +config := 1
> +
> +# standalone clean
> +ifeq ($(MAKECMDGOALS),clean)
> +  config := 0
>  endif
> -ifeq ($(ARCH),x86_64)
> -	override ARCH := x86
> -	IS_X86_64 := 0
> -	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
> -		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
> -	endif
> -	ifeq (${IS_X86_64}, 1)
> -		RAW_ARCH := x86_64
> -		ARCH_CFLAGS := -DARCH_X86_64
> -		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
> -	endif
> -	NO_PERF_REGS := 0
> -	LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
> +
> +# tags cscope
> +ifneq ($(filter tags cscope,$(MAKECMDGOALS)),)
> +  config := 0
> +endif

Good idea!

How about consolidating them like:

  NON_CONFIG_TARGETS := clean TAGS tags cscope help
  
  ifeq ($(filter-out $(NON_CONFIG_TARGETS),$(MAKECMDGOALS)),)
    config := 0
  endif


This way, we can handle multiple targets properly IMHO.

  $ make clean all
  $ make clean tags


Thanks,
Namhyung

> +
> +ifeq ($(config),1)
> +include config/Makefile
>  endif
