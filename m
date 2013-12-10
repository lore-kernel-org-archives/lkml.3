Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3LJPzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:55:49 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:55274 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3LJPzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:55:44 -0500
MIME-Version: 1.0
In-Reply-To: <20131210135542.GE8108@krava.brq.redhat.com>
References: <1386678244-13535-1-git-send-email-jean.pihet@linaro.org>
	<20131210135542.GE8108@krava.brq.redhat.com>
Date: Tue, 10 Dec 2013 16:55:43 +0100
Message-ID: <CAFrcx1=PLssYDKm1HUR2uUSX7+Hrh6g6bB=1VntY_hH6YkdF-w@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Automate setup of FEATURE_CHECK_(C|LD)FLAGS-all
 variables
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Arnaldo <acme@ghostprotocols.net>,
        Patch Tracking <patches@linaro.org>, Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

On 10 December 2013 14:55, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Dec 10, 2013 at 01:24:02PM +0100, Jean Pihet wrote:
>> Add CFLAGS and LDFLAGS for each feature to be checked during the
>> build. This allows to pass particular flags and parameters to the
>> feature checks compilation.
>>
>> Use the per-feature check flags for the unwinding feature in order
>> to correctly compile the test-all, libunwind and libunwind-debug-frame
>> feature checks.
>>
>> This change set simplifies the flags passing mechanism between the
>> Makefiles in config/Makefile and config/feature-checks; this
>> could be farther optimized by moving the compilation flags to the
>> per-feature check flags for all features to be checked.
>>
>> Tested on x86_64, ARMv7 and ARMv8 with and without LIBUNWIND_DIR
>> set in 'make -C tools/perf'
>>
>>
>> Jean Pihet (2):
>>   perf: add per-feature check flags
>>   perf: unwinding: use the per-feature check flags
>>
>>  tools/perf/config/Makefile                | 52 ++++++++++++++++++-------------
>>  tools/perf/config/feature-checks/Makefile |  8 ++---
>>  2 files changed, 34 insertions(+), 26 deletions(-)
>>
>
> while at it, how about following update
Indeed the flags passing mechanism needs to be automated.
The code below looks great.

I propose to submit patches for a consolidation of the features check
Makefiles, i.e. for all features including test-all.
This is next on my ToDo list, is that OK to you?

>
> thanks,
> jirka

Jean

>
>
> ---
> Instead of explicitly adding same value into
> FEATURE_CHECK_(C|LD)FLAGS-all variables we can
> do that automatically.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/config/Makefile | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index f75d814..05fd0e2 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -55,9 +55,6 @@ else
>    FEATURE_CHECK_LDFLAGS-libunwind = $(LIBUNWIND_LDFLAGS)
>    FEATURE_CHECK_CFLAGS-libunwind-debug-frame = $(LIBUNWIND_CFLAGS)
>    FEATURE_CHECK_LDFLAGS-libunwind-debug-frame = $(LIBUNWIND_LDFLAGS)
> -  #  and the flags for the test-all case
> -  FEATURE_CHECK_CFLAGS-all += $(LIBUNWIND_CFLAGS)
> -  FEATURE_CHECK_LDFLAGS-all += $(LIBUNWIND_LDFLAGS)
>  endif
>
>  ifeq ($(NO_PERF_REGS),0)
> @@ -168,6 +165,17 @@ CORE_FEATURE_TESTS =                       \
>         stackprotector-all              \
>         timerfd
>
> +# Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
> +# If in the future we need per-feature checks/flags for features not
> +# mentioned in this list we need to refactor this ;-).
> +set_test_all_flags = $(eval $(set_test_all_flags_code))
> +define set_test_all_flags_code
> +  FEATURE_CHECK_CFLAGS-all  += $(FEATURE_CHECK_CFLAGS-$(1))
> +  FEATURE_CHECK_LDFLAGS-all += $(FEATURE_CHECK_LDFLAGS-$(1))
> +endef
> +
> +$(foreach feat,$(CORE_FEATURE_TESTS),$(call set_test_all_flags,$(feat)))
> +
>  #
>  # So here we detect whether test-all was rebuilt, to be able
>  # to skip the print-out of the long features list if the file
> --
> 1.8.3.1
>
