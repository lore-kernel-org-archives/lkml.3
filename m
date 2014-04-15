Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaDOCos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:44:48 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:39496 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaDOCor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:44:47 -0400
Message-ID: <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v3] Use kernfs_break_active_protection() for device
 online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Tue, 15 Apr 2014 10:44:37 +0800
In-Reply-To: <20140414201315.GD16835@htj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140410133116.GB25308@htj.dyndns.org>
	 <1397189445.3649.14.camel@ThinkPad-T5421>
	 <20140411102649.GB26252@mtj.dyndns.org>
	 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140414201315.GD16835@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041502-6892-0000-0000-00000877C6EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 16:13 -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 14, 2014 at 03:47:29PM +0800, Li Zhong wrote:
> > @@ -439,6 +439,7 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
> >  {
> >  	bool val;
> >  	int ret;
> > +	struct kernfs_node *kn;
> >  
> >  	ret = strtobool(buf, &val);
> >  	if (ret < 0)
> > @@ -448,7 +449,19 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
> >  	if (ret)
> >  		return ret;
> >  
> > +	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
> > +	if (WARN_ON_ONCE(!kn))
> > +		goto out;
> > +
> > +	get_device(dev);
> > +	kernfs_break_active_protection(kn);
> >  	ret = val ? device_online(dev) : device_offline(dev);
> > +	kernfs_unbreak_active_protection(kn);
> > +	put_device(dev);
> > +
> > +	kernfs_put(kn);
> > +
> > +out:
> >  	unlock_device_hotplug();
> >  	return ret < 0 ? ret : count;
> >  }
> 
> Can you please add comment explainin why this is being down?  As it
> currently stands, it's quite a bit of complexity without any
> indication what's going on why.  Also, if device_hotplug is locked, is
> it really necessary to get @dev?  Can it go away inbetween?  The code
> snippet looks weird because getting @dev indicates that the device
> might go away without doing it but then it proceeds to invoke
> device_{on|off}line() which probably isn't safe to invoke on a removed
> device.

Hi Tejun, 

I tried to write some draft words here... (I'm not good at writing
it...) Could you please help to have a review and comment? thanks.

/ *
  * This process might deadlock with another process trying to 
  * remove this device:
  * This process holding the s_active of "online" attribute, and tries 
  * to online/offline the device with some locks protecting hotplug.
  * Device removing process holding some locks protecting hotplug, and 
  * tries to remove the "online" attribute, waiting for the s_active to
  * be released. 
  *
  * The deadlock described above should be solved with
  * lock_device_hotplug_sysfs(). We temporarily drop the active 
  * protection here to avoid some lockdep warnings. 
  *
  * If device_hotplug_lock is forgotten to be used when removing
  * device(possibly some very simple device even don't need this lock?),
  * @dev could go away any time after dropping the active protection. 
  * So increase its ref count before dropping active protection. 
  * Though invoking device_{on|off}line() on a removed device seems
  * unreasonable, it should be less disastrous than playing with freed
  * @dev. Also, we might be able to have some mechanism abort 
  * device_{on|off}line() if @dev already removed.
  */

Thanks, Zhong
> 
> Thanks.
> 


