Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3JODkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:40:35 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57188 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3JODkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <20131013195735.GD18075@htj.dyndns.org>
References: <1380366816-16221-1-git-send-email-yxlraid@gmail.com>
	<20130928114950.GA2620@htj.dyndns.org>
	<CAP0P+NUvaLfXkOUGm8NX19AHvTHmU=Ya0NdFvyJc2gFjN-Cy0A@mail.gmail.com>
	<20130928131059.GA3945@htj.dyndns.org>
	<CAP0P+NXD7pdXQwBUZJdUwyCc=o_5iTzmKJ6FdN6LrqcgX3yK2A@mail.gmail.com>
	<20131013195735.GD18075@htj.dyndns.org>
Date: Tue, 15 Oct 2013 11:40:27 +0800
Message-ID: <CAP0P+NWw2goofPtk5v8qKqAkhGwVJ7Bwn+Pj6meNhyK3KE2CAQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset
From: xiangliang yu <yxlraid@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Sat, Oct 12, 2013 at 02:56:34PM +0800, xiangliang yu wrote:
>> > So it can't find the disk if FBS stays enabled?  Can you please attach
>> > the boot log before & after?
>>
>> Below is boot log:
>
> And it works after the patch, right?  Can you please update the patch
> description so that it includes what was failing before and how it was
> tested?

How about this update:

Subject: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset

Tested with Marvell 88se9125, attached with one port mulitplier(5 ports)
and one disk, we will get following boot log messages if using current
code:

  ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
  ata8.15: Port Multiplier 1.2, 0x1b4b:0x9715 r160, 5 ports, feat 0x1/0x1f
  ahci 0000:03:00.0: FBS is enabled
  ata8.00: hard resetting link
  ata8.00: SATA link down (SStatus 0 SControl 330)
  ata8.01: hard resetting link
  ata8.01: SATA link down (SStatus 0 SControl 330)
  ata8.02: hard resetting link
  ata8.02: SATA link down (SStatus 0 SControl 330)
  ata8.03: hard resetting link
  ata8.03: SATA link up 6.0 Gbps (SStatus 133 SControl 133)
  ata8.04: hard resetting link
  ata8.04: failed to resume link (SControl 133)
  ata8.04: failed to read SCR 0 (Emask=0x40)
  ata8.04: failed to read SCR 0 (Emask=0x40)
  ata8.04: failed to read SCR 1 (Emask=0x40)
  ata8.04: failed to read SCR 0 (Emask=0x40)
  ata8.03: native sectors (2) is smaller than sectors (976773168)
  ata8.03: ATA-8: ST3500413AS, JC4B, max UDMA/133
  ata8.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
  ata8.03: configured for UDMA/133
  ata8.04: failed to IDENTIFY (I/O error, err_mask=0x100)
  ata8.15: hard resetting link
  ata8.15: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
  ata8.15: Port Multiplier vendor mismatch '0x1b4b' != '0x133'
  ata8.15: PMP revalidation failed (errno=-19)
  ata8.15: hard resetting link
  ata8.15: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
  ata8.15: Port Multiplier vendor mismatch '0x1b4b' != '0x133'
  ata8.15: PMP revalidation failed (errno=-19)
  ata8.15: limiting SATA link speed to 3.0 Gbps
  ata8.15: hard resetting link
  ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
  ata8.15: Port Multiplier vendor mismatch '0x1b4b' != '0x133'
  ata8.15: PMP revalidation failed (errno=-19)
  ata8.15: failed to recover PMP after 5 tries, giving up
  ata8.15: Port Multiplier detaching
  ata8.03: disabled
  ata8.00: disabled
  ata8: EH complete

The reason is that current detection code doesn't follow AHCI spec:

First,the port multiplier detection process look like this:

ahci_hardreset(link, class, deadline)
if (class == ATA_DEV_PMP) {
sata_pmp_attach(dev) /* will enable FBS */
sata_pmp_init_links(ap, nr_ports);
ata_for_each_link(link, ap, EDGE) {
sata_std_hardreset(link, class, deadline);
if (link_is_online) /* do soft reset */
ahci_softreset(link, class, deadline);
}
}
But, according to chapter 9.3.9 in AHCI spec: Prior to issuing software
reset, software shall clear PxCMD.ST to '0' and then clear PxFBS.EN to
'0'.

The patch test ok with kernel 3.11.1.

Signed-off-by: Xiangliang Yu <yxlraid@gmail.com>
---
 drivers/ata/libahci.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 34c8216..c2a29bf 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1266,9 +1266,11 @@ int ahci_do_softreset(struct ata_link *link,
unsigned int *class,
 {
  struct ata_port *ap = link->ap;
  struct ahci_host_priv *hpriv = ap->host->private_data;
+ struct ahci_port_priv *pp = ap->private_data;
  const char *reason = NULL;
  unsigned long now, msecs;
  struct ata_taskfile tf;
+ bool fbs_flag = false;
  int rc;

  DPRINTK("ENTER\n");
@@ -1278,6 +1280,11 @@ int ahci_do_softreset(struct ata_link *link,
unsigned int *class,
  if (rc && rc != -EOPNOTSUPP)
  ata_link_warn(link, "failed to reset engine (errno=%d)\n", rc);

+ if (!ata_is_host_link(link) && pp->fbs_enabled) {
+ ahci_disable_fbs(ap);
+ fbs_flag = true;
+ }
+
  ata_tf_init(link->device, &tf);

  /* issue the first D2H Register FIS */
@@ -1318,6 +1325,9 @@ int ahci_do_softreset(struct ata_link *link,
unsigned int *class,
  } else
  *class = ahci_dev_classify(ap);

+ if (fbs_flag)
+ ahci_enable_fbs(ap);
+
  DPRINTK("EXIT, class=%u\n", *class);
  return 0;

-- 
1.7.1


Thanks!
