Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaHIXTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 19:19:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60906 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbaHIXTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 19:19:24 -0400
X-Sasl-enc: n/jdMERVRzF0kcxLXPJ99u3oGtKCMU57N2NTguEq9AZ9 1407626363
Date: Sat, 9 Aug 2014 20:19:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: BUG: early intel microcode update violating alignment rules
Message-ID: <20140809231911.GA4843@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello x86 maintainers,

While adding some paranoia to the Intel Microcode driver, I noticed the
early Intel microcode update driver is not enforcing a 16-byte alignment
when it attempts to send the microcode update data to the processor via
WRMSR 79H.

This 16-byte alignment requirement is stated in the Intel SDM, vol 3A,
section 9.11.6, page 9-34.

Apparently at least some of the recent processors don't need the full
16-byte alignment, as a microcode update that is NOT aligned to 16 bytes,
but which is aligned to 4 bytes seems to work fine on a Xeon X5550 and on a
2nd-gen Core i5.

I detected the problem by adding an alignment test in
apply_microcode_early(), on file arch/x86/kernel/microcode_intel_early.c:

	if ((unsigned long)(mc_intel->bits) % 16)
		return -1;

Which fired on the next reboot, skipping the early update on the BSP and
APs.

This will only happen when the microcode update file data inside the early
initramfs archive is not 16-byte aligned.  Unfortunately, the cpio format
used in the early initramfs aligns the member file data just to 4-byte
boundaries.

Is there a way to fix this in the kernel for the BSP?  We already have
several microcode updates that are >16KiB in size and they seem to be
getting bigger and bigger, so doing it on the stack is out.

Maybe there is a 64KiB scratch area that could be used just to get the BSP
microcode update done?  vmalloc isn't available that early, but it can be
used to fix the issue for the APs.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
