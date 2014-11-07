Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaKGCsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 21:48:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaKGCsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 21:48:06 -0500
Date: Thu, 6 Nov 2014 18:46:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        linux-kernel@vger.kernel.org,
        Weng Meiling <wengmeiling.weng@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] sysfs: driver core: Fix glue dir race condition
Message-ID: <20141107024654.GC22844@kroah.com>
References: <1415261798-9671-1-git-send-email-wangyijing@huawei.com>
 <20141106165547.GG25642@htj.dyndns.org>
 <20141106172246.GA20192@kroah.com>
 <545C2408.60703@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545C2408.60703@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 09:44:40AM +0800, Yijing Wang wrote:
> On 2014/11/7 1:22, Greg KH wrote:
> > On Thu, Nov 06, 2014 at 11:55:47AM -0500, Tejun Heo wrote:
> >> Maybe "fix glue dir race condition by not removing them" is a better
> >> title?
> >>
> >> On Thu, Nov 06, 2014 at 04:16:38PM +0800, Yijing Wang wrote:
> >>> There is a race condition when removing glue directory.
> >>> It can be reproduced in following test:
> >>>
> >>> path 1: Add first child device
> >>> device_add()
> >>> 	get_device_parent()
> >>> 		/*find parent from glue_dirs.list*/
> >>> 		list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)
> >>> 			if (k->parent == parent_kobj) {
> >>> 				kobj = kobject_get(k);
> >>> 				break;
> >>> 			}
> >>> 		....
> >>> 		class_dir_create_and_add()
> >>>
> >>> path2: Remove last child device under glue dir
> >>> device_del()
> >>> 	cleanup_device_parent()
> >>> 		cleanup_glue_dir()
> >>> 			kobject_put(glue_dir);
> >>>
> >>> If path2 has been called cleanup_glue_dir(), but not
> >>> call kobject_put(glue_dir), the glue dir is still
> >>> in parent's kset list. Meanwhile, path1 find the glue
> >>> dir from the glue_dirs.list. Path2 may release glue dir
> >>> before path1 call kobject_get(). So kernel will report
> >>> the warning and bug_on.
> >>>
> >>> This fix keep glue dir around once it created suggested
> >>> by Tejun Heo.
> >>
> >> I think you prolly want to explain why this is okay / desired.
> >> e.g. list how the glue dir is used and how many of them are there and
> >> explain that there's no real benefit in removing them.
> > 
> > I'd really _like_ to remove them if at all possible, as if there isn't
> > any "children" in the subdirectory, there shouldn't be a need for that
> > directory to be there.
> > 
> > This seems to be the "classic" problem we have of a kref in a list that
> > can be found while the last instance could be removed at the same time.
> > I hate to just throw another lock at the problem, but wouldn't a lock to
> > protect the list of glue_dirs be the answer here?
> 
> Hi Greg, in this case, we need to protect the race condition between traverse dev->class->p->glue_dirs.list
> and kobject_put(glue_dir) in cleanup_glue_dir().
> 
> glue_dirs.list_lock only used to protect glue_dirs.list, but what we want to protect is
> don't call kobject_put(glue_dir) to decrease glue_dir ref count during we traverse
> dev->class->p->glue_dirs.list.
> 
> 
> ---------------------------------------------------------------------------
> 		/* find our class-directory at the parent and reference it */
> 		spin_lock(&dev->class->p->glue_dirs.list_lock);
> 		list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)     ------>A
> 			if (k->parent == parent_kobj) {
> 				kobj = kobject_get(k);
> 				break;
> 			}
> 		spin_unlock(&dev->class->p->glue_dirs.list_lock);
> ------------------------------------------------------------------------------
> static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
> {
> 	/* see if we live in a "glue" directory */
> 	if (!glue_dir || !dev->class ||
> 	    glue_dir->kset != &dev->class->p->glue_dirs)
> 		return;
> 
> 	kobject_put(glue_dir);   --------------->B
> }
> ------------------------------------------------------------------------------
> 
> 
> Tejun introduced a mutex gdp_mutex in commit 77d3d7c1d561f49 to fix the race condition in get_device_parent().
> We could reuse the mutex to fix the race condition between glue_dirs.list traverse and kobject_put(glue_dir).
> 
> Greg, the two solutions (reuse the gdp_mutex and don't remove glue_dir), which one do you prefer ?
> 
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 28b808c..645eacf 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -724,12 +724,12 @@ class_dir_create_and_add(struct class *class, struct kobject *parent_kobj)
>  	return &dir->kobj;
>  }
> 
> +static DEFINE_MUTEX(gdp_mutex);
> 
>  static struct kobject *get_device_parent(struct device *dev,
>  					 struct device *parent)
>  {
>  	if (dev->class) {
> -		static DEFINE_MUTEX(gdp_mutex);
>  		struct kobject *kobj = NULL;
>  		struct kobject *parent_kobj;
>  		struct kobject *k;
> @@ -793,7 +793,9 @@ static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
>  	    glue_dir->kset != &dev->class->p->glue_dirs)
>  		return;
> 
> +	mutex_lock(&gdp_mutex);
>  	kobject_put(glue_dir);
> +	mutex_unlock(&gdp_mutex);
>  }
> 
>  static void cleanup_device_parent(struct device *dev)
> 

I much prefer this patch over the other one, as it keeps the same
behavior as today, and fixes the existing bug.

Have you tested it out to see if it works properly?  If so, can you
resend it in a "proper" form so I can apply it?

thanks,

greg k-h
