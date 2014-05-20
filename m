Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaETA4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:56:07 -0400
Received: from mail.phunq.net ([184.71.0.62]:56256 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbaETA4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:56:03 -0400
Message-ID: <537AA802.408@phunq.net>
Date: Mon, 19 May 2014 17:55:30 -0700
From: Daniel Phillips <daniel@phunq.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
References: <5376B273.7000800@partner.samsung.com> <20140518235555.GC18954@dastard>
In-Reply-To: <20140518235555.GC18954@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2014 04:55 PM, Dave Chinner wrote:
> On Fri, May 16, 2014 at 05:50:59PM -0700, Daniel Phillips wrote:
>> We would like to offer Tux3 for review for mainline merge. We have
>> prepared a new repository suitable for pulling:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/
>>
>> Tux3 kernel module files are here:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3
>>
>> Tux3 userspace tools and tests are here:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3/user?h=user
> Post patches for review, please.  Go and look at the process used to
> merge f2fs for an example of how to filesystem merged....
If nobody objects to the flood then we will be happy to post patches, 
one per file. We thought that maybe the patch flood could be avoided by 
pointing to gitweb, but if that does not work for you then here come the 
patches. Andrew wanted patches too, way back, so that would be a quorum 
I think.

     http://osdir.com/ml/linux-kernel/2009-03/msg04753.html
> Example:
>
> static const struct inode_operations tux_file_iops = {
> //      .permission     = ext4_permission,
>          .setattr        = tux3_setattr,
>          .getattr        = tux3_getattr,
> #ifdef CONFIG_EXT4DEV_FS_XATTR
> //      .setxattr       = generic_setxattr,
> //      .getxattr       = generic_getxattr,
> //      .listxattr      = ext4_listxattr,
> //      .removexattr    = generic_removexattr,
> #endif
> //      .fallocate      = ext4_fallocate,
> //      .fiemap         = ext4_fiemap,
>          .update_time    = tux3_file_update_time,
> };
This was mentioned in the cover mail, it is our shorthand for "FIXME". I 
like that usage but if it is not to your taste we will change those to 
C99 comments.
> The hacks around VFS and MM functionality need to have demonstrated
> methods for being removed. We're not going to merge that page
> forking stuff (like you were told at LSF 2013 more than a year ago:
> http://lwn.net/Articles/548091/) without rigorous design review and
> a demonstration of the solutions to all the hard corner cases it
> has.
Thank you. A design review, hack by hack, is exactly what we want. Would 
you prefer to do them all at once, or one at a time?

If one at a time, I propose starting with page forking. We are proud of 
the advantages we get from page forking. It does what "stable pages" 
does, but boosts performance instead of costing performance by cleanly 
separating frontend from backend processing. Page forking also supports 
Tux3's strong ordering, which among other things, guarantees that usage 
like "write; rename" works atomically without creating empty files on crash.
> The current code doesn't solve them (e.g. direct IO doesn't
> work in tux3), and there's no clear patch set we can review that
> demonstrates how it is all supposed to work.
If you don't mind, we will leave direct IO for after merge. Direct IO is 
an enterprise feature on our to-do list, but Implementing it right now 
does not seem like a good reason to continue working out of tree. We 
would be happy to discuss our approach to direct IO if you wish.
> i.e. you need to
> separate out all the page forking code into a separate patchset for
> review, independent of the tux3 code and applies to the core mm/
> code.
Agreed.
> Then there's all the writeback hacks. You've simply copy-n-pasted
> most of fs-writeback.c, including duplicating structures like struct
> wb_writeback_work and then hacked in crap (kallsyms lookups!) to be
> able to access core structures from kernel module context
> (tux3_setup_writeback(), I'm looking at you).
This is intentional. The files named "*_hack" were kept as close as 
possible to the original core code to clarify exactly where core needs 
to change in order to remove our workarounds. If you think we should 
pretty up that code then we will happily do it. Or maybe we can hammer 
out acceptable core patches right now, and include those with our merge 
proposal. That would make us even happier. We hate those hacks as much 
as you do.
> you need to separate out all the
> writeback changes you need into an independent patchset so that they
> can be reviewed independently of the tux3 code that uses it.
OK, patches are coming. I think it makes sense to post the core patches 
with our one-file-per-patch lkml bomb that will be coming soon. These 
will just be "git format-patch" patches from a new branch in our repository.

As an aside, I would be interested in hearing from anybody who actually 
prefers gitweb urls to patches. It doesn't really feel like a hit so far.
> Now, one of the big features tux3 you hyped is built-in snapshotting
> capability. All that talk efficient pointer trees (or whatever they
> were called) and being so much better than ZFS/btrfs-like COW.
> Well, I can't find it anywhere in the code - the only references to
> snapshots are 5 comments like this:
>
> 	* FIXME: what happen if snapshot was introduced?
We decided to add the versioning after merge because there seems to be 
no shortage of people who are more interested in base functionality like 
performance and reliability than snapshotting.It was called "versioned 
pointers" way back when and is now called "version tags". Here is the 
prototype and test harness:

https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3/devel/version.c?h=user

This should not be an obstacle to merging because neither Ext4 or XFS 
have snapshots. However, both Ext4 and XFS could practically use the 
same technique, presumably after we have proved it in Tux3. A generic 
name for the version.c approach is "fat nodes", touched on here:

     http://en.wikipedia.org/wiki/Persistent_data_structure

To use the version tags approach you need to support variable sized 
inodes so that attributes can be versioned. Otherwise, you just need a 
fancier btree leaf format. No huge changes to filesystem structure. It 
would be an interesting avenue for you to explore, if you think that  
XFS could one day get snapshots.
> IOWs, tux3 is just a prototype of a standard journaling filesystem.
No. Tux3 supports strong ordering without taking a performance hit for 
it. The technology is nothing like journalling. Tux3 is closer in spirit 
to a logging filesystem, but not very much like that either because Tux3 
does not need any cleaning pass.
> The tux3 code is still missing large parts of it's intended core
> functionality
I believe I said that.
> and there is nothing to tell us when that might
> appear.
As I said, the glaring omission is proper ENOSPC handling, which is work 
in progress. I do not view that as an obstacle to merging. After all, 
Btrfs did not have proper ENOSPC handling when it was merged. The design 
is here:

      http://phunq.net/pipermail/tux3/2014-May/002102.html
      Design note: ENOSPC again
> It really appears to me that tux3 is where btrfs was 5-6
> years ago - the core of an idea, but a long, long way from being
> feature complete or production ready. btrfs still doesn't handle
> ENOSPC well and given that tux3's is following the same development
> path (BUG on ENOSPC) it doesn't fill me with any confidence that
> tux3 is going to turn out any better than btrfs in 5 years time.
I totally agree. We take this very seriously and do not want to repeat 
that experience. You can't blame the Btrfs team, Btrfs is just really 
complicated. The progress they have made is impressive and they might be 
nearly there.

Tux3 is a lot more simple. I think that our ENOSPC design is simple and 
theoretically sound. It should get solid quickly, but we shall see.
> Really, I don't see how you plan to bring tux3 to be feature
> complete and production ready in less than 2-3 years.
That seems about right. I suppose I will be running around with Tux3 on 
my root filesystem pretty soon, but users really need to be clear on the 
fact that it takes years to make a fileystem stable. It is said that 
merging is a good way to speed that up.
> The current code is barely functional at this point
Disagree. Tux3 pases lots of stress tests including yours. It is showing 
interesting performance results, and stability is looking good. The 
atomic commit and crash recovery seems to be pretty solid. What Tux3 
needs most is to be hammered on a lot by developers.
> and there's still questions
> that haven't been answered about whether core tux3 functionality can
> even be made to work properly, let alone integrated effectively.
If you have specific questions, please raise them. I think our issues 
are actually a lot less than other filesystems that have been merged, 
including yours.
> IMO, it's a waste of time right now asking anyone to review this
> code for inclusion until it has been cleaned up, the core
> infrastructure problems have been solved and the core filesystem
> code is much closer to feature complete.....
We asked for review and you are doing a great job, very much 
appreciated. We will soldier on.

Regards,

Daniel
