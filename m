Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaCVU3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:29:31 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43442 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaCVU32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:29:28 -0400
Message-ID: <532DF2F2.6040005@gmail.com>
Date: Sat, 22 Mar 2014 21:30:42 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Can't umount /mnt/dev after calling dd(1) and with /mnt/dev is
 a bind mount
References: <532DBFC8.4020202@gmail.com> <20140322192404.GG18016@ZenIV.linux.org.uk>
In-Reply-To: <20140322192404.GG18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/22/2014 08:24 PM, Al Viro wrote:
> On Sat, Mar 22, 2014 at 05:52:24PM +0100, Francis Moreau wrote:
>> I'm posting here because it might be a behaviour related to the kernel
>> internals that I can't explain from my user point of view :)
>>
>> Basically I'm doing this:
>>
>>   mount -o bind /dev/ /mnt/dev &&
>>   chroot /mnt dd bs=440 conv=notrunc count=1 if=gptmbr.bin of=/dev/loop0
>>   umount /mnt/dev
>>
>> but umount gives the following error: "umount: /mnt/dev: target is busy"
> 
> What do you have in /proc/self/mountinfo before all that?
> 

here it is:

$ cat /proc/self/mountinfo  
15 19 0:3 / /proc rw,nosuid,nodev,noexec,relatime shared:5 - proc proc rw
16 19 0:14 / /sys rw,nosuid,nodev,noexec,relatime shared:6 - sysfs sys rw
17 19 0:5 / /dev rw,nosuid,relatime shared:2 - devtmpfs dev rw,size=8152392k,nr_inodes=2038098,mode=755
18 19 0:15 / /run rw,nosuid,nodev,relatime shared:12 - tmpfs run rw,mode=755
19 1 8:17 / / rw,relatime shared:1 - ext4 /dev/sdb1 rw,discard,data=ordered
20 16 0:16 / /sys/kernel/security rw,nosuid,nodev,noexec,relatime shared:7 - securityfs securityfs rw
21 17 0:17 / /dev/shm rw,nosuid,nodev shared:3 - tmpfs tmpfs rw
22 17 0:11 / /dev/pts rw,nosuid,noexec,relatime shared:4 - devpts devpts rw,gid=5,mode=620,ptmxmode=000
23 16 0:18 / /sys/fs/cgroup rw,nosuid,nodev,noexec shared:8 - tmpfs tmpfs rw,mode=755
24 23 0:19 / /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime shared:9 - cgroup cgroup rw,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd
25 16 0:20 / /sys/fs/pstore rw,nosuid,nodev,noexec,relatime shared:10 - pstore pstore rw
26 16 0:21 / /sys/firmware/efi/efivars rw,nosuid,nodev,noexec,relatime shared:11 - efivarfs efivarfs rw
27 23 0:22 / /sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime shared:13 - cgroup cgroup rw,cpuset
28 23 0:23 / /sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime shared:14 - cgroup cgroup rw,cpuacct,cpu
29 23 0:24 / /sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime shared:15 - cgroup cgroup rw,memory
30 23 0:25 / /sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime shared:16 - cgroup cgroup rw,devices
31 23 0:26 / /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime shared:17 - cgroup cgroup rw,freezer
32 23 0:27 / /sys/fs/cgroup/net_cls rw,nosuid,nodev,noexec,relatime shared:18 - cgroup cgroup rw,net_cls
33 23 0:28 / /sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime shared:19 - cgroup cgroup rw,blkio
34 15 0:29 / /proc/sys/fs/binfmt_misc rw,relatime shared:20 - autofs systemd-1 rw,fd=21,pgrp=1,timeout=300,minproto=5,maxproto=5,direct
35 16 0:7 / /sys/kernel/debug rw,relatime shared:21 - debugfs debugfs rw
36 17 0:13 / /dev/mqueue rw,relatime shared:22 - mqueue mqueue rw
37 17 0:30 / /dev/hugepages rw,relatime shared:23 - hugetlbfs hugetlbfs rw
39 16 0:32 / /sys/kernel/config rw,relatime shared:24 - configfs configfs rw
38 19 0:31 / /tmp rw shared:25 - tmpfs tmpfs rw
40 34 0:33 / /proc/sys/fs/binfmt_misc rw,relatime shared:26 - binfmt_misc binfmt_misc rw
42 19 8:1 / /boot rw,relatime shared:27 - vfat /dev/sda1 rw,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro
43 19 254:0 / /home rw,relatime shared:28 - ext4 /dev/bcache0 rw,data=ordered
77 18 0:35 / /run/user/1000 rw,nosuid,nodev,relatime shared:61 - tmpfs tmpfs rw,size=1631108k,mode=700,uid=1000,gid=100
79 16 0:36 / /sys/fs/fuse/connections rw,relatime shared:63 - fusectl fusectl rw
81 77 0:37 / /run/user/1000/gvfs rw,nosuid,nodev,relatime shared:65 - fuse.gvfsd-fuse gvfsd-fuse rw,user_id=1000,group_id=100
44 19 7:2 / /mnt rw,relatime shared:29 - ext4 /dev/loop0p2 rw,data=ordered

Thanks
