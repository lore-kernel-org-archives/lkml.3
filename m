Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3FDFaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3FDFac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:30:32 -0400
Message-ID: <51AD7B45.1040603@redhat.com>
Date: Tue, 04 Jun 2013 13:29:41 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: rja@sgi.com, mingo@kernel.org, torvalds@linux-foundation.org, bp@alien8.de,
        jkosina@suse.cz, jlee@suse.com, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] Modify UEFI anti-bricking code
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2013 04:06 AM, Matthew Garrett wrote:
> This patch reworks the UEFI anti-bricking code, including an effective
> reversion of cc5a080c and 31ff2f20. It turns out that calling
> QueryVariableInfo() from boot services results in some firmware
> implementations jumping to physical addresses even after entering virtual
> mode, so until we have 1:1 mappings for UEFI runtime space this isn't
> going to work so well.
>
> Reverting these gets us back to the situation where we'd refuse to create
> variables on some systems because they classify deleted variables as "used"
> until the firmware triggers a garbage collection run, which they won't do
> until they reach a lower threshold. This results in it being impossible to
> install a bootloader, which is unhelpful.
>
> Feedback from Samsung indicates that the firmware doesn't need more than
> 5KB of storage space for its own purposes, so that seems like a reasonable
> threshold. However, there's still no guarantee that a platform will attempt
> garbage collection merely because it drops below this threshold. It seems
> that this is often only triggered if an attempt to write generates a
> genuine EFI_OUT_OF_RESOURCES error. We can force that by attempting to
> create a variable larger than the remaining space. This should fail, but if
> it somehow succeeds we can then immediately delete it.
>
> I've tested this on the UEFI machines I have available, but I don't have
> a Samsung and so can't verify that it avoids the bricking problem.

This patch works well on my Dell Windows 8 logo machine.

This Dell machine will use up ~2K nvram space on each reboot and do 
garbage collection at boot time when full. With the new 5K threshold, it 
is only a few reboots away from boot time garbage collection anyway.

Run time garbage collection also works. But the write takes 5 seconds.


Lingzhu Xiang
