Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaKJROE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:14:04 -0500
Received: from skprod2.natinst.com ([130.164.80.23]:52320 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752880AbaKJROB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:14:01 -0500
Date: Mon, 10 Nov 2014 11:12:53 -0600
From: Ben Shelton <ben.shelton@ni.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH 2/4] UBIFS: Add xattr support for symlinks
Message-ID: <20141110171253.GA18047@bshelton-desktop>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
 <1414781431-2911-3-git-send-email-ben.shelton@ni.com>
 <1415628106.22887.122.camel@sauron.fi.intel.com>
MIME-Version: 1.0
In-Reply-To: <1415628106.22887.122.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 11/10/2014 11:13:04 AM,
	Serialize by Router on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 11/10/2014 11:13:04 AM,
	Serialize complete at 11/10/2014 11:13:04 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-10_04:2014-11-10,2014-11-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10, Artem Bityutskiy wrote:
> Could you please re-test this with any kernel and carefully verify
> symlinks. I think this should not work, because in case of symlinks we
> already store the link target path in the inode, and with this patch the
> target patch will be over-written with the SELinux label. I expect this
> to be seen easily on testing - symlink targets should be corrupted.
> 
> Artem.
> 

I retested this with a 3.18-rc3 kernel on one of our ARM-based targets.
The kernel has patch 1/4 with your changes, plus patches 2/4, 3/4, and
4/4 as posted.

Initially, I booted the target with SELinux disabled.  I then created
'testfile' and made a symlink 'testlink' pointing to it.  I also created
a symlink 'testlink_2' that points to /bin/bash.

I then enabled SELinux in permissive mode and rebooted the target.  As
this was the first boot into SELinux, it relabeled the filesystems and
rebooted.  After it came back up, I created 'testfile_afterrelabel' and
made a symlink 'testlink_afterrelabel' pointing to it.  In addition, I
checked the symlinks that are managed by update-alternatives.  Finally,
I ran `ls -lRZ / | grep ^l` and did not see any corrupted symlink
targets.

The results are below, and they look sane to me.  Please let me know if
there is additional testing you would like me to perform.

admin@galvanized:~# uname -a
Linux galvanized 3.18.0-rc3-ni-04094-g7b78529 #1 SMP Mon Nov 10 09:59:06 CST 2014 armv7l GNU/Linux
admin@galvanized:~# mount | grep ubifs
ubi1:rootfs on / type ubifs (rw,relatime,seclabel)
ubi0:bootfs on /boot type ubifs (rw,noatime,sync,seclabel)
ubi0:config on /etc/natinst/share type ubifs (rw,relatime,sync,seclabel)
admin@galvanized:~# pwd
/home/admin
admin@galvanized:~# ls -lZ
total 8
-rw-r--r--. 1 admin administrators user_u:object_r:user_home_t 15 Nov 10 16:20 testfile
-rw-r--r--. 1 admin administrators root:object_r:user_home_t   21 Nov 10 16:50 testfile_afterrelabel
lrwxrwxrwx. 1 admin administrators user_u:object_r:user_home_t  8 Nov 10 16:21 testlink -> testfile
lrwxrwxrwx. 1 admin administrators user_u:object_r:user_home_t  9 Nov 10 16:21 testlink_2 -> /bin/bash
lrwxrwxrwx. 1 admin administrators root:object_r:user_home_t   21 Nov 10 16:51 testlink_afterrelabel -> testfile_afterrelabel
admin@galvanized:~# which ls     
/bin/ls
admin@galvanized:~# ls -lZ /bin/ls
lrwxrwxrwx. 1 admin administrators system_u:object_r:bin_t 12 Nov 10 16:08 /bin/ls -> ls.coreutils
admin@galvanized:~# ls -lZ /bin/grep
lrwxrwxrwx. 1 admin administrators system_u:object_r:bin_t 25 Nov  5 20:39 /bin/grep -> /usr/lib/busybox/bin/grep

Best,
Ben
