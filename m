Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3AJVx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 16:53:28 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:57843 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3AJVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 16:53:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130109165539.GB1045@krava.brq.redhat.com>
References: <1357583277-4553-1-git-send-email-eranian@google.com>
	<1357583277-4553-12-git-send-email-eranian@google.com>
	<20130109165539.GB1045@krava.brq.redhat.com>
Date: Thu, 10 Jan 2013 22:53:26 +0100
Message-ID: <CABPqkBTTE=36vjMuXjiPojAYsTQfYzSk7=3Jo2WC4ryh7+gpaQ@mail.gmail.com>
Subject: Re: [PATCH v5 11/18] perf tools: add mem access sampling core support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 5:55 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Jan 07, 2013 at 07:27:50PM +0100, Stephane Eranian wrote:
>
> SNIP
>
>>
>> +static void ip__resolve_data(struct machine *self, struct thread *thread,
>> +                          u8 m,
>> +                         struct addr_map_symbol *ams,
>> +                         u64 addr)
>> +{
>> +     struct addr_location al;
>> +
>> +     memset(&al, 0, sizeof(al));
>> +
>> +     thread__find_addr_location(thread, self, m, MAP__VARIABLE, addr, &al,
>> +                                NULL);
>> +     ams->addr = addr;
>> +     ams->al_addr = al.addr;
>> +     ams->sym = al.sym;
>> +     ams->map = al.map;
>> +}
>> +
>> +struct mem_info *machine__resolve_mem(struct machine *self,
>> +                                   struct thread *thr,
>> +                                   struct perf_sample *sample,
>> +                                   u8 cpumode)
>> +{
>> +     struct mem_info *mi;
>> +
>> +     mi = calloc(1, sizeof(struct mem_info));
>> +     if (!mi)
>> +             return NULL;
>> +
>> +     ip__resolve_ams(self, thr, &mi->iaddr, sample->ip);
>> +     ip__resolve_data(self, thr, cpumode, &mi->daddr, sample->addr);
>> +     mi->cost = sample->weight;
>> +     mi->dsrc.val = sample->dsrc;
>> +
>> +     return mi;
>> +}
>> +
>
> The crash I report is due to the some maps could be removed
> via map_groups__fixup_overlappings.
>
> Attached patch makes the code working for me, but we might
> want to have some global unified fix for that, since this
> is not the only place suffering for that.
>
> Like globaly set map->referenced in add_hist_entry or
> hist_entry__new functions..
>
>
Would something like that work for you (untested)?

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7034500..fc05b9f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -274,6 +274,12 @@ static struct hist_entry *hist_entry__new(struct
hist_entry *template)

                if (he->ms.map)
                        he->ms.map->referenced = true;
+               if (he->mem_info) {
+                       if (he->mem_info->iaddr.map)
+                               he->mem_info->iaddr.map->referenced = true;
+                       if (he->mem_info->daddr.map)
+                               he->mem_info->daddr.map->referenced = true;
+               }
                if (symbol_conf.use_callchain)
                        callchain_init(he->callchain);
