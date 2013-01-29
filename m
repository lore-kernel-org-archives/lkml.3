Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3A2EN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:13:58 -0500
Received: from smtp.multi.fi ([85.134.37.151]:33987 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3A2ENy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:13:54 -0500
Message-ID: <51074ADA.4050807@mageia.org>
Date: Tue, 29 Jan 2013 06:06:50 +0200
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 11/74] perf python: Fix breakage introduced by the test_attr
 infrastructure
References: <1359058103-31645-1-git-send-email-acme@infradead.org> <1359058103-31645-12-git-send-email-acme@infradead.org>
In-Reply-To: <1359058103-31645-12-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo skrev 24.1.2013 22:07:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> The test_attr infrastructure hooks on the sys_perf_event_open call,
> checking if a variable is set and if so calling a function to intercept
> calls and do the checking.
>
> But both the variable and the function aren't on objects that are
> linked on the python binding, breaking it:
>


Atleast this one is 3.8 material as it is a regression since 3.7

[tmb@tmb linux-3.8-rc5]$ make -C tools/perf -s V=1 HAVE_CPLUS_DEMANGLE=1 
prefix=%{_prefix} all

python_ext_build/tmp/util/evsel.o: In function `sys_perf_event_open':
/mnt/work/Mageia/RPM/1Work/kerenels/linux-3.8-rc5/tools/perf/util/../perf.h:183: 
undefined reference to `test_attr__enabled'
/mnt/work/Mageia/RPM/1Work/kerenels/linux-3.8-rc5/tools/perf/util/../perf.h:184: 
undefined reference to `test_attr__open'
collect2: ld returned 1 exit status
error: command 'gcc' failed with exit status 1

--
Thomas



>    # perf test -v 15
>    15: Try 'use perf' in python, checking link problems       :
>    --- start ---
>    Traceback (most recent call last):
>      File "<stdin>", line 1, in <module>
>    ImportError: /home/acme/git/build/perf//python/perf.so: undefined symbol: test_attr__enabled
>    ---- end ----
>    Try 'use perf' in python, checking link problems: FAILED!
>    #
>
> Fix it by moving the variable to one of the linked object files and
> providing a stub for the function in the python.o object, that is only
> linked in the python binding.
>
> Now 'perf test' is happy again:
>
>    # perf test 15
>    15: Try 'use perf' in python, checking link problems       : Ok
>    #
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-0rsca2kn44b38rgdpr3tz6n5@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>   tools/perf/tests/attr.c  | 2 --
>   tools/perf/util/python.c | 9 +++++++++
>   tools/perf/util/util.c   | 2 ++
>   3 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
> index 25638a9..05b5acb 100644
> --- a/tools/perf/tests/attr.c
> +++ b/tools/perf/tests/attr.c
> @@ -33,8 +33,6 @@
>
>   extern int verbose;
>
> -bool test_attr__enabled;
> -
>   static char *dir;
>
>   void test_attr__init(void)
> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> index a2657fd..925e0c3 100644
> --- a/tools/perf/util/python.c
> +++ b/tools/perf/util/python.c
> @@ -1045,3 +1045,12 @@ error:
>   	if (PyErr_Occurred())
>   		PyErr_SetString(PyExc_ImportError, "perf: Init failed!");
>   }
> +
> +/*
> + * Dummy, to avoid dragging all the test_attr infrastructure in the python
> + * binding.
> + */
> +void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
> +                     int fd, int group_fd, unsigned long flags)
> +{
> +}
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 5906e84..252b889 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -12,6 +12,8 @@
>    */
>   unsigned int page_size;
>
> +bool test_attr__enabled;
> +
>   bool perf_host  = true;
>   bool perf_guest = false;
>
>

