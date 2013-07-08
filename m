Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3GHPtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:49:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3GHPta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:49:30 -0400
Subject: Suspect loop in dmi_scan_machine()
From: Jean Delvare <jdelvare@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 08 Jul 2013 17:49:14 +0200
Message-ID: <1373298554.4298.228.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

I am looking at this commit of yours:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/firmware/dmi_scan.c?id=79bae42d51a5d498500c890c19ef76df41d2bf59

and am a little worried about the for loop in dmi_scan_machine()
(non-EFI case):

* The first iteration looks wrong, as you're resetting the lower half of
buf to 0 instead of initializing it with the 16 first bytes of p. So if
a system as its SMBIOS entry point at 0xF0000, your code won't see it.
Thankfully it will get the DMI entry point, but if the version is in the
SMBIOS entry point, it will be missed.

* The last iteration looks wrong too, as you are reading from offsets
0x10000-0x1000F of an iomap area of size 0x10000, i.e. beyond the end of
the area. You'll hit that on a machine without SMBIOS/DMI. I'm not sure
what exactly happens when calling memcpy_fromio() on an unmapped area
but I'm reasonably certain this is bad and shouldn't be attempted.

Also, the code only looks for the DMI entry point in the second half of
the buffer, so it would also miss a legacy DMI entry point at 0xF0000.

Thoughts?

-- 
Jean Delvare
Suse L3

