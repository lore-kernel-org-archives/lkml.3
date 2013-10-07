Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3JGPLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:11:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52692 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3JGPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:11:19 -0400
Message-ID: <5252CF13.3040200@gmail.com>
Date: Mon, 07 Oct 2013 09:11:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 26/50] tools/perf/build: Split out feature check: 'libbfd'
References: <1381147003-2574-1-git-send-email-mingo@kernel.org> <1381147003-2574-27-git-send-email-mingo@kernel.org>
In-Reply-To: <1381147003-2574-27-git-send-email-mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/13 5:56 AM, Ingo Molnar wrote:
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 77a2e6b..4f60ecc 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -121,6 +121,7 @@ FEATURE_TESTS =				\
>   	libperl				\
>   	libpython			\
>   	libpython-version		\
> +	libbfd				\
>   	libnuma
>
>   $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))

strlcpy missing from FEATURE_TESTS, but really the strlcpy changes 
should be a separate patch.

David

> @@ -423,7 +423,7 @@ else
>   endif
>
>   ifndef NO_STRLCPY
> -  ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY_SUPPORT),y)
> +  ifeq ($(feature-strlcpy), 1)
>       CFLAGS += -DHAVE_STRLCPY_SUPPORT
>     endif
>   endif
> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> index d15074d..2a3473e 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -19,6 +19,7 @@ FILES=					\
>   	test-libperl			\
>   	test-libpython			\
>   	test-libpython-version		\
> +	test-libbfd			\
>   	test-libnuma
>
>   CC := $(CC) -MD
> @@ -112,6 +113,12 @@ test-libpython:
>   test-libpython-version:
>   	$(BUILD) $(FLAGS_PYTHON_EMBED)
>
> +test-libbfd:
> +	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
> +
> +test-strlcpy:
> +	$(BUILD)
> +
>   -include *.d */*.d
>
>   ###############################
> diff --git a/tools/perf/config/feature-checks/test-libbfd.c b/tools/perf/config/feature-checks/test-libbfd.c
> new file mode 100644
> index 0000000..d03339c
> --- /dev/null
> +++ b/tools/perf/config/feature-checks/test-libbfd.c
> @@ -0,0 +1,7 @@
> +#include <bfd.h>
> +
> +int main(void)
> +{
> +	bfd_demangle(0, 0, 0);
> +	return 0;
> +}
> diff --git a/tools/perf/config/feature-checks/test-strlcpy.c b/tools/perf/config/feature-checks/test-strlcpy.c
> new file mode 100644
> index 0000000..4a6b6ff
> --- /dev/null
> +++ b/tools/perf/config/feature-checks/test-strlcpy.c
> @@ -0,0 +1,8 @@
> +#include <stdlib.h>
> +extern size_t strlcpy(char *dest, const char *src, size_t size);
> +
> +int main(void)
> +{
> +	strlcpy(NULL, NULL, 0);
> +	return 0;
> +}
>

