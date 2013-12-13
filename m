Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3LMB5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:57:47 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39783 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3LMB5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:57:46 -0500
Message-ID: <52AA6993.6080804@hitachi.com>
Date: Fri, 13 Dec 2013 10:57:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 16/17] uprobes: Allocate ->utask before handler_chain()
 for tracing handlers
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-17-git-send-email-namhyung@kernel.org> <52A6EFD7.8050602@hitachi.com> <20131210155744.GA21466@redhat.com> <52A7C347.1060402@hitachi.com> <20131211181155.GA25144@redhat.com> <52A94FED.3020705@hitachi.com> <20131212194628.GA5786@redhat.com>
In-Reply-To: <20131212194628.GA5786@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/13 4:46), Oleg Nesterov wrote:
> On 12/12, Masami Hiramatsu wrote:
>>
>> (2013/12/12 3:11), Oleg Nesterov wrote:
>>> On 12/11, Masami Hiramatsu wrote:
>>>>
>>>> But it could skip the handler_chain silently. It could confuse users
>>>> why their probe doesn't hit as expected.
>>>
>>> No, we will restart the same (probed) instruction, handle_swbp()
>>> will be called again, get_utask() will be called again.
>>
>> Hmm, in that case, how would you avoid infinite recursive loop??
> 
> Masami, I do not understand your concerns ;) see below.
> 
>> Would you repeat it until get_utask() != NULL?
> 
> Yes, the task will loop until kmalloc(GFP_KERNEL) succeeds, and I see
> nothing wrong here.
> 
> Just in case, let me remind that it won't loop in kernel mode, it can
> take a signal, it can be killed. And it is not recursive, this is
> like restart after page fault (which btw can fault again if the page
> was unmapped again, and "in theory" this loop can be infinite too).

Ah! I got it :)

> And why this is bad? Once again, this is GFP_KERNEL allocation, if it
> loops "indefinitely" there is something wrong. Even a single GFP_KERNEL
> failure likely means the task is already killed by oom, so it will
> simply exit when it returns to user-mode.

Indeed. It should be killed.

> And how this differs from, say, the "endless" should_alloc_retry() loop
> in __alloc_pages_slowpath() ? And note that in this case we loop in
> kernel mode. Of course this is not possible "in practice", but the same
> is true for the "endless" loop you are worried about.

Agreed, at least that is not uprobe's business :)

> 
>>>> Hmm, in that case, should uprobes handlers never be called on ppc with
>>>> this change?
>>>
>>> Why? With this change ppc will have ->utask != NULL even if it doesn't
>>> need it at all.
>>
>> Ah, I see. This changes that.
> 
> Yes, this is why the changelog says "a bit unfortunate", we allocate the
> memory even there is no trace_uprobe consumer. So it would be nice to
> cleanup this later somehow, but imho this is a low priority problem and
> perhaps we will simply postulate that uprobe_consumer->handler() can
> rely on task->utask != NULL and remove get_utask() from pre_ssout().
> The only necessary cleanup (in my opinion) is that we should add another
> member into the union in uprobe_task for trace_uprobe.c, but again I
> think we should do this later to avoid the (potentially conflicting)
> changes in this series.
> 
> Oleg.
> 

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


