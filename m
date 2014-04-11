Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965408AbaDKK1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:27:00 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:41952 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965221AbaDKK0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:26:53 -0400
Date: Fri, 11 Apr 2014 06:26:49 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v2] Use kernfs_break_active_protection() for device
 online store callbacks
Message-ID: <20140411102649.GB26252@mtj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
 <20140410133116.GB25308@htj.dyndns.org>
 <1397189445.3649.14.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397189445.3649.14.camel@ThinkPad-T5421>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 11, 2014 at 12:10:45PM +0800, Li Zhong wrote:
> @@ -439,6 +439,7 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
>  {
>  	bool val;
>  	int ret;
> +	struct kernfs_node *kn;
>  
>  	ret = strtobool(buf, &val);
>  	if (ret < 0)
> @@ -448,7 +449,15 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
>  	if (ret)
>  		return ret;
>  
> +	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);

Wouldn't find_and_get need to be paired with put?

> +	if (WARN_ON_ONCE(!kn))
> +		goto out;
> +
> +	kernfs_break_active_protection(kn);
> +
>  	ret = val ? device_online(dev) : device_offline(dev);

With active protection protection @dev may go away at any time.  There
should be some protection / synchronization to prevent that, no?

> +	kernfs_unbreak_active_protection(kn);
> +out:
>  	unlock_device_hotplug();
>  	return ret < 0 ? ret : count;
>  }

Thanks.

-- 
tejun
