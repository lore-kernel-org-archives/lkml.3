Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaFENl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:41:28 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:40805 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaFENlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:41:24 -0400
Date: Thu, 5 Jun 2014 09:41:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>,
        Suman Tripathi <stripathi@apm.com>
Subject: Re: [Regression] commit 8a4aeec8d(libata/ahci: accommodate tag
 ordered controllers)
Message-ID: <20140605134120.GA21607@htj.dyndns.org>
References: <CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com>
 <CAPcyv4icNZU9s7zLYYcrFrNA_9qk4W1je42KKG+ETWqdoQu_kg@mail.gmail.com>
 <CACVXFVPHfP1VXujLx9sGt3c7ptdG1JvBQkw2JiJQsU1KwJ1zog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPHfP1VXujLx9sGt3c7ptdG1JvBQkw2JiJQsU1KwJ1zog@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing ahci_xgene folks)

On Thu, Jun 05, 2014 at 09:24:04PM +0800, Ming Lei wrote:
> On Thu, Jun 5, 2014 at 9:12 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Thu, Jun 5, 2014 at 1:53 AM, Ming Lei <ming.lei@canonical.com> wrote:
> >> Hi Dan and Tejun,
> >>
> >> Looks the commit 8a4aeec8d(libata/ahci: accommodate tag ordered
> >> controllers) causes below sata failure[1] on APM AHCI controller.
> >>
> >> And the error does disappear after reverting the commit.
> >
> > Can you give some more details about the workload and the disk?  What
> > is the APM AHCI?
> 
> The commit causes the APM arm64 based system not bootable, and not
> special workload, just when mounting rootfs or reading init files.
> 
> APM AHCI:
>       drivers/ata/ahci_xgene.c

Urgh... so, the controller can't handle tags allocated in round-robin
instead of lowest-first?  Ming, can you please test with different
controllers / disks / ssds and see whether the problem stays with the
controller?  Loc, can you guys please look into it so that at least
the next revision hardware can fix the issue?

Provided that the tag allocation itself isn't broken, which isn't too
likely given the lack of bug reports on other controllers, we'll need
to blacklist ahci_xgene somehow.  Either disable NCQ support on it or
implement an alternative lowest-first tag allocation for it.  If this
actually is the controller freaking out about tags allocated in a
different order, I'm not sure how much confidence we can put in its
NCQ implementation tho and it might be a better idea to simply plug
NCQ support on it until we understand the details of the problem.

So, something like the following?  Ming, can you please verify whether
the following makes the machine boot again?

Thanks.

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 77c89bf..4950600 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -302,9 +302,16 @@ static struct ata_port_operations xgene_ahci_ops = {
 	.read_id = xgene_ahci_read_id,
 };
 
+/*
+ * The controller seems to freak out depending on the order of tag
+ * allocation.  NCQ support is disabled until the problem is better
+ * understood.
+ *
+ * http://lkml.kernel.org/g/CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com
+ */
 static const struct ata_port_info xgene_ahci_port_info = {
-	AHCI_HFLAGS(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ),
-	.flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	AHCI_HFLAGS(AHCI_HFLAG_NO_PMP),
+	.flags = AHCI_FLAG_COMMON,
 	.pio_mask = ATA_PIO4,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &xgene_ahci_ops,
