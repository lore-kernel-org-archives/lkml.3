Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaHUGuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:50:00 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:57650 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaHUGt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:49:59 -0400
From: "Zhao, Hui-Zhi (Steven, HPservers-Core-OE-PSC)" <hui-zhi.zhao@hp.com>
To: =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, "Gleb Natapov" <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>
CC: "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: RE: [PATCH 0/9] Dynamic Pause Loop Exiting window.
Thread-Topic: [PATCH 0/9] Dynamic Pause Loop Exiting window.
Thread-Index: AQHPu+1fjOE6WtwqRE2UjvvX/8AMiJvagXPw
Date: Thu, 21 Aug 2014 06:48:46 +0000
Message-ID: <DB5C686A0A7EE44A895494A4E25D21FC1C91EB7D@G5W2731.americas.hpqcorp.net>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7L6o9Wf003868

This patch have been tested by Lisa and me and it's success.

We created 4 VM guests and reboot them every 10 minutes for 12 hours around, and this issue is gone with the patch.


Please add Lisa and me to the "tested by:" list.
Tested-by: Mitchell, Lisa <lisa.mitchell@hp.com>
Tested-by: Zhao, Hui Zhi <hui-zhi.zhao@hp.com>


Regards,
Steven Zhao

-----Original Message-----
From: Radim KrÄmÃ¡Å™ [mailto:rkrcmar@redhat.com] 
Sent: Wednesday, August 20, 2014 4:35 AM
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org; Paolo Bonzini; Gleb Natapov; Raghavendra KT; Vinod, Chegu; Zhao, Hui-Zhi (Steven, HPservers-Core-OE-PSC)
Subject: [PATCH 0/9] Dynamic Pause Loop Exiting window.

PLE does not scale in its current form.  When increasing VCPU count above 150, one can hit soft lockups because of runqueue lock contention.
(Which says a lot about performance.)

The main reason is that kvm_ple_loop cycles through all VCPUs.
Replacing it with a scalable solution would be ideal, but it has already been well optimized for various workloads, so this series tries to alleviate one different major problem while minimizing a chance of
regressions: we have too many useless PLE exits.

Just increasing PLE window would help some cases, but it still spirals out of control.  By increasing the window after every PLE exit, we can limit the amount of useless ones, so we don't reach the state where CPUs spend 99% of the time waiting for a lock.

HP confirmed that this series avoids soft lockups and TSC sync errors on large guests.

---
Design notes and questions:

Alternative to first two patches could be a new notifier.

All values are made changeable because defaults weren't selected after weeks of benchmarking -- we can get improved performance by hardcoding if someone is willing to do it.
(Or by presuming that noone is ever going to.)

Then, we can quite safely drop overflow checks: they are impossible to hit with small increases and I don't think that anyone wants large ones.

Also, I'd argue against the last patch: it should be done in userspace, but I'm not sure about Linux's policy.


Radim KrÄmÃ¡Å™ (9):
  KVM: add kvm_arch_sched_in
  KVM: x86: introduce sched_in to kvm_x86_ops
  KVM: VMX: make PLE window per-vcpu
  KVM: VMX: dynamise PLE window
  KVM: VMX: clamp PLE window
  KVM: trace kvm_ple_window grow/shrink
  KVM: VMX: abstract ple_window modifiers
  KVM: VMX: runtime knobs for dynamic PLE window
  KVM: VMX: automatic PLE window maximum

 arch/arm/kvm/arm.c              |  4 ++
 arch/mips/kvm/mips.c            |  4 ++
 arch/powerpc/kvm/powerpc.c      |  4 ++
 arch/s390/kvm/kvm-s390.c        |  4 ++
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/svm.c              |  6 +++
 arch/x86/kvm/trace.h            | 29 +++++++++++++
 arch/x86/kvm/vmx.c              | 93 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |  6 +++
 include/linux/kvm_host.h        |  2 +
 virt/kvm/kvm_main.c             |  2 +
 11 files changed, 153 insertions(+), 3 deletions(-)

--
2.0.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
