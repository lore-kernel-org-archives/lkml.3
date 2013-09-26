Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3IZWNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:13:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55224 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3IZWNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:13:37 -0400
Date: Fri, 27 Sep 2013 00:13:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: suravee.suthikulpanit@amd.com
Cc: herrmann.der.user@googlemail.com, jacob.w.shin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Fix patch level reporting for
 family15h
Message-ID: <20130926221322.GC10123@pd.tnic>
References: <1380232472-2589-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1380232472-2589-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:54:32PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> On AMD family15h, applying microcode patch on the a core (core0)
> would also affect the other core (core1) in the same compute unit.
> The driver would skip applying the patch on core1, but it still
> need to update kernel structures to reflect the proper patch level.
> 
> The current logic is not updating the struct ucode_cpu_info.cpu_sig.rev
> of the skipped core. This causes the /sys/devices/system/cpu/cpu1/microcode/version
> to report incorrect patch level as shown below:
> 
> [   10.708841] microcode: CPU0: new patch_level=0x0600063d
> [   10.714256] microcode: CPU1: patch_level=0x06000626
> [   10.719345] microcode: CPU2: patch_level=0x06000626
> [   10.748095] microcode: CPU2: new patch_level=0x0600063d
> [   10.753365] microcode: CPU3: patch_level=0x06000626
> [   10.758264] microcode: CPU4: patch_level=0x06000626
> [   10.786999] microcode: CPU4: new patch_level=0x0600063d

Actually, this is collect_cpu_info_amd()'s normal operation and shows
that there's no need to apply a microcode patch on the odd core since
the even core's ucode has been updated.

Actually you need something like that:

$ grep . cpu?/microcode/version
cpu0/microcode/version:0x6000822
cpu1/microcode/version:0x600081f
cpu2/microcode/version:0x6000822
cpu3/microcode/version:0x600081f
cpu4/microcode/version:0x6000822
cpu5/microcode/version:0x600081f
cpu6/microcode/version:0x6000822
cpu7/microcode/version:0x600081f

which shows the bug. Other than that, the patch is correct so please fix
the commit message and add x86@kernel.org to CC on the next submission
so that it gets picked by x86 people.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
