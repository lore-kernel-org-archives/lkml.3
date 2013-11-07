Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3KGPzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:55:25 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51662 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3KGPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:55:22 -0500
Message-ID: <527BB7E6.9060402@gmail.com>
Date: Thu, 07 Nov 2013 08:55:18 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?56em5om/5Yia?= <chenggang.qcg@alibaba-inc.com>,
        Chenggang Qin <chenggang.qin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?56em5om/5Yia?= <chenggang.qcg@taobao.com>
Subject: Re: =?UTF-8?B?562U5aSN77ya562U5aSN77yaW1BBVENIIDIvNF0gcGVyZiB0b28=?=
 =?UTF-8?B?bHM6IHJlbGF0ZSAnc3RhcnQnICYgJ2VuZCcgdG8gcGVyZl9zZXNzaW9u?=
References: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com> <1383298146-3860-3-git-send-email-chenggang.qin@gmail.com>,52757E0B.3010805@gmail.com <f31aa7c2-c31a-47f2-a051-a5bd44f4d07d@alibaba-inc.com>,527A5D20.3000308@gmail.com <6d5d4b79-c25a-4f12-984a-58b310dae2a5@alibaba-inc.com>
In-Reply-To: <6d5d4b79-c25a-4f12-984a-58b310dae2a5@alibaba-inc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/13, 5:14 AM, 秦承刚 wrote:
> Hi, David
> The samples for the task before the end of the time window are not
> influenced by the time window. The time window only cover the sample
> events in the ordered_samples. FORK, MMAP, COMM events are not in the
> ordered_samples. They are delivered in the function
> "perf_session__process_event". The task events that are after the end of
> the time window can be ingnored safely.

following builtin-report.c:
perf_session__process_events() -> __perf_session__process_events() --> 
perf_session__process_event():

     ret = perf_evlist__parse_sample(session->evlist, event, &sample);
     if (ret)
         return ret;

     if (tool->ordered_samples) {
         ret = perf_session_queue_event(session, event, &sample,
                            file_offset);
         if (ret != -ETIME)
             return ret;
     }

All samples are dropped into the ordered_samples queue if they have a 
timestamp. And I believe it was the sample_id_all patch that put a 
timestamp on task events too (~2.6.35 or 36 timeframe).


> Would you give me a link to your patch?

https://github.com/dsahern/linux/blob/timehist-timeofday-3.9/tools/perf/util/time-utils.c
and
https://github.com/dsahern/linux/blob/timehist-timeofday-3.9/tools/perf/builtin-timehist.c

I did not push the builtin-report.c change, but it follows directly from 
the timehist command.

David
