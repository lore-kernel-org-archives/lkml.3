Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaA3IJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 03:09:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:1563 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaA3IJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 03:09:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,748,1384329600"; 
   d="scan'208";a="446894267"
Message-ID: <52EA090A.8090807@intel.com>
Date: Thu, 30 Jan 2014 10:10:50 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 8/9] perf tools: Adjust kallsyms for relocated kernel
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com> <1391004884-10334-9-git-send-email-adrian.hunter@intel.com> <20140129190850.GF3998@ghostprotocols.net>
In-Reply-To: <20140129190850.GF3998@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/14 21:08, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 29, 2014 at 04:14:43PM +0200, Adrian Hunter escreveu:
>> If the kernel is relocated at boot time, kallsyms
>> will not match data recorded previously.  That
>> does not matter for modules because they are
>> corrected anyway.  It also does not matter if
>> vmlinux is being used for symbols. But if perf
>> tools has only kallsyms then the symbols will not
>> match.  Fix by applying the delta gained by
>> comparing the old and current addresses of the
>> relocation reference symbol.
> 
> Don't we have map->reloc? Can't we use it here, i.e. be consistent and
> have the unrelocated address + the relocation, and then, when using
> map->{map,unmap} take that into account, as you did to the objdump
> variants, no?

map->reloc is calculated from vmlinux.  No vmlinux, no map->reloc.
e.g. we don't need to calculate objdump addresses if we have no
object code anyway.  Also without vmlinux we do not know what the
actual relocation was, we just know the difference between where
the kernel was located when the data was recorded and where it
is now.  That is the "delta".

This is the case where all we have is kallsyms.  In that case
perf tools uses identity maps (identity__map_ip).  An alternative
would be to change to use map__[un]map_ip() and set map->pgoff to
match the current kallsyms. i.e. map->pgoff = map->start + delta

So we need either to change the symbols to match the mapping or
change the mapping to match the symbols.  I went with the former
because we are already changing the module symbols so it seemed
consistent.

> 
> I applied the others, testing now.
> 
> - Arnaldo
>  
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/symbol.c | 40 ++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 38 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
>> index 4ac1f87..a9d758a 100644
>> --- a/tools/perf/util/symbol.c
>> +++ b/tools/perf/util/symbol.c
>> @@ -627,7 +627,7 @@ static int dso__split_kallsyms_for_kcore(struct dso *dso, struct map *map,
>>   * kernel range is broken in several maps, named [kernel].N, as we don't have
>>   * the original ELF section names vmlinux have.
>>   */
>> -static int dso__split_kallsyms(struct dso *dso, struct map *map,
>> +static int dso__split_kallsyms(struct dso *dso, struct map *map, u64 delta,
>>  			       symbol_filter_t filter)
>>  {
>>  	struct map_groups *kmaps = map__kmap(map)->kmaps;
>> @@ -692,6 +692,12 @@ static int dso__split_kallsyms(struct dso *dso, struct map *map,
>>  			char dso_name[PATH_MAX];
>>  			struct dso *ndso;
>>  
>> +			if (delta) {
>> +				/* Kernel was relocated at boot time */
>> +				pos->start -= delta;
>> +				pos->end -= delta;
>> +			}
>> +
>>  			if (count == 0) {
>>  				curr_map = map;
>>  				goto filter_symbol;
>> @@ -721,6 +727,10 @@ static int dso__split_kallsyms(struct dso *dso, struct map *map,
>>  			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
>>  			map_groups__insert(kmaps, curr_map);
>>  			++kernel_range;
>> +		} else if (delta) {
>> +			/* Kernel was relocated at boot time */
>> +			pos->start -= delta;
>> +			pos->end -= delta;
>>  		}
>>  filter_symbol:
>>  		if (filter && filter(curr_map, pos)) {
>> @@ -1130,15 +1140,41 @@ out_err:
>>  	return -EINVAL;
>>  }
>>  
>> +/*
>> + * If the kernel is relocated at boot time, kallsyms won't match.  Compute the
>> + * delta based on the relocation reference symbol.
>> + */
>> +static int kallsyms__delta(struct map *map, const char *filename, u64 *delta)
>> +{
>> +	struct kmap *kmap = map__kmap(map);
>> +	u64 addr;
>> +
>> +	if (!kmap->ref_reloc_sym || !kmap->ref_reloc_sym->name)
>> +		return 0;
>> +
>> +	addr = kallsyms__get_function_start(filename,
>> +					    kmap->ref_reloc_sym->name);
>> +	if (!addr)
>> +		return -1;
>> +
>> +	*delta = addr - kmap->ref_reloc_sym->addr;
>> +	return 0;
>> +}
>> +
>>  int dso__load_kallsyms(struct dso *dso, const char *filename,
>>  		       struct map *map, symbol_filter_t filter)
>>  {
>> +	u64 delta = 0;
>> +
>>  	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
>>  		return -1;
>>  
>>  	if (dso__load_all_kallsyms(dso, filename, map) < 0)
>>  		return -1;
>>  
>> +	if (kallsyms__delta(map, filename, &delta))
>> +		return -1;
>> +
>>  	symbols__fixup_duplicate(&dso->symbols[map->type]);
>>  	symbols__fixup_end(&dso->symbols[map->type]);
>>  
>> @@ -1150,7 +1186,7 @@ int dso__load_kallsyms(struct dso *dso, const char *filename,
>>  	if (!dso__load_kcore(dso, map, filename))
>>  		return dso__split_kallsyms_for_kcore(dso, map, filter);
>>  	else
>> -		return dso__split_kallsyms(dso, map, filter);
>> +		return dso__split_kallsyms(dso, map, delta, filter);
>>  }
>>  
>>  static int dso__load_perf_map(struct dso *dso, struct map *map,
>> -- 
>> 1.7.11.7
> 
> 

