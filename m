Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaFOKaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 06:30:12 -0400
Received: from wind.enjellic.com ([76.10.64.91]:58333 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaFOKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 06:30:09 -0400
X-Greylist: delayed 1039 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jun 2014 06:30:08 EDT
Date: Sun, 15 Jun 2014 05:12:37 -0500
From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Message-Id: <201406151012.s5FACb3t001981@wind.enjellic.com>
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.6-ESD1.0 03/31/2012)
To: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org
Subject: ANNOUNCE: Hugepage (HPD) block device driver.
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [0.0.0.0]); Sun, 15 Jun 2014 05:12:38 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning, I hope this note finds the weekend going well for
everyone.

Izzy, our Golden Retriever, and I headed out to our lake place last
weekend.  I was fighting off a miserable early summer cold so I didn't
feel up to cycling and the fish weren't biting so Izzy suggested we
catch up on our backlogged projects by getting our HPD driver ready
for a release.

So while Izzy intensely monitored the family of geese that
periodically swim by the cabin I got the driver into reasonable shape
for people to start testing.  It is now a week later and Izzy thought
that given the work schedule coming up I had better get the package
out on the FTP server.

So without further ado, on behalf of Izzy and Enjellic Systems
Development, I would like to announce the first testing release of the
HupgePage Block Device (HPD) driver.  Source is available at the
following URL:

	ftp://ftp.enjellic.com/pub/hpd/hpd_driver-1.0beta.tar.gz

The HPD driver implements a dynamically configurable RAM based block
device which uses the kernel hugepage infrastructure and magazines to
provide the memory based backing for the block devices.  It borrows
heritage from the existing brd ramdisk code with the primary
differences being dynamic configurability and the backing methodology.

Izzy has watched the discussion of the relevancy of hugepages with
some interest.  It is his contention that the HPD driver may offer one
of the most useful applications of this infrastructure.  There are
obvious advantages in a ramdisk to handling the backing store in
larger size units and NUMA support falls out naturally since the
hugepage infrastructure is NUMA aware.

Block devices are created by writing the desired size of the block
device, in bytes, to the following pseudo-file:

	/sys/fs/hpd/create

On a NUMA capable platform there will be additional pseudo-files of
the following form:

	/sys/fs/hpd/create_nodeN

Which will constrain the ramdisk to use memory from only the specified
node.  On NUMA platforms a request through the /sys/fs/hpd/create file
will interleave the ramdisk allocation across all memory capable
nodes.

Prior to creating an HPD device there must be an allocation of
hugepages made to the freepage pool.  This can be done by writing the
number of pages desired to the following pseudo-file:

	/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

The following pseudo-files can be used to implement allocations which
are pinned to a specific memory capable NUMA node:

	/sys/devices/system/node/nodeN/hugepages/hugepages-2048kB/nr_hugepages

A hugepage allocation can also be specified by specifying the
following argument on the kernel command-line:

	nr_hugepages=N

Depending on the activity of your machine this may be needed since
memory fragmentation may limit the number of order 9 pages which are
available.

A ramdisk is deleted by writing the value 1 to the following
pseudo-file:

	/sys/block/hpdN/device/delete

We have found the driver to be particularly useful in testing our SCST
implementation, extensions and infrastructure.  It is capable of
sustaining line-rate 10+ GBPS throughput which allows target
infrastructure to be tested and verified with FIO running in verify
mode.  The NULLIO target, while fast of course, does not allow
verification of I/O since there is no persistent backing.

Measured I/O latency on 4K block sizes is approximately five
micro-seconds.  Based on that Izzy thought we should get this released
for our fellow brethren in the storage appliance industry.  He
suggests that pretty impressive appliance benchmark numbers can be
obtained by using an HPD based cache device with bcache in writeback
mode..... :-)

The driver includes a small patch to the mm/hugetlb.c to add two
exported functions for allocation and release of generic hugepages.
This was needed since there was not a suitable API for
allocating/released extended size pages in a NUMA aware fashion.

>From an architectural perspective the HPD driver differs from the
current ramdisk driver by using a single extended size page to hold
the array of page pointers for the backing store rather then a radix
tree mapping sectors to pages.  This limits the size of an individual
block device to one-half of a terrabyte.

A single major with 128 minors is supported.  Izzy recommends using
RAID0 if single block device semantics are needed and you have a
machine with 64 terrabytes of RAM handy.  Hopefully this won't be a
major limitation for other then the SGI boys.

The driver has been tested pretty extensively but public releases are
legendary for brown bag issues.  Please let us know if you test this
and run into any issues.

Finally, thanks and kudos should go to Izzy for prompting all the work
on this.  Anyone who has been snooted by a Golden Retriever will tell
you how difficult they are to resist once they put their mind to
something.  Anyone who finds this driver useful should note that he
enjoys the large Milk Bone (tm) dog biscuits.... :-)

Best wishes for a productive week.

Dr Greg and Izzy.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"One problem with monolithic business structures is losing sight
 of the fundamental importance of mathematics.  Consider committees;
 commonly forgotten is the relationship that given a projection of N
 individuals to complete an assignment the most effective number of
 people to assign to the committee is given by f(N) = N - (N-1)."
                                -- Dr. G.W. Wettstein
                                   Guerrilla Tactics for Corporate Survival
