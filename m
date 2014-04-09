Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008AbaDIFVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:21:55 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:38946 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaDIFVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:21:52 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 4/6 V2] perf, sort:  Add physid sorting based on mmap2 data
References: <1395689676-214799-5-git-send-email-dzickus@redhat.com>
	<1395694638-220799-1-git-send-email-dzickus@redhat.com>
Date: Wed, 09 Apr 2014 14:21:49 +0900
In-Reply-To: <1395694638-220799-1-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 16:57:18 -0400")
Message-ID: <87lhvft6vm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 16:57:18 -0400, Don Zickus wrote:
> In order for the c2c tool to work correctly, it needs to properly
> sort all the records on uniquely identifiable data addresses.  These
> unique addresses are converted from virtual addresses provided by the
> hardware into a kernel address using an mmap2 record as the decoder.
>
> Once a unique address is converted, we can sort on them based on
> various rules.  Then it becomes clear which address are overlapping
> with each other across mmap regions or pid spaces.
>
> This patch just creates the rules and inserts the records into a
> sort entry for safe keeping until later patches process them.
>
> The general sorting rule is:
>
> o group cpumodes together
> o if (nonzero major/minor number - ie mmap'd areas)
>   o sort on major, minor, inode, inode generation numbers
> o else if cpumode is not kernel
>   o sort on pid
> o sort on data addresses
>
> I also hacked in the concept of 'color'.  The purpose of that bit is to
> provides hints later when processing these records that indicate a new unique
> address has been encountered.  Because later processing only checks the data
> addresses, there can be a theoretical scenario that similar sequential data
> addresses (when walking the rbtree) could be misinterpreted as overlapping
> when in fact they are not.
>
> Sample output: (perf report --stdio --physid-mode)
>
>   Overhead            Data Address            Source Address    Command:  Pid    Tid Major  Minor  Inode  Inode Gen
>   ........  ......................  ........................ ................. ..... .....  ..... ....... .........
>     18.93%  [k] 0xffffc900139c40b0  [k] igb_update_stats     kworker/0:1:  257   257     0      0       0         0
>      7.63%  [k] 0xffff88082e6cf0a8  [k] watchdog_timer_fn        swapper:    0     0     0      0       0         0
>      1.86%  [k] 0xffff88042ef94700  [k] _raw_spin_lock           swapper:    0     0     0      0       0         0
>      1.77%  [k] 0xffff8804278afa50  [k] __switch_to              swapper:    0     0     0      0       0         0
>
> V4: add manpage entry in perf-report
>
> V3: split out the sorting into unique entries.  This makes it look
>       far less ugly
>     create a new 'physid mode' to group all the sorting rules together
>       (mimics the mem-mode)

What is 'physid' then?  I guess you meant physical id but it seems
unique id or unique map id looks like a better fit IMHO.

>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  tools/perf/Documentation/perf-report.txt |  23 +++
>  tools/perf/builtin-report.c              |  20 ++-
>  tools/perf/util/hist.c                   |  27 ++-
>  tools/perf/util/hist.h                   |   8 +
>  tools/perf/util/sort.c                   | 294 +++++++++++++++++++++++++++++++
>  tools/perf/util/sort.h                   |  13 ++
>  6 files changed, 381 insertions(+), 4 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 8eab8a4..01391b0 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -95,6 +95,23 @@ OPTIONS
>  	And default sort keys are changed to comm, dso_from, symbol_from, dso_to
>  	and symbol_to, see '--branch-stack'.
>  
> +	If --physid-mode option is used, following sort keys are also
> +	available:
> +	daddr, iaddr, pid, tid, major, minor, inode, inode_gen.
> +
> +	- daddr: data address (sorted based on major, minor, inode and inode
> +		generation numbers if shared, otherwise pid)

By "if shared", did you mean "for shared file mapping"?


> +	- iaddr: instruction address
> +	- pid: command and pid of the task
> +	- tid: tid of the task
> +	- major: major number of mapped location (0 if not mapped)
> +	- minor: minor number of mapped location (0 if not mapped)
> +	- inode: inode number of mapped location (0 if not mapped)
> +	- inode_gen: inode generation number of mapped location (0 if not mapped)

s/if not mapped/if not file-mapped/ ?

> +
> +	And default sort keys are changed to daddr, iaddr, pid, tid, major,
> +	minor, inode and inode_gen, see '--physid-mode'.
> +
>  -p::
>  --parent=<regex>::
>          A regex filter to identify parent. The parent is a caller of this
> @@ -223,6 +240,12 @@ OPTIONS
>  	branch stacks and it will automatically switch to the branch view mode,
>  	unless --no-branch-stack is used.
>  
> +--physid-mode::
> +	Use the data addresses sampled using perf record -d and combine them
> +	with the mmap'd area region where they are located.  This helps identify
> +	which data addresses collide with similar addresses in another process
> +	space.  See --sort for output choices.
> +
>  --objdump=<path>::
>          Path to objdump binary.
>  
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index c87412b..093f5ad 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -49,6 +49,7 @@ struct report {
>  	bool			show_threads;
>  	bool			inverted_callchain;
>  	bool			mem_mode;
> +	bool			physid_mode;
>  	bool			header;
>  	bool			header_only;
>  	int			max_stack;
> @@ -241,7 +242,7 @@ static int process_sample_event(struct perf_tool *tool,
>  		ret = report__add_branch_hist_entry(rep, &al, sample, evsel);
>  		if (ret < 0)
>  			pr_debug("problem adding lbr entry, skipping event\n");
> -	} else if (rep->mem_mode == 1) {
> +	} else if ((rep->mem_mode == 1) || (rep->physid_mode)) {

As you can see rep->mem_mode is also a boolean field.  Please change it
like:

	} else if (rep->mem_mode || rep->physid_mode) {


>  		ret = report__add_mem_hist_entry(rep, &al, sample, evsel);
>  		if (ret < 0)
>  			pr_debug("problem adding mem entry, skipping event\n");
> @@ -746,6 +747,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
>  		    "Disable symbol demangling"),
>  	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
> +	OPT_BOOLEAN(0, "physid-mode", &report.physid_mode, "physid access profile"),
>  	OPT_CALLBACK(0, "percent-limit", &report, "percent",
>  		     "Don't show entries under that percent", parse_percent_limit),
>  	OPT_END()
> @@ -817,6 +819,22 @@ repeat:
>  			sort_order = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
>  	}
>  
> +	if (report.physid_mode) {
> +		if ((sort__mode == SORT_MODE__BRANCH) ||
> +		    (sort__mode == SORT_MODE__MEMORY)) {
> +			pr_err("branch or memory and physid mode incompatible\n");
> +			goto error;
> +		}
> +		sort__mode = SORT_MODE__PHYSID;
> +
> +		/*
> +		 * if no sort_order is provided, then specify
> +		 * branch-mode specific order

s/branch-mode/physid-mode/

It looks mem-mode has the same copy-n-paste problem.


> +		 */
> +		if (sort_order == default_sort_order)
> +			sort_order = "daddr,iaddr,pid,tid,major,minor,inode,inode_gen";

So if the 'daddr' key already checks major, minor, inode and inode_gen
by itself why do we need to add those sort keys again?


> +	}
> +
>  	if (setup_sorting() < 0) {
>  		parse_options_usage(report_usage, options, "s", 1);
>  		goto error;


[SNIP]
> +static int64_t
> +sort__physid_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +	u64 l, r;
> +	struct map *l_map = left->mem_info->daddr.map;
> +	struct map *r_map = right->mem_info->daddr.map;
> +
> +	/* store all NULL mem maps at the bottom */
> +	/* shouldn't even need this check, should have stubs */
> +	if (!left->mem_info->daddr.map || !right->mem_info->daddr.map)
> +		return 1;

You might want to use 'return cmp_null(l_map, r_map);' here.

> +
> +	/* group event types together */
> +	if (left->cpumode > right->cpumode) return -1;
> +	if (left->cpumode < right->cpumode) return 1;
> +
> +	/*
> +	 * Addresses with no major/minor numbers are assumed to be
> +	 * anonymous in userspace.  Sort those on pid then address.
> +	 *
> +	 * The kernel and non-zero major/minor mapped areas are
> +	 * assumed to be unity mapped.  Sort those on address then pid.
> +	 */
> +
> +	if (l_map->maj || l_map->min || l_map->ino || l_map->ino_generation) {
> +		/* mmapped areas */
> +
> +		if (l_map->maj > r_map->maj) return -1;
> +		if (l_map->maj < r_map->maj) return 1;
> +
> +		if (l_map->min > r_map->min) return -1;
> +		if (l_map->min < r_map->min) return 1;
> +
> +		if (l_map->ino > r_map->ino) return -1;
> +		if (l_map->ino < r_map->ino) return 1;
> +
> +		if (l_map->ino_generation > r_map->ino_generation) return -1;
> +		if (l_map->ino_generation < r_map->ino_generation) return 1;
> +
> +	} else if (left->cpumode != PERF_RECORD_MISC_KERNEL) {
> +		/* userspace anonymous */
> +		if (left->thread->pid_ > right->thread->pid_) return -1;
> +		if (left->thread->pid_ < right->thread->pid_) return 1;
> +	}
> +
> +	/* hack to mark similar regions, 'right' is new entry */
> +	right->color = TRUE;

I don't understand the logic behind the 'color'.  It seems just mark
every samples except first one on a same file (or same pid for anon map)
indicating that those accesses are for distinct maps, right?

I don't know how it could help to distinguish whether an access is for a
same map or different map.  For the userspace anon map case, why doesn't
it check the start addresses of l_map and r_map?

I'm feeling ignorant.. :-(

> +
> +	/* al_addr does all the right addr - start + offset calculations */
> +	l = left->mem_info->daddr.al_addr;
> +	r = right->mem_info->daddr.al_addr;
> +
> +	if (l > r) return -1;
> +	if (l < r) return 1;
> +
> +	/* sanity check the maps; only mmaped areas should have different maps */
> +	if ((left->mem_info->daddr.map != right->mem_info->daddr.map) &&
> +	     !right->mem_info->daddr.map->maj && !right->mem_info->daddr.map->min)
> +		pr_debug("physid_cmp: Similar entries have different maps\n");
> +
> +	return 0;
> +}


[SNIP]
> @@ -1104,6 +1382,22 @@ int sort_dimension__add(const char *tok)
>  		return 0;
>  	}
>  
> +	for (i = 0; i < ARRAY_SIZE(physid_sort_dimensions); i++) {
> +		struct sort_dimension *sd = &physid_sort_dimensions[i];
> +
> +		if (strncasecmp(tok, sd->name, strlen(tok)))
> +			continue;
> +
> +		if (sort__mode != SORT_MODE__PHYSID)
> +			return -EINVAL;
> +
> +		if (sd->entry == &sort_physid_daddr)
> +			sort__has_sym = 1;

I think it's not needed.  The sort__has_sym is for doing annotate during
report/top session and it only works for symbol (i.e. function) basis.

Thanks,
Namhyung

> +
> +		__sort_dimension__add(sd, i + __SORT_PHYSID_MODE);
> +		return 0;
> +	}
> +
>  	return -ESRCH;
>  }
