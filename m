Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbaGATjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbaGATjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:39:17 -0400
Date: Tue, 1 Jul 2014 15:39:07 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Paul Mackerras <paulus@samba.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, bvanassche@acm.org
Subject: Re: Regression in 3.15 on POWER8 with multipath SCSI
Message-ID: <20140701193907.GA15306@redhat.com>
References: <20140630103058.GA17747@iris.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630103058.GA17747@iris.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30 2014 at  6:30am -0400,
Paul Mackerras <paulus@samba.org> wrote:

> I have a machine on which 3.15 usually fails to boot, and 3.14 boots
> every time.  The machine is a POWER8 2-socket server with 20 cores
> (thus 160 CPUs), 128GB of RAM, and 7 SCSI disks connected via a
> hardware-RAID-capable adapter which appears as two IPR controllers
> which are both connected to each disk.  I am booting from a disk that
> has Fedora 20 installed on it.
> 
> After over two weeks of bisections, I can finally point to the commits
> that cause the problems.  The culprits are:
> 
> 3e9f1be1 dm mpath: remove process_queued_ios()
> e8099177 dm mpath: push back requests instead of queueing
> bcccff93 kobject: don't block for each kobject_uevent
> 
> The interesting thing is that neither e8099177 nor bcccff93 cause
> failures on their own, but with both commits in there are failures
> where the system will fail to find /home on some occasions.
> 
> With 3e9f1be1 included, the system appears to be prone to a deadlock
> condition which typically causes the boot process to hang with this
> message showing:
> 
> A start job is running for Monitoring of LVM2 mirror...rogress polling
> 
> (with a [***     ] thing before it where the asterisks move back and
> forth).
> 
> If I revert 63d832c3 ("dm mpath: really fix lockdep warning") ,
> 4cdd2ad7 ("dm mpath: fix lock order inconsistency in
> multipath_ioctl"), 3e9f1be1 and bcccff93, in that order, I get a
> kernel that will boot every time.  The first two are later commits
> that fix some problems with 3e9f1be1 (though not the problems I am
> seeing).
> 
> Can anyone see any reason why e8099177 and bcccff93 would interfere
> with each other?

No, not seeing any obvious relation.

But even though you listed e8099177 as a culprit you didn't list it as a
commit you reverted.  Did you leave e8099177 simply because attempting
to revert it fails (if you don't first revert other dm-mpath.c commits)?

(btw, Bart Van Assche also has issues with commit e8099177 due to hangs
during cable pull testing of mpath devices -- Bart: curious to know if
your cable pull tests pass if you just revert bcccff93).

Mike
