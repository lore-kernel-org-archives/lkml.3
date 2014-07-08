Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaGHW6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:58:23 -0400
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:5405 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaGHW6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:58:21 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2014 18:58:21 EDT
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=97kX/pcSDRzxCpZyrJZ+O3bQ3yje/MppWgySN1iIsrk= c=1 sm=1
 a=vULbWnCzOkcA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=f/edn6q14DUxYFbwN4BeGQ==:17 a=20KFwNOVAAAA:8 a=gu6fZOg2AAAA:8
 a=kn0y_Jr5trtkw_KoMmwA:9 a=CjuIK1q_8ugA:10 a=GC8p-B92FUEA:10
 a=NWVoK91CQyQA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Date: Tue, 8 Jul 2014 17:48:43 -0500
From: Trevor Cordes <trevor@tecnopolis.ca>
To: linux-kernel@vger.kernel.org
Subject: memory bug ever since 3.12, oom-killer invoked, computer freezes
Message-ID: <20140708174843.046ed76a@pog.tecnopolis.ca>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; i686-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excuse a novice on his first post to this list.  I have tried to obtain
help elsewhere with no success.

I have been dealing with a bad kernel bug since 3.12 came out.  It is
present in 3.12, 3.13 and 3.14 up to 3.14.8 (Fedora 19 kernel).

What happens is around the same time every day, using the buggy
kernels, I get dozens of oom-killer messages over about 3-5 minutes,
the system slows to a crawl instantly, and usually freezes (numlock no
longer works, etc) within a few minutes.

Using 3.11, the system runs fine, there is no bug.

I think I have isolated the trigger of the problem to a simple
backup-helper script I run nightly at the same time.  I have come to
this conclusion based on the fact I can run in 3.14 for many days with
no problems if I disable my script from running.  As soon as I enable
the script, the bug will hit the subsequent morning at the same time as
usual.  Again, in 3.11 there is no bug even if my script is running.

I have made a RH bugzilla bug for this that contains even more detail:
https://bugzilla.redhat.com/show_bug.cgi?id=1075185

My script looks like this (simplified):
#!/bin/perl
$dirs="/ /mnt/peecee/DATA";
$Ddest="/data/Bak/FindList";
system "/bin/nice -n19 /usr/bin/ionice -c2 -n7 -t find $dirs -xdev -ls
2>/dev/null > $Ddest/find-list";

Notes: /mnt/peecee is a cifs share (old XP box).  $Ddest is an NFS
mount on my file server.

This script runs in about 1 min when nothing is cached, about 10s when
everything is cached.

I can run this script 200 times over and over again manually for
testing (not via the usual cron) and it does NOT trigger the bug.  It
is only when I enable this script via cron that the bug occurs.

I have captured key /proc files at moments in time before/during the
bug occurring, which may help figure out the problem.  I have attached
those files to the bugzilla linked above.  I can post them here if
required.  I can obtain more/finer results if required.  I can
reproduce this bug "sort of on demand" by enabling my script to run the
following morning.

Known buggy kernels:
3.14.8-100.fc19
3.14.4-100.fc19
3.13.9-100.fc19
3.13.5-103.fc19
3.12.9-201.fc19

Known good kernel:
3.11.10-200.fc19

My kernels are all 32-bit, PAE.

My / is md RAID1.  The disks are 15k UW-SCSI enterprise drives.  The
controller is Adaptec AIC-7892A U160/m, a 29160 card I believe.  I am
usually tainted with Nvidia video driver binary, but can untaint for
purposes of testing.

I wanted to bisect to help figure this out but cannot using Fedora
tools due to bug in 32-bit python libraries.  I don't know how to
bisect the vanilla kernel whilst still incorporating all Fedora tweaks
without using Fedora tools.

I did much googling and discovered this thread which sounds very much
related to my problem, though not an exact duplicate:
http://marc.info/?l=linux-mm&m=139267140606805&w=2
