Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaIWMts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:49:48 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:56808 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaIWMtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:49:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140923122437.GE2979@krava.brq.redhat.com>
References: <1411453828-14832-1-git-send-email-namhyung@kernel.org> <20140923122437.GE2979@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 23 Sep 2014 21:49:22 +0900
X-Google-Sender-Auth: RASQM4JICPK4JvZnyS3rfBlPnNw
Message-ID: <CAM9d7cjY9HwRSKJvuUfbQPmi6se1H7+vONGxDTBdv=xNR-EOUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf callchain: Create an address space per thread
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>, Arun Sharma <asharma@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Sep 23, 2014 at 9:24 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Sep 23, 2014 at 03:30:27PM +0900, Namhyung Kim wrote:
>> The unw_addr_space_t in libunwind represents an address space to be
>> used for stack unwinding.  It doesn't need to be create/destory
>> everytime to unwind callchain (as in get_entries) and can have a same
>> lifetime as thread (unless exec called).
>>
>> So move the address space construction/destruction logic to the thread
>> lifetime handling functions.  This is a preparation to enable caching
>> in the unwind library.
>>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Jean Pihet <jean.pihet@linaro.org>
>> Cc: Arun Sharma <asharma@fb.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/util/thread.c           |  8 ++++++++
>>  tools/perf/util/unwind-libunwind.c | 30 +++++++++++++++++++++++++-----
>>  tools/perf/util/unwind.h           | 17 +++++++++++++++++
>>  3 files changed, 50 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
>> index a9df7f2c6dc9..c1fa4a3597ea 100644
>> --- a/tools/perf/util/thread.c
>> +++ b/tools/perf/util/thread.c
>> @@ -7,6 +7,7 @@
>>  #include "util.h"
>>  #include "debug.h"
>>  #include "comm.h"
>> +#include "unwind.h"
>>
>>  int thread__init_map_groups(struct thread *thread, struct machine *machine)
>>  {
>> @@ -48,6 +49,12 @@ struct thread *thread__new(pid_t pid, pid_t tid)
>>                       goto err_thread;
>>
>>               list_add(&comm->list, &thread->comm_list);
>> +
>> +             if (unwind__prepare_access(thread) < 0) {
>
> you could call list_add below this call and thus save
> the list_del call below in error path
>
> looks like you dont need comm to be on comm_list within
> the unwind__prepare_access call

Right.  Will change.

Thanks,
Namhyung


>
>> +                     list_del(&comm->list);
>> +                     free(comm);
>> +                     goto err_thread;
>> +             }
>>       }
>
> SNIP
>
> jirka
