Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaIDE5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:57:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29347 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaIDE5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:57:40 -0400
Message-ID: <5407F124.5070203@oracle.com>
Date: Thu, 04 Sep 2014 12:57:08 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: david@fromorbit.com, xuejiufei@huawei.com, ming.lei@canonical.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set
References: <1409723694-16047-1-git-send-email-junxiao.bi@oracle.com>	<20140903161000.f383fa4c1a4086de054cb6a0@linux-foundation.org>	<5407C989.50605@oracle.com> <20140903193058.2bc891a7.akpm@linux-foundation.org>
In-Reply-To: <20140903193058.2bc891a7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 10:30 AM, Andrew Morton wrote:
> On Thu, 04 Sep 2014 10:08:09 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
> 
>> On 09/04/2014 07:10 AM, Andrew Morton wrote:
>>> On Wed,  3 Sep 2014 13:54:54 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
>>>
>>>> commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O during memory allocation")
>>>> introduces PF_MEMALLOC_NOIO flag to avoid doing I/O inside memory allocation, __GFP_IO is cleared
>>>> when this flag is set, but __GFP_FS implies __GFP_IO, it should also be cleared. Or it may still
>>>> run into I/O, like in superblock shrinker.
>>>
>>> Is there an actual bug which inspired this fix?  If so, please describe
>>> it.
>>>
>> Yes, an ocfs2 deadlock bug is related to this, there is a workqueue in
>> ocfs2 who is for building tcp connections and processing ocfs2 message.
>> Like when an new node is up in ocfs2 cluster, the workqueue will try to
>> build the connections to it, since there are some common code in
>> networking like sock_alloc() using GFP_KERNEL to allocate memory, direct
>> reclaim will be triggered and call into superblock shrinker if available
>> memory is not enough even set PF_MEMALLOC_NOIO for the workqueue. To
>> shrink the inode cache, ocfs2 needs release cluster lock and this
>> depends on workqueue to do it, so cause the deadlock. Not sure whether
>> there are similar issue for other cluster fs, like nfs, it is possible
>> rpciod hung like the ocfs2 workqueue?
> 
> All this info should be in the changelog.
> 
>>
>>> I don't think it's accurate to say that __GFP_FS implies __GFP_IO. 
>>> Where did that info come from?
>> __GFP_FS allowed callback into fs during memory allocation, and fs may
>> do io whatever __GFP_IO is set?
> 
> __GFP_FS and __GFP_IO are (or were) for communicating to vmscan: don't
> enter the fs for writepage, don't write back swapcache.
> 
> I guess those concepts have grown over time without a ton of thought
> going into it.  Yes, I suppose that if a filesystem's writepage is
> called (for example) it expects that it will be able to perform
> writeback and it won't check (or even be passed) the __GFP_IO setting.
> 
> So I guess we could say that !__GFP_FS && GFP_IO is not implemented and
> shouldn't occur.
> 
> That being said, it still seems quite bad to disable VFS cache
> shrinking for PF_MEMALLOC_NOIO allocation attempts.
Even without this ocfs2 deadlock bug, the implement of PF_MEMALLOC_NOIO
is wrong. See the deadlock case described in its log below. Let see the
case "block device runtime resume", since __GFP_FS is not cleared, it
could run into fs writepage and cause deadlock.


>From 21caf2fc1931b485483ddd254b634fa8f0099963 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@canonical.com>
Date: Fri, 22 Feb 2013 16:34:08 -0800
Subject: [PATCH] mm: teach mm by current context info to not do I/O during
 memory allocation

This patch introduces PF_MEMALLOC_NOIO on process flag('flags' field of
'struct task_struct'), so that the flag can be set by one task to avoid
doing I/O inside memory allocation in the task's context.

The patch trys to solve one deadlock problem caused by block device, and
the problem may happen at least in the below situations:

- during block device runtime resume, if memory allocation with
  GFP_KERNEL is called inside runtime resume callback of any one of its
  ancestors(or the block device itself), the deadlock may be triggered
  inside the memory allocation since it might not complete until the block
  device becomes active and the involed page I/O finishes.  The situation
  is pointed out first by Alan Stern.  It is not a good approach to
  convert all GFP_KERNEL[1] in the path into GFP_NOIO because several
  subsystems may be involved(for example, PCI, USB and SCSI may be
  involved for usb mass stoarage device, network devices involved too in
  the iSCSI case)

- during block device runtime suspend, because runtime resume need to
  wait for completion of concurrent runtime suspend.

- during error handling of usb mass storage deivce, USB bus reset will
  be put on the device, so there shouldn't have any memory allocation with
  GFP_KERNEL during USB bus reset, otherwise the deadlock similar with
  above may be triggered.  Unfortunately, any usb device may include one
  mass storage interface in theory, so it requires all usb interface
  drivers to handle the situation.  In fact, most usb drivers don't know
  how to handle bus reset on the device and don't provide .pre_set() and
  .post_reset() callback at all, so USB core has to unbind and bind driver
  for these devices.  So it is still not practical to resort to GFP_NOIO
  for solving the problem.

Thanks,
Junxiao.
> 
>>>
>>> And the superblock shrinker is a good example of why this shouldn't be
>>> the case.  The main thing that code does is to reclaim clean fs objects
>>> without performing IO.  AFAICT the proposed patch will significantly
>>> weaken PF_MEMALLOC_NOIO allocation attempts by needlessly preventing
>>> the kernel from reclaiming such objects?
>> Even fs didn't do io in superblock shrinker, it is possible for a fs
>> process who is not convenient to set GFP_NOFS holding some fs lock and
>> call back fs again?
>>
>> PF_MEMALLOC_NOIO is only set for some special processes. I think it
>> won't affect much.
> 
> Maybe not now.  But once we add hacks like this, people say "goody" and
> go and use them rather than exerting the effort to sort out their
> deadlocks properly :( There will be more PF_MEMALLOC_NOIO users in
> 2019.
> 
> Dunno, I'd like to hear David's thoughts but perhaps it would be better
> to find some way to continue to permit PF_MEMALLOC_NOIO to shrink VFS
> caches for most filesystems and find some fs-specific fix for ocfs2. 
> That would mean testing PF_MEMALLOC_NOIO directly I guess.
> 

