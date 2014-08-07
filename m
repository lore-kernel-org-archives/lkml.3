Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaHGCm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 22:42:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12586 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbaHGCm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 22:42:56 -0400
Message-ID: <53E2E79F.6040903@huawei.com>
Date: Thu, 7 Aug 2014 10:42:39 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
CC: Dave Kleikamp <dave.kleikamp@oracle.com>, <linux-ext4@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: testing result of loop-aio patchset on ext3
References: <53C3A42E.40000@huawei.com> <alpine.LFD.2.00.1407141142520.13527@localhost.localdomain> <53C5F770.9030105@huawei.com> <alpine.LFD.2.00.1407160955010.2431@localhost.localdomain> <53C645AA.9080509@huawei.com> <alpine.LFD.2.00.1407181105410.12453@localhost.localdomain> <53CC7C47.9040001@huawei.com>
In-Reply-To: <53CC7C47.9040001@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.22.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/21 10:34, Rui Xiang wrote:
> On 2014/7/18 17:10, Lukáš Czerner wrote:
>> On Wed, 16 Jul 2014, Rui Xiang wrote:
>>
>>> Date: Wed, 16 Jul 2014 17:28:10 +0800
>>> From: Rui Xiang <rui.xiang@huawei.com>
>>> To: Lukáš Czerner <lczerner@redhat.com>
>>> Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-ext4@vger.kernel.org,
>>>     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
>>>     Li Zefan <lizefan@huawei.com>
>>> Subject: Re: testing result of loop-aio patchset on ext3
>>>
>>> On 2014/7/16 15:58, Lukáš Czerner wrote:
>>>> On Wed, 16 Jul 2014, Rui Xiang wrote:
>>>>
>>>>> Date: Wed, 16 Jul 2014 11:54:24 +0800
>>>>> From: Rui Xiang <rui.xiang@huawei.com>
>>>>> To: Lukáš Czerner <lczerner@redhat.com>
>>>>> Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-ext4@vger.kernel.org,
>>>>>     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
>>>>>     Li Zefan <lizefan@huawei.com>
>>>>> Subject: Re: testing result of loop-aio patchset on ext3
>>>>>
>>>>> On 2014/7/14 17:51, Lukáš Czerner wrote:
>>>>>> On Mon, 14 Jul 2014, Rui Xiang wrote:
>>>>>>
>>>>>>> Date: Mon, 14 Jul 2014 17:34:38 +0800
>>>>>>> From: Rui Xiang <rui.xiang@huawei.com>
>>>>>>> To: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-ext4@vger.kernel.org
>>>>>>> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
>>>>>>>     Li Zefan <lizefan@huawei.com>
>>>>>>> Subject: testing result of loop-aio patchset on ext3
>>>>>>>
>>>>>>> Hi Dave,
>>>>>>>
>>>>>>> We export a container image file as a block device via loop device, but we
>>>>>>> found it's very easy that the container rootfs gets corrupted due to power
>>>>>>> loss.
>>>>>>>
>>>>>>> Your early version of loop-aio patchset said the patchset can make loop
>>>>>>> mounted filesystems recoverable(lkml.org/lkml/2012/3/30/317), but we found
>>>>>>> it doesn't help.
>>>>>>>
>>>>>>> Both the guest fs and host fs are ext3.
>>>>>>>
>>>>>>> The loop-aio patchset is from:
>>>>>>> git://github.com/kleikamp/linux-shaggy.git aio_loop
>>>>>>>
>>>>>>> Steps:
>>>>>>> 1. dd a 10G image, mkfs.ext3,
>>>>>>>   # dd if=/dev/zero of=./raw_image bs=1M count=10000
>>>>>>>   # echo y | mkfs.ext3 raw_image
>>>>>>>
>>>>>>> 2. losetup a loop device, mount at ./test_dir
>>>>>>>   # losetup /dev/loop1 raw_image
>>>>>>>   # mount /dev/loop1 ./test_dir
>>>>>>>
>>>>>>> 3. copy fs_mark into test_dir and run
>>>>>>>   # ./fs_mark -d ./tmp/ -s 102400000 -n 80
>>>>>>>
>>>>>>> 4. during runing fs_mark, make systerm reboot indirectly.
>>>>>>>   # echo b > /proc/sysrq-trigger
>>>>>>>
>>>>>>> After systerm booted up, sometimes fsck reported raw_image fs has been damaged.
>>>>>>>
>>>>>>> # fsck.ext3 -n raw_image
>>>>>>> e2fsck 1.41.9 (22-Aug-2009)
>>>>>>> Warning: skipping journal recovery because doing a read-only filesystem check.
>>>>>>> raw_image contains a file system with errors, check forced.
>>>>>>> Pass 1: Checking inodes, blocks, and sizes
>>>>>>> Pass 2: Checking directory structure
>>>>>>> Pass 3: Checking directory connectivity
>>>>>>> Pass 4: Checking reference counts
>>>>>>> Pass 5: Checking group summary information
>>>>>>> Free blocks count wrong (2481348, counted=2480577).
>>>>>>> Fix? no
>>>>>>> Free inodes count wrong (640837, counted=640835).
>>>>>>> Fix? no
>>>>>>> raw_image: ********** WARNING: Filesystem still has errors **********
>>>>>>> raw_image: 11/640848 files (0.0% non-contiguous), 78652/2560000 blocks
>>>>>>
>>>>>> It's not damaged, this is expected result if you're using old
>>>>>> e2fsprogs which still treats this as an error.
>>>>>>
>>>>>> It's not an error because we only update superblock summary at
>>>>>> unmount time so with unclean shutdown it's likely that it does not
>>>>>> match the reality, but e2fsck can and will easily fix that for you.
>>>>>>
>>>>>> Please try e2fsprogs v1.42.3 or newer.
>>>>>>
>>>>>
>>>>> Hi Lukas,
>>>>>
>>>>> I updated e2fsprogs to v1.42.3, and user the newer fsck.ext3 to check raw_image.
>>>>> Exactly, the result seemed normal.
>>>>
>>>> Now I can see that there are much more problems than before, that's
>>>> weird. Sorry for not making this clear, but for this kind of
>>>> reproducers please use the most recent e2fsprogs. Also , what is the
>>>> kernel version you're using in this test ?
>>>>
>>>
>>> I use the most recent e2fsprogs 1.42.11 to check, and the error info is same as
>>> result fscked by v1.42.3. It seems that shouldn't be the reason.
>>>
>>> Otherwise, the kernel version in this test is stable 3.4.
>>
>> In that case, this is a problem somewhere else. I'll try to
>> reproduce and see what I can see.
>>
>> I assume you're not able to reproduce this on a real device ?
>>
> 
> Yes, it only exits on a loop device in my test.
> 
> Otherwise, There was another case in this test:
> 
> I fsck the err image with "-n", the result contains 7 issues.
> 
> # fsck.ext3 -n image1
> Warning: skipping journal recovery because doing a read-only filesystem check.
> image1 has been mounted 36 times without being checked, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> *Inode 16407, i_size is 643005, should be 647168.  Fix? no
> *Inode 16407, i_blocks is 1264, should be 1272.  Fix? no
> *Inode 409941, i_blocks is 200208, should be 16688.  Fix? no
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> *Block bitmap differences:  -1643951 +1644741 -(1646592--1646598) +(1648640--1648646) -(1657079--1658102) -(1658104--1659127) -(1659129--1660152) -(1660154--1661177) -(1661179--1662202) -(1662204--1663227) -(1663229--1664252) -(1664254--1665277) -(1665279--1666302) -(1666304--1667327) -(1667329--1668352) -(1668354--1669377) -(1669379--1670402) -(1670404--1671167) -(1671688--1671947) -(1671949--1672972) -(1672974--1673997) -(1673999--1675022) -(1675024--1676047) -(1676049--1677072) -(1677074--1678097) -(1678099--1679122) -(1679124--1680147) -(1680149--1680560)
> Fix? no
> *Free blocks count wrong for group #2 (31522, counted=31520).
> Fix? no
> *Free blocks count wrong for group #43 (15870, counted=15871).
> Fix? no
> *Free blocks count wrong for group #45 (398, counted=396).
> Fix? no
> *Free blocks count wrong (2203971, counted=2203968).
> Fix? no
> image1: ********** WARNING: Filesystem still has errors **********
> image1: 13008/655360 files (0.3% non-contiguous), 417469/2621440 blocks
> 
> When I "fsck -y" the image, it seems that only fixes 1 issue.
> 
> # fsck.ext3 -y image1
> image1: recovering journal
> image1 has been mounted 36 times without being checked, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> *Free blocks count wrong (2203971, counted=2203968).
> Fix<y>? yes
> image1: ***** FILE SYSTEM WAS MODIFIED *****
> image1: 13008/655360 files (0.3% non-contiguous), 417472/2621440 blocks
> 
> So, I assume journal is revocered before fs checking while doing
> "fsck -y", and other issues are fixed during fs revovering journal,
>  is that?
> 

