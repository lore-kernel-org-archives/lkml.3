Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3EHNsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:48:43 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59565 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3EHNsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:48:42 -0400
Message-ID: <518A57B5.2040605@gmail.com>
Date: Wed, 08 May 2013 07:48:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf record: handle death by SIGTERM
References: <1367864663-1309-1-git-send-email-dsahern@gmail.com> <CABPqkBTj6Jt82mvVJKJxXaGnbD5GbW5mo4L71StOZuA=8MwDdw@mail.gmail.com> <20130507062947.GB17705@gmail.com> <51896A71.8010007@gmail.com> <20130508065447.GB5378@gmail.com>
In-Reply-To: <20130508065447.GB5378@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/13 12:54 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> On 5/7/13 12:29 AM, Ingo Molnar wrote:
>>>
>>> * Stephane Eranian <eranian@google.com> wrote:
>>>
>>>> This is a good fix. I have run into this infinite loop in perf report
>>>> many times.
>>>
>>> Hm, perf record should really not assume much about the perf.data and
>>> should avoid infinite loops ...
>>>
>>> So while making perf.data more consistent on SIGTERM is a nice fix, perf
>>> report should be fixed as well to detect loops and such.
>>>
>>> Thanks,
>>>
>>> 	Ingo
>>>
>>
>> This seems to do the trick:
>>
>> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
>> index 326068a..e82646f 100644
>> --- a/tools/perf/util/header.c
>> +++ b/tools/perf/util/header.c
>> @@ -2802,6 +2802,17 @@ int perf_session__read_header(struct
>> perf_session *session, int fd)
>>      if (perf_file_header__read(&f_header, header, fd) < 0)
>>          return -EINVAL;
>>
>> +   /*
>> +    * sanity check that perf.data was written cleanly: data size
>> +    * is initialized to 0 and updated only if the on_exit function
>> +    * is run. If data size is still 0 then the file cannot be
>> +    * processed.
>> +    */
>> +   if (f_header.data.size == 0) {
>> +       pr_err("data size is 0. Was record properly terminated?\n");
>> +       return -1;
>> +   }
>
> Hm, this detects the condition - but where does the looping come from?
>
> Can it happen with a perf.data that 'seems' clean but is corrupted
> (because not fully written, buggy kernel just crashed, etc.).
>
> In essence it would be _very_ nice if someone reproduced the looping and
> checked what to do to fix the looping itself. Or does the above
> data.size == 0 check fully fix the looping under every possible state of a
> perf.data?

I think so. If you want the dirty details here you go.

The looping is in __perf_session__process_events. When the data file is 
not closed properly data_size is 0 and n my case data_offset is 288. 
Dropping into this function:

     page_offset = page_size * (data_offset / page_size);
     file_offset = page_offset;
     head = data_offset - page_offset;

which means

   page_offset = 0
   file_offset = 0
   head = 288

The looping is here:

remap:
     buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, session->fd,
            file_offset);
     if (buf == MAP_FAILED) {
         pr_err("failed to mmap file\n");
         err = -errno;
         goto out_err;
     }
     mmaps[map_idx] = buf;
     map_idx = (map_idx + 1) & (ARRAY_SIZE(mmaps) - 1);
     file_pos = file_offset + head;

more:
     event = fetch_mmaped_event(session, head, mmap_size, buf);

--> returned event is NULL

     if (!event) {
         if (mmaps[map_idx]) {
             munmap(mmaps[map_idx], mmap_size);
             mmaps[map_idx] = NULL;
         }

         page_offset = page_size * (head / page_size);
         file_offset += page_offset;
         head -= page_offset;

--> head is 288 which means the new page_offset is 0 and the new 
file_offset is 0. head never changes. and then we go back to remap.

         goto remap;
     }

So, if you want to handle the looping then seeing that page_offset new 
in the above is 0 would suffice. A 0 value means file_offset does not 
change and the jump to remap means the mmap does not change. ie., in a 
loop where no values are changing.

David
