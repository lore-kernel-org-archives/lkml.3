Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069Ab3IDHIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:08:55 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60068 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab3IDHIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:08:54 -0400
X-AuditID: 9c930197-b7b44ae00000347f-e1-5226dc84476b
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a ring buffer
References: <1378187054-27401-1-git-send-email-namhyung@kernel.org>
	<1378187054-27401-11-git-send-email-namhyung@kernel.org>
	<5225BEF4.5030901@hitachi.com>
Date: Wed, 04 Sep 2013 16:08:52 +0900
In-Reply-To: <5225BEF4.5030901@hitachi.com> (Masami Hiramatsu's message of
	"Tue, 03 Sep 2013 19:50:28 +0900")
Message-ID: <871u55t663.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Sep 2013 19:50:28 +0900, Masami Hiramatsu wrote:
> (2013/09/03 14:44), Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Fetching from user space should be done in a non-atomic context.  So
>> use a per-cpu buffer and copy its content to the ring buffer
>> atomically.  Note that we can migrate during accessing user memory
>> thus use a per-cpu mutex to protect concurrent accesses.
>> 
>> This is needed since we'll be able to fetch args from an user memory
>> which can be swapped out.  Before that uprobes could fetch args from
>> registers only which saved in a kernel space.
>> 
>> While at it, use __get_data_size() and store_trace_args() to reduce
>> code duplication.

[SNIP]

>> +	size = esize + tu->p.size + dsize;
>>  	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
>> -						  size + tu->p.size, 0, 0);
>> -	if (!event)
>> +						  size, 0, 0);
>> +	if (!event) {
>> +		mutex_unlock(mutex);
>>  		return;
>
> Just for a maintenance reason, I personally like to use "goto" in this case
> to fold up the mutex_unlock. :)
>
> Other parts are good for me.
>
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you for review!

I'll change it as you said and fix atomic_dec bug that Jovi found.

Thanks,
Namhyung
