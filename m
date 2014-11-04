Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaKDTPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:15:40 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55445 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKDTPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:15:39 -0500
Date: Tue, 4 Nov 2014 14:15:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Weng Meiling <wengmeiling.weng@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Frans Klaver <fransklaver@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, akpm@linux-foundation.org,
        adilger.kernel@dilger.ca, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        Wangyijing <wangyijing@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
Message-ID: <20141104191535.GI14459@htj.dyndns.org>
References: <543E1754.8040701@huawei.com>
 <543F25D3.8010708@huawei.com>
 <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com>
 <543F7289.8010807@huawei.com>
 <20141016091328.GB24374@kroah.com>
 <544765D0.70302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544765D0.70302@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry about the delay.

On Wed, Oct 22, 2014 at 04:07:44PM +0800, Weng Meiling wrote:
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

So, yeah, this looks like a correct approach; however, do we even need
to clear the glue directories?  What's the downside of just keeping
them around once created?

Thanks.

-- 
tejun
