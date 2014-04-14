Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaDNL1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:27:21 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45702 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaDNL1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:27:19 -0400
Date: Mon, 14 Apr 2014 13:27:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mjg59@srcf.ucam.org, aubrey.li@linux.intel.com, rostedt@goodmis.org,
        tglx@linutronix.de, Borislav Petkov <bp@alien8.de>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
Message-ID: <20140414112714.GC4050@gmail.com>
References: <20140404064120.GB11877@gmail.com>
 <tip-f042310bf8a846bcf21012ffee78d9eb562a7fa4@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-f042310bf8a846bcf21012ffee78d9eb562a7fa4@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Ingo Molnar <tipbot@zytor.com> wrote:

> Commit-ID:  f042310bf8a846bcf21012ffee78d9eb562a7fa4
> Gitweb:     http://git.kernel.org/tip/f042310bf8a846bcf21012ffee78d9eb562a7fa4
> Author:     Ingo Molnar <mingo@kernel.org>
> AuthorDate: Fri, 4 Apr 2014 08:41:26 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 14 Apr 2014 13:13:30 +0200
> 
> [PATCH] x86: Try the BIOS reboot method before the PCI reboot method
> 
> Steve reported a reboot hang and bisected it back to this commit:
> 
>   a4f1987e4c54 x86, reboot: Add EFI and CF9 reboot methods into the default list
> 
> He heroically tested all reboot methods and found the following:
> 
>   reboot=t       # triple fault                  ok
>   reboot=k       # keyboard ctrl                 FAIL
>   reboot=b       # BIOS                          ok
>   reboot=a       # ACPI                          FAIL
>   reboot=e       # EFI                           FAIL   [system has no EFI]
>   reboot=p       # PCI 0xcf9                     FAIL
> 
> And I think it's pretty obvious that we should only try 0xcf9 as a
> last resort - if at all.
> 
> The other observation is that (on this box) we should never try
> the PCI reboot method, but close with either the 'triple fault'
> or the 'BIOS' (terminal!) reboot methods.
> 
> Thirdly, CF9_COND is a total misnomer - it should be something like
> CF9_SAFE or CF9_CAREFUL, and 'CF9' should be 'CF9_FORCE' ...
> 
> So this patch fixes the worst problems:
> 
>  - it orders the actual reboot logic to follow the reboot ordering
>    pattern - it was in a pretty random order before for no good
>    reason.
> 
>  - it fixes the CF9 misnomers and uses BOOT_CF9_FORCE and
>    BOOT_CF9_SAFE flags to make the code more obvious.
> 
>  - it tries the BIOS reboot method before the PCI reboot method.
>    (Since 'BIOS' is a terminal reboot method resulting in a hang
>     if it does not work, this is essentially equivalent to removing
>     the PCI reboot method from the default reboot chain.)
> 
>  - just for the miraculous possibility of terminal (resulting
>    in hang) reboot methods of triple fault or BIOS returning
>    without having done their job, there's an ordering between
>    them as well.
> 
> Reported-and-bisected-and-tested-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Li Aubrey <aubrey.li@linux.intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Link: http://lkml.kernel.org/r/20140404064120.GB11877@gmail.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

So I rebased the patch Steve tested as-is and only fixed the patch 
description and some comments in the code, preserving Steve's testing 
status, and propagated it into x86/urgent.

I've added this description that tries to describe the new/old logic:

> + * To the best of our knowledge Windows compatible x86 hardware expects
> + * the following on reboot:
>   *
>   * 1) If the FADT has the ACPI reboot register flag set, try it
>   * 2) If still alive, write to the keyboard controller
>   * 3) If still alive, write to the ACPI reboot register again
>   * 4) If still alive, write to the keyboard controller again
>   * 5) If still alive, call the EFI runtime service to reboot
> + * 6) If no EFI runtime service, call the BIOS to do a reboot
>   *
> + * We default to following the same pattern. We also have
> + * two other reboot methods: 'triple fault' and 'PCI', which
> + * can be triggered via the reboot= kernel boot option or
> + * via quirks.
> + *
> + * This means that this function can never return, it can misbehave
> + * by not rebooting properly and hanging.

If this is inaccurate (or undesirable, or fails to match the fine 
code) then please object.

Thanks,

	Ingo
