Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaIVQ0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:26:08 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:13917 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaIVQ0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:26:04 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Andreas Dilger <adilger@dilger.ca>, Milosz Tanski <milosz@adfin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: RE: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
Thread-Topic: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache
 only)
Thread-Index: AQHP0SKGxsA+DTFen0Wh6Y6YnaKzXpwCtzGAgAANsvCABZCkgIADsElw
Date: Mon, 22 Sep 2014 16:25:24 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C9102B@G9W0745.americas.hpqcorp.net>
References: <cover.1410810247.git.milosz@adfin.com>
 <8EC2A7F3-0E25-4054-9863-4488B8ED5C8D@dilger.ca>
 <94D0CD8314A33A4D9D801C0FE68B402958C81D56@G9W0745.americas.hpqcorp.net>
 <20140919112147.GA4639@infradead.org>
In-Reply-To: <20140919112147.GA4639@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, 19 September, 2014 6:22 AM
> To: Elliott, Robert (Server Storage)
> Cc: Andreas Dilger; Milosz Tanski; linux-kernel@vger.kernel.org; Christoph
> Hellwig; linux-fsdevel@vger.kernel.org; linux-aio@kvack.org; Mel Gorman;
> Volker Lendecke; Tejun Heo; Jeff Moyer
> Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
> 
> On Mon, Sep 15, 2014 at 10:36:46PM +0000, Elliott, Robert (Server Storage)
> wrote:
> > That sounds like the proposed WRITE SCATTERED/READ GATHERED
> > commands for SCSI (where are related to, but not necessarily
> > tied to, atomic writes).  We discussed them a bit at
> > LSF-MM 2013 - see http://lwn.net/Articles/548116/.
> 
> In the same way a preadx/pwritex could use but would not require an
> O_ATOMIC.  What's the status of those in t10?  Last I heard
> READ GATHERED was out and they were only looking into WRITE SCATTERED?

Both of these essentially require more CDB bytes to convey the
LBA range list.  Under the current SCSI architecture model, the 
choices are:
* include in a longer CDB
* include in the data-out buffer

For longer CDBs:
* CDBs >16 bytes are not widely supported
* 260 byte max CDB size limits the number of LBA ranges
* in most SCSI protocols, commands are unsolicited (push rather
than pull), so the target must have buffer space for (max queue
depth)*(max CDB size). In SCSI Express, although CDBs are pulled
with PCIe memory reads rather than pushed, longer CDBs complicate
circular queue handling.

For the data-out buffer:
* not delivering all the CDB info upfront complicates drive 
hardware designs. They want to get the data transfer started
from the medium, but have to wait for a whole extra DMA 
transfer first. This is not so bad for low-latency PCIe,
but is not a good fit for protocols behind HBAs like
SAS, iSCSI, etc.
* READ GATHERED requires bidirectional command support, which 
is not widely or efficiently supported

Protocols could add direct support for delivering more CDB bytes
(like how the ATA PACKET command delivers a SCSI CDB over
an ATA transport), but that requires a lot of changes.

---
Rob Elliott    HP Server Storage


