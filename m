Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaDNUNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:13:24 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:46441 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaDNUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:13:19 -0400
Date: Mon, 14 Apr 2014 16:13:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v3] Use kernfs_break_active_protection() for device
 online store callbacks
Message-ID: <20140414201315.GD16835@htj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
 <20140410133116.GB25308@htj.dyndns.org>
 <1397189445.3649.14.camel@ThinkPad-T5421>
 <20140411102649.GB26252@mtj.dyndns.org>
 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 14, 2014 at 03:47:29PM +0800, Li Zhong wrote:
> @@ -439,6 +439,7 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
>  {
>  	bool val;
>  	int ret;
> +	struct kernfs_node *kn;
>  
>  	ret = strtobool(buf, &val);
>  	if (ret < 0)
> @@ -448,7 +449,19 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
>  	if (ret)
>  		return ret;
>  
> +	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
> +	if (WARN_ON_ONCE(!kn))
> +		goto out;
> +
> +	get_device(dev);
> +	kernfs_break_active_protection(kn);
>  	ret = val ? device_online(dev) : device_offline(dev);
> +	kernfs_unbreak_active_protection(kn);
> +	put_device(dev);
> +
> +	kernfs_put(kn);
> +
> +out:
>  	unlock_device_hotplug();
>  	return ret < 0 ? ret : count;
>  }

Can you please add comment explainin why this is being down?  As it
currently stands, it's quite a bit of complexity without any
indication what's going on why.  Also, if device_hotplug is locked, is
it really necessary to get @dev?  Can it go away inbetween?  The code
snippet looks weird because getting @dev indicates that the device
might go away without doing it but then it proceeds to invoke
device_{on|off}line() which probably isn't safe to invoke on a removed
device.

Thanks.

-- 
tejun
