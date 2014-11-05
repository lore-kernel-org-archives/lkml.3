Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaKED2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:28:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:14397 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaKED2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:28:08 -0500
Message-ID: <5459992B.1040700@huawei.com>
Date: Wed, 5 Nov 2014 11:27:39 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Weng Meiling <wengmeiling.weng@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Frans Klaver <fransklaver@gmail.com>, "Jens Axboe" <axboe@kernel.dk>,
        <akpm@linux-foundation.org>, <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
References: <543E1754.8040701@huawei.com> <543F25D3.8010708@huawei.com> <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com> <543F7289.8010807@huawei.com> <20141016091328.GB24374@kroah.com> <544765D0.70302@huawei.com> <20141104191535.GI14459@htj.dyndns.org> <54598503.1060905@huawei.com> <20141105031345.GA29392@htj.dyndns.org>
In-Reply-To: <20141105031345.GA29392@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/5 11:13, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 05, 2014 at 10:01:39AM +0800, Yijing Wang wrote:
>>> So, yeah, this looks like a correct approach; however, do we even need
>>> to clear the glue directories? 
>>
>> Yes. In our platform, the glue directories
>> /sys/devices/virtual/block will be removed once the last child
>> device call device_del().
> 
> What I mean is why are we even trying to remove the parent directory?
> Can't we just keep them around once created?

We remove the parent directory because parent ref count is equal to children
device numebr, every child device will get/add parent's ref count when child
device be created.

Keep the parent directory looks good to me,  we could only add kobject_get(&parent)
after the parent dir be created.

....
		/* or create a new class-directory at the parent device */
		k = class_dir_create_and_add(dev->class, parent_kobj);
		/* do not emit an uevent for this simple "glue" directory */
		kobject_get(k);  <--------add parent ref count for first child device.
		mutex_unlock(&gdp_mutex);
		return k;
....

> 
> Thanks.
> 


-- 
Thanks!
Yijing

