Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaKYLnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:43:47 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:54499 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbaKYLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:43:43 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com
Subject: [RFC 0/2] Reenable might_sleep() checks for might_fault() when atomic
Date: Tue, 25 Nov 2014 12:43:24 +0100
Message-Id: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112511-0041-0000-0000-0000023EAC6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently discovered that commit 662bbcb2747c2422cf98d3d97619509379eee466
removed/skipped all might_sleep checks for might_fault() calls when in atomic.

Reason was to allow calling copy_(to|from)_user while in pagefault_disabled(),
because otherwise, CONFIG_DEBUG_ATOMIC_SLEEP would find false positives. However
we have the inatomic variants of these function for this purpose.

The result of this change was that all guest access (that correctly uses
might_fault()) doesn't perform atomic checks when CONFIG_DEBUG_ATOMIC_SLEEP is
enabled. We lost a mighty debugging feature for user access.

As I wasn't able to come up with any other reason why this should be
necessary, I suggest turning the might_sleep() checks on again in the
might_fault() code.

pagefault_disable/pagefault_enable seems to be used mainly for futex, perf event
and kmap.

Going over all changes since that commit, it seems like most code already uses the
inatomic variants of copy_(to|from)_user. Code relying on (get|put)_user during
pagefault_disable() don't make use of any might_fault() in their (get|put)_user
implementation. Examples:
- arch/m68k/include/asm/futex.h
- arch/parisc/include/asm/futex.h
- arch/sh/include/asm/futex-irq.h
- arch/tile/include/asm/futex.h
So changing might_fault() back to trigger might_sleep() won't change a thing for
them. Hope I haven't missed anything.

I only identified one might_fault() that would get triggered by get_user() on
powerpc and fixed it by using the inatomic variant (not tested). I am not sure
if we need some non-sleeping access_ok() prior to __get_user_inatomic().

By looking at the code I was wondering where the correct place for might_fault()
calls is? Doesn't seem to be very consistent. Examples:

                   | asm-generic | arm | arm64 | frv | m32r | x86 and s390
---------------------------------------------------------------------------
get_user()         |   Yes       | Yes | Yes   | No  | Yes  |     Yes
__get_user()       |   No        | Yes | No    | No  | Yes  |     No
put_user()         |   Yes       | Yes | Yes   | No  | Yes  |     Yes
__put_user()       |   No        | Yes | No    | No  | Yes  |     No
copy_to_user()     |   Yes       | No  | No    | Yes | Yes  |     Yes
__copy_to_user()   |   No        | No  | No    | Yes | No   |     No
copy_from_user()   |   Yes       | No  | No    | Yes | Yes  |     Yes
__copy_from_user() |   No        | No  | No    | Yes | No   |     No

So I would have assume that the way asm-generic, x86 and s390 (+ propably
others) do this is the right way?
So we can speed up multiple calls to e.g. copy_to_user() by doing the access
check manually (and also the might_fault() if relevant), then calling
__copy_to_user().

So in general, I conclude that the concept is:
1. __.* variants perform no checking and don't call might_fault()
2. [a-z].* variants perform access checking (access_ok() if implemented)
3. [a-z].* variants call might_fault()
4. .*_inatomic variants usually don't perform access checks
5. .*_inatomic variants don't call might_fault()
6. If common code uses the __.* variants, it has to trigger access_ok() and
   call might_fault()
7. For pagefault_disable(), the inatomic variants are to be used

Comments? Opinions?


David Hildenbrand (2):
  powerpc/fsl-pci: atomic get_user when pagefault_disabled
  mm, sched: trigger might_sleep() in might_fault() when atomic

 arch/powerpc/sysdev/fsl_pci.c |  2 +-
 include/linux/kernel.h        |  8 ++++++--
 mm/memory.c                   | 11 ++++-------
 3 files changed, 11 insertions(+), 10 deletions(-)

-- 
1.8.5.5

