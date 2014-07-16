Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaGPUSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:18:43 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:56779 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaGPUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:18:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21446.56861.789139.773769@quad.stoffel.home>
Date: Wed, 16 Jul 2014 16:18:37 -0400
From: "John Stoffel" <john@stoffel.org>
To: Mason <mpeg.blue@free.fr>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: After unlinking a large file on ext4, the process stalls for a
 long time
In-Reply-To: <53C6B38A.3000100@free.fr>
References: <53C687B1.30809@free.fr>
	<21446.38705.190786.631403@quad.stoffel.home>
	<53C6B38A.3000100@free.fr>
X-Mailer: VM 8.2.0b under 23.4.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mason> (I hope you'll forgive me for reformatting the quote characters
Mason> to my taste.)

No problem.

Mason> On 16/07/2014 17:16, John Stoffel wrote:

>> Mason wrote:
>> 
>>> I'm using Linux (3.1.10 at the moment) on a embedded system
>>> similar in spec to a desktop PC from 15 years ago (256 MB RAM,
>>> 800-MHz CPU, USB).
>> 
>> Sounds like a Raspberry Pi...  And have you investigated using
>> something like XFS as your filesystem instead?

Mason> The system is a set-top box (DVB-S2 receiver). The system CPU is
Mason> MIPS 74K, not ARM (not that it matters, in this case).

So it's a slow slow box... and it's only going to handle writing data
at 3Mbs... so why do you insist that the filesystem work at magic
speeds?  

Mason> No, I have not investigated other file systems (yet).

>>> I need to be able to create large files (50-1000 GB) "as fast
>>> as possible".  These files are created on an external hard disk
>>> drive, connected over Hi-Speed USB (typical throughput 30 MB/s).
>> 
>> Really... so you just need to create allocations of space as quickly
>> as possible,

Mason> I may not have been clear. The creation needs to be fast (in UX terms,
Mason> so less than 5-10 seconds), but it only occurs a few times during the
Mason> lifetime of the system.

If this only happens a few times, why do you care how quick the delete
is?  And if it's only happening a few times, why don't you just do the
space reservation OUTSIDE of the filesystem? 

Or do you need to do encryption of these containers and strictly
segrate them?  Basically, implement a daemon which knows how much free
space is on the device, how much is already pre-committed to other
users, and then how much free space there is.  

If the space isn't actually used, then you don't care, because you've
reserved it.  

>> which will then be filled in later with actual data?

Mason> Yes. In fact, I use the loopback device to format the file as an
Mason> ext4 partition. 

Why are you doing it like this?  What advantage does this buy you?  In
any case, you're now slowing things down because you have the overhead
of the base filesystem, which you then create a large file on top of,
which you then mount and format with a SECOND filesystem.  

Instead, you should probably just have a small boot/OS filesystem, and
then put the rest of the storage under LVM control.  At that point,
you can reserve space using 'lvcreate ...' which will succeed or
fail.  If good, create a filesystem in there and use it.  When you
need to delete it, just unmount the LV and just do 'lvdestroy' which
should be much faster, since you won't bother to zero out the blocks.

Now I don't know offhand if lvcreate ontop of a recently deleted LV
volume whill make sure to zero all the blocks, but I suspect so, and
probably only when they're used.

Does this make more sense?  It seems to fit your strange requirements
better...

John


>> basically someone will say "give me 600G of space reservation" and
>> then will eventually fill it up, otherwise you say "Nope, can't do
>> it!"

Mason> Right, take a 1000 GB disk,
Mason> Reserve(R1 = 300 GB) <- SUCCESS
Mason> Reserve(R2 = 300 GB) <- SUCCESS
Mason> Reserve(R3 = 300 GB) <- SUCCESS
Mason> Reserve(R4 = 300 GB) <- FAIL
Mason> Delete (R1)          <- SUCCESS
Mason> Reserve(R4 = 300 GB) <- SUCCESS

>>> So I create an ext4 partition with
>>> $ mkfs.ext4 -m 0 -i 1024000 -O ^has_journal,^huge_file /dev/sda1
>>> (Using e2fsprogs-1.42.10 if it matters)
>>> 
>>> And mount with "typical" mount options
>>> $ mount -t ext4 /dev/sda1 /mnt/hdd -o noexec,noatime
>>> /dev/sda1 on /mnt/hdd type ext4 (rw,noexec,noatime,barrier=1)
>>> 
>>> I wrote a small test program to create a large file, then immediately
>>> unlink it.
>>> 
>>> My problem is that, while file creation is "fast enough" (4 seconds
>>> for a 300 GB file) and unlink is "immediate", the process hangs
>>> while it waits (I suppose) for the OS to actually complete the
>>> operation (almost two minutes for a 300 GB file).

