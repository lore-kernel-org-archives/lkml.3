Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3J1J6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:58:04 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61143 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3J1J6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <20131026174426.GD1069@krava.brq.redhat.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
	<1382533085-7166-2-git-send-email-eranian@google.com>
	<20131025145625.GB1196@krava.brq.redhat.com>
	<CABPqkBTHnRXwKVJucKRuPA1cLzKur2dbkKu_PS5sQKK2XjovnQ@mail.gmail.com>
	<20131026174426.GD1069@krava.brq.redhat.com>
Date: Mon, 28 Oct 2013 10:58:01 +0100
Message-ID: <CABPqkBSmjOq75mwJimj95XpTqE3BZh6=JzSM0D50z=gTMvh_6w@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] perf: add active_entry list head to struct perf_event
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 7:44 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Sat, Oct 26, 2013 at 06:57:37PM +0200, Stephane Eranian wrote:
>> On Fri, Oct 25, 2013 at 4:56 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> >
>> > On Wed, Oct 23, 2013 at 02:58:02PM +0200, Stephane Eranian wrote:
>> > > This patch adds a new fields to the struct perf_event.
>> > > It is intended to be used to chain events which are
>> > > active (enabled). It helps in the hardware layer
>> > > for PMU which do not have actual counter restrictions, i.e.,
>> > > free running read-only counters. Active events are chained
>> > > as opposed to being tracked via the counter they use.
>> > >
>> > > Signed-off-by: Stephane Eranian <eranian@google.com>
>> > > ---
>> > >  include/linux/perf_event.h |    1 +
>> > >  kernel/events/core.c       |    1 +
>> > >  2 files changed, 2 insertions(+)
>> > >
>> > > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> > > index 2e069d1..a376384 100644
>> > > --- a/include/linux/perf_event.h
>> > > +++ b/include/linux/perf_event.h
>> > > @@ -435,6 +435,7 @@ struct perf_event {
>> > >       struct perf_cgroup              *cgrp; /* cgroup event is attach to */
>> > >       int                             cgrp_defer_enabled;
>> > >  #endif
>> > > +     struct list_head                active_entry;
>> >
>> > Could this be in union with 'hlist_entry' ? It looks
>> > as 'same purpose' and 'mutualy exclusive stuff.
>> >
>> You're saying that I could use the hlist_entry field because
>> it is currently only used by the sw events in the generic layer.
>> But it seems to be a complicated rcu list for the purpose here.
>
> nope, I just meant saving little space like:
>
> union {
>         struct list_head                active_entry;
>         struct hlist_node               hlist_entry;
> }
>
> just a nitpick
>
But you are relying on the fact that active_entry and hlist_entry can never be
used at the same time. You're saying this because *so far* hlist_entry is
only used for SW events and what I added is  only used by RAPL.

If the goal is the same, then we should add a better description for the field:
"chain the event in the list of active events for a PMU instance on a CPU".
Handled by PMU specific code only (not generic code).
