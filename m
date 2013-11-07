Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3KGCTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:19:00 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37986 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3KGCS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:18:59 -0500
MIME-Version: 1.0
X-Originating-IP: [111.240.52.201]
In-Reply-To: <CACVXFVMn6RSXchQ8u47F35_J+YSnp1bwF1tr-8uCEYwvFsOfgQ@mail.gmail.com>
References: <1383789208.5970.1.camel@phoenix>
	<CACVXFVMn6RSXchQ8u47F35_J+YSnp1bwF1tr-8uCEYwvFsOfgQ@mail.gmail.com>
Date: Thu, 7 Nov 2013 10:18:58 +0800
Message-ID: <CAFRkauAEt-YhBt11opj_GVCLrxGsTSd2LowWGmukTSmGuJkd3A@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Axel Lin <axel.lin@ingics.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/7 Ming Lei <tom.leiming@gmail.com>:
> Hi,
>
> On Thu, Nov 7, 2013 at 9:53 AM, Axel Lin <axel.lin@ingics.com> wrote:
>> Hi,
>> I got below oops while debugging a sd controller driver:
>>
>> [    4.032026] ------------[ cut here ]------------
>> [    4.036730] kernel BUG at kernel/kallsyms.c:222!
>> [    4.041501] Internal error: Oops - BUG: 0 [#1] ARM
>> [    4.046847] CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.12.0-00061-g0835d93-dirty #1657
>>
>> I can avoid the oops by either revert commit f6537f2f0eba4eba
>> "scripts/kallsyms: filter symbols not in kernel address space",
>> or comment out below line in drivers/mmc/core/sdio.c.
>>         dev_dbg(&card->dev, "calling %pF\n", f->vendor_fixup);
>>
>> The f->vendor_fixup points to add_quirk_for_sdio_devices.
>> It looks like the symbol add_quirk_for_sdio_devices is missing.
>>
>> So I revert commit f6537f2f and check /proc/kallsyms:
>> ~ # grep add_quirk_for_sdio_devices /proc/kallsyms
>> 00157bf8 t add_quirk_for_sdio_devices
>>
>> If I don't revert commit f6537f2f and just comment out above dev_dbg line,
>> Checking /proc/kallsyms then I got:
>> ~ # grep add_quirk_for_sdio_devices /proc/kallsyms
>> [sched_delayed] sched: RT throttling activated
>> BUG: soft lockup - CPU#0 stuck for 21s! [grep:59]
>>
>> CPU: 0 PID: 59 Comm: grep Not tainted 3.12.0-00061-g0835d93-dirty #1675
>> task: 01d36320 ti: 008be000 task.ti: 008be000
>>
>> BTW, I'm testing it on a noMMU platform (arm7tdmi).
>
> Could you share what is the value of CONFIG_PAGE_OFFSET
> on your noMMU platform?

$ grep  CONFIG_PAGE_OFFSET .config
CONFIG_PAGE_OFFSET=0xC0000000

>
>
> Thanks,
> --
> Ming Lei
