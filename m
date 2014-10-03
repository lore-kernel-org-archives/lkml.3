Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaJCMwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:52:44 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41580 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaJCMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:52:43 -0400
Message-ID: <542E9C14.3010406@hitachi.com>
Date: Fri, 03 Oct 2014 21:52:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 3/5] perf/sdt: Show SDT cache contents
References: <20141001023723.28985.39736.stgit@hemant-fedora> <20141001024815.28985.8980.stgit@hemant-fedora>
In-Reply-To: <20141001024815.28985.8980.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/01 11:48), Hemant Kumar wrote:
> This patch adds support to dump the SDT cache onto sdtout.
> The cache data is read into a hash_list and then, it iterates through
> the hash_list to dump the data onto stdout.
> 
> # ./perf sdt-cache --dump
> 
> /usr/lib64/libc-2.16.so :
> %libc:lll_futex_wake
> %libc:longjmp_target
> %libc:longjmp
> %libc:lll_lock_wait_private
> %libc:lll_futex_wake
> %libc:longjmp_target
> %libc:longjmp
> %libc:setjmp
> 
> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>

Looks good to me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> ---
>  tools/perf/builtin-sdt-cache.c |   26 +++++++++++++++++++++-
>  tools/perf/util/parse-events.h |    1 +
>  tools/perf/util/sdt.c          |   47 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 73 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-sdt-cache.c b/tools/perf/builtin-sdt-cache.c
> index 3754896..5faf8e5 100644
> --- a/tools/perf/builtin-sdt-cache.c
> +++ b/tools/perf/builtin-sdt-cache.c
> @@ -16,6 +16,7 @@
>  /* Session management structure */
>  static struct {
>  	bool add;
> +	bool dump;
>  	const char *target;
>  } params;
>  
> @@ -28,6 +29,15 @@ static int opt_add_sdt_events(const struct option *opt __maybe_unused,
>  	return 0;
>  }
>  
> +static int opt_show_sdt_events(const struct option *opt __maybe_unused,
> +			       const char *str, int unset __maybe_unused)
> +{
> +	if (str)
> +		pr_err("Unknown option %s\n", str);
> +	params.dump = true;
> +	return 0;
> +}
> +
>  int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	int ret;
> @@ -35,10 +45,13 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
>  		OPT_CALLBACK('a', "add", NULL, "filename",
>  			     "add SDT events from a file.",
>  			     opt_add_sdt_events),
> +		OPT_CALLBACK_NOOPT('s', "dump", NULL, "show SDT events",
> +				   "Read SDT events from cache and display.",
> +				   opt_show_sdt_events),
>  		OPT_END()
>  	};
>  	const char * const sdt_cache_usage[] = {
> -		"perf sdt_cache --add filename",
> +		"perf sdt_cache [--add filename | --dump]",
>  		NULL
>  	};
>  
> @@ -50,9 +63,20 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
>  
>  	symbol__elf_init();
>  	if (params.add) {
> +		if (params.dump) {
> +			pr_err("Error: Don't use --dump with --add\n");
> +			usage_with_options(sdt_cache_usage, sdt_cache_options);
> +		}
>  		ret = add_sdt_events(params.target);
>  		if (ret < 0)
>  			pr_err("Cannot add SDT events to cache!\n");
> +	} else if (params.dump) {
> +		if (argc == 0) {
> +			ret = dump_sdt_events();
> +			if (ret < 0)
> +				pr_err("Cannot dump SDT event cache!\n");
> +		} else
> +			usage_with_options(sdt_cache_usage, sdt_cache_options);
>  	} else
>  		usage_with_options(sdt_cache_usage, sdt_cache_options);
>  	return 0;
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index e6efe2c..f43e6aa 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -110,5 +110,6 @@ extern int is_valid_tracepoint(const char *event_string);
>  extern int valid_debugfs_mount(const char *debugfs);
>  
>  int add_sdt_events(const char *file);
> +int dump_sdt_events(void);
>  
>  #endif /* __PERF_PARSE_EVENTS_H */
> diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
> index 9a39d36..f2c7dc0 100644
> --- a/tools/perf/util/sdt.c
> +++ b/tools/perf/util/sdt.c
> @@ -664,3 +664,50 @@ int add_sdt_events(const char *arg)
>  	}
>  	return ret;
>  }
> +
> +/**
> + * file_hash_list__display: Dump the entries of file_hash list
> + * @file_hash: file hash list
> + *
> + * Iterate through each of the entries and the chains and dump
> + * onto stdscr.
> + */
> +static void file_hash_list__display(struct hash_list *file_hash)
> +{
> +	struct file_sdt_ent *file_pos;
> +	struct list_head *ent_head, *sdt_head;
> +	struct sdt_note *sdt_pos;
> +	int i;
> +
> +	for (i = 0; i < HASH_TABLE_SIZE; i++) {
> +		/* Get the list_head for this entry */
> +		ent_head = &file_hash->ent[i].list;
> +		/* No entries ?*/
> +		if (list_empty(ent_head))
> +			continue;
> +
> +		/* Iterate through the chain in this entry */
> +		list_for_each_entry(file_pos, ent_head, file_list) {
> +			printf("%s :\n", file_pos->name);
> +			/* Get he SDT events' head */
> +			sdt_head = &file_pos->sdt_list;
> +			list_for_each_entry(sdt_pos, sdt_head, note_list) {
> +				printf("\t%%%s:%s\n", sdt_pos->provider,
> +				       sdt_pos->name);
> +			}
> +			printf("\n");
> +		}
> +	}
> +}
> +
> +/**
> + * dump_sdt_events: Dump the SDT events on stdout
> + */
> +int dump_sdt_events(void)
> +{
> +	struct hash_list file_hash;
> +
> +	file_hash_list__init(&file_hash);
> +	file_hash_list__display(&file_hash);
> +	return 0;
> +}
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


