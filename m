Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3LJKFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:05:13 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:45049 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3LJKFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:05:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131210095723.GB2352@krava.brq.redhat.com>
References: <1386411461-21510-1-git-send-email-jean.pihet@linaro.org>
	<1386411461-21510-3-git-send-email-jean.pihet@linaro.org>
	<20131209171719.GA16631@krava.brq.redhat.com>
	<CAFrcx1khWGXJOyyqOBedyZsmLWYdhmkGsn0FhNt6hwCYhf5qfA@mail.gmail.com>
	<20131210095723.GB2352@krava.brq.redhat.com>
Date: Tue, 10 Dec 2013 11:05:04 +0100
Message-ID: <CAFrcx1kKmTf=6DjAbn8F=--KaijotSqo8_dkRFpgo5J+q8Vfeg@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf: unwinding: use the per-feature check flags
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Arnaldo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 10 December 2013 10:57, Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Dec 09, 2013 at 07:02:02PM +0100, Jean Pihet wrote:
>> Hi Jiri,
>>
>> On 9 December 2013 18:17, Jiri Olsa <jolsa@redhat.com> wrote:
>> > On Sat, Dec 07, 2013 at 11:17:41AM +0100, Jean Pihet wrote:
>> >> Use the per-feature check flags for the unwinding feature in order
>> >> to correctly compile the libunwind and libunwind-debug-frame feature
>> >> checks.
>> >>
>> >> Tested on x86_64, ARMv7 and ARMv8 with and without LIBUNWIND_DIR set
>> >> in 'make -C tools/perf'
>> >>
>> >> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
>> >> Cc: Jiri Olsa <jolsa@redhat.com>
>> >
>> > SNIP
>> >
>> >> +BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $@.c $(LDFLAGS)
>> >>
>> >>  ###############################
>> >>
>> >>  test-all:
>> >> -     $(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma $(LIBUNWIND_LIBS) -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
>> >> +     $(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
>> >
>> > hum, the test-all build command should have every possible flags we use, right?
>> > including LIBUNWIND_CFLAGS, LIBUNWIND_LDFLAGS
>> Oh yes you are right. I am overlooked the test-all feature (which
>> never builds on my modest embedded systems).
>> $(LIBUNWIND_LIBS) should be replaced by $(LIBUNWIND_CFLAGS)
>> $(LIBUNWIND_LDFLAGS), is that a reasonable approach?
>
> hum, I'm just dealing with same issue for new libdw feature.. ;-)
>
> I was wondering we could just setup:
>   FEATURE_CHECK_CFLAGS-all
>   FEATURE_CHECK_LDFLAGS-all
>
> automatically from all defined FEATURE_CHECK_(C|LD)FLAGS-*
> just a thought.. haven't tried it yet
Yes that is the idea. The per-feature flags are designed for that
purpose. For now I have the fix for libunwind only, cf. here below.
All features should use the flags. There are complex cases though (e.g
perl flags in config/Makefile andconfig/feature-checks)...

My plan is to submit the ix for libunwind first and if ok care about
the other features. Is that OK?

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d24b4bd..65bc78e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -56,10 +56,14 @@ else
   endif
   LIBUNWIND_LDFLAGS += $(LIBUNWIND_LIBS)

+  # Set per-feature check compilation flags
   FEATURE_CHECK_CFLAGS-libunwind = $(LIBUNWIND_CFLAGS)
   FEATURE_CHECK_LDFLAGS-libunwind = $(LIBUNWIND_LDFLAGS)
   FEATURE_CHECK_CFLAGS-libunwind-debug-frame = $(LIBUNWIND_CFLAGS)
   FEATURE_CHECK_LDFLAGS-libunwind-debug-frame = $(LIBUNWIND_LDFLAGS)
+  #  and the flags for the test-all case
+  FEATURE_CHECK_CFLAGS-all += $(LIBUNWIND_CFLAGS)
+  FEATURE_CHECK_LDFLAGS-all += $(LIBUNWIND_LDFLAGS)
 endif

 ifeq ($(NO_PERF_REGS),0)


>
> jirka

Thx,
Jean
