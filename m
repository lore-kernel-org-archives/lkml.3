Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3JARDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:03:38 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34745 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3JARDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:03:36 -0400
Message-ID: <524B0065.60200@lwfinger.net>
Date: Tue, 01 Oct 2013 12:03:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Alex Dubov <oakad@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12-rc3 memory leak in module memstick
References: <5249BA20.1040402@lwfinger.net> <CAHkRjk6Wuf4Lcd1mN0ZuKBb9aX2VqoUVMG_UWkKNdRSM3407+Q@mail.gmail.com>
In-Reply-To: <CAHkRjk6Wuf4Lcd1mN0ZuKBb9aX2VqoUVMG_UWkKNdRSM3407+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 09:04 AM, Catalin Marinas wrote:
> On 30 September 2013 18:51, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 3.12-rc3, I detected a memory leak in module memstick. The kmemleak
>> results are listed below. The second output is after memstick was unloaded,
>> which shows that it is not a false positive from kmemleak.
>>
>> larrylap:~ # echo scan > /sys/kernel/debug/kmemleak
>> larrylap:~ # cat /sys/kernel/debug/kmemleak
>> unreferenced object 0xffff8800ae85c190 (size 16):
>>    comm "kworker/u4:3", pid 685, jiffies 4294916336 (age 2831.760s)
>>    hex dump (first 16 bytes):
>>      6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
>>    backtrace:
>>      [<ffffffff8146a0d1>] kmemleak_alloc+0x21/0x50
>>      [<ffffffff81160720>] __kmalloc_track_caller+0x160/0x2f0
>>      [<ffffffff81237b9b>] kvasprintf+0x5b/0x90
>>      [<ffffffff8122c0c1>] kobject_set_name_vargs+0x21/0x60
>>      [<ffffffff812e7f5c>] dev_set_name+0x3c/0x40
>>      [<ffffffffa02bf918>] memstick_check+0xb8/0x340 [memstick]
>>      [<ffffffff81069862>] process_one_work+0x1d2/0x670
>>      [<ffffffff8106a88a>] worker_thread+0x11a/0x370
>>      [<ffffffff81072ea6>] kthread+0xd6/0xe0
>>      [<ffffffff81478bbc>] ret_from_fork+0x7c/0xb0
>
> The leak is most likely coming from memstick_alloc_card() on the error
> path. Commit 0252c3b4f0 (memstick: struct device - replace bus_id with
> dev_name(), dev_set_name()) sets allocates the device name but 'card'
> is freed on the error path without freeing the name.

Thanks for the analysis. From that I am quite sure I can devise a patch.

Larry


