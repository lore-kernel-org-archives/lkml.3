Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbbANSil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:38:41 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:38588 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbbANSij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:38:39 -0500
MIME-Version: 1.0
In-Reply-To: <20150114112210.GF4050@arm.com>
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
	<20150114112210.GF4050@arm.com>
Date: Wed, 14 Jan 2015 10:38:38 -0800
Message-ID: <CAA3XUr2KUyafcnUggN7=xGNGSeRkkRtYtxZmwm4UC8sRCGup3g@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf symbols: Ignore mapping symbols on aarch64
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, David Ahern <dsahern@gmail.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2015 at 03:22, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Jan 13, 2015 at 04:59:03PM +0000, Victor Kamensky wrote:
>> Aarch64 ELF files use mapping symbols with special names $x, $d
>> to identify regions of Aarch64 code (see Aarch64 ELF ABI - "ARM
>> IHI 0056B", section "4.5.4 Mapping symbols").
>>
>> The patch filters out these symbols at load time, similar to
>> "696b97a perf symbols: Ignore mapping symbols on ARM" changes
>> done for ARM before V8.
>>
>> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
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
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Dave Martin <Dave.Martin@arm.com>
>> ---
>>  tools/perf/util/symbol-elf.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
>> index 06fcd1b..1e188dd 100644
>> --- a/tools/perf/util/symbol-elf.c
>> +++ b/tools/perf/util/symbol-elf.c
>> @@ -862,6 +862,14 @@ int dso__load_sym(struct dso *dso, struct map *map,
>>                           !strcmp(elf_name, "$t"))
>>                               continue;
>>               }
>> +             /* Reject Aarch64 ELF "mapping symbols": these aren't unique and
>> +              * don't identify functions, so will confuse the profile
>> +              * output: */
>> +             if (ehdr.e_machine == EM_AARCH64) {
>> +                     if (!strcmp(elf_name, "$x") ||
>> +                         !strcmp(elf_name, "$d"))
>> +                             continue;
>> +             }
>
> Do we need to skip $x.* and $d.* too? I doubt GCC generates them, but they
> are permitted by the ELF ABI.

Fair enough. But I think it would need to be done for both EM_ARM and
EM_AARCH64. My above patch follows EM_ARM current case. Also it
seems that it would be quite rare case, as ABI suggests symbols
with dot notation should be used in manual asm where assembler does not
support multiple definitions of the same symbol.

Will something like the following suffice? I can add that as separate follow up
patch in this small series. Tested with explicit "$x.func1" symbol introduced in
manual asm.

>From fed6caab410ddcaf487ff23a3908eca129e50b89 Mon Sep 17 00:00:00 2001
From: Victor Kamensky <victor.kamensky@linaro.org>
Date: Wed, 14 Jan 2015 07:42:41 -0800
Subject: [PATCH 3/3] perf symbols: improve abi compliance in arm mapping
 symbols handling

Both Arm and Aarch64 ELF ABI allow mapping symbols be in from
either "$d" or "$d.<any>". But current code that handles mapping
symbols only deals with the first, dollar character and a single
letter, case.

The patch adds handling of the second case with period
followed by any characters.

Suggested-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
---
 tools/perf/util/symbol-elf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 1e188dd..ae92c27 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -859,7 +859,10 @@ int dso__load_sym(struct dso *dso, struct map *map,
         if (ehdr.e_machine == EM_ARM) {
             if (!strcmp(elf_name, "$a") ||
                 !strcmp(elf_name, "$d") ||
-                !strcmp(elf_name, "$t"))
+                !strcmp(elf_name, "$t") ||
+                !strncmp(elf_name, "$a.", 3) ||
+                !strncmp(elf_name, "$d.", 3) ||
+                !strncmp(elf_name, "$t.", 3))
                 continue;
         }
         /* Reject Aarch64 ELF "mapping symbols": these aren't unique and
@@ -867,7 +870,9 @@ int dso__load_sym(struct dso *dso, struct map *map,
          * output: */
         if (ehdr.e_machine == EM_AARCH64) {
             if (!strcmp(elf_name, "$x") ||
-                !strcmp(elf_name, "$d"))
+                !strcmp(elf_name, "$d") ||
+                !strncmp(elf_name, "$x.", 3) ||
+                !strncmp(elf_name, "$d.", 3))
                 continue;
         }

-- 
1.9.3

Thanks,
Victor

> Will