Hi Lukas,




> Thanks!
> 
>> Thanks!
>> -Lukas
>>
>>>
>>>
>>> Thanks!
>>>
>>>> Thanks!
>>>> -Lukas
>>>>
>>>>>
>>>>> Then, I continue my previous test. And after testing 35 times, "fsck -n" reported image fs
>>>>> had been damaged, too.
>>>>>
>>>>>  # fsck.ext3 -n image1
>>>>> e2fsck 1.42.3.wc1 (28-May-2012)
>>>>> Warning: skipping journal recovery because doing a read-only filesystem check.
>>>>> image1 has been mounted 36 times without being checked, check forced.
>>>>> Pass 1: Checking inodes, blocks, and sizes
>>>>> Inode 16407, i_size is 597447, should be 602112.  Fix? no
>>>>> Inode 16407, i_blocks is 1176, should be 1184.  Fix? no
>>>>> Inode 409941, i_blocks is 200208, should be 112.  Fix? no
>>>>> Pass 2: Checking directory structure
>>>>> Pass 3: Checking directory connectivity
>>>>> Pass 4: Checking reference counts
>>>>> Pass 5: Checking group summary information
>>>>> Block bitmap differences:  -1506836 -1506843 -(1506859--1506860) -(1660941--1661964) -(1661966--1671167) -(1671688--1686473)
>>>>> Fix? no
>>>>> Free blocks count wrong for group #2 (31558, counted=31556).
>>>>> Fix? no
>>>>> Free blocks count wrong for group #43 (15871, counted=15867).
>>>>> Fix? no
>>>>> Free blocks count wrong (2204041, counted=2204035).
>>>>> Fix? no
>>>>> image1: ********** WARNING: Filesystem still has errors **********
>>>>> image1: 13008/655360 files (0.3% non-contiguous), 417399/2621440 blocks
>>>>>
>>>>> I backup the image to image_bk, and then mount the image to a dir, and cat all files in the image.
>>>>> Steps:
>>>>> # dd if=image1 of=image_bk
>>>>> # mount image1 err_dir
>>>>> # find -name '*' -exec cat > /dev/null {} \;
>>>>>
>>>>> There are no issues during catting, and no err in dmesg too.
>>>>>
>>>>> *But when I umount the image1 from err_dir, The fsck result didn't show any fs corruption info.
>>>>>
>>>>> I mount image_bk to err_dir and umount it with no operation directly. The result is same to iamge1.
>>>>>
>>>>> *So, is fs in the image as a block device via loop device damaged really, or does it have some others issues? 
>>>>> Could you give me some opinions?
>>>>>
>>>>>
>>>>> Thanks.
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


