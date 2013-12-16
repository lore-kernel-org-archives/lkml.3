Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3LPHzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 02:55:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:36580 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3LPHzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 02:55:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,493,1384329600"; 
   d="scan'208";a="425230493"
Message-ID: <52AEB206.4080508@intel.com>
Date: Mon, 16 Dec 2013 09:55:50 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 07/71] perf tools: Record whether a dso is 64-bit
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com> <52AE7086.2030708@gmail.com>
In-Reply-To: <52AE7086.2030708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/13 05:16, David Ahern wrote:
> On 12/11/13, 5:36 AM, Alexander Shishkin wrote:
>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>> index a0c7c59..80817ec 100644
>> --- a/tools/perf/util/dso.c
>> +++ b/tools/perf/util/dso.c
>> @@ -446,6 +446,7 @@ struct dso *dso__new(const char *name)
>>           dso->cache = RB_ROOT;
>>           dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
>>           dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
>> +        dso->is_64_bit = (sizeof(void *) == 8);
>>           dso->loaded = 0;
>>           dso->rel = 0;
>>           dso->sorted_by_name = 0;
>> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
>> index 384f2d9..62680e1 100644
>> --- a/tools/perf/util/dso.h
>> +++ b/tools/perf/util/dso.h
>> @@ -91,6 +91,7 @@ struct dso {
>>       u8         annotate_warned:1;
>>       u8         sname_alloc:1;
>>       u8         lname_alloc:1;
>> +    u8         is_64_bit:1;
>>       u8         sorted_by_name;
>>       u8         loaded;
>>       u8         rel;
>> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
>> index eed0b96..a0fc81b 100644
>> --- a/tools/perf/util/symbol-elf.c
>> +++ b/tools/perf/util/symbol-elf.c
>> @@ -595,6 +595,8 @@ int symsrc__init(struct symsrc *ss, struct dso *dso,
>> const char *name,
>>               goto out_elf_end;
>>       }
>>
>> +    ss->is_64_bit = (gelf_getclass(elf) == ELFCLASS64);
>> +
>>       ss->symtab = elf_section_by_name(elf, &ehdr, &ss->symshdr, ".symtab",
>>               NULL);
>>       if (ss->symshdr.sh_type != SHT_SYMTAB)
>> @@ -694,6 +696,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
>>       bool remap_kernel = false, adjust_kernel_syms = false;
>>
>>       dso->symtab_type = syms_ss->type;
>> +    dso->is_64_bit = syms_ss->is_64_bit;
>>       dso->rel = syms_ss->ehdr.e_type == ET_REL;
>>
>>       /*
>> diff --git a/tools/perf/util/symbol-minimal.c
>> b/tools/perf/util/symbol-minimal.c
>> index ac7070a..b9d1119 100644
>> --- a/tools/perf/util/symbol-minimal.c
>> +++ b/tools/perf/util/symbol-minimal.c
>> @@ -1,3 +1,4 @@
>> +#include "util.h"
>>   #include "symbol.h"
>>
>>   #include <stdio.h>
>> @@ -287,6 +288,23 @@ int dso__synthesize_plt_symbols(struct dso *dso
>> __maybe_unused,
>>       return 0;
>>   }
>>
>> +static int fd__is_64_bit(int fd)
>> +{
>> +    u8 e_ident[EI_NIDENT];
>> +
>> +    if (lseek(fd, 0, SEEK_SET))
>> +        return -1;
>> +
>> +    if (readn(fd, e_ident, sizeof(e_ident)) != sizeof(e_ident))
>> +        return -1;
>> +
>> +    if (memcmp(e_ident, ELFMAG, SELFMAG) ||
>> +        e_ident[EI_VERSION] != EV_CURRENT)
>> +        return -1;
>> +
>> +    return e_ident[EI_CLASS] == ELFCLASS64;
>> +}
>> +
>>   int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
>>             struct symsrc *ss,
>>             struct symsrc *runtime_ss __maybe_unused,
>> @@ -294,6 +312,11 @@ int dso__load_sym(struct dso *dso, struct map *map
>> __maybe_unused,
>>             int kmodule __maybe_unused)
>>   {
>>       unsigned char *build_id[BUILD_ID_SIZE];
>> +    int ret;
>> +
>> +    ret = fd__is_64_bit(ss->fd);
>> +    if (ret >= 0)
>> +        dso->is_64_bit = ret;
>>
>>       if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) > 0) {
>>           dso__set_build_id(dso, build_id);
> 
> 
> Here's what is wrong with this API: you are determining DSO bitness at
> symbol load time, not when the DSO is created and added to the maps.
> 
> As I pointed out in a prior comment you are initializing dso->is_64_bit to
> perf's bitness when the dso object is created (dso__new) but the value is
> not correctly set until dso__load time. Some tools (perf-trace) never load
> symbols, so that value is always wrong in the sense that its value has no
> correlation to the dso object.

That is a very good point.  I think Arnaldo has previously noted that symbol
loading needs to be split from dso (map) loading.  I don't have the time to
do that right now.

