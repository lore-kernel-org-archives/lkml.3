Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3JHDMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:12:12 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:46119 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3JHDMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:12:07 -0400
Message-ID: <52537803.8010709@lwfinger.net>
Date: Mon, 07 Oct 2013 22:12:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linville@tuxdriver.com, Alex Dubov <oakad@yahoo.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH V2] memstick: Fix memory leak in memstick_check() error
 path
References: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net> <20131008021304.GB32733@kroah.com>
In-Reply-To: <20131008021304.GB32733@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 09:13 PM, Greg Kroah-Hartman wrote:
> On Sun, Oct 06, 2013 at 10:21:51PM -0500, Larry Finger wrote:
>> With kernel 3.12-rc3, kmemleak reports the following leak:
>>
>>> unreferenced object 0xffff8800ae85c190 (size 16):
>>>    comm "kworker/u4:3", pid 685, jiffies 4294916336 (age 2831.760s)
>>>    hex dump (first 16 bytes):
>>>      6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
>>>    backtrace:
>>>      [<ffffffff8146a0d1>] kmemleak_alloc+0x21/0x50
>>>      [<ffffffff81160720>] __kmalloc_track_caller+0x160/0x2f0
>>>      [<ffffffff81237b9b>] kvasprintf+0x5b/0x90
>>>      [<ffffffff8122c0c1>] kobject_set_name_vargs+0x21/0x60
>>>      [<ffffffff812e7f5c>] dev_set_name+0x3c/0x40
>>>      [<ffffffffa02bf918>] memstick_check+0xb8/0x340 [memstick]
>>>      [<ffffffff81069862>] process_one_work+0x1d2/0x670
>>>      [<ffffffff8106a88a>] worker_thread+0x11a/0x370
>>>      [<ffffffff81072ea6>] kthread+0xd6/0xe0
>>>      [<ffffffff81478bbc>] ret_from_fork+0x7c/0xb0
>>
>> This problem was introduced by commit 0252c3b "memstick: struct device -
>> replace bus_id with dev_name(), dev_set_name()" where the name is not freed
>> in the error path. The name is also leaked in memstick_free_card().
>>
>> Thanks to Catalin Marinas for suggesting the fix.
>>
>> Cc: Kay Sievers <kay.sievers@vrfy.org>
>> Cc: Alex Dubov <oakad@yahoo.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> V2 fixes the typos in the commit message, and frees the name in
>> memstick_free_card() as well as the error path in memstick_check().
>
> Looking back at this, to try to figure out why the kmemleak report shows
> up, shows that this is a mess.  Why would we be erroring out _before_ we
> try to register the struct device with the driver core, yet we had
> already initialized the struct device structure?  Only set up the
> structure right before sending it to driver core, don't delay in
> allocation, only problems can happen (like here.)
>
> To fix this up, will take some major work, which I can't do, sorry, but
> this patch will not work either.

Thanks for the analysis. My interest is getting rid of memory leaks from other 
sources so that the leaks from my drivers are more obvious.

Perhaps Alex will pick this up and do the rewrite.

Please drop both patches.

Larry


