Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaJUEp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:45:56 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56739 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaJUEpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:45:54 -0400
Date: Tue, 21 Oct 2014 05:45:50 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Jeff Leung <jleung@v10networks.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@infradead.org>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Message-ID: <20141021044550.GC11691@sucs.org>
References: <20141010074901.GA32028@sucs.org>
 <20141011173902.GA1946@infradead.org>
 <1413049313.2068.48.camel@jarvis.lan>
 <b0069f11bbe64ebc8c9981ea90429014@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <A70AC0C1B7E7FD478A6BF19705461AA01109B3@IMBER.smb.curriegrad2004.ca>
 <da5106ddc725481784ed12bccb594980@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <da5106ddc725481784ed12bccb594980@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 01:21:01AM +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Jeff Leung [mailto:jleung@v10networks.ca]
> > Sent: Saturday, October 11, 2014 1:22 PM
> > 
> > > On the current release of Windows (windows 10), we are advertising
> > > SPC3 compliance.
> > > We are ok with declaring compliance to SPC3 in our drivers.
> > If you are going to declare SPC3 compliance in the drivers, are you going to
> > put in checks to ensure that SPC-3 compliance doesn't get accidentally
> > enabled for hypervisors below Win10?
> > 
> > I do know for a fact that Ubuntu's kernels already force SPC3 compliance to
> > enable specific features such as TRIM on earlier versions of Hyper-V (Namely
> > Hyper-V 2012 and 2012 R2).
> You are right; Ubuntu has been carrying a patch  that was doing just
> this and this has been working without any issues on many earlier
> versions of Windows. (2012 and 2012 R2).  On windows 10 we don't need
> any changes in the Linux driver as the host itself is advertising SPC3
> compliance. Based on the testing we have done with Ubuntu, we are
> comfortable picking up that patch.

OK this seems to be the patch currently carried by Ubuntu:

>From ff2c5fa3fa9adf0b919b9425e71a8ba044c31a7d Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Fri, 13 Sep 2013 17:49:16 +0100
Subject: [PATCH] scsi: hyper-v storsvc switch up to SPC-3

Suggested-By: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/scsi/storvsc_drv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9969fa1..3903c8a 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1441,6 +1441,14 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 
+	/*
+	 * hyper-v lies about its capabilities indicating it is only SPC-2
+	 * compliant, but actually implements the core SPC-3 features.
+	 * If we pretend to be SPC-3, we send RC16 which activates trim and
+	 * will query the appropriate VPD pages to enable trim.
+	 */
+	sdevice->scsi_level = SCSI_SPC_3;
+
 	return 0;
 }
 
-- 
1.7.9.5

(Downloaded from
http://kernel.ubuntu.com/git?p=jsalisbury/stable/trusty/ubuntu-trusty.git;a=patch;h=ff2c5fa3fa9adf0b919b9425e71a8ba044c31a7d
).

I think it's unwise to override the scsi_level at this particular point
because you are going to do it for ALL Hyper-V "disks" (perhaps all
Hyper-V SCSI devices?)...

Here's the SCSI inquiry information reported by a USB 2 hard disk being
passed passed-through by one of my 2012 R2 hosts:

# sg_inq /dev/sdc
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x02  [SCSI-2]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=1
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
    length=36 (0x24)   Peripheral device type: disk
 Vendor identification: MDT MD50
 Product identification: 00AAKS-00TMA0   
 Product revision level: 

Is it OK to replace a scsi_level of SCSI-2 with SCSI_SPC_3? Additionally
is it also OK to force SCSI_SPC_3 on Hyper-V 2008?

> > > NryزXvؖ){nǉ{zX}zj:v zZzf~zwڢ)jyA
> > >
> > > i
> N?????r??y????b?X??ǧv?^?)޺{.n?+????{????zX????ܨ}???Ơz?&j:+v???????zZ+??+zf???h???~????i???z??w?????????&?)ߢf??^jǫy?m??@A?a???0??h???i

^^^ Where do these characters come from? I've occasionally seen them on
emails from other Microsoft folks posting to LKML too...

-- 
Sitsofe | http://sucs.org/~sits/
