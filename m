Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab3IMOrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:47:01 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42060 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3IMOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:47:00 -0400
Date: Fri, 13 Sep 2013 10:46:55 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Karel Zak <kzak@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20130913144654.GG10973@ohporter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lkml
Bcc: 
Subject: GPT detection regression in efi.c from commit 27a7c64
Reply-To: 

The commit, "27a7c64 partitions/efi: account for pmbr size in lba", that
was just merged in 3.12-rc caused a regression on my system with a GPT
formatted eMMC device. In 3.11, the GPT partition table was detected
fine but now a partition table is not detected.

Not being a GPT expert, I did some research and found that the tool used
to create the PMBR on my system shares characteristics with what is
mentioned in an explanation of Microsoft created PMBRs [1]. In short,
the size_in_lba field incorrectly has 0xffffffff even though I have a
<2TiB drive (16GiB eMMC).

I get that this is not compliant with UEFI. I bring this up because
before this commit the is_pmbr_valid() check was less pedantic. In 3.11
a PMBR formatted this way did not fail the check. For my particular
case, I simply dded out LBA 1 and whacked the SizeInLBA field to comply
with the spec and this patch and I'm back in business. We're updating
the tools that we inherited to prepopulate our boards with a GPT to be
compliant. However, I wondered if this would be a problem for all the
people with Windows-generated GPTs as noted in [1].

-Matt

[1] http://thestarman.pcministry.com/asm/mbr/GPT.htm#GPTPT

"The partition table contains only a single "GPT Protective" entry which
in all cases is set to the maximum 32-bit limitation (even though a
drive may have far less than a 2.2 TB capacity). The "GPT Protective MBR
Sector" has exactly the same contents for all GPT disk drives created by
the Windows 7 (or 8) OS. But, note: This does not follow the UEFI
Specification, which states that the "SizeInLBA" should be "set to the
size of the disk minus one" if it's not too large to be represented.[1]
(GPT drives partitioned under various Linux and Apple® Mac OS systems do
follow the UEFI Specification in this regard.)"

