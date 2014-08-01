Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaHATtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:49:08 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:45003 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbaHATtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:49:06 -0400
Date: Fri, 1 Aug 2014 20:48:57 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Message-ID: <20140801194857.GA1476@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <53D09C54.1000206@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D09C54.1000206@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 07:40:36AM +0200, Hannes Reinecke wrote:
> On 07/22/2014 01:06 AM, K. Y. Srinivasan wrote:
> >Add blist flags to permit the reading of the VPD pages even when
> >the target may claim SPC-2 compliance. MSFT targets currently
> >claim SPC-2 compliance while they implement post SPC-2 features.
> >With this patch we can correctly handle WRITE_SAME_16 issues.
> >
> >Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >
> Reviewed-by: Hannes Reinecke <hare@suse.de>

On Wed, Jul 23, 2014 at 09:13:41PM +0100, Sitsofe Wheeler wrote:
> On Wed, Jul 23, 2014 at 07:15:58AM -0700, Christoph Hellwig wrote:
> > On Wed, Jul 23, 2014 at 03:10:28PM +0100, Sitsofe Wheeler wrote:
> > > I'm not sure this alone will work - won't sdev_bflags/bflags have
> > > already been built at this point?
> > 
> > They've been built up, but we can still or new values into it.  It looks
> > fine to me from review, but if you can test it on an actualy hypverv
> > setup that would be valueable feedback.
> 
> The previous patches didn't work for me with a Windows 2012 R2 host with a
> 3.16.0-rc6.x86_64-00076-g2f7d2ec-dirty guest. After applying
> https://patchwork.kernel.org/patch/4541201 (which needed a small fixup) and
> https://patchwork.kernel.org/patch/4598601 and the attached debugging output

I've tested f3cfabce7a2e92564d380de3aad4b43901fb7ae6 (Drivers: add blist
flags) from the drivers-for-3.17 branch of scsi-queue
(http://git.infradead.org/users/hch/scsi-queue.git/commit/f3cfabce7a2e92564d380de3aad4b43901fb7ae6
) and this patch still doesn't appear to work (thin provisioning on
Hyper-V's Virtual Disks is not enabled):

# sg_inq  /dev/sda
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x04  [SPC-2]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
    length=36 (0x24)   Peripheral device type: disk
 Vendor identification: Msft    
 Product identification: Virtual Disk    
 Product revision level: 1.0 
# sg_vpd -p lbpv /dev/sda
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBWS): 0
  Write same (10) with unmap bit supported (LBWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 0
  Threshold exponent: 1
  Descriptor present (DP): 0
  Provisioning type: 2

grep . /sys/block/sd*/device/scsi_disk/*/{thin,prov,rotat,device/model}* | sort
/sys/block/sda/device/scsi_disk/0:0:0:0/device/model:Virtual Disk    
/sys/block/sda/device/scsi_disk/0:0:0:0/provisioning_mode:full
/sys/block/sda/device/scsi_disk/0:0:0:0/thin_provisioning:0
/sys/block/sdb/device/scsi_disk/1:0:0:0/device/model:Virtual Disk    
/sys/block/sdb/device/scsi_disk/1:0:0:0/provisioning_mode:full
/sys/block/sdb/device/scsi_disk/1:0:0:0/thin_provisioning:0
/sys/block/sdc/device/scsi_disk/1:0:0:2/device/model:00AAKS-00TMA0   
/sys/block/sdc/device/scsi_disk/1:0:0:2/provisioning_mode:full
/sys/block/sdc/device/scsi_disk/1:0:0:2/thin_provisioning:0
/sys/block/sdd/device/scsi_disk/1:0:0:1/device/model:SSD S510 120GB  
/sys/block/sdd/device/scsi_disk/1:0:0:1/provisioning_mode:full
/sys/block/sdd/device/scsi_disk/1:0:0:1/thin_provisioning:0
/sys/block/sde/device/scsi_disk/1:0:0:3/device/model:Virtual Disk    
/sys/block/sde/device/scsi_disk/1:0:0:3/provisioning_mode:full
/sys/block/sde/device/scsi_disk/1:0:0:3/thin_provisioning:0
/sys/block/sdf/device/scsi_disk/1:0:0:4/device/model:ST1000DM003-9YN1
/sys/block/sdf/device/scsi_disk/1:0:0:4/provisioning_mode:full
/sys/block/sdf/device/scsi_disk/1:0:0:4/thin_provisioning:0

At least the virtual disks should have thin_provisioning... I was also
expecting the passthrough SSD to be reported as non-rotational with this patch:

# sg_inq /dev/sdd
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x00  [no conformance claimed]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=60 (0x3c)   Peripheral device type: disk
 Vendor identification: ADATA   
 Product identification: SSD S510 120GB
 Product revision level: 5.2.
 Unit serial number: 03205115500300002076
# sg_vpd -p bdc /dev/sdd
Block device characteristics VPD page (SBC):
  Non-rotating medium (e.g. solid state)
  Product type: Not specified
  WABEREQ=0
  WACEREQ=0
  Nominal form factor not reported
  FUAB=0
  VBULS=0
# grep -H . /sys/block/sdd/queue/rot*
/sys/block/sdd/queue/rotational:1

-- 
Sitsofe | http://sucs.org/~sits/
