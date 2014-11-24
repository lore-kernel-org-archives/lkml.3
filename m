Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaKXSbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:31:52 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61100 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaKXSbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:31:49 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: linux-spi@vger.kernel.org
Cc: andrew.smirnov@gmail.com, yurovsky@gmail.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC, PATCH, RESEND] spi, spidev: Add support for long SPI transfers
Date: Mon, 24 Nov 2014 10:31:33 -0800
Message-Id: <1416853893-1993-1-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPI controllers found on modern SoCs have rather large SPI FIFOs and
allow for uninterrupted SPI transaction that are more then 255 bits
long. This commit adds necessary plumbing for such SPI transfers.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---

Changes:
 - Fixed commit message
 - Ditched the cover letter
 - Used correct address for linux-kernel mailing list

Hi,

This patch is a very first, very preliminary version of the feature I
am implementing for niche usecase of SPI in a system I am working
on. It by no means contains production code and is purely RFC to "test
the water" and see if there would be any interest in including this in
mainline tree.

The system I am working with implements a lion's share of its
functionality in an extrenal FPGA connected to an ARM SoC via SPI
bus. In my use-case SPI bus used both for initial bitfile programming
of the FPGA and sending/fetching data to/from FPGA as well. Both use
cases, can benefit greatly from ability to send very long bit streams
over SPI as a single transaction during which CS line stays low the
whole time. The use-case of programming the FPGA is the most important
for me, since it is mandatory to program the FPGA before the rest of
the system can proceed to a functioning state and therefore my
"Applied power -> Functional State" time is greatly influenced by that
operation.

As things are right now both SPI subsystem and SPIDEV driver are
limited by their APIs to SPI transactions that are no longer than 255
bits and that problem is exacerbated by the fact that transction
length validity verification code does not have provisions for
anything bigger than 32 bits.

The code in this RFC deals only with the first problem, as I am not
sure what would best way to tackle the second one.

So I guess my two maing questions for this RFC are the following:

 - Is this work seem like a good fit to be included in the mainline
   kernel, or should I just keep doing it as my system specifica hack
   and not bother with upsteaming?

 - If the idea is good for upstreaming what would be a good way to
   improve length checking code? I was thinking of ditching the
   bitmask in favour of driver provided function that would take
   transfer length as an argument, are there any better options?

Thank you.

Andrey Smirnov


 drivers/spi/spidev.c            | 7 ++++++-
 include/linux/spi/spi.h         | 4 ++--
 include/uapi/linux/spi/spidev.h | 2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index d7c6e36..45d8905 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -265,7 +265,12 @@ static int spidev_message(struct spidev_data *spidev,
 		buf += k_tmp->len;
 
 		k_tmp->cs_change = !!u_tmp->cs_change;
-		k_tmp->bits_per_word = u_tmp->bits_per_word;
+
+		if (!u_tmp->bits_per_word && u_tmp->bits_per_burst)
+			k_tmp->bits_per_word = u_tmp->bits_per_burst;
+		else
+			k_tmp->bits_per_word = u_tmp->bits_per_word;
+
 		k_tmp->delay_usecs = u_tmp->delay_usecs;
 		k_tmp->speed_hz = u_tmp->speed_hz;
 #ifdef VERBOSE
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 4203c66..a0c34c1 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -75,7 +75,7 @@ struct spi_device {
 	struct spi_master	*master;
 	u32			max_speed_hz;
 	u8			chip_select;
-	u8			bits_per_word;
+	u32			bits_per_word;
 	u16			mode;
 #define	SPI_CPHA	0x01			/* clock phase */
 #define	SPI_CPOL	0x02			/* clock polarity */
@@ -586,7 +586,7 @@ struct spi_transfer {
 #define	SPI_NBITS_SINGLE	0x01 /* 1bit transfer */
 #define	SPI_NBITS_DUAL		0x02 /* 2bits transfer */
 #define	SPI_NBITS_QUAD		0x04 /* 4bits transfer */
-	u8		bits_per_word;
+	u32		bits_per_word;
 	u16		delay_usecs;
 	u32		speed_hz;
 
diff --git a/include/uapi/linux/spi/spidev.h b/include/uapi/linux/spi/spidev.h
index 52d9ed0..b70f3d4 100644
--- a/include/uapi/linux/spi/spidev.h
+++ b/include/uapi/linux/spi/spidev.h
@@ -92,7 +92,7 @@ struct spi_ioc_transfer {
 	__u16		delay_usecs;
 	__u8		bits_per_word;
 	__u8		cs_change;
-	__u32		pad;
+	__u32		bits_per_burst;
 
 	/* If the contents of 'struct spi_ioc_transfer' ever change
 	 * incompatibly, then the ioctl number (currently 0) must change;
-- 
1.9.3

