Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaKECCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 21:02:15 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:20923 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaKECCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:02:14 -0500
Message-ID: <54598503.1060905@huawei.com>
Date: Wed, 5 Nov 2014 10:01:39 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Weng Meiling <wengmeiling.weng@huawei.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Frans Klaver <fransklaver@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, <akpm@linux-foundation.org>,
        <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
References: <543E1754.8040701@huawei.com> <543F25D3.8010708@huawei.com> <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com> <543F7289.8010807@huawei.com> <20141016091328.GB24374@kroah.com> <544765D0.70302@huawei.com> <20141104191535.GI14459@htj.dyndns.org>
In-Reply-To: <20141104191535.GI14459@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/5 3:15, Tejun Heo wrote:
> Hello,
> 
> Sorry about the delay.

Thank you for your review and comments.

> 
> On Wed, Oct 22, 2014 at 04:07:44PM +0800, Weng Meiling wrote:
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 28b808c..645eacf 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -724,12 +724,12 @@ class_dir_create_and_add(struct class *class, struct kobject *parent_kobj)
>>  	return &dir->kobj;
>>  }
>>
>> +static DEFINE_MUTEX(gdp_mutex);
>>
>>  static struct kobject *get_device_parent(struct device *dev,
>>  					 struct device *parent)
>>  {
>>  	if (dev->class) {
>> -		static DEFINE_MUTEX(gdp_mutex);
>>  		struct kobject *kobj = NULL;
>>  		struct kobject *parent_kobj;
>>  		struct kobject *k;
>> @@ -793,7 +793,9 @@ static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
>>  	    glue_dir->kset != &dev->class->p->glue_dirs)
>>  		return;
>>
>> +	mutex_lock(&gdp_mutex);
>>  	kobject_put(glue_dir);
>> +	mutex_unlock(&gdp_mutex);
> 
> So, yeah, this looks like a correct approach; however, do we even need
> to clear the glue directories? 

Yes. In our platform, the glue directories /sys/devices/virtual/block will be removed once the last child device call device_del().

> What's the downside of just keeping
> them around once created?

Without the fix, kernel will report the bug as bellow:

We tested it in 3.4 kernel, but this issue still exists in latest kernel.

<2>[ 3965.441912] kernel BUG at /usr/src/packages/BUILD/kernel-default-3.4.24.19/linux-3.4/fs/sysfs/group.c:65!
<4>[ 3965.441915] invalid opcode: 0000 [#1] SMP
<4>[ 3965.443707] calling kbox_sync :begin
<4>[ 3965.447262] sync kbox :begin
<4>[ 3965.450122] open all redirect device :begin
<4>[ 3965.454276] open all redirect device :end
<4>[ 3965.458257] flush kbox regions :begin
<4>[ 3965.461897] kbox region (die) is writing into (biosnvram), action is 202
<4>[ 3965.468556] test write len : 2009
<4>[ 3965.471847] first start addr : ffff88007e706000
......
<4>[ 3965.686743]  [<ffffffff811a677e>] sysfs_create_group+0xe/0x10
<4>[ 3965.686748]  [<ffffffff810cfb04>] blk_trace_init_sysfs+0x14/0x20
<4>[ 3965.686753]  [<ffffffff811fcabb>] blk_register_queue+0x3b/0x120
<4>[ 3965.686756]  [<ffffffff812030bc>] add_disk+0x1cc/0x490
<4>[ 3965.686770]  [<ffffffffa36a67c6>] SDM_BLKAddBlkDisk+0x86/0x290 [sdm]
<4>[ 3965.686780]  [<ffffffffa36a6a55>] SDM_BLKRegisterThread+0x85/0x330 [sdm]
<4>[ 3965.686801]  [<ffffffffa00dfb7e>] LVOS_SchedWorkThread+0xde/0x190 [vos]
<4>[ 3965.686806]  [<ffffffff8144a8a4>] kernel_thread_helper+0x4/0x10
<4>[ 3965.686821]  [<ffffffffa00dfaa0>] ? LVOS_CreateSchedWorkThread+0xd0/0xd0 [vos]
<4>[ 3965.686825]  [<ffffffff8144a8a0>] ? gs_change+0x13/0x13

Hi Tejun, if you think it make sense, I will resend it to make Greg easy review and apply.


Thanks!
Yijing.

> 
> Thanks.
> 


-- 
Thanks!
Yijing

