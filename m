Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3DYJFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:05:10 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57866 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab3DYJFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:05:07 -0400
X-AuditID: 9c930179-b7c28ae0000018a0-66-5178f1be4c23
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
Subject: Re: [PATCH 01/26] perf tools: Add automated make test suite
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
	<1366796273-4780-2-git-send-email-jolsa@redhat.com>
Date: Thu, 25 Apr 2013 18:05:01 +0900
In-Reply-To: <1366796273-4780-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 24 Apr 2013 11:37:28 +0200")
Message-ID: <871u9z9e0y.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 11:37:28 +0200, Jiri Olsa wrote:
> Adding automated test for testing the build process.
> To run it you need to be in perf directory or specify
> one with PERF variable. It's also possible to specify
> optional Makefile to test via MK variable.

  $ pwd
  /home/namhyung/project/linux

  $ make -f tools/perf/tests/make PERF=tools/perf
  - make_pure: cd tools/perf && make -f Makefile 
    test: test -x tools/perf/perf
  make: *** [make_pure] Error 1

  $ cat tools/perf/make_pure 
  cd tools/perf && make -f Makefile
  /bin/sh: line 3: cd: tools/perf: No such file or directory


I guess it's because calling 'clean' does cd $(PERF) in it.
Please see below.

>
> Whole suite is executed twice, the second time with
> O=/tmp/xxx option added.
>
> To run the whole suite:
>   $ make -f tests/make
>   - make_pure: cd . && make -f Makefile
>     test: test -x ./perf
>   - make_clean_all: cd . && make -f Makefile clean all
>     test: test -x ./perf
>   - make_python_perf_so: cd . && make -f Makefile python/perf.so
>     test: test -f ./python/perf.so
>   - make_debug: cd . && make -f Makefile DEBUG=1
>     test: test -x ./perf
>   - make_no_libperl: cd . && make -f Makefile NO_LIBPERL=1
>     test: test -x ./perf
>
> You see command line for 'make_pure' test right away,
> and the output is stored into 'make_pure' file.
>
> To run simple test:
>   $ make -f tests/make make_debug
>   - make_debug: cd . && make -f Makefile DEBUG=1
>     test: test -x ./perf
>
> At this moment tests checks for successfull build
> and for existence of several built files. Additional
> after-build checks could be added.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/tests/make | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 141 insertions(+)
>  create mode 100644 tools/perf/tests/make
>
> diff --git a/tools/perf/tests/make b/tools/perf/tests/make
> new file mode 100644
> index 0000000..6fdc8f5
> --- /dev/null
> +++ b/tools/perf/tests/make
> @@ -0,0 +1,141 @@
> +ifndef PERF
> +PERF := .
> +endif
> +
> +ifndef MK
> +MK := Makefile
> +endif

I think these two can be plain assignment without ifndef's as they
can be overridden from command line.

> +
> +# standard single make variable specified
[SNIP]
> +
> +clean := @cd $(PERF); make -s -f $(MK) clean >/dev/null

Why is this clean a function (or macro) rather than a 
prerequisites?  And it could be a single command:

  make -s -C $(PERF) -f $(MK) clean

One more good thing of this is that it doesn't change the current
directory.

> +
> +$(run):
> +	$(call clean) && \
> +	cmd="cd $(PERF) && make -f $(MK) $($@)"; \

So this could be

  $(run): clean
	cmd="make -C $(PERF) -f $(MK) $($@)"; \

> +	echo "- $@: $$cmd" && echo $$cmd > $@ && \
> +	( eval $$cmd ) >> $@ 2>&1; \
> +	echo "  test: $(call test,$@)"; \
> +	$(call test,$@)

It seems it doesn't delete result files.  Wouldn't it be better
deleting them - at least in case of success?

> +
> +$(run_O):
> +	$(call clean) && \
> +	TMP=$$(mktemp -d); \
> +	cmd="cd $(PERF) && make -f $(MK) $($(patsubst %_O,%,$@)) O=$$TMP"; \

Same as above.


> +	echo "- $@: $$cmd" && echo $$cmd > $@ && \
> +	( eval $$cmd ) >> $@ 2>&1 && \
> +	echo "  test: $(call test_O,$@)"; \
> +	$(call test_O,$@) && \
> +	rm -rf $$TMP
> +
> +all: $(run) $(run_O)
> +	@echo OK

Finally, I hope we can do this parallelly (i.e. with -j XX) at least
for $(run_O) targets only.  Is that possible?

Thanks,
Namhyung


> +
> +out: $(run_O)
> +	@echo OK
> +
> +.PHONY: all $(run) $(run_O) clean
