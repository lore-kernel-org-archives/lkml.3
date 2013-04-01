Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3DAUV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:21:27 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63679 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3DAUV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:21:26 -0400
Message-ID: <5159EC3D.2020501@gmail.com>
Date: Tue, 02 Apr 2013 00:21:17 +0400
From: Max Filippov <jcmvbkbc@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: mkfs.f2fs gets stuck with "blk_update_request: bio idx 0 >= vcnt
 0" on 3.8
References: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com> <254789F5-7950-4239-AB7B-2DB9DC73565F@dubeyko.com>
In-Reply-To: <254789F5-7950-4239-AB7B-2DB9DC73565F@dubeyko.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 11:27 PM, Vyacheslav Dubeyko wrote:
> 
> On Apr 1, 2013, at 9:19 PM, Max Filippov wrote:
> 
>> Hi,
>>
>> I'm trying to create f2fs filesystem on SD card on pandaboard using
>> f2fs-tools v1.0.0.
>> It works fine on Linus' v3.6, but fails on both v3.8 and stable v3.8.5:
>>
>> # mkfs.f2fs /dev/mmcblk0p3
>> Info: sector size = 512
>> Info: total sectors = 11370496 (in 512bytes)
>> Info: zone aligned segment0 blkaddr: 512
>> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
>>
>> mkfs process gets stuck in D state and I see the following in the dmesg:
>>
>> [  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
>> [  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
>> [  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
>> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
>> [  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
>> [  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
>> [  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
>>
>> I'd appreciate any suggestion on what to try before I try to bisect it.
>>
> 
> Could you share "cat /proc/partitions" and "strace mkfs.f2fs /dev/mmcblk0p3" outputs? I think that these outputs can be very useful for issue analysis.
> 
> By the way, can you reproduce the issue on another SD-card? Do you reproduce the issue only under pandaboard?

Yes, I can reproduce it on three SD cards of different vendors and different sizes.
Unfortunately ATM I don't have any other board to try it on.

# cat /proc/partitions
major minor  #blocks  name

 179        0    7782400 mmcblk0
 179        1      40131 mmcblk0p1
 179        2      32130 mmcblk0p2
 179        3    5685248 mmcblk0p3

strace output is the following:

execve("/home/jcmvbkbc/opt/bin/mkfs.f2fs", ["mkfs.f2fs", "/dev/mmcblk0p3"], [/* 17 vars */]) = 0
brk(0)                                  = 0x15000
uname({sys="Linux", node="zoo.metropolis", ...}) = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f39000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=15792, ...}) = 0
mmap2(NULL, 15792, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6f35000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/arm-linux-gnueabihf/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\340%\0\0004\0\0\0"..., 512) = 512
lseek(3, 33324, SEEK_SET)               = 33324
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1120) = 1120
lseek(3, 32988, SEEK_SET)               = 32988
read(3, "A6\0\0\0aeabi\0\1,\0\0\0\0057-A\0\6\n\7A\10\1\t\2\n\4\22"..., 55) = 55
fstat64(3, {st_mode=S_IFREG|0644, st_size=34444, ...}) = 0
mmap2(NULL, 65812, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb6f0c000
mprotect(0xb6f14000, 28672, PROT_NONE)  = 0
mmap2(0xb6f1b000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x7) = 0xb6f1b000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/arm-linux-gnueabihf/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\355p\1\0004\0\0\0"..., 512) = 512
lseek(3, 888764, SEEK_SET)              = 888764
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1360) = 1360
lseek(3, 888324, SEEK_SET)              = 888324
read(3, "A4\0\0\0aeabi\0\1*\0\0\0\0057-A\0\6\n\7A\10\1\t\2\n\4\22"..., 53) = 53
fstat64(3, {st_mode=S_IFREG|0755, st_size=890124, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f34000
mmap2(NULL, 931200, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb6e28000
mprotect(0xb6efe000, 32768, PROT_NONE)  = 0
mmap2(0xb6f06000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xd6) = 0xb6f06000
mmap2(0xb6f09000, 9600, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6f09000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6e27000
set_tls(0xb6e274c0, 0xb6e27b98, 0xb6f3c048, 0xb6e274c0, 0xb6f34570) = 0
mprotect(0xb6f06000, 8192, PROT_READ)   = 0
mprotect(0xb6f1b000, 4096, PROT_READ)   = 0
mprotect(0x13000, 4096, PROT_READ)      = 0
mprotect(0xb6f3b000, 4096, PROT_READ)   = 0
munmap(0xb6f35000, 15792)               = 0
brk(0)                                  = 0x15000
brk(0x36000)                            = 0x36000
open("/etc/mtab", O_RDONLY|O_CLOEXEC)   = 3
fcntl64(3, F_GETFD)                     = 0x1 (flags FD_CLOEXEC)
fstat64(3, {st_mode=S_IFREG|0644, st_size=506, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f38000
read(3, "192.168.0.1:/tftpboot/zoo/panda_"..., 4096) = 506
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb6f38000, 4096)                = 0
open("/dev/mmcblk0p3", O_RDWR)          = 3
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(179, 3), ...}) = 0
ioctl(3, BLKSSZGET, 0xbeffc27c)         = 0
ioctl(3, BLKGETSIZE, 0x140d8)           = 0
ioctl(3, 0x301, 0xbeffc274)             = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 2), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f38000
write(1, "Info: sector size = 512\n", 24) = 24
write(1, "Info: total sectors = 11370496 ("..., 45) = 45
write(1, "Info: zone aligned segment0 blka"..., 41) = 41
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(179, 3), ...}) = 0
ioctl(3, BLKDISCARD


-- 
Thanks.
-- Max
