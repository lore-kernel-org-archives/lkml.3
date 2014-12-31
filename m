Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaLaOxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 09:53:55 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:65220 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaLaOxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 09:53:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141231120112.GD1256@krava.brq.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-9-git-send-email-namhyung@kernel.org> <20141231120112.GD1256@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 31 Dec 2014 23:53:33 +0900
X-Google-Sender-Auth: Mzevnwf4X7h1MbYEZteNtE5ZK9w
Message-ID: <CAM9d7cimRFYWp2-jqQCZXo0FjDnF-an1wuK+Y64431PfgVnxMw@mail.gmail.com>
Subject: Re: [PATCH 08/37] perf tools: Handle multi-file session properly
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, Dec 31, 2014 at 9:01 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Dec 24, 2014 at 04:15:04PM +0900, Namhyung Kim wrote:
>> When perf detects multi-file data directory, process header file first
>> and then rest data files in a row.  Note that the multi-file data is
>> recorded for each cpu/thread separately, it's already ordered with
>> respect to themselves so no need to use the ordered event queue
>> interface.

[SNIP]
>> @@ -1362,18 +1361,40 @@ int perf_session__process_events(struct perf_session *session,
>>                                struct perf_tool *tool)
>>  {
>>       u64 size = perf_data_file__size(session->file);
>> -     int err;
>> +     int err, i;
>>
>>       if (perf_session__register_idle_thread(session) == NULL)
>>               return -ENOMEM;
>>
>> -     if (!perf_data_file__is_pipe(session->file))
>> -             err = __perf_session__process_events(session,
>> -                                                  session->header.data_offset,
>> -                                                  session->header.data_size,
>> -                                                  size, tool);
>> -     else
>> -             err = __perf_session__process_pipe_events(session, tool);
>> +     if (perf_data_file__is_pipe(session->file))
>> +             return __perf_session__process_pipe_events(session, tool);
>> +
>> +     err = __perf_session__process_events(session,
>> +                                          perf_data_file__fd(session->file),
>> +                                          session->header.data_offset,
>> +                                          session->header.data_size,
>> +                                          size, tool);
>> +     if (!session->file->is_multi || err)
>> +             return err;
>
> if we have file->is_multi true, the perf_data_file__fd(session->file)
> is the perf.header file right? So presumably, there's no data in it,
> and we dont need to call above __perf_session__process_events function?

Right, it's for perf.header file and has no samples but it has meta
events like fork, comm, mmap so it needs to be processed (before
processing samples).

Thanks,
Namhyung


>
>> +
>> +     /*
>> +      * For multi-file data storage, events are processed for each
>> +      * cpu/thread so it's already ordered.
>> +      */
>> +     tool->ordered_events = false;
>> +
>> +     for (i = 0; i < session->file->nr_multi; i++) {
>> +             int fd = perf_data_file__multi_fd(session->file, i);
>> +
>> +             size = lseek(fd, 0, SEEK_END);
>> +             if (size == 0)
>> +                     continue;
>> +
>> +             err = __perf_session__process_events(session, fd,
>> +                                                  0, size, size, tool);
>> +             if (err < 0)
>> +                     break;
>> +     }
>>
>>       return err;
>>  }
>> --
>> 2.1.3
>>
