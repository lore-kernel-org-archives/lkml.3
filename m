Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaHUGud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:50:33 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:57655 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaHUGua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:50:30 -0400
From: "Zhao, Hui-Zhi (Steven, HPservers-Core-OE-PSC)" <hui-zhi.zhao@hp.com>
To: =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        "Raghavendra KT" <raghavendra.kt@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: RE: [PATCH v2 0/6] Dynamic Pause Loop Exiting window.
Thread-Topic: [PATCH v2 0/6] Dynamic Pause Loop Exiting window.
Thread-Index: AQHPvLjban0sWhIckkuvxGqFxJK+4Jvagw6A
Date: Thu, 21 Aug 2014 06:49:18 +0000
Message-ID: <DB5C686A0A7EE44A895494A4E25D21FC1C91EB8A@G5W2731.americas.hpqcorp.net>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.201.12.22]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7L6ocsM003872

This patch have been tested by Lisa and me and it's success.

We created 4 VM guests and reboot them every 10 minutes for 12 hours around, and this issue is gone with the patch.


Please add Lisa and me to the "tested by:" list.
Tested-by: Mitchell, Lisa <lisa.mitchell@hp.com>
Tested-by: Zhao, Hui Zhi <hui-zhi.zhao@hp.com>


Regards,
Steven Zhao

-----Original Message-----
From: Radim KrÄmÃ¡Å™ [mailto:rkrcmar@redhat.com] 
Sent: Thursday, August 21, 2014 4:53 AM
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org; Paolo Bonzini; Gleb Natapov; Raghavendra KT; Vinod, Chegu; Zhao, Hui-Zhi (Steven, HPservers-Core-OE-PSC); Christian Borntraeger
Subject: [PATCH v2 0/6] Dynamic Pause Loop Exiting window.

v1 -> v2:
 * squashed [v1 4/9] and [v1 5/9] (clamping)
 * dropped [v1 7/9] (CPP abstractions)
 * merged core of [v1 9/9] into [v1 4/9] (automatic maximum)
 * reworked kernel_param_ops: closer to pure int [v2 6/6]
 * introduced ple_window_actual_max & reworked clamping [v2 4/6]
 * added seqlock for parameter modifications [v2 6/6]

---
PLE does not scale in its current form.  When increasing VCPU count above 150, one can hit soft lockups because of runqueue lock contention.
(Which says a lot about performance.)

The main reason is that kvm_ple_loop cycles through all VCPUs.
Replacing it with a scalable solution would be ideal, but it has already been well optimized for various workloads, so this series tries to alleviate one different major problem while minimizing a chance of
regressions: we have too many useless PLE exits.

Just increasing PLE window would help some cases, but it still spirals out of control.  By increasing the window after every PLE exit, we can limit the amount of useless ones, so we don't reach the state where CPUs spend 99% of the time waiting for a lock.

HP confirmed that this series prevents soft lockups and TSC sync errors on large guests.

Radim KrÄmÃ¡Å™ (6):
  KVM: add kvm_arch_sched_in
  KVM: x86: introduce sched_in to kvm_x86_ops
  KVM: VMX: make PLE window per-VCPU
  KVM: VMX: dynamise PLE window
  KVM: trace kvm_ple_window
  KVM: VMX: runtime knobs for dynamic PLE window

 arch/arm/kvm/arm.c              |   4 ++
 arch/mips/kvm/mips.c            |   4 ++
 arch/powerpc/kvm/powerpc.c      |   4 ++
 arch/s390/kvm/kvm-s390.c        |   4 ++
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/svm.c              |   6 ++
 arch/x86/kvm/trace.h            |  25 ++++++++
 arch/x86/kvm/vmx.c              | 124 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |   6 ++
 include/linux/kvm_host.h        |   2 +
 virt/kvm/kvm_main.c             |   2 +
 11 files changed, 179 insertions(+), 4 deletions(-)

--
2.0.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
