Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414AbaGPPQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:16:07 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:54888 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbaGPPQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:16:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21446.38705.190786.631403@quad.stoffel.home>
Date: Wed, 16 Jul 2014 11:16:01 -0400
From: "John Stoffel" <john@stoffel.org>
To: Mason <mpeg.blue@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: After unlinking a large file on ext4, the process stalls for a long
 time
In-Reply-To: <53C687B1.30809@free.fr>
References: <53C687B1.30809@free.fr>
X-Mailer: VM 8.2.0b under 23.4.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mason> I'm using Linux (3.1.10 at the moment) on a embedded system
Mason> similar in spec to a desktop PC from 15 years ago (256 MB RAM,
Mason> 800-MHz CPU, USB).

Sounds like a Raspberry Pi...  And have you investigated using
something like XFS as your filesystem instead?  

Mason> I need to be able to create large files (50-1000 GB) "as fast
Mason> as possible".  These files are created on an external hard disk
Mason> drive, connected over Hi-Speed USB (typical throughput 30
Mason> MB/s).

Really... so you just need to create allocations of space as quickly
as possible, which will then be filled in later with actuall data?  So
basically someone will say "give me 600G of space reservation" and
then will eventually fill it up, otherwise you say "Nope, can't do
it!"

Mason> Sparse files were not an acceptable solution (because the space
Mason> must be reserved, and the operation must fail if the space is
Mason> unavailable).  And filling the file with zeros was too slow
Mason> (typically 35 s/GB).

Mason> Someone mentioned fallocate on an ext4 partition.

Mason> So I create an ext4 partition with
Mason> $ mkfs.ext4 -m 0 -i 1024000 -O ^has_journal,^huge_file /dev/sda1
Mason> (Using e2fsprogs-1.42.10 if it matters)

Mason> And mount with "typical" mount options
Mason> $ mount -t ext4 /dev/sda1 /mnt/hdd -o noexec,noatime
Mason> /dev/sda1 on /mnt/hdd type ext4 (rw,noexec,noatime,barrier=1)

Mason> I wrote a small test program to create a large file, then immediately
Mason> unlink it.

Mason> My problem is that, while file creation is "fast enough" (4 seconds
Mason> for a 300 GB file) and unlink is "immediate", the process hangs
Mason> while it waits (I suppose) for the OS to actually complete the
Mason> operation (almost two minutes for a 300 GB file).

Mason> I also note that the (weak) CPU is pegged, so perhaps this problem
Mason> does not occur on a desktop workstation?

Mason> /tmp # time ./foo /mnt/hdd/xxx 5
Mason> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [68 ms]
Mason> unlink(filename): 0 [0 ms]
Mason> 0.00user 1.86system 0:01.92elapsed 97%CPU (0avgtext+0avgdata 528maxresident)k
Mason> 0inputs+0outputs (0major+168minor)pagefaults 0swaps

Mason> /tmp # time ./foo /mnt/hdd/xxx 10
Mason> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [141 ms]
Mason> unlink(filename): 0 [0 ms]
Mason> 0.00user 3.71system 0:03.83elapsed 96%CPU (0avgtext+0avgdata 528maxresident)k
Mason> 0inputs+0outputs (0major+168minor)pagefaults 0swaps

Mason> /tmp # time ./foo /mnt/hdd/xxx 100
Mason> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [1882 ms]
Mason> unlink(filename): 0 [0 ms]
Mason> 0.00user 37.12system 0:38.93elapsed 95%CPU (0avgtext+0avgdata 528maxresident)k
Mason> 0inputs+0outputs (0major+168minor)pagefaults 0swaps

Mason> /tmp # time ./foo /mnt/hdd/xxx 300
Mason> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [3883 ms]
Mason> unlink(filename): 0 [0 ms]
Mason> 0.00user 111.38system 1:55.04elapsed 96%CPU (0avgtext+0avgdata 528maxresident)k
Mason> 0inputs+0outputs (0major+168minor)pagefaults 0swaps


Mason> QUESTIONS:

Mason> 1) Did I provide enough information for someone to reproduce?

Sure, but you didn't give enough information to explain what you're
trying to accomplish here.  And what the use case is.  Also, since you
know you cannot fill 500Gb in any sorta of reasonable time over USB2,
why are you concerned that the delete takes so long?  

I think that maybe using the filesystem for the reservations is the
wrong approach.  You should use a simple daemon which listens for
requests, and then checks the filesystem space and decides if it can
honor them or not.

Then you just store the files as they get writen...

Mason> 2) Is this expected behavior?

Sure, unlinking a 1Gb file that's been written too means (on EXT4)
that you need to update all the filesystem structures.  Now it should
be quicker honestly, but maybe you're not mounting it with a journal?
And have you tried tuning the filesystem to use larger allocations and
blocks?  You're not going to make alot of files on there obviously,
but just a few large ones.  

Mason> 3) Are there knobs I can tweak (at FS creation, or at mount
Mason> time) to improve the performance of file unlinking?  (Maybe
Mason> there is a safety/performance trade-off?

Sure, there are all kinds of things you can do.  For example, how
many of these files are you expecting to store?  Will you have to be
able to handle writing of more than one file at a time?  Or are they
purely sequential?  

If you are creating a small embedded system to manage a bunch of USB2
hard drives and write data to them with a space reservation process,
then you need to make sure you can actually handle the data throughput
requirements.  And I'm not sure you can.

John
