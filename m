Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaAPATh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:19:37 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43692 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaAPATf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:19:35 -0500
MIME-Version: 1.0
In-Reply-To: <20140116000516.GB4724@localhost>
References: <20140115121201.GA16953@localhost>
	<20140115122401.GB18065@localhost>
	<CAGXu5jL5zZwhEtPG=-1UNJ-AgKdFNeLzk-EoYdAzjMWQbBUK4Q@mail.gmail.com>
	<20140116000516.GB4724@localhost>
Date: Wed, 15 Jan 2014 16:19:34 -0800
X-Google-Sender-Auth: 1Td6Vr3ffIS0QvilhFmmm0SfnsY
Message-ID: <CAGXu5jJUMr7DBRNF8rpuO33UKhwB3zVs=NWBO7G7pZ=FysKnLA@mail.gmail.com>
Subject: Re: [x86, kaslr] PANIC: early exception 0e rip 10:ffffffff8ae04c6e
 error 0 cr2 ffffffff81972b28
From: Kees Cook <keescook@chromium.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible this is the bug that was fixed with "x86, relocs: add
percpu fixup for GNU ld 2.23"?

82fa9637a2ba285bcc7c5050c73010b2c1b3d803 doesn't include the full
x86,kalsr (and x86,relocs) series, so I'm not sure it's a good place
to test.

-Kees


On Wed, Jan 15, 2014 at 4:05 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Wed, Jan 15, 2014 at 02:32:52PM -0800, Kees Cook wrote:
>> On Wed, Jan 15, 2014 at 4:24 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> > Kees,
>> >
>> > This script can reproduce the problem. Please modify the -initrd line
>> > before use.
>> >
>> > Usage:
>> >         ./kvm-0day.sh vmlinuz-3.12.0-rc4-00008-g6e6a493
>> >
>> > #!/bin/bash
>> >
>> > kernel=$1
>> >
>> > kvm=(
>> >         qemu-system-x86_64 -cpu kvm64 -enable-kvm
>> >         -kernel $kernel
>> >         -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz
>> >         # -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz
>> >         # -initrd /kernel-tests/initrd/quantal-core-i386.cgz
>> >         # -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz
>> >         -smp 2
>> >         -m 256M
>> >         -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>> >         -net user,vlan=0
>> >         -net nic,vlan=1,model=e1000
>> >         -net user,vlan=1
>> >         -boot order=nc
>> >         -no-reboot
>> >         -watchdog i6300esb
>> >         -serial stdio
>> >         -display none
>> >         -monitor null
>> > )
>> >
>> > append=(
>> >         debug
>> >         sched_debug
>> >         apic=debug
>> >         ignore_loglevel
>> >         # dyndbg=\"func kobject_release +p\"
>> >         sysrq_always_enabled
>> >         panic=10
>> >         prompt_ramdisk=0
>> >         earlyprintk=ttyS0,115200
>> >         console=ttyS0,115200
>> >         console=tty0
>> >         vga=normal
>> >         root=/dev/ram0
>> >         rw
>> > )
>> >
>> > "${kvm[@]}" --append "${append[*]}"
>>
>> Thanks! I'm using your yocto image and this script, but I still am not
>> encountering the problem. I'm building next-20140114 using the
>> randconfig you sent in the original report. It looks like you're built
>> against a slightly different kernel version? Is there some way you can
>> push the tree you're building to git somewhere for me to fetch?
>
> Kees, judging from the below bisect log, next-20140114 boots fine.
> If you still have access to commit 82fa9637a2ba285bcc7c5050c73010b2c1b3d803
> in the tip tree, it's the right one to test.
>
> git bisect start 6e6a4932b0f569b1a5bb4fcbf5dde1b1a42f01bb v3.11 --
> git bisect good b7c09ad4014e3678e8cc01fdf663c9f43b272dc6  # 22:54     20+      0  Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
> git bisect good 654fdd041227d7de1594baa61c58f2c87bd0640f  # 23:15     20+      1  Merge branch 'x86-urgent-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 0b936842c86392dad2c880539e824881e5d8ba77  # 23:35     20+      0  Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
> git bisect good 3dbecf0aa9692cffbb71313a380c0ecc606c5920  # 23:56     20+      0  Merge tag 'xfs-for-linus-v3.12-rc4' of
> git://oss.sgi.com/xfs/xfs
> git bisect good 13caa8ed93513dd216ede0c84d833e39fc2e3e2a  # 00:06     20+      0  Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
> git bisect good 8ab3820fd5b2896d66da7bb2a906bc382e63e7bc  # 00:18     20+      0  x86, kaslr: Return location from decompress_kernel
> git bisect  bad 82fa9637a2ba285bcc7c5050c73010b2c1b3d803  # 00:18      0-    988  x86, kaslr: Select random position from e820 maps
> git bisect good 5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3  # 00:27     20+     52  x86, kaslr: Provide randomness functions
> # first bad commit: [82fa9637a2ba285bcc7c5050c73010b2c1b3d803] x86, kaslr: Select random position from e820 maps
> git bisect good 5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3  # 00:39     60+     52  x86, kaslr: Provide randomness functions
> git bisect good 1955a14a5ba6e3c3b11117812d11dc550ccc37ae  # 00:59     60+    149  Add linux-next specific files for 20140110
> git bisect good 8bcd53c437d5fdd04fddd8c7e29ecbdc682e7ce1  # 01:22     60+     60  Revert "x86, kaslr: Select random position from e820
> maps"
> git bisect good a6da83f98267bc8ee4e34aa899169991eb0ceb93  # 01:38     60+     42  Merge branch 'merge' of
> git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
> git bisect good cf1c1d193e37b9f79eedddc6bbd71b9f5f9751e5  # 01:45     72+   1972  Add linux-next specific files for 20140114
>
> Thanks,
> Fengguang
>



-- 
Kees Cook
Chrome OS Security
