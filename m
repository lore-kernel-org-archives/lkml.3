Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaFLBIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:08:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51007 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaFLBIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:08:14 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] tracing: Fix memory leak on failure path in ftrace_allocate_pages()
References: <1402474014-28655-1-git-send-email-namhyung@kernel.org>
	<20140611100340.76b61805@gandalf.local.home>
Date: Thu, 12 Jun 2014 10:08:10 +0900
In-Reply-To: <20140611100340.76b61805@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 11 Jun 2014 10:03:40 -0400")
Message-ID: <87ha3r9bph.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Wed, 11 Jun 2014 10:03:40 -0400, Steven Rostedt wrote:
> On Wed, 11 Jun 2014 17:06:53 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> As struct ftrace_page is managed in a single linked list, it should
>> free from the start page.
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  kernel/trace/ftrace.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 5b372e3ed675..ddfda763ded7 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -2398,7 +2398,8 @@ ftrace_allocate_pages(unsigned long num_to_init)
>>  	return start_pg;
>>  
>>   free_pages:
>> -	while (start_pg) {
>> +	pg = start_pg;
>> +	while (pg) {
>
> It works with just the added "pg = start_page", I would keep the
> while (start_pg) still.

The reason why I changed it is the code actually uses pg rather than
start_pg in the loop.  So it's more comfortable for me to check the pg
in the condition.  But it's minor, I won't insist it strongly.. :)

Thanks,
Namhyung


>>  		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
>>  		free_pages((unsigned long)pg->records, order);
>>  		start_pg = pg->next;
