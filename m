Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3H1FlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:41:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47029 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3H1FlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:41:11 -0400
X-AuditID: 9c930197-b7b44ae00000347f-a5-521d8d752de0
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 13/13] tracing/uprobes: Add support for full argument access methods
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
	<1377593336-16828-14-git-send-email-namhyung@kernel.org>
	<521C9385.8070201@hitachi.com>
Date: Wed, 28 Aug 2013 14:41:08 +0900
In-Reply-To: <521C9385.8070201@hitachi.com> (Masami Hiramatsu's message of
	"Tue, 27 Aug 2013 20:54:45 +0900")
Message-ID: <87d2oyv0cr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 20:54:45 +0900, Masami Hiramatsu wrote:
> (2013/08/27 17:48), Namhyung Kim wrote:
>> @@ -315,13 +316,18 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
>>  			ret = -EINVAL;
>>  	} else if (strncmp(arg, "stack", 5) == 0) {
>>  		if (arg[5] == '\0') {
>> -			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
>> -				f->fn = fetch_stack_address;
>> -			else
>> -				ret = -EINVAL;
>> +			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR))
>> +				return -EINVAL;
>> +
>> +			if (is_kprobe)
>> +				f->fn = fetch_kernel_stack_address;
>> +			else {
>> +				f->fn = t->fetch[FETCH_MTD_stack];
>> +				f->data = (void *)0;
>> +			}
>
> No, the 'stack' means the address of the stack frame. Perhaps you might make a
> new function to retrieve it from pt_regs.

Hmm.. right.  How about this?


static __kprobes void fetch_user_stack_address(struct pt_regs *regs,
					  void *dummy, void *dest, void *priv)
{
	*(unsigned long *)dest = user_stack_pointer(regs);
}


...

			if (is_kprobe)
				f->fn = fetch_kernel_stack_address;
			else
				f->fn = fetch_user_stack_address;


Thanks,
Namhyung
