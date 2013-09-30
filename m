Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3I3Rvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:51:33 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:38637 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab3I3Rvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:51:31 -0400
Message-ID: <5249BA20.1040402@lwfinger.net>
Date: Mon, 30 Sep 2013 12:51:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: 3.12-rc3 memory leak in module memstick
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.12-rc3, I detected a memory leak in module memstick. The kmemleak results 
are listed below. The second output is after memstick was unloaded, which shows 
that it is not a false positive from kmemleak.

larrylap:~ # echo scan > /sys/kernel/debug/kmemleak
larrylap:~ # cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff8800ae85c190 (size 16):
   comm "kworker/u4:3", pid 685, jiffies 4294916336 (age 2831.760s)
   hex dump (first 16 bytes):
     6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
   backtrace:
     [<ffffffff8146a0d1>] kmemleak_alloc+0x21/0x50
     [<ffffffff81160720>] __kmalloc_track_caller+0x160/0x2f0
     [<ffffffff81237b9b>] kvasprintf+0x5b/0x90
     [<ffffffff8122c0c1>] kobject_set_name_vargs+0x21/0x60
     [<ffffffff812e7f5c>] dev_set_name+0x3c/0x40
     [<ffffffffa02bf918>] memstick_check+0xb8/0x340 [memstick]
     [<ffffffff81069862>] process_one_work+0x1d2/0x670
     [<ffffffff8106a88a>] worker_thread+0x11a/0x370
     [<ffffffff81072ea6>] kthread+0xd6/0xe0
     [<ffffffff81478bbc>] ret_from_fork+0x7c/0xb0
     [<ffffffffffffffff>] 0xffffffffffffffff
larrylap:~ # modprobe -rv r592
rmmod /lib/modules/3.12.0-rc3-wl+/kernel/drivers/memstick/host/r592.ko
rmmod /lib/modules/3.12.0-rc3-wl+/kernel/drivers/memstick/core/memstick.ko
larrylap:~ # echo scan > /sys/kernel/debug/kmemleak
larrylap:~ # cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff8800ae85c190 (size 16):
   comm "kworker/u4:3", pid 685, jiffies 4294916336 (age 2947.576s)
   hex dump (first 16 bytes):
     6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
   backtrace:
     [<ffffffff8146a0d1>] kmemleak_alloc+0x21/0x50
     [<ffffffff81160720>] __kmalloc_track_caller+0x160/0x2f0
     [<ffffffff81237b9b>] kvasprintf+0x5b/0x90
     [<ffffffff8122c0c1>] kobject_set_name_vargs+0x21/0x60
     [<ffffffff812e7f5c>] dev_set_name+0x3c/0x40
     [<ffffffffa02bf918>] 0xffffffffa02bf918
     [<ffffffff81069862>] process_one_work+0x1d2/0x670
     [<ffffffff8106a88a>] worker_thread+0x11a/0x370
     [<ffffffff81072ea6>] kthread+0xd6/0xe0
     [<ffffffff81478bbc>] ret_from_fork+0x7c/0xb0
     [<ffffffffffffffff>] 0xffffffffffffffff
larrylap:~ #

As I have not had this driver enabled in my configuration for very long, I'm not 
sure when this behavior started, but it is definitely present in 3.11.0.

Thanks,

Larry

