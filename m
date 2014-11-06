Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaKFQz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:55:58 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44008 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaKFQzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:55:51 -0500
Date: Thu, 6 Nov 2014 11:55:47 -0500
From: Tejun Heo <tj@kernel.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: gregkh@linuxfoundation.org, lizefan@huawei.com,
        linux-kernel@vger.kernel.org,
        Weng Meiling <wengmeiling.weng@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] sysfs: driver core: Fix glue dir race condition
Message-ID: <20141106165547.GG25642@htj.dyndns.org>
References: <1415261798-9671-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415261798-9671-1-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe "fix glue dir race condition by not removing them" is a better
title?

On Thu, Nov 06, 2014 at 04:16:38PM +0800, Yijing Wang wrote:
> There is a race condition when removing glue directory.
> It can be reproduced in following test:
> 
> path 1: Add first child device
> device_add()
> 	get_device_parent()
> 		/*find parent from glue_dirs.list*/
> 		list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)
> 			if (k->parent == parent_kobj) {
> 				kobj = kobject_get(k);
> 				break;
> 			}
> 		....
> 		class_dir_create_and_add()
> 
> path2: Remove last child device under glue dir
> device_del()
> 	cleanup_device_parent()
> 		cleanup_glue_dir()
> 			kobject_put(glue_dir);
> 
> If path2 has been called cleanup_glue_dir(), but not
> call kobject_put(glue_dir), the glue dir is still
> in parent's kset list. Meanwhile, path1 find the glue
> dir from the glue_dirs.list. Path2 may release glue dir
> before path1 call kobject_get(). So kernel will report
> the warning and bug_on.
> 
> This fix keep glue dir around once it created suggested
> by Tejun Heo.

I think you prolly want to explain why this is okay / desired.
e.g. list how the glue dir is used and how many of them are there and
explain that there's no real benefit in removing them.

...
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
> Cc: <stable@vger.kernel.org> #3.4+

Except for the above nits.

Reviewed-by: Tejun Heo <tj@kernel.org>

-- 
tejun
