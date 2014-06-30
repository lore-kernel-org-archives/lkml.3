Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbaF3VaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:30:19 -0400
Received: from ozlabs.org ([103.22.144.67]:50226 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbaF3VaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:30:15 -0400
Date: Tue, 1 Jul 2014 07:30:08 +1000
From: Paul Mackerras <paulus@samba.org>
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Regression in 3.15 on POWER8 with multipath SCSI
Message-ID: <20140630213008.GC20819@iris.ozlabs.ibm.com>
References: <20140630103058.GA17747@iris.ozlabs.ibm.com>
 <53B1416D.8020305@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B1416D.8020305@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 12:52:29PM +0200, Hannes Reinecke wrote:
> On 06/30/2014 12:30 PM, Paul Mackerras wrote:
> >I have a machine on which 3.15 usually fails to boot, and 3.14 boots
> >every time.  The machine is a POWER8 2-socket server with 20 cores
> >(thus 160 CPUs), 128GB of RAM, and 7 SCSI disks connected via a
> >hardware-RAID-capable adapter which appears as two IPR controllers
> >which are both connected to each disk.  I am booting from a disk that
> >has Fedora 20 installed on it.
> >
> >After over two weeks of bisections, I can finally point to the commits
> >that cause the problems.  The culprits are:
> >
> >3e9f1be1 dm mpath: remove process_queued_ios()
> >e8099177 dm mpath: push back requests instead of queueing
> >bcccff93 kobject: don't block for each kobject_uevent
> >
> >The interesting thing is that neither e8099177 nor bcccff93 cause
> >failures on their own, but with both commits in there are failures
> >where the system will fail to find /home on some occasions.
> >
> >With 3e9f1be1 included, the system appears to be prone to a deadlock
> >condition which typically causes the boot process to hang with this
> >message showing:
> >
> >A start job is running for Monitoring of LVM2 mirror...rogress polling
> >
> >(with a [***     ] thing before it where the asterisks move back and
> >forth).
> >
> >If I revert 63d832c3 ("dm mpath: really fix lockdep warning") ,
> >4cdd2ad7 ("dm mpath: fix lock order inconsistency in
> >multipath_ioctl"), 3e9f1be1 and bcccff93, in that order, I get a
> >kernel that will boot every time.  The first two are later commits
> >that fix some problems with 3e9f1be1 (though not the problems I am
> >seeing).
> >
> >Can anyone see any reason why e8099177 and bcccff93 would interfere
> >with each other?
> >
> It might be running afoul with the 'cookie' mechanism.
> Device-mapper is using inserting a 'cookie' with the ioctl, and listens to
> any event containing the cookie to ensure udev has finished processing that
> device and hence the device node is accessible. Added to this is the problem
> that we don't have any good means of detecting any changes to device-mapper
> devices.

How does that relate to e8099177?  Did e8099177 introduce this cookie
mechanism?  If not, what is it about e8099177 that makes the async
processing problematic?

Paul.
