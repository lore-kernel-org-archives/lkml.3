Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaH3XL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 19:11:27 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54219 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaH3XLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 19:11:25 -0400
Message-ID: <54025A07.9070109@ontolinux.com>
Date: Sun, 31 Aug 2014 01:11:03 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows NT 5.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v10 00/21] Support ext4 on NV-DIMMs
References: <cover.1409110741.git.matthew.r.wilcox@intel.com> <20140827130613.c8f6790093d279a447196f17@linux-foundation.org> <alpine.DEB.2.11.1408271616070.17080@gentwo.org> <20140827143055.5210c5fb9696e460b456eb26@linux-foundation.org> <20140828071706.GD26465@dastard>
In-Reply-To: <20140828071706.GD26465@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:VjnbLvzowePrJyUQH+jnP6TXlsDaSQiDR9APQjzTXeU
 /21n6sVol7c5R6CxUhRPa7spkz7oH5UFqGRR2AIuOSY5oMbX5y
 o8ml+V6h+See/qM3OGNdSLr3v1PqJYp01pskQw023bT92Lxvlk
 EFY1sNfCh0xSNpOBLDRCwHS7ezhTx4tVcULSnuQA4t3WOuxctt
 STk890HkUriMnsc62HQmDZToTbC8YFA/AOudfErLVHwejFQF4y
 dKUfiBLybix62kx2bKVs54p1YnHiUOxDS2gUCFClst8eTaq+ST
 kp0NZ2KBOY2tOete4LWz62MG5QyZn57XZrdTYDUG6jJBq4vwEt
 Q/kD8qWua62u5oybzbUU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the 28th of August 2014 at 09:17, Dave Chinner wrote:
> On Wed, Aug 27, 2014 at 02:30:55PM -0700, Andrew Morton wrote:
>> On Wed, 27 Aug 2014 16:22:20 -0500 (CDT) Christoph Lameter<cl@linux.com>  wrote:
>>
>>>> Some explanation of why one would use ext4 instead of, say,
>>>> suitably-modified ramfs/tmpfs/rd/etc?
>>> The NVDIMM contents survive reboot and therefore ramfs and friends wont
>>> work with it.
>> See "suitably modified".  Presumably this type of memory would need to
>> come from a particular page allocator zone.  ramfs would be unweildy
>> due to its use to dentry/inode caches, but rd/etc should be feasible.
> <sigh>

Hello Dave and the others

Thank you very much for your patience and your following summarization.

> That's where we started about two years ago with that horrible
> pramfs trainwreck.
>
> To start with: brd is a block device, not a filesystem. We still
> need the filesystem on top of a persistent ram disk to make it
> useful to applications. We can do this with ext4/XFS right now, and
> that is the fundamental basis on which DAX is built.
>
> For sake of the discussion, however, let's walk through what is
> required to make an "existing" ramfs persistent. Persistence means we
> can't just wipe it and start again if it gets corrupted, and
> rebooting is not a fix for problems.  Hence we need to be able to
> identify it, check it, repair it, ensure metadata operations are
> persistent across machine crashes, etc, so there is all sorts of
> management tools required by a persistent ramfs.
>
> But most important of all: the persistent storage format needs to be
> forwards and backwards compatible across kernel versions.  Hence we
> can't encode any structure the kernel uses internally into the
> persistent storage because they aren't stable structures.  That
> means we need to marshall objects between the persistence domain and
> the volatile domain in an orderly fashion.

Two little questions:
1. If we would omit the compatiblitiy across kernel versions only for 
theoretical reasons,
then would it make sense at all to encode a structure that the kernel 
uses internally and
what advantages could be reached in this way?
2. Have the said structures used by the kernel changed so many times?

> We can avoid using the dentry/inode *caches* by freeing those
> volatile objects the moment reference counts dop to zero rather than
> putting them on LRUs. However, we can't store them in persistent
> storage and we can't avoid using them to interface with the VFS, so
> it makes little sense to burn CPU continually marshalling such
> structures in and out of volatile memory if we have free RAM to do
> so. So even with a "persistent ramfs" caching the working set of
> volatile VFS objects makes sense from a peformance point of view.

I am sorry to say so, but I am confused again and do not understand this 
argument,
because we are already talking about NVDIMMs here. So, if we have those 
volatile
VFS objects already in NVDIMMs so to say, then we have them also in 
persistent
storage and in DRAM at the same time.

>
> Then you've got crash recovery management: NVDIMMs are not
> synchronous: they can still lose data while it is being written on
> power loss. And we can't update persistent memory piecemeal as the
> VFS code modifies metadata - there needs to be synchronisation
> points, otherwise we will always have inconsistent metadata state in
> persistent memory.
>
> Persistent memory also can't do atomic writes across multiple,
> disjoint CPU cachelines or NVDIMMs, and this is what is needed for
> synchroniation points for multi-object metadata modification
> operations to be consistent after a crash.  There is some work in
> the nvme working groups to define this, but so far there hasn't been
> any useful outcome, and then we willhave to wait for CPUs to
> implement those interfaces.
>
> Hence the metadata that indexes the persistent RAM needs to use COW
> techniques, use a log structure or use WAL (journalling).  Hence
> that "persistent ramfs" is now looking much more like a database or
> traditional filesystem.
>
> Further, it's going to need to scale to very large amounts of
> storage.  We're talking about machines with *tens of TB* of NVDIMM
> capacity in the immediate future and so free space manangement and
> concurrency of allocation and freeing of used space is going to be
> fundamental to the performance of the persistent NVRAM filesystem.
> So, you end up with block/allocation groups to subdivide the space.
> Looking a lot like ext4 or XFS at this point.
>
> And now you have to scale to indexing tens of millions of
> everything. At least tens of millions - hundreds of millions to
> billions is more likely, because storing tens of terabytes of small
> files is going to require indexing billions of files. And because
> there is no performance penalty for doing this, people will use the
> filesystem as a great big database. So now you have to have a
> scalable posix compatible directory structures, scalable freespace
> indexation, dynamic, scalable inode allocation, freeing, etc. Oh,
> and it also needs to be highly concurrent to handle machines with
> hundreds of CPU cores.
>
> Funnily enough, we already have a couple of persistent storage
> implementations that solve these problems to varying degrees. ext4
> is one of them, if you ignore the scalability and concurrency
> requirements. XFS is the other. And both will run unmodified on
> a persistant ram block device, which we *already have*.

Yeah! :D

>
> And so back to DAX. What users actually want from their high speed
> persistant RAM storage is direct, cpu addressable access to that
> persistent storage. They don't want to have to care about how to
> find an object in the persistent storage - that's what filesystems
> are for - they just want to be able to read and write to it
> directly. That's what DAX does - it provides existing filesystems
> a method for exposing direct access to the persistent RAM to
> applications in a manner that application developers are already
> familiar with. It's a win-win situation all round.
>
> IOWs, ext4/XFS + DAX gets us to a place that is good enough for most
> users and the hardware capabilities we expect to see in the next 5
> years.  And hopefully that will be long enough to bring a purpose
> built, next generation persistent memory filesystem to production
> quality that can take full advantage of the technology...

Please, if possible, then could you be so kind and give such a very good 
summarization
or a sketch about the future development path and system architecture?
How does this mentioned purpose built, next generation persistent memory 
filesystem
looks like?
How does it differ from the DAX + FS approach and which advantages will 
it offer?
Would it be some kind of an object storage system that possibly uses the 
said structures
used by the kernel (see the two little questions above again)?
Do we have to keep the term file for everything?

>
> Cheers,
>
> Dave.

With all the best
Christian Stroetmann