Mason> [snip performance numbers]

>>> QUESTIONS:
>>> 
>>> 1) Did I provide enough information for someone to reproduce?
>> 
>> Sure, but you didn't give enough information to explain what you're
>> trying to accomplish here.  And what the use case is.  Also, since you
>> know you cannot fill 500Gb in any sort of reasonable time over USB2,
>> why are you concerned that the delete takes so long?

Mason> I don't understand your question. If the user asks to create a 300 GB
Mason> file, then immediately realizes than he won't need it, and asks for it
Mason> to be deleted, I don't see why the process should hang for 2 minutes.

Mason> The use case is
Mason> - allocate a large file
Mason> - stick a file system on it
Mason> - store stuff (typically video files) inside this "private" FS
Mason> - when the user decides he doesn't need it anymore, unmount and unlink
Mason> (I also have a resize operation in there, but I wanted to get the
Mason> basics before taking the hard stuff head on.)

Mason> So, in the limit, we don't store anything at all: just create and
Mason> immediately delete. This was my test.

>> I think that maybe using the filesystem for the reservations is the
>> wrong approach.  You should use a simple daemon which listens for
>> requests, and then checks the filesystem space and decides if it can
>> honor them or not.

Mason> I considered using ACTUAL partitions, but there were too many downsides.
Mason> NB: there may be several "containers" active at the same time.

>>> 2) Is this expected behavior?
>> 
>> Sure, unlinking a 1Gb file that's been written too means (on EXT4)
>> that you need to update all the filesystem structures.

Mason> Well creating such a file means updating all the filesystem structures,
Mason> yet that operation is 30x faster. Also note that I have not written
Mason> ANYTHING to the file; my test did:

Mason>   open();
Mason>   posix_fallocate();
Mason>   unlink();

>> Now it should
>> be quicker honestly, but maybe you're not mounting it with a journal?

Mason> Indeed no, I expected the journal to slow things down.
Mason> $ mkfs.ext4 -m 0 -i 1024000 -O ^has_journal,^huge_file /dev/sda1
Mason> https://lwn.net/Articles/313514/

Mason> Also, the user might format a Flash-based device, and I've read that
Mason> journals and Flash-based storage are not a good mix.

>> And have you tried tuning the filesystem to use larger allocations and
>> blocks?  You're not going to make a lot of files on there obviously,
>> but just a few large ones.

Mason> Are you suggesting bigalloc?
Mason> https://ext4.wiki.kernel.org/index.php/Bigalloc
Mason> 1. It is not supported by my kernel AFAIU.
Mason> 2. It is still experimental AFAICT.
Mason> 3. Resizing bigalloc file systems is not well tested.

>>> 3) Are there knobs I can tweak (at FS creation, or at mount
>>> time) to improve the performance of file unlinking?  (Maybe
>>> there is a safety/performance trade-off?
>> 
>> Sure, there are all kinds of things you can do.  For example, how
>> many of these files are you expecting to store?

Mason> I do not support more than 8 containers. (But the drive is used to
Mason> store other (mostly large) files.)

Mason> This is why I specified "-i 1024000" to mkfs.ext4, to limit the number
Mason> of inodes created. Is this incorrect?

Mason> What other improvements would you suggest?
Mason> (I'd like to get the unlink operation to complete in < 10 seconds.)

>> Will you have to be able to handle writing of more than one file
>> at a time?  Or are they purely sequential?

Mason> All containers may be active concurrently, and since they are proper
Mason> file systems, they are written to as the FS drivers sees fit (i.e. not
Mason> sequentially). However, the max write throughput is limited to 3 MB/s
Mason> (which USB2 should easily manage to handle).

>> If you are creating a small embedded system to manage a bunch of USB2
>> hard drives and write data to them with a space reservation process,
>> then you need to make sure you can actually handle the data throughput
>> requirements.  And I'm not sure you can.

Mason> AFAIK, the plan is to support only one drive, and not to write faster
Mason> than 3 MB/s. I think it should handle it.

Mason> Thanks for your insightful questions :-)

Mason> Regards.
