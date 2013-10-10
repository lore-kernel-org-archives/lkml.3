Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3JJGfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:35:16 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51244 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3JJGfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:35:14 -0400
X-AuditID: 9c930197-b7b88ae0000032c4-10-52564aa083ab
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 50/52] tools/perf/build: Fix O=/some/dir perf.o type of targets
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-51-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 15:35:12 +0900
In-Reply-To: <1381227082-22039-51-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:11:20 +0200")
Message-ID: <87fvs9iqfz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 12:11:20 +0200, Ingo Molnar wrote:
> If someone specifies a single target, mixed with O=, the following way:
>
>     hubble:~/tip/tools/perf> make O=/tmp/perf util/stat.o
>     BUILD: Doing 'make -j8' parallel build
>     gcc  -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k [...]
>
> The build might even fail, if a target depends on other targets:
>
>     hubble:~/tip/tools/perf> make O=/tmp/perf perf.o
>     ...
>     perf.c: In function ‘handle_options’:
>     perf.c:155:21: error: ‘PERF_HTML_PATH’ undeclared (first use in this function)
>
> The correct way to invoke such targets is:
>
>     hubble:~/tip/tools/perf> make O=/tmp/perf /tmp/perf/perf.o
>     BUILD: Doing 'make -j8' parallel build
>     GEN /tmp/perf/common-cmds.h
>     CC /tmp/perf/perf.o
>
> But that's unnecessary typing and it's also easy to mistakenly build into the
> source directory.
>
> To fix this remove the generic suffix rules and add redirection to $(OUTPUT)
> for the most popular .o targets.

I got this:

  $ cd tools/perf
  $ make
  ... (succeeded)

  $ make O=~/build/perf perf.o
  make: `perf.o' is up to date.

  $ rm ~/build/perf/perf.o
  $ make O=~/build/perf/ perf.o
  make: `perf.o' is up to date.

> +#
> +# If a target does not match any of the later rules then prefix it by $(OUTPUT)
> +# This makes targets like 'make O=/tmp/perf perf.o' work in a natural way.
> +#
> +ifneq ($(OUTPUT),)
> +%.o: $(OUTPUT)%.o
> +	@echo "    # Redirected target $@ => $(OUTPUT)$@"
> +util/%.o: $(OUTPUT)util/%.o
> +	@echo "    # Redirected target $@ => $(OUTPUT)util/$@"
> +bench/%.o: $(OUTPUT)bench/%.o
> +	@echo "    # Redirected target $@ => $(OUTPUT)bench/$@"
> +tests/%.o: $(OUTPUT)tests/%.o
> +	@echo "    # Redirected target $@ => $(OUTPUT)tests/$@"
> +endif

It also doesn't care about other directories - arch/, scripts/ and ui/ -
and their subdirectories.  So even on clean build it'll failed to build
these files with O=dir.

  $ make clean

  $ make O=~/build/perf ui/stdio/hist.o
      BUILD: Doing 'make -j12' parallel build
  make[1]: *** No rule to make target `ui/stdio/hist.o'.  Stop.
  make: *** [ui/stdio/hist.o] Error 2


Thanks,
Namhyung
