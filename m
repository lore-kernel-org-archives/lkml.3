Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3JBGr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:47:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52903 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3JBGrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:47:25 -0400
X-AuditID: 9c930179-b7bc4ae000001e3e-19-524bc178361b
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Speed up git-version test on re-make
References: <20130912200236.GC11400@ghostprotocols.net>
	<20130912203116.GD32644@gmail.com> <20130912204313.GA3259@gmail.com>
	<20130915091029.GA21465@gmail.com> <20130930164210.GA22342@gmail.com>
	<20130930171220.GC10293@ghostprotocols.net>
	<CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
	<20130930175342.GI10293@ghostprotocols.net>
	<20130930190434.GA3427@gmail.com> <20131001113456.GA31331@gmail.com>
	<20131001144618.GA8970@gmail.com>
Date: Wed, 02 Oct 2013 15:47:19 +0900
In-Reply-To: <20131001144618.GA8970@gmail.com> (Ingo Molnar's message of "Tue,
	1 Oct 2013 16:46:18 +0200")
Message-ID: <87txh0mao8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013 16:46:18 +0200, Ingo Molnar wrote:

[SNIP]
>  
> -$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
> +$(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
>  	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
> +	@touch $(OUTPUT)PERF-VERSION-FILE
>  
>  CC = $(CROSS_COMPILE)gcc
>  AR = $(CROSS_COMPILE)ar
> @@ -813,7 +814,17 @@ clean: $(LIBTRACEEVENT)-clean $(LIBLK)-c
>  	$(RM) $(OUTPUT)util/*-flex*
>  	$(python-clean)
>  
> +#
> +# Trick: if ../../.git does not exist - we are building out of tree for example,
> +# then force version regeneration:
> +#
> +ifeq ($(wildcard ../../.git/HEAD),) 
> +    GIT-HEAD-PHONY = ../../.git/HEAD
> +else 
> +    GIT-HEAD-PHONY =
> +endif
> +
>  .PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
>  .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
> -.PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
> +.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
>  

I found an unrelated bug.  When I tried to build perf out of tree after
'make perf-targz-src-pkg' it cannot get any version number.

      GEN common-cmds.h
      * new build flags or prefix
  make[1]: *** No rule to make target `kernelversion'.  Stop.
  PERF_VERSION = 
      ...
      AR libperf.a
      LINK perf

  $ ./perf --version
  perf version 


It looks like we should save and pass the result of 'make kernelversion'
to the tarball.

Thanks,
Namhyung
