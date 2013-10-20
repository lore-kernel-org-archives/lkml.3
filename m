Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3JTVfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 17:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab3JTVfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 17:35:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, x86@kernel.org,
        herrmann.der.user@googlemail.com, ming.lei@canonical.com,
        tigran@aivazian.fsnet.co.uk
Subject: [PATCH 0/2] Improve firmware loading times on AMD and Intel
Date: Sun, 20 Oct 2013 17:35:24 -0400
Message-Id: <1382304926-1641-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no firmware is found on the system that matches the processor, the
microcode module can take hours to load.  For example on recent kernels
when loading the microcode module on an Intel system:

[  239.532116] microcode: CPU0 sig=0x306e4, pf=0x1, revision=0x413
[  299.693447] microcode: CPU1 sig=0x306e4, pf=0x1, revision=0x413
[  359.821972] microcode: CPU2 sig=0x306e4, pf=0x1, revision=0x413
[  419.960263] microcode: CPU3 sig=0x306e4, pf=0x1, revision=0x413
[  480.090024] microcode: CPU4 sig=0x306e4, pf=0x1, revision=0x413
...
[ 2825.151364] microcode: CPU43 sig=0x306e4, pf=0x1, revision=0x413
[ 2885.280863] microcode: CPU44 sig=0x306e4, pf=0x1, revision=0x413
[ 2945.410719] microcode: CPU45 sig=0x306e4, pf=0x1, revision=0x413
[ 3005.540541] microcode: CPU46 sig=0x306e4, pf=0x1, revision=0x413
[ 3065.670405] microcode: CPU47 sig=0x306e4, pf=0x1, revision=0x413
...
etc.

Since this takes 1 minute per cpu, the microcode module requires two hours to
load on a 120 cpu Intel box.

Similarly there is a 60 second "hang" when loading the AMD module, which
isn't as bad as the Intel situation, but it is a noticeable delay in the
system boot.

Using request_firmware_nowait() seems more appropriate here and then we
can avoid these delays, resulting in very quick load times for the
microcode.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: x86@kernel.org
Cc: herrmann.der.user@googlemail.com
Cc: ming.lei@canonical.com
Cc: tigran@aivazian.fsnet.co.uk

Prarit Bhargava (2):
  firmware, fix request_firmware_nowait() freeze with no uevent
  intel_microcode, Fix long microcode load time when firmware file is
    missing

 arch/x86/include/asm/microcode.h  |    7 ++++
 arch/x86/kernel/microcode_amd.c   |   79 +++++++++++++++++++++++++++----------
 arch/x86/kernel/microcode_core.c  |    7 ++++
 arch/x86/kernel/microcode_intel.c |   67 +++++++++++++++++++++++++------
 drivers/base/firmware_class.c     |    6 ++-
 5 files changed, 132 insertions(+), 34 deletions(-)

-- 
1.7.9.3

