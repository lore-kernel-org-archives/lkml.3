Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3JBAyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:54:47 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49512 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3JBAyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:54:44 -0400
X-AuditID: 9c930197-b7b7aae000005bd9-07-524b6ed063b5
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Support for Openembedded/Yocto -dbg packages
References: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
	<20130918092444.GA2778@gmail.com>
	<CAPybu_2GBymhgxHmtJu63pT2t8ge84EA9Ww54r9mGOA5KH7Hww@mail.gmail.com>
	<CAPybu_2Wf_p-jo2X4VzSBXrfy3DnHY4PeOvNVLfeoGRFfbDwRA@mail.gmail.com>
	<20130918101801.GO12926@twins.programming.kicks-ass.net>
	<20130918130735.GC2240@ghostprotocols.net>
	<20130918132903.GA4071@gmail.com>
Date: Wed, 02 Oct 2013 09:54:40 +0900
In-Reply-To: <20130918132903.GA4071@gmail.com> (Ingo Molnar's message of "Wed,
	18 Sep 2013 15:29:03 +0200")
Message-ID: <87had0o5kf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Arnaldo,

On Wed, 18 Sep 2013 15:29:03 +0200, Ingo Molnar wrote:
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
>
>> Em Wed, Sep 18, 2013 at 12:18:01PM +0200, Peter Zijlstra escreveu:
>> > On Wed, Sep 18, 2013 at 12:02:12PM +0200, Ricardo Ribalda Delgado wrote:
>> > > Perhaps this is even more clear than v2:
>> 
>> > > len = snprintf(file, size, "%s", symbol_conf.symfs);
>> > > size -= len;
>> > > file += len;
>> > > len = snprintf(file, MIN(size,(last_slash - dso->long_name) + 2),
>> > > "%s",  dso->long_name);
>> > > size -= len;
>> > > file += len;
>> > > len = snprintf(file, size, ".debug%s",  last_slash);
>> 
>> > len = 0;
>> 
>> > len += snprintf(str + len, size - len, ...);
>> > len += snprintf(str + len, size - len, ...);
>> 
>> And avoid snprintf like the plague, use scnprintf instead...  See
>> e7f01d1e3d8d501deb8abeaa269d5d48a703b8b0 for details :-)
>
> Hm, could we do:
>
> 	#define snprintf scnprintf
>
> or:
>
> 	#define snprintf(x...) BUILD_BUG()
>
> ?
>
> I don't think there's any valid code, except printf wrappers (which we 
> don't have in perf), where the semantics of snprintf() would be needed.

There are some places that use snprintf() to query the actual length:

tools/perf/util/srcline.c:245:	size = snprintf(NULL, 0, "%s:%u", file, line) + 1;
tools/perf/util/values.c:147:		width = snprintf(NULL, 0, "%d", values->pid[i]);
tools/perf/util/values.c:150:		width = snprintf(NULL, 0, "%d", values->tid[i]);
tools/perf/util/values.c:154:			width = snprintf(NULL, 0, "%" PRIu64, values->value[i][j]);
tools/perf/util/values.c:189:		width = snprintf(NULL, 0, "%d", values->pid[i]);
tools/perf/util/values.c:192:		width = snprintf(NULL, 0, "%d", values->tid[i]);
tools/perf/util/values.c:200:		width = snprintf(NULL, 0, "%" PRIx64, values->counterrawid[j]);
tools/perf/util/values.c:206:			width = snprintf(NULL, 0, "%" PRIu64, values->value[i][j]);


Thanks,
Namhyung
