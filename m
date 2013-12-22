Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3LVVj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 16:39:26 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59735 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab3LVVjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 16:39:24 -0500
Message-ID: <52B75C04.6000404@hitachi.com>
Date: Mon, 23 Dec 2013 06:39:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip  2/3] perf-probe: Support dwarf on uprobe events
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal> <20131220100259.7169.57512.stgit@kbuild-fedora.novalocal> <20131220180154.GB28878@ghostprotocols.net>
In-Reply-To: <20131220180154.GB28878@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/21 3:01), Arnaldo Carvalho de Melo wrote:
> Em Fri, Dec 20, 2013 at 10:02:59AM +0000, Masami Hiramatsu escreveu:
>> Support dwarf(debuginfo) based operations for uprobe events.
>> With this change, perf probe can analyze debuginfo of user
>> application binary to set up new uprobe event.
>> This allows perf-probe --add/--line works with -x option.
>> (Actually, --vars has already accepted -x option)
> 
> Can you provide an example?
> 

OK, here is the examples from 0/3. :)
Or, should I better put this into the patch description too?

For example)
- Shows the probe-able lines of the given function
----
# ./perf probe -x perf --line map__load
<map__load@/home/fedora/ksrc/linux-2.6/tools/perf/util/map.c:0>
      0  int map__load(struct map *map, symbol_filter_t filter)
      1  {
      2         const char *name = map->dso->long_name;
                int nr;

      5         if (dso__loaded(map->dso, map->type))
      6                 return 0;

      8         nr = dso__load(map->dso, map, filter);
      9         if (nr < 0) {
     10                 if (map->dso->has_build_id) {
----

- Shows the available variables of the given line
----
# ./perf probe -x perf --vars map__load:8
Available variables at map__load:8
        @<map__load+96>
                char*   name
                struct map*     map
                symbol_filter_t filter
        @<map__find_symbol+112>
                char*   name
                symbol_filter_t filter
        @<map__find_symbol_by_name+136>
                char*   name
                symbol_filter_t filter
        @<map_groups__find_symbol_by_name+176>
                char*   name
                struct map*     map
                symbol_filter_t filter
----

- Set a probe with available vars on the given line
----
# ./perf probe -x perf --add 'map__load:8 $vars'

Added new events:
  probe_perf:map__load (on map__load:8 with $vars)
  probe_perf:map__load_1 (on map__load:8 with $vars)
  probe_perf:map__load_2 (on map__load:8 with $vars)
  probe_perf:map__load_3 (on map__load:8 with $vars)

You can now use it in all perf tools, such as:

        perf record -e probe_perf:map__load_3 -aR sleep 1
----

> Showing output from commands when new features are implemented can speed
> up the process of having it used :-)
> 
> - Arnaldo
>  
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>  tools/perf/builtin-probe.c    |    2 
>>  tools/perf/util/probe-event.c |  230 +++++++++++++++++++++++++++--------------
>>  2 files changed, 155 insertions(+), 77 deletions(-)
>>
>> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
>> index b40d064..7fc566a 100644
>> --- a/tools/perf/builtin-probe.c
>> +++ b/tools/perf/builtin-probe.c
>> @@ -420,7 +420,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>>  	}
>>  
>>  #ifdef HAVE_DWARF_SUPPORT
>> -	if (params.show_lines && !params.uprobes) {
>> +	if (params.show_lines) {
>>  		if (params.mod_events) {
>>  			pr_err("  Error: Don't use --line with"
>>  			       " --add/--del.\n");
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index 05be5de..e27cecb 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -186,6 +186,90 @@ static int init_user_exec(void)
>>  	return ret;
>>  }
>>  
>> +static const char *__target_symbol;
>> +static struct symbol *__result_sym;
>> +
>> +static int filter_target_symbol(struct map *map __maybe_unused,
>> +				struct symbol *sym)
>> +{
>> +	if (strcmp(__target_symbol, sym->name) == 0) {
>> +		__result_sym = sym;
>> +		return 0;
>> +	}
>> +	return 1;
>> +}
>> +
>> +/* Find the offset of the symbol in the executable binary */
>> +static int find_symbol_offset(const char *exec, const char *function,
>> +			      unsigned long *offs)
>> +{
>> +	struct symbol *sym;
>> +	struct map *map = NULL;
>> +	int ret = -EINVAL;
>> +
>> +	if (!offs)
>> +		return -EINVAL;
>> +
>> +	map = dso__new_map(exec);
>> +	if (!map) {
>> +		pr_warning("Cannot find appropriate DSO for %s.\n", exec);
>> +		goto out;
>> +	}
>> +	pr_debug("Search %s in %s\n", function, exec);
>> +	__target_symbol = function;
>> +	__result_sym = NULL;
>> +	if (map__load(map, filter_target_symbol)) {
>> +		pr_err("Failed to find %s in %s.\n", function, exec);
>> +		goto out;
>> +	}
>> +	sym = __result_sym;
>> +	if (!sym) {
>> +		pr_warning("Cannot find %s in DSO %s\n", function, exec);
>> +		goto out;
>> +	}
>> +
>> +	*offs = (map->start > sym->start) ?  map->start : 0;
>> +	*offs += sym->start + map->pgoff;
>> +	ret = 0;
>> +out:
>> +	if (map) {
>> +		dso__delete(map->dso);
>> +		map__delete(map);
>> +	}
>> +	return ret;
>> +}
>> +
>> +static int convert_exec_to_group(const char *exec, char **result)
>> +{
>> +	char *ptr1, *ptr2, *exec_copy;
>> +	char buf[64];
>> +	int ret;
>> +
>> +	exec_copy = strdup(exec);
>> +	if (!exec_copy)
>> +		return -ENOMEM;
>> +
>> +	ptr1 = basename(exec_copy);
>> +	if (!ptr1) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	ptr2 = strpbrk(ptr1, "-._");
>> +	if (ptr2)
>> +		*ptr2 = '\0';
>> +	ret = e_snprintf(buf, 64, "%s_%s", PERFPROBE_GROUP, ptr1);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	*result = strdup(buf);
>> +	ret = *result ? 0 : -ENOMEM;
>> +
>> +out:
>> +	free(exec_copy);
>> +	return ret;
>> +}
>> +
>>  static int convert_to_perf_probe_point(struct probe_trace_point *tp,
>>  					struct perf_probe_point *pp)
>>  {
>> @@ -261,6 +345,45 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
>>  	return 0;
>>  }
>>  
>> +static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
>> +					  int ntevs, const char *exec,
>> +					  const char *group)
>> +{
>> +	int i, ret = 0;
>> +	unsigned long offset;
>> +	char buf[32];
>> +
>> +	if (!exec)
>> +		return 0;
>> +
>> +	for (i = 0; i < ntevs && ret >= 0; i++) {
>> +		/* Get proper offset */
>> +		ret = find_symbol_offset(exec, tevs[i].point.symbol, &offset);
>> +		if (ret < 0)
>> +			break;
>> +		offset += tevs[i].point.offset;
>> +		tevs[i].point.offset = 0;
>> +		free(tevs[i].point.symbol);
>> +		ret = e_snprintf(buf, 32, "0x%lx", offset);
>> +		if (ret < 0)
>> +			break;
>> +		tevs[i].point.module = strdup(exec);
>> +		tevs[i].point.symbol = strdup(buf);
>> +		if (!tevs[i].point.symbol || !tevs[i].point.module) {
>> +			ret = -ENOMEM;
>> +			break;
>> +		}
>> +		/* Replace group name if not given */
>> +		if (!group) {
>> +			free(tevs[i].group);
>> +			ret = convert_exec_to_group(exec, &tevs[i].group);
>> +		}
>> +		tevs[i].uprobes = true;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>  static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
>>  					    int ntevs, const char *module)
>>  {
>> @@ -305,15 +428,6 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
>>  	struct debuginfo *dinfo;
>>  	int ntevs, ret = 0;
>>  
>> -	if (pev->uprobes) {
>> -		if (need_dwarf) {
>> -			pr_warning("Debuginfo-analysis is not yet supported"
>> -					" with -x/--exec option.\n");
>> -			return -ENOSYS;
>> -		}
>> -		return convert_name_to_addr(pev, target);
>> -	}
>> -
>>  	dinfo = open_debuginfo(target);
>>  
>>  	if (!dinfo) {
>> @@ -332,9 +446,14 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
>>  
>>  	if (ntevs > 0) {	/* Succeeded to find trace events */
>>  		pr_debug("find %d probe_trace_events.\n", ntevs);
>> -		if (target)
>> -			ret = add_module_to_probe_trace_events(*tevs, ntevs,
>> -							       target);
>> +		if (target) {
>> +			if (pev->uprobes)
>> +				ret = add_exec_to_probe_trace_events(*tevs,
>> +						 ntevs, target, pev->group);
>> +			else
>> +				ret = add_module_to_probe_trace_events(*tevs,
>> +						 ntevs, target);
>> +		}
>>  		return ret < 0 ? ret : ntevs;
>>  	}
>>  
>> @@ -654,9 +773,6 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
>>  		return -ENOSYS;
>>  	}
>>  
>> -	if (pev->uprobes)
>> -		return convert_name_to_addr(pev, target);
>> -
>>  	return 0;
>>  }
>>  
>> @@ -1916,11 +2032,26 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>>  	int ret = 0, i;
>>  	struct probe_trace_event *tev;
>>  
>> +	if (pev->uprobes)
>> +		if (!pev->group) {
>> +			ret = convert_exec_to_group(target, &pev->group);
>> +			if (ret != 0) {
>> +				pr_warning("Failed to make group name.\n");
>> +				return ret;
>> +			}
>> +		}
>> +
>>  	/* Convert perf_probe_event with debuginfo */
>>  	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
>>  	if (ret != 0)
>>  		return ret;	/* Found in debuginfo or got an error */
>>  
>> +	if (pev->uprobes) {
>> +		ret = convert_name_to_addr(pev, target);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>>  	/* Allocate trace event buffer */
>>  	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
>>  	if (tev == NULL)
>> @@ -2279,88 +2410,35 @@ int show_available_funcs(const char *target, struct strfilter *_filter,
>>  static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>>  {
>>  	struct perf_probe_point *pp = &pev->point;
>> -	struct symbol *sym;
>> -	struct map *map = NULL;
>> -	char *function = NULL;
>>  	int ret = -EINVAL;
>> -	unsigned long long vaddr = 0;
>> +	unsigned long vaddr = 0;
>>  
>>  	if (!pp->function) {
>>  		pr_warning("No function specified for uprobes");
>>  		goto out;
>>  	}
>>  
>> -	function = strdup(pp->function);
>> -	if (!function) {
>> -		pr_warning("Failed to allocate memory by strdup.\n");
>> -		ret = -ENOMEM;
>> -		goto out;
>> -	}
>> -
>> -	map = dso__new_map(exec);
>> -	if (!map) {
>> -		pr_warning("Cannot find appropriate DSO for %s.\n", exec);
>> -		goto out;
>> -	}
>> -	available_func_filter = strfilter__new(function, NULL);
>> -	if (map__load(map, filter_available_functions)) {
>> -		pr_err("Failed to load map.\n");
>> -		goto out;
>> -	}
>> -
>> -	sym = map__find_symbol_by_name(map, function, NULL);
>> -	if (!sym) {
>> -		pr_warning("Cannot find %s in DSO %s\n", function, exec);
>> +	ret = find_symbol_offset(exec, pp->function, &vaddr);
>> +	if (ret < 0)
>>  		goto out;
>> -	}
>>  
>> -	if (map->start > sym->start)
>> -		vaddr = map->start;
>> -	vaddr += sym->start + pp->offset + map->pgoff;
>> +	vaddr += pp->offset;
>>  	pp->offset = 0;
>>  
>>  	if (!pev->event) {
>> -		pev->event = function;
>> -		function = NULL;
>> -	}
>> -	if (!pev->group) {
>> -		char *ptr1, *ptr2, *exec_copy;
>> -
>> -		pev->group = zalloc(sizeof(char *) * 64);
>> -		exec_copy = strdup(exec);
>> -		if (!exec_copy) {
>> -			ret = -ENOMEM;
>> -			pr_warning("Failed to copy exec string.\n");
>> -			goto out;
>> -		}
>> +		pev->event = pp->function;
>> +	} else
>> +		free(pp->function);
>>  
>> -		ptr1 = strdup(basename(exec_copy));
>> -		if (ptr1) {
>> -			ptr2 = strpbrk(ptr1, "-._");
>> -			if (ptr2)
>> -				*ptr2 = '\0';
>> -			e_snprintf(pev->group, 64, "%s_%s", PERFPROBE_GROUP,
>> -					ptr1);
>> -			free(ptr1);
>> -		}
>> -		free(exec_copy);
>> -	}
>> -	free(pp->function);
>>  	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
>>  	if (!pp->function) {
>>  		ret = -ENOMEM;
>>  		pr_warning("Failed to allocate memory by zalloc.\n");
>>  		goto out;
>>  	}
>> -	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
>> +	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%lx", vaddr);
>>  	ret = 0;
>>  
>>  out:
>> -	if (map) {
>> -		dso__delete(map->dso);
>> -		map__delete(map);
>> -	}
>> -	if (function)
>> -		free(function);
>>  	return ret;
>>  }
>>
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


