Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbaGPRRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:17:07 -0400
Received: from smtp21.services.sfr.fr ([93.17.128.1]:42654 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209AbaGPRRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:17:04 -0400
Authentication-Results: sfrmc.priv.atos.fr; dkim=none (no signature);
	dkim-adsp=none (no policy) header.from=mpeg.blue@free.fr
X-SFR-UUID: 20140716171700593.90F8170001A4@msfrf2108.sfr.fr
Message-ID: <53C6B38A.3000100@free.fr>
Date: Wed, 16 Jul 2014 19:16:58 +0200
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:29.0) Gecko/20100101
	Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: After unlinking a large file on ext4, the process stalls for a
 long time
References: <53C687B1.30809@free.fr>
	<21446.38705.190786.631403@quad.stoffel.home>
In-Reply-To: <21446.38705.190786.631403@quad.stoffel.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I hope you'll forgive me for reformatting the quote characters
to my taste.)

On 16/07/2014 17:16, John Stoffel wrote:

> Mason wrote:
>
>> I'm using Linux (3.1.10 at the moment) on a embedded system
>> similar in spec to a desktop PC from 15 years ago (256 MB RAM,
>> 800-MHz CPU, USB).
> 
> Sounds like a Raspberry Pi...  And have you investigated using
> something like XFS as your filesystem instead?

The system is a set-top box (DVB-S2 receiver). The system CPU is
MIPS 74K, not ARM (not that it matters, in this case).

No, I have not investigated other file systems (yet).

>> I need to be able to create large files (50-1000 GB) "as fast
>> as possible".  These files are created on an external hard disk
>> drive, connected over Hi-Speed USB (typical throughput 30 MB/s).
> 
> Really... so you just need to create allocations of space as quickly
> as possible,

I may not have been clear. The creation needs to be fast (in UX terms,
so less than 5-10 seconds), but it only occurs a few times during the
lifetime of the system.

> which will then be filled in later with actual data?

Yes. In fact, I use the loopback device to format the file as an
ext4 partition. 

> basically someone will say "give me 600G of space reservation" and
> then will eventually fill it up, otherwise you say "Nope, can't do
> it!"

Right, take a 1000 GB disk,
Reserve(R1 = 300 GB) <- SUCCESS
Reserve(R2 = 300 GB) <- SUCCESS
Reserve(R3 = 300 GB) <- SUCCESS
Reserve(R4 = 300 GB) <- FAIL
Delete (R1)          <- SUCCESS
Reserve(R4 = 300 GB) <- SUCCESS

>> So I create an ext4 partition with
>> $ mkfs.ext4 -m 0 -i 1024000 -O ^has_journal,^huge_file /dev/sda1
>> (Using e2fsprogs-1.42.10 if it matters)
>> 
>> And mount with "typical" mount options
>> $ mount -t ext4 /dev/sda1 /mnt/hdd -o noexec,noatime
>> /dev/sda1 on /mnt/hdd type ext4 (rw,noexec,noatime,barrier=1)
>> 
>> I wrote a small test program to create a large file, then immediately
>> unlink it.
>> 
>> My problem is that, while file creation is "fast enough" (4 seconds
>> for a 300 GB file) and unlink is "immediate", the process hangs
>> while it waits (I suppose) for the OS to actually complete the
>> operation (almost two minutes for a 300 GB file).

[snip performance numbers]

>> QUESTIONS:
>> 
>> 1) Did I provide enough information for someone to reproduce?
> 
> Sure, but you didn't give enough information to explain what you're
> trying to accomplish here.  And what the use case is.  Also, since you
> know you cannot fill 500Gb in any sort of reasonable time over USB2,
> why are you concerned that the delete takes so long?

I don't understand your question. If the user asks to create a 300 GB
file, then immediately realizes than he won't need it, and asks for it
to be deleted, I don't see why the process should hang for 2 minutes.

The use case is
- allocate a large file
- stick a file system on it
- store stuff (typically video files) inside this "private" FS
- when the user decides he doesn't need it anymore, unmount and unlink
(I also have a resize operation in there, but I wanted to get the
basics before taking the hard stuff head on.)

So, in the limit, we don't store anything at all: just create and
immediately delete. This was my test.

> I think that maybe using the filesystem for the reservations is the
> wrong approach.  You should use a simple daemon which listens for
> requests, and then checks the filesystem space and decides if it can
> honor them or not.

I considered using ACTUAL partitions, but there were too many downsides.
NB: there may be several "containers" active at the same time.

>> 2) Is this expected behavior?
> 
> Sure, unlinking a 1Gb file that's been written too means (on EXT4)
> that you need to update all the filesystem structures.

Well creating such a file means updating all the filesystem structures,
yet that operation is 30x faster. Also note that I have not written
ANYTHING to the file; my test did:

  open();
  posix_fallocate();
  unlink();

> Now it should
> be quicker honestly, but maybe you're not mounting it with a journal?

Indeed no, I expected the journal to slow things down.
$ mkfs.ext4 -m 0 -i 1024000 -O ^has_journal,^huge_file /dev/sda1
https://lwn.net/Articles/313514/

Also, the user might format a Flash-based device, and I've read that
journals and Flash-based storage are not a good mix.

> And have you tried tuning the filesystem to use larger allocations and
> blocks?  You're not going to make a lot of files on there obviously,
> but just a few large ones.

Are you suggesting bigalloc?
https://ext4.wiki.kernel.org/index.php/Bigalloc
1. It is not supported by my kernel AFAIU.
2. It is still experimental AFAICT.
3. Resizing bigalloc file systems is not well tested.

>> 3) Are there knobs I can tweak (at FS creation, or at mount
>> time) to improve the performance of file unlinking?  (Maybe
>> there is a safety/performance trade-off?
> 
> Sure, there are all kinds of things you can do.  For example, how
> many of these files are you expecting to store?

I do not support more than 8 containers. (But the drive is used to
store other (mostly large) files.)

This is why I specified "-i 1024000" to mkfs.ext4, to limit the number
of inodes created. Is this incorrect?

What other improvements would you suggest?
(I'd like to get the unlink operation to complete in < 10 seconds.)

> Will you have to be able to handle writing of more than one file
> at a time?  Or are they purely sequential?

All containers may be active concurrently, and since they are proper
file systems, they are written to as the FS drivers sees fit (i.e. not
sequentially). However, the max write throughput is limited to 3 MB/s
(which USB2 should easily manage to handle).

> If you are creating a small embedded system to manage a bunch of USB2
> hard drives and write data to them with a space reservation process,
> then you need to make sure you can actually handle the data throughput
> requirements.  And I'm not sure you can.

AFAIK, the plan is to support only one drive, and not to write faster
than 3 MB/s. I think it should handle it.

Thanks for your insightful questions :-)

Regards.
