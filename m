Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3IYGxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 02:53:47 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:45140 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3IYGxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 02:53:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130924174318.GE3080@krava.brq.redhat.com>
References: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
	<1379323053-11458-4-git-send-email-jean.pihet@linaro.org>
	<20130917102904.GA27258@mudshark.cambridge.arm.com>
	<CAFrcx1nnx0+kWx3z3A86Fwz13RYRVSPSG0YHBcxFeFQP8W7jBg@mail.gmail.com>
	<20130924093450.GB1008@krava.brq.redhat.com>
	<20130924100620.GG15119@mudshark.cambridge.arm.com>
	<CAFrcx1k-sfHMRz6mvibBbph4vNOMkVddE4LEE4yXbWHC3DwMZA@mail.gmail.com>
	<20130924174318.GE3080@krava.brq.redhat.com>
Date: Wed, 25 Sep 2013 08:53:44 +0200
Message-ID: <CAFrcx1kw-vEo8m0yNFK1d7Sw+o8C7K7j1feLdOk3Mcdmw9tPcw@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of dwarf
 parsing feature
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 24 September 2013 19:43, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Sep 24, 2013 at 02:03:47PM +0200, Jean Pihet wrote:
>> Hi Jiri, Will,
>>
>> On 24 September 2013 12:06, Will Deacon <will.deacon@arm.com> wrote:
>> > On Tue, Sep 24, 2013 at 10:34:50AM +0100, Jiri Olsa wrote:
>> >> On Tue, Sep 24, 2013 at 10:55:32AM +0200, Jean Pihet wrote:
>> >> > Ping on the series. The two patches above (3/4 and 4/4) are generic
>> >> > while the two others are impacting ARM only.
>> >> > Is it possible to get an Ack for the generic ones?
>> >>
>> >> I'm fine with those changes.. still I'm sort of worried about
>> >> current DWARF unwind users (but not sure if there're any),
>> >> who depends on packaged libunwind compiled without
>> >> --enable-debug-frame option.
>> >
>> > Since x86 is the only architecture using libunwind with perf at the moment,
>> > and I'd expect it to use .eh_frame for unwinding, I'm also not sure there
>> > are any existing users to worry about.
>> Right
>>
>> >
>> >> I've seen your libunwind patch to make it default, but
>> >> not sure if it was accepted.. if not, maybe we should
>> >> detect this and build that code conditionaly.
>> >
>> > It certainly defaults to "on" for ARM, but other architectures have to
>> > enable it explicitly afaict.
>> Yes that is correct.
>> This patch (3/4) detects if the debug frame code is enabled in
>> libunwind and uses the lib only if it is the case.
>
> My concern is about users (again, not sure if there are any ;-) )
> that use this with packaged libunwind compiled without
> --enable-debug-frame option.
>
> For them perf will consider libunwind as 'not available' with
> your changes:
>
>       ...
>       CHK libunwind
>   config/Makefile:223: No libunwind found, disabling post unwind support.  Please install libunwind-dev[el] >= 1.1
>       ...
>
> and they'll need to compile their own libunwind
> (thats the case on Fedora).
>
> This could be solved by detecting this and make your
> code conditional as attached below (not much tested).
Ok that makes sense.
Let me integrate this in the patch series, test it (on ARM and x86)
and re-submit. Is that OK?

Regards,
Jean

>
> thanks,
> jirka
>
>
> ---
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 134b36e..d40cf0a 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -223,6 +223,10 @@ ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
>    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
>    NO_LIBUNWIND := 1
>  endif # Libunwind support
> +ifneq ($(call try-cc,$(SOURCE_LIBUNWIND_DEBUG_FRAME),$(FLAGS_UNWIND),libunwind debug_frame),y)
> +  msg := $(warning No debug_frame support found in libunwind);
> +CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
> +endif
>  endif # NO_LIBUNWIND
>
>  ifndef NO_LIBUNWIND
> diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
> index 87124d0..645141c 100644
> --- a/tools/perf/config/feature-tests.mak
> +++ b/tools/perf/config/feature-tests.mak
> @@ -178,6 +178,28 @@ extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
>
>  #define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
>
> +int main(void)
> +{
> +       unw_addr_space_t addr_space;
> +       addr_space = unw_create_addr_space(NULL, 0);
> +       unw_init_remote(NULL, addr_space, NULL);
> +       dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
> +       return 0;
> +}
> +endef
> +
> +define SOURCE_LIBUNWIND_DEBUG_FRAME
> +#include <libunwind.h>
> +#include <stdlib.h>
> +
> +extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
> +                                      unw_word_t ip,
> +                                      unw_dyn_info_t *di,
> +                                      unw_proc_info_t *pi,
> +                                      int need_unwind_info, void *arg);
> +
> +#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
> +
>  extern int
>  UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
>                                  unw_word_t ip,
> @@ -189,11 +211,7 @@ UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
>
>  int main(void)
>  {
> -       unw_addr_space_t addr_space;
> -       addr_space = unw_create_addr_space(NULL, 0);
> -       unw_init_remote(NULL, addr_space, NULL);
>         dwarf_find_debug_frame(0, NULL, 0, 0, NULL, 0, 0);
> -       dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
>         return 0;
>  }
>  endef
> diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
> index 429a99c..231c941 100644
> --- a/tools/perf/util/unwind.c
> +++ b/tools/perf/util/unwind.c
> @@ -277,6 +277,7 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
>         return ret;
>  }
>
> +#ifndef NO_LIBUNWIND_DEBUG_FRAME
>  static int read_unwind_spec_debug_frame(struct dso *dso,
>                                         struct machine *machine, u64 *offset)
>  {
> @@ -294,6 +295,7 @@ static int read_unwind_spec_debug_frame(struct dso *dso,
>
>         return -EINVAL;
>  }
> +#endif
>
>  static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
>  {
> @@ -334,6 +336,7 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
>                                                  need_unwind_info, arg);
>         }
>
> +#ifndef NO_LIBUNWIND_DEBUG_FRAME
>         /* Check the .debug_frame section for unwinding info */
>         if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
>                 memset(&di, 0, sizeof(di));
> @@ -342,7 +345,7 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
>                 return dwarf_search_unwind_table(as, ip, &di, pi,
>                                                  need_unwind_info, arg);
>         }
> -
> +#endif
>         return -EINVAL;
>  }
>
