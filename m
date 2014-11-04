Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaKDHiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:38:12 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46456 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaKDHiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:38:09 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v4 5/5] perf/sdt: Add support to perf record to trace SDT events
References: <20141102105006.21708.28734.stgit@hemant-fedora>
	<20141102105557.21708.19032.stgit@hemant-fedora>
Date: Tue, 04 Nov 2014 16:38:06 +0900
In-Reply-To: <20141102105557.21708.19032.stgit@hemant-fedora> (Hemant Kumar's
	message of "Sun, 02 Nov 2014 16:26:28 +0530")
Message-ID: <87lhnr5sbl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

As you know, you need to keep an eye on how (kprobes) event cache
patchset from Masami settles down.  For those who aren't CC'ed, please
see the link below:

  https://lkml.org/lkml/2014/10/31/207


On Sun, 02 Nov 2014 16:26:28 +0530, Hemant Kumar wrote:
> This patch adds support to perf to record SDT events. When invoked,
> the SDT event is looked up in the sdt-cache. If its found, an entry is
> made silently to uprobe_events file and then recording is invoked, and
> then the entry for the SDT event in uprobe_events is silently discarded.
>
> The SDT events are already stored in a cache file
> (/var/cache/perf/perf-sdt-file.cache).
> Although the file_hash table helps in addition or deletion of SDT events
> from the cache, its not of much use when it comes to probing the actual
> SDT event, because the key to this hash list is a file name and not the
> SDT event name (which is given as an argument to perf record). So, we
> won't be able to hash into it.

It likely to be ended up with per-file or per-buildid cache files under
~/.debug directory.  In this case we also need to have the (central)
event-to-cache table anyway IMHO.


>
> To avoid this problem, we can create another hash list "event_hash" list
> which will be maintained along with the file_hash list.
> Whenever a user invokes 'perf record -e %provider:event, perf should
> initialize the event_hash list and the file_hash list.
> The key to event_hash list is calculated from the event name and its
> provider name.

Isn't it enough just to use provide name?  I guess the provider names
are (should be?) unique among a system although there's no absolute
guarantee for that.


>
>             event_hash       sdt_note
>             |---------|   ----------------
>             |         |   |   file_ptr   |==> container file_sdt_ent
> key = 129 =>| hlist ==|===|=> event_list=|==> to sdt notes hashed to
>        	    |         |   |   name       |    same entry
>             |---------|   |   provider   |
>             |	      |   |   note_list==|==> to other notes in the
> key = 130 =>| hlist   |   ---------------     same file
>             |---------|
>
> The entry at that key in event_hash contains a list of SDT notes hashed to
> the same entry. It compares the name and provider to see if that is the SDT
> note we are looking for. If yes, find out the file that contains this SDT
> note. There is a file_ptr pointer embedded in this note which points to the
> struct file_sdt_ent contained in the file_hash. From "file_sdt_ent" we will
> find out the file name.
> Convert this sdt note into a perf event and then write this into
> uprobe_events file to be able to record the event.
> Then, corresponding entries are added to uprobe_events file for
> the SDT events.
> After recording is done, these events are silently deleted from uprobe_events
> file. The uprobe_events file is present in debugfs/tracing directory.
>
> To support the addition and deletion of SDT events to/from uprobe_events
> file, a record_sdt struct is maintained which has the event data.
>
> An example usage:
>
> # perf record -e %libc:setjmp -aR sleep 10
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.277 MB perf.data (~12103 samples) ]
>
> # perf report --stdio
> # To display the perf.data header info, please use --header/--header-only
> #
> # Samples: 1  of event 'libc:setjmp'
> # Event count (approx.): 1
> #
> # Overhead  Command  Shared Object  Symbol
> # ........  .......  .............  ...............
> #
>    100.00%  sleep    libc-2.16.so   [.] __sigsetjmp
>
>
> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>


[SNIP]
> +/* Session specific to SDT tracing */
> +struct record_sdt {
> +	bool    sdt;    /* is this SDT event tracing? */
> +	char    *str;   /* hold the event name */
> +} rec_sdt;
> +
> +int trace_sdt_event(const char *str)
> +{
> +	int ret = 0;
> +
> +	rec_sdt.sdt = true;
> +	rec_sdt.str = strdup(str);
> +	if (!rec_sdt.str)
> +		return -ENOMEM;
> +	ret = event_hash_list__lookup(str);
> +	return ret;
> +}

Hmm.. does it support multiple SDT events recorded in a session like:

  # perf record -e %libc:setjmp -e %libc:longjmp -aR sleep 10

?


[SNIP]
> +/* Parse an SDT event */
> +static int parse_perf_sdt_event(struct perf_sdt_event *sev,
> +				struct perf_probe_event *pev)
> +{
> +	struct perf_probe_point *pp = &pev->point;
> +
> +	pev->uprobes = true;
> +	pev->sdt = true;
> +	pev->event = strdup(sev->note->name);
> +	if (pev->event == NULL)
> +		return -ENOMEM;
> +	pev->group = strdup(sev->note->provider);
> +	if (pev->event == NULL)

s/event/group/

> +		return -ENOMEM;
> +
> +	pp->file = strdup(sev->file_name);
> +	if (pp->file == NULL)
> +		return -ENOMEM;
> +
> +	pp->function = strdup(sev->note->name);

Missing NULL check.  Also you need to free prior allocations in case of
error.

Thanks,
Namhyung


> +	pp->offset = sev->note->addr.a64[0];
> +	return 0;
> +}
