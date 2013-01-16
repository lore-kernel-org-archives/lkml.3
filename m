Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3APP5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:57:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35602 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3APP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:57:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Graf <agraf@suse.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 002/222] s390/kvm: dont announce RRBM support
Date: Wed, 16 Jan 2013 13:53:22 -0200
Message-Id: <1358351822-7675-3-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 87cac8f879a5ecd7109dbe688087e8810b3364eb upstream.

Newer kernels (linux-next with the transparent huge page patches)
use rrbm if the feature is announced via feature bit 66.
RRBM will cause intercepts, so KVM does not handle it right now,
causing an illegal instruction in the guest.
The  easy solution is to disable the feature bit for the guest.

This fixes bugs like:
Kernel BUG at 0000000000124c2a [verbose debug info unavailable]
illegal operation: 0001 [#1] SMP
Modules linked in: virtio_balloon virtio_net ipv6 autofs4
CPU: 0 Not tainted 3.5.4 #1
Process fmempig (pid: 659, task: 000000007b712fd0, ksp: 000000007bed3670)
Krnl PSW : 0704d00180000000 0000000000124c2a (pmdp_clear_flush_young+0x5e/0x80)
     R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 EA:3
     00000000003cc000 0000000000000004 0000000000000000 0000000079800000
     0000000000040000 0000000000000000 000000007bed3918 000000007cf40000
     0000000000000001 000003fff7f00000 000003d281a94000 000000007bed383c
     000000007bed3918 00000000005ecbf8 00000000002314a6 000000007bed36e0
 Krnl Code:>0000000000124c2a: b9810025          ogr     %r2,%r5
           0000000000124c2e: 41343000           la      %r3,0(%r4,%r3)
           0000000000124c32: a716fffa           brct    %r1,124c26
           0000000000124c36: b9010022           lngr    %r2,%r2
           0000000000124c3a: e3d0f0800004       lg      %r13,128(%r15)
           0000000000124c40: eb22003f000c       srlg    %r2,%r2,63
[ 2150.713198] Call Trace:
[ 2150.713223] ([<00000000002312c4>] page_referenced_one+0x6c/0x27c)
[ 2150.713749]  [<0000000000233812>] page_referenced+0x32a/0x410
[...]

CC: Alex Graf <agraf@suse.de>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/s390/kvm/kvm-s390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 664766d..cea9701 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -981,7 +981,7 @@ static int __init kvm_s390_init(void)
 	}
 	memcpy(facilities, S390_lowcore.stfle_fac_list, 16);
 	facilities[0] &= 0xff00fff3f47c0000ULL;
-	facilities[1] &= 0x201c000000000000ULL;
+	facilities[1] &= 0x001c000000000000ULL;
 	return 0;
 }
 
-- 
1.7.9.5

