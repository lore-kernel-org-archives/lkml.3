Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3IMQ3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:29:01 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:47040 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3IMQ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:28:59 -0400
Message-ID: <1379089736.2197.14.camel@buesod1.americas.hpqcorp.net>
Subject: Re: GPT detection regression in efi.c from commit 27a7c64
From: Davidlohr Bueso <davidlohr@hp.com>
To: Matt Porter <matt.porter@linaro.org>
Cc: Karel Zak <kzak@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Date: Fri, 13 Sep 2013 09:28:56 -0700
In-Reply-To: <20130913145033.GA8502@ohporter.com>
References: <20130913145033.GA8502@ohporter.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing Linus.

On Fri, 2013-09-13 at 10:50 -0400, Matt Porter wrote:
> The commit, "27a7c64 partitions/efi: account for pmbr size in lba", that
> was just merged in 3.12-rc caused a regression on my system with a GPT
> formatted eMMC device. In 3.11, the GPT partition table was detected
> fine but now a partition table is not detected.
> 
> Not being a GPT expert, I did some research and found that the tool used
> to create the PMBR on my system shares characteristics with what is
> mentioned in an explanation of Microsoft created PMBRs [1]. In short,
> the size_in_lba field incorrectly has 0xffffffff even though I have a
> <2TiB drive (16GiB eMMC).

*sigh*. So Microsoft decided to do its own version of the GPT specs. 

Up until now, Linux was incorrectly enforcing pMBR checks: not
recognizing valid labels and vice versa, as with the case you are
mentioning now. The changes that went in the 3.12 merge window attempt
to address those concerns, enforcing the correct checks - which is also
how Linux partitioning tools do it (fdisk, parted).

> 
> I get that this is not compliant with UEFI. I bring this up because
> before this commit the is_pmbr_valid() check was less pedantic. In 3.11
> a PMBR formatted this way did not fail the check. For my particular
> case, I simply dded out LBA 1 and whacked the SizeInLBA field to comply
> with the spec and this patch and I'm back in business. We're updating
> the tools that we inherited to prepopulate our boards with a GPT to be
> compliant. However, I wondered if this would be a problem for all the
> people with Windows-generated GPTs as noted in [1].

I guess this comes down to choosing whether or not we want Linux to be
more UEFI compliant or not. Should we care if Microsoft decides to go do
things out of the official spec? I don't know the policy here. The fact
is that *they* should update their partitioning tools and create valid
pMBRs. Any way, I'm ok with reverting this commit if deemed necessary.

Thanks,
Davidlohr

> 
> -Matt
> 
> [1] http://thestarman.pcministry.com/asm/mbr/GPT.htm#GPTPT
> 
> "The partition table contains only a single "GPT Protective" entry which
> in all cases is set to the maximum 32-bit limitation (even though a
> drive may have far less than a 2.2 TB capacity). The "GPT Protective MBR
> Sector" has exactly the same contents for all GPT disk drives created by
> the Windows 7 (or 8) OS. But, note: This does not follow the UEFI
> Specification, which states that the "SizeInLBA" should be "set to the
> size of the disk minus one" if it's not too large to be represented.[1]
> (GPT drives partitioned under various Linux and Apple® Mac OS systems do
> follow the UEFI Specification in this regard.)"


