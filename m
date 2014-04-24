Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaDXI3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:29:30 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:53240 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaDXI30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:29:26 -0400
Message-ID: <1398328155.2805.100.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
Date: Thu, 24 Apr 2014 16:29:15 +0800
In-Reply-To: <20140423141908.GA4781@htj.dyndns.org>
References: <1398245539-1618-1-git-send-email-jhovold@gmail.com>
	 <20140423141908.GA4781@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042408-1948-0000-0000-00000890B668
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 10:19 -0400, Tejun Heo wrote:
> cc'ing Li Zhong who's working on a simliar issue in the following
> thread and quoting whole body.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1680706
> 
> Li, this is another variation of the same problem.  Maybe this can be
> covered by your work too?

It seems to me that it is about write something to driver attribute, and
driver unloading. If so, maybe it's not easy to reuse the help functions
created for device attribute, and device removing.

But I guess the idea to break the active protection could still be
applied here:

Maybe we could try_module_get() here (like the other option suggested by
Johan?), and break active protection if we could get the module,
something like below? 

================
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83e910a..6ce27e0 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -69,9 +69,24 @@ static ssize_t drv_attr_store(struct kobject *kobj, struct attribute *attr,
 	struct driver_attribute *drv_attr = to_drv_attr(attr);
 	struct driver_private *drv_priv = to_driver(kobj);
 	ssize_t ret = -EIO;
+	struct kernfs_node *kn;
+
+	if (!try_module_get(drv_priv->driver->owner))
+		return ret;
+
+	kn = kernfs_find_and_get(kobj->sd, attr->name);
+	if (WARN_ON_ONCE(!kn))
+		return ret;
+
+	kernfs_break_active_protection(kn);
 
 	if (drv_attr->store)
 		ret = drv_attr->store(drv_priv->driver, buf, count);
+
+	kernfs_unbreak_active_protection(kn);
+	kernfs_put(kn);
+
+	module_put(drv_priv->driver->owner);
 	return ret;
 }
 


