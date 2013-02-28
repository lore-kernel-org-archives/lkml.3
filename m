Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab3B1QfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:35:09 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48076 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab3B1QfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:35:03 -0500
Message-ID: <512F8732.9090005@gmail.com>
Date: Thu, 28 Feb 2013 09:34:58 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: chenggang <chenggang.qin@gmail.com>
CC: linux-kernel@vger.kernel.org, chenggang <chenggang.qcg@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/4] Transform mmap and other related structures to
 list with new xyarray
References: <1361871710-6251-1-git-send-email-chenggang.qin@gmail.com> <1361871710-6251-2-git-send-email-chenggang.qin@gmail.com>
In-Reply-To: <1361871710-6251-2-git-send-email-chenggang.qin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/13 2:41 AM, chenggang wrote:
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 774c907..13112c6 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -31,6 +31,8 @@
>   #include <sched.h>
>   #include <sys/mman.h>
>
> +#define MMAP(e, y) (*(struct perf_mmap *)xyarray__entry(e->mmap, 0, y))
> +

That is ugly to have in perf commands. It would be better to hide such 
details within evlist.c. e.g.

struct perf_mmap *perf_evlist__get_mmap(struct perf_evlist *evlist, int i)

>   #ifndef HAVE_ON_EXIT
>   #ifndef ATEXIT_MAX
>   #define ATEXIT_MAX 32
> @@ -367,8 +369,8 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
>   	int rc = 0;
>
>   	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
> -		if (rec->evlist->mmap[i].base) {
> -			if (perf_record__mmap_read(rec, &rec->evlist->mmap[i]) != 0) {
> +		if (MMAP(rec->evlist, i).base) {
> +			if (perf_record__mmap_read(rec, &MMAP(rec->evlist, i)) != 0) {
>   				rc = -1;
>   				goto out;
>   			}

and then here get the mmap, if base is set call the read function.

However, changing the mmaps from an indexed array to a linked list is 
going to have a cost with loops like this one - especially as the number 
of events goes up (e.g., perf record -e kvm:*). Might be better to walk 
the mmap list and call mmap_read for each.

---8<---

> +/*
> + * If threads->nr > 1, the cpu_map__nr() must be 1.
> + * If the cpu_map__nr() > 1, we should not append pollfd.
> + */
> +static int perf_evlist__append_pollfd_thread(struct perf_evlist *evlist)
> +{
> +	int new_nfds;
> +
> +	if (cpu_map__all(evlist->cpus)) {
> +		struct pollfd *pfd;
> +
> +		new_nfds = evlist->threads->nr * evlist->nr_entries;
> +		pfd = zalloc(sizeof(struct pollfd) * new_nfds);
> +
> +		if (!pfd)
> +			return -1;
> +
> +		memcpy(pfd, evlist->pollfd, (evlist->threads->nr - 1) * evlist->nr_entries);
> +
> +		evlist->pollfd = pfd;
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
>   static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
>   {
>   	int nfds = cpu_map__nr(evlist->cpus) * evlist->threads->nr * evlist->nr_entries;
> @@ -288,7 +316,7 @@ void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
>   			 int cpu, int thread, u64 id)
>   {
>   	perf_evlist__id_hash(evlist, evsel, cpu, thread, id);
> -	evsel->id[evsel->ids++] = id;
> +	ID(evsel, evsel->ids++) = id;
>   }

The pollfd changes should be a separate patch (should be possible; seems 
independent of the mmap change).

>
>   static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
> @@ -336,7 +364,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
>
>   union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
>   {
> -	struct perf_mmap *md = &evlist->mmap[idx];
> +	struct perf_mmap *md = &MMAP(evlist, idx);
>   	unsigned int head = perf_mmap__read_head(md);
>   	unsigned int old = md->prev;
>   	unsigned char *data = md->base + page_size;
> @@ -404,9 +432,9 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
>   	int i;
>
>   	for (i = 0; i < evlist->nr_mmaps; i++) {
> -		if (evlist->mmap[i].base != NULL) {
> -			munmap(evlist->mmap[i].base, evlist->mmap_len);
> -			evlist->mmap[i].base = NULL;
> +		if (MMAP(evlist, i).base != NULL) {
> +			munmap(MMAP(evlist, i).base, evlist->mmap_len);
> +			MMAP(evlist, i).base = NULL;
>   		}
>   	}

same comment here -- walk the mmap list rather than index looping. 
Changing evlist as threads come and go will have implications on 
multi-threaded users.


---8<---

> +int perf_evlist__mmap_thread(struct perf_evlist *evlist, bool overwrite, int tidx)
> +{
> +	struct perf_evsel *evsel;
> +	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
> +	int mask = evlist->mmap_len - page_size - 1;
> +	int output = -1;
> +	struct pollfd *old_pollfd = evlist->pollfd;
> +
> +	if (!cpu_map__all(evlist->cpus))
> +		return 1;
> +
> +	if (perf_evlist__append_mmap_thread(evlist) < 0)
> +		return -ENOMEM;
> +
> +	if (perf_evlist__append_pollfd_thread(evlist) < 0)
> +		goto free_append_mmap;
> +
> +	list_for_each_entry(evsel, &evlist->entries, node)
> +		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
> +		    evsel->sample_id == NULL)
> +			if (perf_evsel__append_id_thread(evsel, tidx) < 0)
> +				goto free_append_pollfd;

braces


---8<---

> +void perf_evsel__close_thread(struct perf_evsel *evsel, int cpu_nr, int tidx)
> +{
> +	int cpu;
> +
> +	for (cpu = 0; cpu < cpu_nr; cpu++)
> +		if (FD(evsel, cpu, tidx) >= 0)
> +			close(FD(evsel, cpu, tidx));

braces

---8<---
			\
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index f4bfd79..51a52d4 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -25,6 +25,8 @@
>   #include "strbuf.h"
>   #include "build-id.h"
>
> +#define ID(e, y) (*(u64 *)xyarray__entry(e->id, 0, y))

again here, really do not want that outside of the evlist.c/evsel.c files

> +
>   static bool no_buildid_cache = false;
>
>   static int trace_event_count;
> @@ -1260,7 +1262,6 @@ static struct perf_evsel *
>   read_event_desc(struct perf_header *ph, int fd)
>   {
>   	struct perf_evsel *evsel, *events = NULL;
> -	u64 *id;
>   	void *buf = NULL;
>   	u32 nre, sz, nr, i, j;
>   	ssize_t ret;
> @@ -1325,19 +1326,17 @@ read_event_desc(struct perf_header *ph, int fd)
>   		if (!nr)
>   			continue;
>
> -		id = calloc(nr, sizeof(*id));
> -		if (!id)
> -			goto error;
>   		evsel->ids = nr;
> -		evsel->id = id;
> +		evsel->id = xyarray__new(1, nr, sizeof(u64));
> +		if (!evsel->id)
> +			goto error;

perf_evsel__id_new()?

>
>   		for (j = 0 ; j < nr; j++) {
> -			ret = readn(fd, id, sizeof(*id));
> -			if (ret != (ssize_t)sizeof(*id))
> +			ret = readn(fd, &ID(evsel, j), sizeof(u64));

perf_evsel__get_id()?

Also, think about how to break up the patches into smaller change sets.

David
