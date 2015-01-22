Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbbAVQCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:02:24 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64135 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbbAVQCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:02:22 -0500
MIME-Version: 1.0
In-Reply-To: <20150122152908.GA26493@n2100.arm.linux.org.uk>
References: <1421902378-3634-1-git-send-email-victor.kamensky@linaro.org>
	<1421902378-3634-3-git-send-email-victor.kamensky@linaro.org>
	<20150122152908.GA26493@n2100.arm.linux.org.uk>
Date: Thu, 22 Jan 2015 08:02:20 -0800
Message-ID: <CAA3XUr2sMr1wgPDCqNrQnbUb-zJ67v6M=kFfFRHzLg6YR=ZtZw@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] perf symbols: improve abi compliance in arm
 mapping symbols handling
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 January 2015 at 07:29, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jan 21, 2015 at 08:52:57PM -0800, Victor Kamensky wrote:
>> Both Arm and Aarch64 ELF ABI allow mapping symbols be in from
>> either "$d" or "$d.<any>". But current code that handles mapping
>> symbols only deals with the first, dollar character and a single
>> letter, case.
>>
>> The patch adds handling of the second case with period
>> followed by any characters.
>>
>> Suggested-by: Russell King <linux@arm.linux.org.uk>
>> Suggested-by: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
>> Acked-by: Will Deacon <will.deacon@arm.com>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Avi Kivity <avi@cloudius-systems.com>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Anton Blanchard <anton@samba.org>
>> Cc: David Ahern <dsahern@gmail.com>
>> Cc: Dave Martin <Dave.Martin@arm.com>
>> ---
>>  tools/perf/util/symbol-elf.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
>> index 1e188dd..7fd35d6 100644
>> --- a/tools/perf/util/symbol-elf.c
>> +++ b/tools/perf/util/symbol-elf.c
>> @@ -857,17 +857,16 @@ int dso__load_sym(struct dso *dso, struct map *map,
>>                * don't identify functions, so will confuse the profile
>>                * output: */
>>               if (ehdr.e_machine == EM_ARM) {
>> -                     if (!strcmp(elf_name, "$a") ||
>> -                         !strcmp(elf_name, "$d") ||
>> -                         !strcmp(elf_name, "$t"))
>> +                     if (elf_name[0] == '$' && strchr("adt", elf_name[1])
>> +                         && (elf_name[2] == '\0' || elf_name[2] == '.'))
>>                               continue;
>>               }
>>               /* Reject Aarch64 ELF "mapping symbols": these aren't unique and
>>                * don't identify functions, so will confuse the profile
>>                * output: */
>>               if (ehdr.e_machine == EM_AARCH64) {
>> -                     if (!strcmp(elf_name, "$x") ||
>> -                         !strcmp(elf_name, "$d"))
>> +                     if (elf_name[0] == '$' && strchr("dx", elf_name[1])
>> +                         && (elf_name[2] == '\0' || elf_name[2] == '.'))
>>                               continue;
>>               }
>
> Why not fix this first?  Then, all you'd need to do would be to change
> the test for EM_ARM to EM_ARM or EM_AARCH64, and add the 'x' into the
> strchr() string.

In previously discussed [1] I proposed two variants and ask
for people's preferences. Will replied that he did not care and
let me choose that I like.

It seems to me that you more like variant 2 (provided here
for reference again). It would replace patch 1 and patch 2 of
version 2. Please confirm. I don't practically care much and
can use either. I personally preferred variant 1 because in
variant 2 $x will be filtered on ARM V7, but V7 ABI does not
say anything about $x, only Aarch64 does. I.e special symbols
do to match between V7 and V8 exactly. But as it is
already in other places like kallsyms, I agree practically it
may not matter. If you give your node to variant 2 (as below)
I can report this miniseries: Please let me know

Variant 2:

>From c8d08ebddc61203daf21b17c891c26c1d08e14f1 Mon Sep 17 00:00:00 2001
From: Victor Kamensky <victor.kamensky@linaro.org>
Date: Mon, 12 Jan 2015 14:13:36 -0800
Subject: [PATCH 1/2] perf symbols: Ignore mapping symbols on aarch64

Aarch64 ELF files use mapping symbols with special names $x, $d
to identify regions of Aarch64 code (see Aarch64 ELF ABI - "ARM
IHI 0056B", section "4.5.4 Mapping symbols").

The patch filters out these symbols at load time, similar to
"696b97a perf symbols: Ignore mapping symbols on ARM" changes
done for ARM before V8.

Also added handling of mapping symbols that has format
"$d.<any>" and similar for both cases.

Note we are not making difference between EM_ARM and
EM_AARCH64 mapping symbols instead code handles superset
of both.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Avi Kivity <avi@cloudius-systems.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Dave Martin <Dave.Martin@arm.com>
---
 tools/perf/util/symbol-elf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 06fcd1b..b2eb0f9 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -856,10 +856,9 @@ int dso__load_sym(struct dso *dso, struct map *map,
         /* Reject ARM ELF "mapping symbols": these aren't unique and
          * don't identify functions, so will confuse the profile
          * output: */
-        if (ehdr.e_machine == EM_ARM) {
-            if (!strcmp(elf_name, "$a") ||
-                !strcmp(elf_name, "$d") ||
-                !strcmp(elf_name, "$t"))
+        if (ehdr.e_machine == EM_ARM || ehdr.e_machine == EM_AARCH64) {
+                        if (elf_name[0] == '$' && strchr("adtx", elf_name[1])
+                        && (elf_name[2] == '\0' || elf_name[2] == '.'))
                 continue;
         }

-- 
1.9.3

Thanks,
Victor

[1] https://lkml.org/lkml/2015/1/14/1019

> --
> FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
> according to speedtest.net.
