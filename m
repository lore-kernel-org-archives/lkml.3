Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbbA1CDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:03:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770AbbA1B22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ronny Hegewald <Ronny.Hegewald@online.de>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3.18 08/61] libata: allow sata_sil24 to opt-out of tag ordered submission
Date: Tue, 27 Jan 2015 17:26:20 -0800
Message-Id: <20150128012637.840594053@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 72dd299d5039a336493993dcc63413cf31d0e662 upstream.

Ronny reports: https://bugzilla.kernel.org/show_bug.cgi?id=87101
    "Since commit 8a4aeec8d "libata/ahci: accommodate tag ordered
    controllers" the access to the harddisk on the first SATA-port is
    failing on its first access. The access to the harddisk on the
    second port is working normal.

    When reverting the above commit, access to both harddisks is working
    fine again."

Maintain tag ordered submission as the default, but allow sata_sil24 to
continue with the old behavior.

Cc: Tejun Heo <tj@kernel.org>
Reported-by: Ronny Hegewald <Ronny.Hegewald@online.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    5 ++++-
 drivers/ata/sata_sil24.c  |    2 +-
 include/linux/libata.h    |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4740,7 +4740,10 @@ static struct ata_queued_cmd *ata_qc_new
 		return NULL;
 
 	for (i = 0, tag = ap->last_tag + 1; i < max_queue; i++, tag++) {
-		tag = tag < max_queue ? tag : 0;
+		if (ap->flags & ATA_FLAG_LOWTAG)
+			tag = i;
+		else
+			tag = tag < max_queue ? tag : 0;
 
 		/* the last tag is reserved for internal command. */
 		if (tag == ATA_TAG_INTERNAL)
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -246,7 +246,7 @@ enum {
 	/* host flags */
 	SIL24_COMMON_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA |
 				  ATA_FLAG_NCQ | ATA_FLAG_ACPI_SATA |
-				  ATA_FLAG_AN | ATA_FLAG_PMP,
+				  ATA_FLAG_AN | ATA_FLAG_PMP | ATA_FLAG_LOWTAG,
 	SIL24_FLAG_PCIX_IRQ_WOC	= (1 << 24), /* IRQ loss errata on PCI-X */
 
 	IRQ_STAT_4PORTS		= 0xf,
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -230,6 +230,7 @@ enum {
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
 					      * led */
 	ATA_FLAG_NO_DIPM	= (1 << 23), /* host not happy with DIPM */
+	ATA_FLAG_LOWTAG		= (1 << 24), /* host wants lowest available tag */
 
 	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
 


