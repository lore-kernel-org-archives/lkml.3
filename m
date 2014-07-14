Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaGNJcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:32:45 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:14055 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751282AbaGNJcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:32:39 -0400
X-IronPort-AV: E=Sophos;i="5.00,888,1396972800"; 
   d="scan'208";a="33233833"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "'Daniel P. Berrange (berrange@redhat.com)'" <berrange@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Could not mount sysfs when enable userns but disable netns
Thread-Topic: Could not mount sysfs when enable userns but disable netns
Thread-Index: AQHPnSU7SG1yNTatakGghsdrDCeAZpue1FMQ
Date: Mon, 14 Jul 2014 09:32:39 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5632BD@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <5871495633F38949900D2BF2DC04883E562293@G08CNEXMBPEKD02.g08.fujitsu.local>
	<20140711142806.GA26441@mail.hallyn.com>
 <87ha2nyi3y.fsf@x220.int.ebiederm.org>
In-Reply-To: <87ha2nyi3y.fsf@x220.int.ebiederm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6E9WsX9003026



> -----Original Message-----
> From: Eric W. Biederman [mailto:ebiederm@xmission.com]
> Sent: Saturday, July 12, 2014 12:29 AM
> To: Serge E. Hallyn
> Cc: Chen, Hanxiao/³Â êÏÏö; Serge Hallyn (serge.hallyn@ubuntu.com); Greg
> Kroah-Hartman; containers@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org
> Subject: Re: Could not mount sysfs when enable userns but disable netns
> 
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> >> Hello,
> >>
> >> How to reproduce:
> >> 1. Prepare a container, enable userns and disable netns
> >> 2. use libvirt-lxc to start a container
> >> 3. libvirt could not mount sysfs then failed to start.
> >>
> >> Then I found that
> >> commit 7dc5dbc879bd0779924b5132a48b731a0bc04a1e says:
> >> "Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
> >> over the net namespace."
> >>
> >> But why should we check sysfs mouont permission over net namespace?
> >> We've already checked CAP_SYS_ADMIN though.
> 
> We already checked capable(CAP_SYS_ADMIN) and it failed.

But on my machine, capable(CAP_SYS_ADMIN) passed
but failed in kobj_ns_current_may_mount.

I added some printks in sysfs_mount:
        if (!(flags & MS_KERNMOUNT)) {
-               if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
+               if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type)) {
+                       printk(KERN_WARNING "Failed in capable\n");
                        return ERR_PTR(-EPERM);
+                }
 
-               if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
+               if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET)) {
+                       printk(KERN_WARNING "Failed in kobj_ns_current_may_mount\n");
                        return ERR_PTR(-EPERM);
+                }

And found: 
Jul 14 09:55:26 localhost systemd: Starting Container lxc-chx.
Jul 14 09:55:26 localhost systemd-machined: New machine lxc-chx.
Jul 14 09:55:26 localhost systemd: Started Container lxc-chx.
Jul 14 09:55:26 localhost kernel: [  784.044709] Failed in kobj_ns_current_may_mount
Jul 14 09:55:26 localhost systemd-machined: Machine lxc-chx terminated.

> 
> >> What the relationship between sysfs and net namespace,
> >> or this check is a little redundant?
> 
> You want a bind mount not a new fresh mount.
> 

Yes, we need to modify libvirt's codes to deal with sysfs
when enable userns but disable netns.

Thanks,
- Chen

> When looking at how evil actors could abuse things it turned out that in
> some circumstances the root user (before a user namespace is created)
> needs to control the policy on which filesystems may be mounted.  There
> are files in sysfs and in proc that you never want to see in a chroot
> jail, as they just create more surface area to attack.
> 
> The only reason for creating a new fresh mount of sysfs is to get access
> to /sys/class/net.  So to keep things simple we restrict creation of
> that mount to cases where the mounter has permisions over the network
> namespace, and cases where nothing interesing is mounted on top of
> sysfs.
> 
> If a new /sys/class/net is not needed it is possible to bind mount the
> existing copy of sysfs to the new location without loss of
> functionality.
> 
> > It is not redundant.  The whole point is that after clone(CLONE_NEWUSER)
> > you get a newly filled set of capabilities.  But you should not have
> > privileges over the host's network namesapce.  After you unshare a new
> > network namespace, you *should* have privilege over it.  So the fact
> > that we've already check CAP_SYS_ADMIN means nothing, because the
> > capabilities need to be targeted.
> 
> Exactly the tests are failing because the caller is not the global root
> and so the code is properly failing the permission checks.
> 
> Eric
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
