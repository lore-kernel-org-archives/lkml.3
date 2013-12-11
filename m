Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3LKBnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:43:45 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34793 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3LKBnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:43:42 -0500
Message-ID: <52A7C347.1060402@hitachi.com>
Date: Wed, 11 Dec 2013 10:43:35 +0900
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
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-17-git-send-email-namhyung@kernel.org> <52A6EFD7.8050602@hitachi.com> <20131210155744.GA21466@redhat.com>
In-Reply-To: <20131210155744.GA21466@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/11 0:57), Oleg Nesterov wrote:
> On 12/10, Masami Hiramatsu wrote:
>>
>> (2013/12/09 15:20), Namhyung Kim wrote:
>>> From: Oleg Nesterov <oleg@redhat.com>
>>>
>>> uprobe_trace_print() and uprobe_perf_print() need to pass the additional
>>> info to call_fetch() methods, currently there is no simple way to do this.
>>>
>>> current->utask looks like a natural place to hold this info, but we need
>>> to allocate it before handler_chain().
>>>
>>> This is a bit unfortunate, perhaps we will find a better solution later,
>>> but this is simnple and should work right now.
>>
>> Hmm, when this will happen?
> 
> Perhaps never. Perhaps it will stay forever and we remove get_utask() from
> pre_ssout() (it is not needed after this patch).

Ah, OK, get_utask() is almost same as kzalloc().

> However I still think we can cleanup this. And to remind, we need to clean
> the usage of utask->vaddr in trace_uprobe.c anyway. We can either try to
> find another place to pass the info, or we can create a helper(s) for the
> tracing handlers to access (and populate if NULL) utask->handler_data.
> Note that this (probably) also makes sense because we can unexport
> "struct uprobe_task" (but this needs a couple of off-topic cleanups).
> 
> We will see. Lets do the minimal change which can work right now, Namhyung
> has enough more serious problems ;)
> 
>> and isn't it better to increment
>> miss-hit counter of the uprobe?
> 
> What do you mean? This is not miss-hit and ->utask == NULL is quite normal.

But it could skip the handler_chain silently. It could confuse users
why their probe doesn't hit as expected.

> For example, on ppc it can be always NULL because ppc likely emulates the
> probed insn.

Hmm, in that case, should uprobes handlers never be called on ppc with
this change?

> Or did you mean that if get_utask() fails we should report this somehow?

I meant that if the uprobes hits some error and not work as expected,
it should be reported somehow to users, and miss-hit counter will be
a possible option.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


