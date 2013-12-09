Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071Ab3LIOF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:05:28 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54914 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760384Ab3LIOFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:05:25 -0500
Message-ID: <52A5CE1B.3030007@gmail.com>
Date: Mon, 09 Dec 2013 07:05:15 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tool: Ensure forward progress unwinding frames
References: <1385942509-11445-1-git-send-email-dsahern@gmail.com> <52A4B065.9080804@gmail.com> <20131209100205.GA1242@krava.brq.redhat.com>
In-Reply-To: <20131209100205.GA1242@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/13, 3:02 AM, Jiri Olsa wrote:
>> On 12/1/13, 5:01 PM, David Ahern wrote:
>>> The dwarf option for callstacks is getting stuck on the unwind and showing
>>> repeated frames. For example,
>>>
>>> qemu-system-x86 13759 [001] 287663.084957: syscalls:sys_enter_futex: uaddr: 0x7f770a958700, op: 0x00000081, val: 0x00000001, utime: 0x7f75ea
>>>              7f7705fd23ea __lll_unlock_wake (/lib64/libpthread-2.14.90.so)
>>>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>>>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>>>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>>>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>>>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>>>              ...
>
> I wonder this is us or libunwind bug (or cfi code) ;-)
>
> looks like you can reproduce..? are you using the latest libunwind?

$ rpm -q libunwind
libunwind-0.99-2.20110424git1e10c293.fc16.x86_64

>
>
>>>              (Last frame repeats 126 times)
>>>
>>> Catch that the same frame is hit multiple times and break out of the loop.
>>>
>>> With this patch:
>>>
>>> qemu-system-x86 13759 [001] 287663.084967: syscalls:sys_exit_futex: 0x1
>>>              7f7705fd23ea __lll_unlock_wake (/lib64/libpthread-2.14.90.so)
>>>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>>>
>>> Signed-off-by: David Ahern <dsahern@gmail.com>
>>> Cc: Jiri Olsa <jolsa@redhat.com>
>>> ---
>>>   tools/perf/util/unwind.c | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
>>> index 0efd5393de85..817ffc1f3a00 100644
>>> --- a/tools/perf/util/unwind.c
>>> +++ b/tools/perf/util/unwind.c
>>> @@ -563,6 +563,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
>>>   {
>>>   	unw_addr_space_t addr_space;
>>>   	unw_cursor_t c;
>>> +	unw_word_t prev_ip = 0;
>>>   	int ret;
>>>
>>>   	addr_space = unw_create_addr_space(&accessors, 0);
>>> @@ -579,6 +580,10 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
>>>   		unw_word_t ip;
>>>
>>>   		unw_get_reg(&c, UNW_REG_IP, &ip);
>>> +		if (ip == prev_ip)
>>> +			break;
>>> +		prev_ip = ip;
>
> hum, how about recursion?
>
> how about some counter and break after some insane value

I chose > 1 as the insane value. Do you have a suggestion on something 
else? 5? 10?

> and maybe display some warning..
>
>    qemu-system-x86 13759 [001] 287663.084967: syscalls:sys_exit_futex: 0x1
>               7f7705fd23ea __lll_unlock_wake (/lib64/libpthread-2.14.90.so)
>               7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>               warning: unwind broken

sure.

David
