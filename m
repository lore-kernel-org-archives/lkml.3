Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaKGBYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:24:10 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:39544 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKGBYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:24:06 -0500
Message-ID: <545C1EC0.1070907@huawei.com>
Date: Fri, 7 Nov 2014 09:22:08 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <gregkh@linuxfoundation.org>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Weng Meiling <wengmeiling.weng@huawei.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] sysfs: driver core: Fix glue dir race condition
References: <1415261798-9671-1-git-send-email-wangyijing@huawei.com> <20141106165547.GG25642@htj.dyndns.org>
In-Reply-To: <20141106165547.GG25642@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.545C1F33.0140,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 3ea8af9f1b4f92a978deeeaae8527107
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/7 0:55, Tejun Heo wrote:
> Maybe "fix glue dir race condition by not removing them" is a better
> title?

Yes, it's better, thank you!

> 
> On Thu, Nov 06, 2014 at 04:16:38PM +0800, Yijing Wang wrote:
>> There is a race condition when removing glue directory.
>> It can be reproduced in following test:
>>
>> path 1: Add first child device
>> device_add()
>> 	get_device_parent()
>> 		/*find parent from glue_dirs.list*/
>> 		list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)
>> 			if (k->parent == parent_kobj) {
>> 				kobj = kobject_get(k);
>> 				break;
>> 			}
>> 		....
>> 		class_dir_create_and_add()
>>
>> path2: Remove last child device under glue dir
>> device_del()
>> 	cleanup_device_parent()
>> 		cleanup_glue_dir()
>> 			kobject_put(glue_dir);
>>
>> If path2 has been called cleanup_glue_dir(), but not
>> call kobject_put(glue_dir), the glue dir is still
>> in parent's kset list. Meanwhile, path1 find the glue
>> dir from the glue_dirs.list. Path2 may release glue dir
>> before path1 call kobject_get(). So kernel will report
>> the warning and bug_on.
>>
>> This fix keep glue dir around once it created suggested
>> by Tejun Heo.
> 
> I think you prolly want to explain why this is okay / desired.
> e.g. list how the glue dir is used and how many of them are there and
> explain that there's no real benefit in removing them.
> 

Right, I will add the explanation. :)

> ...
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
>> Cc: <stable@vger.kernel.org> #3.4+
> 
> Except for the above nits.
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks!

> 


-- 
Thanks!
Yijing

