Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3EOUqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:46:43 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37702 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab3EOUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:46:42 -0400
Message-ID: <5193F42D.7020301@lwfinger.net>
Date: Wed, 15 May 2013 15:46:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: V3.10-rc1 memory leak
References: <51912567.6090507@lwfinger.net> <1368558586.6828.53.camel@gandalf.local.home> <20130514203028.GA2997@MacBook-Pro.local> <5192A847.1000100@lwfinger.net> <1368566427.6828.58.camel@gandalf.local.home> <1368579423.6828.63.camel@gandalf.local.home> <5192FDE2.1020305@lwfinger.net> <20130515150228.GC1096@darko.cambridge.arm.com>
In-Reply-To: <20130515150228.GC1096@darko.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 10:02 AM, Catalin Marinas wrote:
> On Wed, May 15, 2013 at 04:15:46AM +0100, Larry Finger wrote:
>> I do not see that particular one; however, I see 4 instances of
>>
>> unreferenced object 0xffff8800b7979750 (size 8):
>>     comm "swapper/0", pid 1, jiffies 4294892402 (age 21888.316s)
>>     hex dump (first 8 bytes):
>>       31 38 00 b7 00 88 ff ff                          18......
>>     backtrace:
>>       [<ffffffff81432ea1>] kmemleak_alloc+0x21/0x50
>>       [<ffffffff81145d50>] __kmalloc_track_caller+0x140/0x2b0
>>       [<ffffffff81119fb5>] kstrdup+0x35/0x70
>>       [<ffffffff8125febc>] acpi_set_pnp_ids+0xd0/0x304
>>       [<ffffffff81260c47>] acpi_scan_init_hotplug+0x47/0xa1
>>       [<ffffffff81261223>] acpi_bus_check_add+0x66/0xd7
>>       [<ffffffff8127877a>] acpi_ns_walk_namespace+0xb9/0x173
>>       [<ffffffff81278bf3>] acpi_walk_namespace+0x93/0xc6
>>       [<ffffffff812612dc>] acpi_bus_scan+0x48/0x9a
>>       [<ffffffff818c983d>] acpi_scan_init+0x57/0x14b
>>       [<ffffffff818c966a>] acpi_init+0x244/0x286
>>       [<ffffffff810002fa>] do_one_initcall+0x10a/0x160
>>       [<ffffffff8189cef0>] kernel_init_freeable+0x103/0x192
>>       [<ffffffff814313a9>] kernel_init+0x9/0xf0
>>       [<ffffffff8144992c>] ret_from_fork+0x7c/0xb0
>>       [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> All four were allocated early in the bootup, and are the only leaks reported in
>> my system. I have not yet tested to see if they are false.
>
> This looks to me like a real leak, possibly introduced by commit
> 6b772e8f9 (ACPI: Update PNPID match handling for notify). The
> acpi_scan_init_hotplug() function calls acpi_set_pnp_ids() which
> allocates pnp.unique_id (kstrdup()) but for some reason it fails and
> does not set pnp.type.hardware_id. The return does not call
> acpi_free_pnp_ids() which would be responsible for such freeing.
> Something like below, but not tested and may fail some NULL pointer
> checks:
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index fe158fd..c1bc608 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1785,7 +1785,7 @@ static void acpi_scan_init_hotplug(acpi_handle handle, int type)
>   	acpi_set_pnp_ids(handle, &pnp, type);
>
>   	if (!pnp.type.hardware_id)
> -		return;
> +		goto out;
>
>   	/*
>   	 * This relies on the fact that acpi_install_notify_handler() will not
> @@ -1800,6 +1800,7 @@ static void acpi_scan_init_hotplug(acpi_handle handle, int type)
>   		}
>   	}
>
> +out:
>   	acpi_free_pnp_ids(&pnp);
>   }

This patch fixes the memory leaks on my system. My kmemleak scans are now clean 
again. You may add a "Tested-by: Larry Finger <Larry.Finger@lwfinger.net>".

Thanks,

Larry


