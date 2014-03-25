Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaCYWjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:39:40 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:40723 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbaCYWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:39:38 -0400
Date: Tue, 25 Mar 2014 23:39:36 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
Message-ID: <20140325233936.655a798e@linux.lan.towertech.it>
In-Reply-To: <5331FA9E.20506@oracle.com>
References: <5308E3AE.3040405@oracle.com>
	<20140222205217.GC16272@mtj.dyndns.org>
	<20140224120427.6394d5dd@linux.lan.towertech.it>
	<5331FA9E.20506@oracle.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014 17:52:30 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> >
> >   Pretty interesting indeed. One option would be to remove
> >   the sys files before acquiring the lock. But I wonder
> >   if this could lead to other issues.
> >  
> 
> Ping? Seems this thing got lost.

 What if we move

   rtc_sysfs_del_device(rtc);

 before acquiring the lock?

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 589351e..a0c19a3 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -261,11 +261,13 @@ EXPORT_SYMBOL_GPL(rtc_device_register);
 void rtc_device_unregister(struct rtc_device *rtc)
 {
        if (get_device(&rtc->dev) != NULL) {
+
+               rtc_sysfs_del_device(rtc);
+
                mutex_lock(&rtc->ops_lock);
                /* remove innards of this RTC, then disable it, before
                 * letting any rtc_class_open() users access it again
                 */
-               rtc_sysfs_del_device(rtc);
                rtc_dev_del_device(rtc);
                rtc_proc_del_device(rtc);
                device_unregister(&rtc->dev);


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

