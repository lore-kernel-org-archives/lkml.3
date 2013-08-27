Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab3H0Vk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:40:27 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12759 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3H0VkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:40:24 -0400
Message-ID: <1377639529.10300.847.camel@misato.fc.hp.com>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking
 problems
From: Toshi Kani <toshi.kani@hp.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Date: Tue, 27 Aug 2013 15:38:49 -0600
In-Reply-To: <521C6FA8.4070804@cn.fujitsu.com>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan>
	 <4785337.sqQqDSPcpL@vostro.rjw.lan> <3389643.Fdir3g6c6B@vostro.rjw.lan>
	 <1430120.G7JdUKlgj6@vostro.rjw.lan> <521C6FA8.4070804@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 17:21 +0800, Gu Zheng wrote:
> Hi Rafael,
> 
> On 08/26/2013 11:02 PM, Rafael J. Wysocki wrote:
> 
> > On Monday, August 26, 2013 04:43:26 PM Rafael J. Wysocki wrote:
> >> On Monday, August 26, 2013 02:42:09 PM Rafael J. Wysocki wrote:
> >>> On Monday, August 26, 2013 11:13:13 AM Gu Zheng wrote:
> >>>> Hi Rafael,
> > 
> > [...]
> > 
> >>
> >> OK, so the patch below is quick and dirty and overkill, but it should make the
> >> splat go away at least.
> > 
> > And if this patch does make the splat go away for you, please also test the
> > appended one (Tejun, thanks for the hint!).
> > 
> > I'll address the ACPI part differently later.
> 
> What about changing device_hotplug_lock and acpi_scan_lock to rwsem? like the
> attached one(With a preliminary test, it also can make the splat go away).:)

I am curious how msleep(10) & restart_syscall() work in the change
below.  Doesn't the msleep() make s_active held longer time, which can
lead the thread holding device_hotplug_lock to wait it for deletion?
Also, does restart_syscall() release s_active and reopen this file
again?

@@ -408,9 +408,13 @@ static ssize_t show_online(struct device *dev,
struct device_attribute *attr,
 {
        bool val;

-       lock_device_hotplug();
+       if (!read_lock_device_hotplug()) {
+               msleep(10);
+               return restart_syscall();
+       }
+

Thanks,
-Toshi

