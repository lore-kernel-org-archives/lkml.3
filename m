Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3FEPY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:24:29 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58164 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3FEPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:24:28 -0400
Message-ID: <51AF5824.80706@gmail.com>
Date: Wed, 05 Jun 2013 23:24:20 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] zram: avoid invalid memory access in zram_exit()
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com> <1370361968-8764-2-git-send-email-jiang.liu@huawei.com> <20130605060442.GB8732@blaptop>
In-Reply-To: <20130605060442.GB8732@blaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05 Jun 2013 02:04:42 PM CST, Minchan Kim wrote:
> On Wed, Jun 05, 2013 at 12:06:00AM +0800, Jiang Liu wrote:
>> Memory for zram->disk object may have already been freed after returning
>> from destroy_device(zram), then it's unsafe for zram_reset_device(zram)
>> to access zram->disk again.
>>
>> We can't solve this bug by flipping the order of destroy_device(zram)
>> and zram_reset_device(zram), that will cause deadlock issues to the
>> zram sysfs handler.
>
> What kinds of deadlock happen?
> Could you elaborate it more?
>
Hi Minchan,
      I will try my best to explain the situation.
1) if we change the order as:
                zram_reset_device(zram);
                destroy_device(zram);
zram->meta could be rebuilt by disksize_store() just between
zram_reset_device(zram) and destroy_device(zram) because all sysfs
entries are still available, which then cause memory leak.

2) If we change the code as:
        down_write(&zram->init_lock);
        __zram_reset_device(zram);
        destroy_device(zram);
        up_write(&zram->init_lock);
Then it will cause a typical deadlock as:
Thread1:
1) acquire init_lock
2) destroy_device(zram);
2.a)sysfs_remove_group()
2.b) wait for all sysfs files to be closed and released.

Thread2:
1) echo xxm > disksize
2) open sysfs file and call disksize_store()
3) disksize_store() tries to acquire zram->init_lock

Then deadlock.

Regards!
Gerry
