Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3LSKte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:49:34 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:38656 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355Ab3LSKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:49:29 -0500
Date: Thu, 19 Dec 2013 10:49:08 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 02/14] x86-64/efi: Use EFI to deal with platform wall
 clock (again)
Message-ID: <20131219104908.GE3145@console-pimps.org>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
 <1387448416-11672-1-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387448416-11672-1-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec, at 06:20:16PM, Lee, Chun-Yi wrote:
> From: Jan Beulich <JBeulich@suse.com>
> 
> Other than ix86, x86-64 on EFI so far didn't set the
> {g,s}et_wallclock accessors to the EFI routines, thus
> incorrectly using raw RTC accesses instead.
> 
> Simply removing the #ifdef around the respective code isn't
> enough, however: While so far early get-time calls were done in
> physical mode, this doesn't work properly for x86-64, as virtual
> addresses would still need to be set up for all runtime regions
> (which wasn't the case on the system I have access to), so
> instead the patch moves the call to efi_enter_virtual_mode()
> ahead (which in turn allows to drop all code related to calling
> efi-get-time in physical mode).
> 
> Additionally the earlier calling of efi_set_executable()
> requires the CPA code to cope, i.e. during early boot it must be
> avoided to call cpa_flush_array(), as the first thing this
> function does is a BUG_ON(irqs_disabled()).
> 
> Also make the two EFI functions in question here static -
> they're not being referenced elsewhere.
> 
> History:
> 
>     This commit was originally merged as bacef661acdb ("x86-64/efi:
>     Use EFI to deal with platform wall clock") but it resulted in some
>     ASUS machines no longer booting due to a firmware bug, and so was
>     reverted in f026cfa82f62.
> 
>     Then a pre-emptive fix for the buggy ASUS firmware was merged in
>     03a1c254975e ("x86, efi: 1:1 pagetable mapping for virtual EFI
>     calls") but it causes odd bootup problems on x86-64. So this patch
>     revoked again by 11520e5e7c1.
> 
>     Now Borislav Petkov's "EFI runtime services virtual mapping" is
>     merged to EFI 'next' branch. So this patch can be reapplied again.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Tested-by: Matt Fleming <matt.fleming@intel.com>
> Acked-by: Matthew Garrett <mjg@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com> [added commit history]
> Acked-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  arch/x86/mm/pageattr.c      |   10 ++++++----
>  arch/x86/platform/efi/efi.c |   35 +++++++++++------------------------
>  include/linux/efi.h         |    2 --
>  init/main.c                 |    8 ++++----
>  4 files changed, 21 insertions(+), 34 deletions(-)

Lee, you can't just simply resend this patch with all the tags - I
haven't tested this version with any recent changes and I'm pretty sure
Matthew isn't going to Ack it.

Do you know if anyone has tested this patch with Borislav's recent
changes?

-- 
Matt Fleming, Intel Open Source Technology Center
