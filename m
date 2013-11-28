Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3K1H5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:57:00 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56682 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3K1H4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:56:43 -0500
X-AuditID: 9c93017d-b7b24ae000002834-f5-5296f739852e
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH/RFC 17/17] tracing/uprobes: Add @+file_offset fetch method
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
	<1385533203-10014-18-git-send-email-namhyung@kernel.org>
	<20131127185546.GA30544@redhat.com>
Date: Thu, 28 Nov 2013 16:56:40 +0900
In-Reply-To: <20131127185546.GA30544@redhat.com> (Oleg Nesterov's message of
	"Wed, 27 Nov 2013 19:55:46 +0100")
Message-ID: <877gbtq7rb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Wed, 27 Nov 2013 19:55:46 +0100, Oleg Nesterov wrote:
> Hi Namhyung,
>
> I'll certainly try to read (and even apply ;) this series carefully.

Thanks in advance. :)

>
> But let me make a couple of nits right now, even if I do not understand
> this code yet.

Okay.

>
> On 11/27, Namhyung Kim wrote:
>>
>> +		} else if (arg[1] == '+') {
>> +			struct file_offset_fetch_param *foprm;
>> +
>> +			/* kprobes don't support file offsets */
>> +			if (is_kprobe)
>> +				return -EINVAL;
>> +
>> +			ret = kstrtol(arg + 2, 0, &offset);
>> +			if (ret)
>> +				break;
>> +
>> +			foprm = kzalloc(sizeof(*foprm), GFP_KERNEL);
>> +			if (!foprm)
>> +				return -ENOMEM;
>> +
>> +			foprm->tu = priv;
>> +			foprm->offset = offset;
>
> Hmm. I am not sure, but can't we simplify this?
>
> Why do we need this foprm at all? To pass tu/offset obviously. But
> why we need to store this info in fetch_param?
>
> translate_user_vaddr() needs to access utask->vaddr anyway. It seems
> to me it would be more clean to do the following:
>
> 	1. Add
> 		struct xxx {
> 			struct trace_uprobe *tu;
> 			unsigned long bp_addr;
> 		};
>
> 	   in trace_uprobe.c.
>
> 	2. Add
>
> 		struct xxx info = {
> 			.tu = tu,
> 			.bp_addr = instruction_pointer(regs);
> 		};
>
> 		current->utask->vaddr = (long)&info;
>
> 	   into uprobe_dispatcher() and uretprobe_dispatcher() (the latter
> 	   should obviously use func instead of instruction_pointer).
>
> 	 3. FETCH_FUNC_NAME(file_offset, type) can do
>
> 	 	struct xxx *info = (void*)current->utask->vaddr;
> 		void *addr = data + info->bp_addr - info->tu->offset;
>
> 	 	return FETCH_FUNC_NAME(memory, type)(regs, aaddr, dest);
>
> 	 4. Now, the only change we need in parse_probe_arg("@") is that
> 	    it should use either FETCH_MTD_memory or FETCH_MTD_file_offset
> 	    depending on arg[0] == '+'.
>
> 	    And we do not need to pass "void *prive" to parse_probe_arg().
>
> What do you think? One again, I can be easily wrong, I didn't read the
> code yet.

You are absolutely right.

I thought we need a fetch_param anyway if we will add support for
cross-fetch later.  But I won't insist it strongly, I can delay it to
later work and make current code simpler if you want. :)

>
>>  static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
>>  {
>>  	struct trace_uprobe *tu;
>> +	struct uprobe_task *utask;
>>  	int ret = 0;
>>  
>>  	tu = container_of(con, struct trace_uprobe, consumer);
>>  	tu->nhit++;
>>  
>> +	utask = current->utask;
>> +	if (utask == NULL)
>> +		return UPROBE_HANDLER_REMOVE;
>
> Hmm, why? The previous change ensures ->utask is not NULL? If we hit
> NULL we have a bug, we should not remove this uprobe.

Yes, I just want to be defensive. :)

So do you suggest to add BUG_ON()?  And can I convert or remove a
similar check in uprobes.c:pre_ssout() too?

Thanks,
Namhyung
