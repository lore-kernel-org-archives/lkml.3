Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3JJVIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:08:39 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:42787 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3JJVIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:08:38 -0400
MIME-Version: 1.0
Date: Thu, 10 Oct 2013 14:08:37 -0700
Message-ID: <CAPu=PNYkX32ZzUmjHmy9GqcbWBVN-xrX_c_Hhrz5aDEKy2s2=g@mail.gmail.com>
Subject: SDD disk and unmap granularity value 0xFFFF
From: =?ISO-8859-1?Q?Jes=FAs_Velazquez?= <jesus.velazquez@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am facing an issue regarding unmap support with a couple of Intel SDD.

/dev/sde:

ATA device, with non-removable media
        Model Number:       INTEL SSDSA2BW300G3
        Serial Number:      BTPR245400ZL300EGN
        Firmware Revision:  4PC10362
        Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II
Extensions, SATA Rev 2.5, SATA Rev 2.6

The problem I am facing is that vpd page 0xb0 returns 0xFFFF... for
unmap LBA count, descriptor count and granularity.

# sg_vpd -p 0xb0 /dev/sde
Block limits VPD page (SBC):
  Optimal transfer length granularity: 0 blocks
  Maximum transfer length: 0 blocks
  Optimal transfer length: 0 blocks
  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks
  Maximum unmap LBA count: 4294967295
  Maximum unmap block descriptor count: 4294967295
  Optimal unmap granularity: 65535
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0

# sg_vpd -p 0xb0 -H /dev/sde
Block limits VPD page (SBC):
 00     00 b0 00 3c 00 00 00 00  00 00 00 00 00 00 00 00    ...<............
 10     00 00 00 00 ff ff ff ff  ff ff ff ff 00 00 ff ff    ................
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................

The response looks valid, taking a look at  Linux 3.12-rc3 (drivers/scsi/sd.c),

  static void sd_read_block_limits(struct scsi_disk *sdkp)
{
.....
                  sdkp->unmap_granularity
=get_unaligned_be32(&buffer[28]);

.....
}

That value is never validated, the final outcome is that I do not have
TRIM support for those devices if I try to create a md raid0/1/10 with
any other SSD driver with granularity < 0xFFFF.

Have you ever seen a similar behaviour?

Regards,

Jesus
