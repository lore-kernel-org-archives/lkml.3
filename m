Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaGPVqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:46:15 -0400
Received: from smtp22.services.sfr.fr ([93.17.128.13]:43980 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaGPVqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:46:10 -0400
Authentication-Results: sfrmc.priv.atos.fr; dkim=none (no signature);
	dkim-adsp=none (no policy) header.from=mpeg.blue@free.fr
X-SFR-UUID: 20140716214608725.11B3070000E4@msfrf2216.sfr.fr
Message-ID: <53C6F29E.1080805@free.fr>
Date: Wed, 16 Jul 2014 23:46:06 +0200
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
	<53C6B38A.3000100@free.fr> <21446.56861.789139.773769@quad.stoffel.home>
In-Reply-To: <21446.56861.789139.773769@quad.stoffel.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/2014 22:18, John Stoffel wrote:

> Mason wrote:
>
>> The system is a set-top box (DVB-S2 receiver). The system CPU is
>> MIPS 74K, not ARM (not that it matters, in this case).
> 
> So it's a slow slow box... and it's only going to handle writing data
> at 3 MBps...

What do you mean "it's only going to handle writing data at 3 MBps"?
It's a good thing that I am nowhere near the peak throughput! I have
tested the system for hours, and it can handle 30 MB/s with only a
few minor hiccups (unexplained, so far).

> so why do you insist that the filesystem work at magic speeds?

Why do you say that deleting an empty 300-GB fallocated file in
less than 10 seconds is "working at magic speeds"? What numbers
do you get for this benchmark? I would expect to get roughly
similar numbers for creation and deletion. Why aren't you
surprised by the deletion numbers? You know something I don't.
So please share with me.

>> I may not have been clear. The creation needs to be fast (in UX terms,
>> so less than 5-10 seconds), but it only occurs a few times during the
>> lifetime of the system.
> 
> If this only happens a few times, why do you care how quick the delete
> is?  And if it's only happening a few times, why don't you just do the
> space reservation OUTSIDE of the filesystem?

I care because the delete operation is done when the user asks
for it, and it hangs the UI for 2 minutes. Isn't that reason
enough to care?

I don't know what you mean by reservation OUTSIDE of the FS.
The user supplies the external HDD, and the sizes to reserve
are known at run-time (sent in the broadcast signal).

> Or do you need to do encryption of these containers and strictly
> segrate them?  Basically, implement a daemon which knows how much free
> space is on the device, how much is already pre-committed to other
> users, and then how much free space there is.

I don't think you've thought this through...
You propose to have a daemon that will mediate every file system
write to the external HDD. That means that the application has
to explicitly be coded to talk to the daemon. (My solution is
transparent to the app.) Or did you have some kind of interposition
of write system calls? Anyway, this code would be duplicating the
bean counting done inside the file system driver. (I considered
using quotas, but I didn't see how to make it work as required.)

Note that the OS and main app reside in Flash (ubifs). And there
are also a couple tmpfs. There are about 15 mount points (most
of them pseudo file systems, though).

> Why are you doing it like this?  What advantage does this buy you?  In
> any case, you're now slowing things down because you have the overhead
> of the base filesystem, which you then create a large file on top of,
> which you then mount and format with a SECOND filesystem.

Write performance is secondary. I was just providing insight
into what I planned to do with the large files, but the
performance problem of unlinking occurs *even when nothing
was done to the file*. (Please don't get distracted by the
FS-within-FS gizmo.)

> Instead, you should probably just have a small boot/OS filesystem, and
> then put the rest of the storage under LVM control.  At that point,
> you can reserve space using 'lvcreate ...' which will succeed or
> fail.  If good, create a filesystem in there and use it.  When you
> need to delete it, just unmount the LV and just do 'lvdestroy' which
> should be much faster, since you won't bother to zero out the blocks.

I didn't look closely at the LVM solution, because space in
Flash is tight, and I had the prejudice that LVM was large,
as a server/workstation solution.

[huge snip of my other questions]

I will try to test XFS on the STB, and also run my ext4 test
on my workstation, see if get the same disappointing results.

Regards.
