Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaJPB5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 21:57:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:58757 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaJPB5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 21:57:05 -0400
Message-ID: <543F25D3.8010708@huawei.com>
Date: Thu, 16 Oct 2014 09:56:35 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, <akpm@linux-foundation.org>,
        <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
References: <543E1754.8040701@huawei.com>
In-Reply-To: <543E1754.8040701@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi，

Would you please give me some of your views on this issue? Any suggestion is appreciative.

Thanks!

Weng Meiling

On 2014/10/15 14:42, Weng Meiling wrote:
> When the last child kobject was deleted, it's parent kobject will be deleted,
> when removing the parent kobject if the parent kobject's sd has been set NULL
> and still not been removed from it's kset's list, at the same time another one
> trigger an device adding event, the function get_parent_device() will get the
> parent object from the kset's list for kobject_add(), but this time parent
> kobject's sd has been NULL. This race will make the sysfs_create_dir() return
> ENOENT, the new kobject will be failed to added into sysfs and trigger BUG()
> when creating attribute group under the new device's directory. So move the
> kobject removal from kset's list before kobj->sd=NULL.
> 
> The race situation:
> 
> path0(remove parent kobj, e.g:/sys/devices/virtual/block/)   path1(register a new device)
> 
> kobject_del(){                                               get_device_parent(){
> ...                                                          ...
> sysfs_remove_dir(kobj);  //kobj->sd=NULL                     spin_lock(&dev->class->p->glue_dirs.list_lock);
> ...                                                  <===    list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)
> kobj_kset_leave(kobj);   //remove kobj from kset list        ...
> }                                                           }
> 
> 
> We had triggered the bug, the detail message link:
> https://lkml.org/lkml/2014/10/13/40
> 
> Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
> ---
>  lib/kobject.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 58751bb..af2b7bb 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -560,12 +560,13 @@ void kobject_del(struct kobject *kobj)
>  	if (!kobj)
>  		return;
> 
> +	kobj_kset_leave(kobj);
> +
>  	sd = kobj->sd;
>  	sysfs_remove_dir(kobj);
>  	sysfs_put(sd);
> 
>  	kobj->state_in_sysfs = 0;
> -	kobj_kset_leave(kobj);
>  	kobject_put(kobj->parent);
>  	kobj->parent = NULL;
>  }
> 


