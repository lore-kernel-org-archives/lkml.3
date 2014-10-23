Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbaJWMwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:52:25 -0400
Received: from marcansoft.com ([213.138.101.166]:48323 "EHLO
	mail.marcansoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbaJWMwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:52:22 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2014 08:52:22 EDT
Message-ID: <5448F83A.7010903@marcansoft.com>
Date: Thu, 23 Oct 2014 21:44:42 +0900
From: Hector Martin <hector@marcansoft.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: russ.dill@gmail.com
Subject: Re: [PATCH] usb: serial: Perform verification for FTDI FT232R devices
In-Reply-To: 1414054344-3688-1-git-send-email-Russ.Dill@gmail.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK. This patch neither accomplishes what FTDI intended, nor what the
author humorously intended.

> +	/* Attempt to set Vendor ID to 0 */
> +	eeprom_data[1] = 0;
> +
> +	/* Calculate new checksum to avoid bricking devices */
> +	checksum = ftdi_checksum(eeprom_data, eeprom_size);
> +
> +	/* Verify EEPROM programming behavior/nonbehavior */
> +	write_eeprom(port, 1, 0);
> +	write_eeprom(port, eeprom_size - 1, checksum);

FTDI's verification routine sets the Product ID (at address 2) to 0 and
a dummy word (at address 0x3e) to a correctly crafted value that makes
the existing checksum pass. This bricks clone devices (setting PID to
0), while original FT232RL devices are not affected as they only commit
writes when they receive a write command to an odd EEPROM address,
combining it with the most recently issued write to an even address and
writing 32 bits at a time.

This patch instead writes the Vendor ID (at address 1) and the real
checksum (at address 0x3f). As amusing as bricking all devices would be,
unfortunately, a real FT232RL would just write garbage at addresses 0
and 0x3e too (as writes are still 32 bits, and no prior even-addressed
writes have occurred, so the holding register on the chip contains
garbage). Therefore, the real effect of this patch is to brick clone
devices (in a different way from the official driver, killing the VID
instead of the PID), while merely resetting original FT232RL devices to
defaults, due to the inadvertently corrupted even words now causing a
checksum mismatch.

Props on the humor, try again with better code next time ;-). I suggest
the following:

+	write_eeprom(port, 0, eeprom_data[0]);
+	write_eeprom(port, 1, 0);
+	write_eeprom(port, eeprom_size - 2, eeprom_data[eeprom_size - 2]);
+	write_eeprom(port, eeprom_size - 1, checksum);

This will correctly set the Vendor ID to zero on all devices, counterfeit
or not.

-- 
Hector Martin (hector@marcansoft.com)
Public Key: http://www.marcansoft.com/marcan.asc

