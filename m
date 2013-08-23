Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3HWEWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 00:22:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49705 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3HWEWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:22:08 -0400
Message-ID: <5216E36B.9070701@hitachi.com>
Date: Fri, 23 Aug 2013 13:22:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a
 ring buffer
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org> <1376037909-17797-11-git-send-email-namhyung@kernel.org> <5204BCE6.2070102@hitachi.com> <20130822124212.328c09c7@gandalf.local.home> <5216A55B.4030400@huawei.com>
In-Reply-To: <5216A55B.4030400@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/23 8:57), zhangwei(Jovi) wrote:
> On 2013/8/23 0:42, Steven Rostedt wrote:
>> On Fri, 09 Aug 2013 18:56:54 +0900
>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>
>>> (2013/08/09 17:45), Namhyung Kim wrote:
>>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>>>
>>>> Fetching from user space should be done in a non-atomic context.  So
>>>> use a temporary buffer and copy its content to the ring buffer
>>>> atomically.
>>>>
>>>> While at it, use __get_data_size() and store_trace_args() to reduce
>>>> code duplication.
>>>
>>> I just concern using kmalloc() in the event handler. For fetching user
>>> memory which can be swapped out, that is true. But most of the cases,
>>> we can presume that it exists on the physical memory.
>>>
>>
>>
>> What about creating a per cpu buffer when uprobes are registered, and
>> delete them when they are finished? Basically what trace_printk() does
>> if it detects that there are users of trace_printk() in the kernel.
>> Note, it does not deallocate them when finished, as it is never
>> finished until reboot ;-)
>>
>> -- Steve
>>
> I also thought out this approach, but the issue is we cannot fetch user
> memory into per-cpu buffer, because use per-cpu buffer should under
> preempt disabled, and fetching user memory could sleep.

Hm, perhaps, we just need a "hot" buffer pool which can be allocate/free
soon, and whan the pool shortage caller just wait or allocate new page
from "cold" area, this is a.k.a. kmem_cache :)

Anyway, kmem_cache/kmalloc looks so heavy to just allocate temporally
buffers for trace handler (and also, those have tracepoints), so I think
you may just need a memory pool whose has enough number of slots with
a semaphore (which will wait if the all slots are currently used).

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


