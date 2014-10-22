Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaJVEsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 00:48:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:36098 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaJVEsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 00:48:37 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v3 3/5] perf/sdt: Show SDT cache contents
References: <20141010104402.15506.73285.stgit@hemant-fedora>
	<20141010105830.15506.69597.stgit@hemant-fedora>
Date: Wed, 22 Oct 2014 13:48:35 +0900
In-Reply-To: <20141010105830.15506.69597.stgit@hemant-fedora> (Hemant Kumar's
	message of "Fri, 10 Oct 2014 16:28:43 +0530")
Message-ID: <871tq0g15o.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014 16:28:43 +0530, Hemant Kumar wrote:
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

Hmm.. it seems the output is prefixed with '\t' in the code..


[SNIP]

> @@ -35,10 +45,14 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
>  		OPT_CALLBACK('a', "add", NULL, "filename",
>  			     "add SDT events from a file.",
>  			     opt_add_sdt_events),
> +		OPT_CALLBACK_NOOPT('D', "dump", NULL, "show SDT events",
> +				   "Read SDT events from cache and display.",
> +				   opt_show_sdt_events),
>  		OPT_END()
>  	};
>  	const char * const sdt_cache_usage[] = {
>  		"perf sdt-cache --add filename",
> +		"perf sd-cache --dump",

s/sd-cache/sdt-cache/


>  		NULL
>  	};

[SNIP]
> +static void file_hash_list__display(struct hash_table *file_hash)
> +{
> +	struct file_sdt_ent *file_pos;
> +	struct list_head *sdt_head;
> +	struct hlist_head *ent_head;
> +	struct sdt_note *sdt_ptr;
> +	int i;
> +
> +	/* Go through all entries */
> +	for (i = 0; i < SDT_HASH_SIZE; i++) {
> +		/* Obtain the list head */
> +		ent_head = &file_hash->ent[i];
> +
> +		/* ':' are used here as delimiters */
> +		hlist_for_each_entry(file_pos, ent_head, file_list) {
> +			fprintf(stdout, "%s:\n", file_pos->name);
> +			sdt_head = &file_pos->sdt_list;
> +			list_for_each_entry(sdt_ptr, sdt_head, note_list) {
> +				fprintf(stdout, "\t%%%s:%s\n",
> +					sdt_ptr->provider, sdt_ptr->name);

.. Here you printed it with \t.

Other than that, looks good to me.

Thanks,
Namhyung


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
> +	struct hash_table file_hash;
> +	int ret;
> +
> +	ret = file_hash_list__init(&file_hash);
> +	if (!ret)
> +		file_hash_list__display(&file_hash);
> +	file_hash_list__cleanup(&file_hash);
> +	return ret;
> +}
