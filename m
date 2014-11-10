Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaKJGNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:13:55 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34160 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaKJGNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:13:54 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 14/18] perf tools: Make vmlinux short name more like kallsyms short name
References: <1415307879-912-1-git-send-email-acme@kernel.org>
	<1415307879-912-15-git-send-email-acme@kernel.org>
	<20141109075126.GB3366@krava.redhat.com>
Date: Mon, 10 Nov 2014 15:13:46 +0900
In-Reply-To: <20141109075126.GB3366@krava.redhat.com> (Jiri Olsa's message of
	"Sun, 9 Nov 2014 08:51:26 +0100")
Message-ID: <87r3xbvazp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sun, 9 Nov 2014 08:51:26 +0100, Jiri Olsa wrote:
> On Thu, Nov 06, 2014 at 06:04:35PM -0300, Arnaldo Carvalho de Melo wrote:
>> From: Namhyung Kim <namhyung@kernel.org>
>> 
>> The previous patch changed kernel dso name from '[kernel.kallsyms]' to
>> vmlinux.  However it might add confusion to old users accustomed to the
>> old name.  So change the short name to '[kernel.vmlinux]' to reduce such
>> confusion.
>> 
>
> SNIP
>
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>> ---
>>  tools/perf/util/machine.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
>> index 53f90e9c65fe..52e94902afb1 100644
>> --- a/tools/perf/util/machine.c
>> +++ b/tools/perf/util/machine.c
>> @@ -1106,6 +1106,9 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
>>  		if (__machine__create_kernel_maps(machine, kernel) < 0)
>>  			goto out_problem;
>>  
>> +		if (strstr(dso->long_name, "vmlinux"))
>> +			dso__set_short_name(dso, "[kernel.vmlinux]", false);
>> +
>
> heya,
> I've got attached segfault in perf script because of this,
> if I revert it's ok..

Oops, sorry.  It seems somehow to fail to find a matching kernel dso
from the build-id table..  anyway we need to access 'kernel' instead of
'dso' since it might be invalid at this time.

Could you please check below patch?


>From e28ec815465721b81669c47eb00d8307f4b424cd Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 10 Nov 2014 15:05:26 +0900
Subject: [PATCH] perf tools: Fix segfault due to invalid kernel dso access

When processing kernel mmap event, it should access the 'kernel'
variable as sometimes it cannot find a matching dso from build-id
table so 'dso' might be invalid.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/machine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 52e94902afb1..85033d80fd6a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1106,8 +1106,8 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		if (__machine__create_kernel_maps(machine, kernel) < 0)
 			goto out_problem;
 
-		if (strstr(dso->long_name, "vmlinux"))
-			dso__set_short_name(dso, "[kernel.vmlinux]", false);
+		if (strstr(kernel->long_name, "vmlinux"))
+			dso__set_short_name(kernel, "[kernel.vmlinux]", false);
 
 		machine__set_kernel_mmap_len(machine, event);
 
-- 
2.1.2

