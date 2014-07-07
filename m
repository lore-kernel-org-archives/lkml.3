Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaGGNka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:40:30 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:61607 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaGGNk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:40:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140703175231.GF17372@arm.com>
References: <1403881067-22690-1-git-send-email-jean.pihet@linaro.org>
	<1403881067-22690-3-git-send-email-jean.pihet@linaro.org>
	<20140703175231.GF17372@arm.com>
Date: Mon, 7 Jul 2014 15:40:27 +0200
Message-ID: <CAFrcx1=NWiJ4+qe-cp2t+Cx7Q7dexjbzu-q9fE+HVR2JTOn-SQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: perf: disable the pagefault handler when reading
 from user space
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Sneha Priya <sneha.cse@hotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steve Capper <steve.capper@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 3 July 2014 19:52, Will Deacon <will.deacon@arm.com> wrote:
> Hi Jean,
>
> On Fri, Jun 27, 2014 at 03:57:46PM +0100, Jean Pihet wrote:
>> As done on other architectures (ARM64, x86, Sparc etc.).
>>
>> This prevents a deadlock on down_read in do_page_fault when unwinding
>> using fp and triggering on kernel tracepoints:
>
> So is this an issue because you could try setting tracepoints on the
> pagefault path? If so, the patch is a little brutal as it would break user
> backtracing as soon as we take any old page fault, no?
>
> Or am I missing something obvious?
The problem is a deadlock between the perf events interrupt and
copy_from_user, which take the same lock.
The commit description has been updated to give all the details about it.

Big thanks to Steve on the debugging!

A new patch set is on its way.

Jean

>
> Will
>
>>   INFO: task stress:2116 blocked for more than 120 seconds.
>>         Not tainted 3.15.0-rc4-00364-g3401dfb-dirty #43
>>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>   stress          D c04b41e8     0  2116   2115 0x00000000
>>   [<c04b41e8>] (__schedule) from [<c04b46dc>] (schedule+0x40/0x90)
>>   [<c04b46dc>] (schedule) from [<c04b6ec8>] (__down_read+0xc4/0xfc)
>>   [<c04b6ec8>] (__down_read) from [<c04b69c0>] (down_read+0x18/0x1c)
>>   [<c04b69c0>] (down_read) from [<c001d41c>] (do_page_fault+0xac/0x420)
>>   [<c001d41c>] (do_page_fault) from [<c0008444>] (do_DataAbort+0x44/0xa8)
>>   [<c0008444>] (do_DataAbort) from [<c00136b8>] (__dabt_svc+0x38/0x60)
>>   Exception stack(0xecbc3af8 to 0xecbc3b40)
>>   3ae0:                                                       ecbc3b74 b6d72ff4
>>   3b00: ffffffec 00000000 b6d72ff4 ec0fc000 00000000 ec0fc000 0000007e 00000000
>>   3b20: ecbc2000 ecbc3bac 00000014 ecbc3b44 c0019e78 c021ef44 00000013 ffffffff
>>   [<c00136b8>] (__dabt_svc) from [<c021ef44>] (__copy_from_user+0xa4/0x3a0)
>>
>> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>>  arch/arm/kernel/perf_event.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
>> index 6493c4c..f5aeca2 100644
>> --- a/arch/arm/kernel/perf_event.c
>> +++ b/arch/arm/kernel/perf_event.c
>> @@ -560,11 +560,16 @@ user_backtrace(struct frame_tail __user *tail,
>>              struct perf_callchain_entry *entry)
>>  {
>>       struct frame_tail buftail;
>> +     unsigned long err;
>>
>> -     /* Also check accessibility of one struct frame_tail beyond */
>>       if (!access_ok(VERIFY_READ, tail, sizeof(buftail)))
>>               return NULL;
>> -     if (__copy_from_user_inatomic(&buftail, tail, sizeof(buftail)))
>> +
>> +     pagefault_disable();
>> +     err = __copy_from_user_inatomic(&buftail, tail, sizeof(buftail));
>> +     pagefault_enable();
>> +
>> +     if (err)
>>               return NULL;
>>
>>       perf_callchain_store(entry, buftail.lr);
>> --
>> 1.8.1.2
>>
>>
