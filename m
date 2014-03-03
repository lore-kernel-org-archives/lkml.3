Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaCCTIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:08:24 -0500
Received: from ihemail3.lucent.com ([135.245.0.37]:39212 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaCCTIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:08:21 -0500
X-Greylist: delayed 2620 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Mar 2014 14:08:19 EST
Message-ID: <5314C8C3.3090607@alcatel-lucent.com>
Date: Mon, 3 Mar 2014 13:24:03 -0500
From: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130809 Thunderbird/17.0.8
MIME-Version: 1.0
To: <kvm@vger.kernel.org>
CC: Neel Jatania <neel.jatania@alcatel-lucent.com>,
        <linux-kernel@vger.kernel.org>, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        <ttracy@redhat.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
        <riel@redhat.com>
Subject: Enhancement for PLE handler in KVM
References: <53061044.2000009@alcatel-lucent.com> <530B9637.6030708@alcatel-lucent.com>
In-Reply-To: <530B9637.6030708@alcatel-lucent.com>
Content-Type: multipart/mixed;
	boundary="------------020002020808040206090104"
X-Originating-IP: [135.5.27.16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------020002020808040206090104
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Hello, all.

The PLE handler attempts to determine an alternate vCPU to schedule.  In 
some cases the wrong vCPU is scheduled and performance suffers.

This patch allows for the guest OS to signal, using a hypercall, that 
it's starting/ending a critical section.  Using this information in the 
PLE handler allows for a more intelligent VCPU scheduling determination 
to be made.  The patch only changes the PLE behaviour if this new 
hypercall mechanism is used; if it isn't used, then the existing PLE 
algorithm continues to be used to determine the next vCPU.

Benefit from the patch:
  -  the guest OS real time performance being significantly improved 
when using hyper call marking entering and leaving guest OS kernel state.
  - The guest OS system clock jitter measured on on Intel E5 2620 
reduced from 400ms down to 6ms.
  - The guest OS system lock is set to a 2ms clock interrupt. The jitter 
is measured by the difference between dtsc() value in clock interrupt 
handler and the expectation of tsc value.
  - detail of test report is attached as reference.

Path details:

 From 77edfa193a4e29ab357ec3b1e097f8469d418507 Mon Sep 17 00:00:00 2001

From: Bin BL LI <bin.bl.li@alcatel-lucent.com>

Date: Mon, 3 Mar 2014 11:23:35 -0500

Subject: [PATCH] Initial commit

---

  arch/x86/kvm/x86.c            |    7 +++++++

  include/linux/kvm_host.h      |   16 ++++++++++++++++

  include/uapi/linux/kvm_para.h |    2 ++

  virt/kvm/kvm_main.c           |   14 +++++++++++++-

  4 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c

index 39c28f0..e735de3 100644

--- a/arch/x86/kvm/x86.c

+++ b/arch/x86/kvm/x86.c

@@ -5582,6 +5582,7 @@ void kvm_arch_exit(void)

  int kvm_emulate_halt(struct kvm_vcpu *vcpu)

  {

      ++vcpu->stat.halt_exits;

+    kvm_vcpu_set_holding_lock(vcpu,false);

      if (irqchip_in_kernel(vcpu->kvm)) {

          vcpu->arch.mp_state = KVM_MP_STATE_HALTED;

          return 1;

@@ -5708,6 +5709,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)

          kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);

          ret = 0;

          break;

+    case KVM_HC_LOCK_GET:

+        kvm_vcpu_set_holding_lock(vcpu,true);

+        break;

+    case KVM_HC_LOCK_RELEASE:

+        kvm_vcpu_set_holding_lock(vcpu,false);

+        break;

      default:

          ret = -KVM_ENOSYS;

          break;

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h

index b8e9a43..f24892e 100644

--- a/include/linux/kvm_host.h

+++ b/include/linux/kvm_host.h

@@ -266,6 +266,7 @@ struct kvm_vcpu {

          bool in_spin_loop;

          bool dy_eligible;

      } spin_loop;

+    bool holding_lock;

  #endif

      bool preempted;

      struct kvm_vcpu_arch arch;

@@ -403,6 +404,10 @@ struct kvm {

  #endif

      long tlbs_dirty;

      struct list_head devices;

+

+#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT

+    bool using_lock_flag;

+#endif

  };

  

  #define kvm_err(fmt, ...) \

@@ -1076,6 +1081,13 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)

      vcpu->spin_loop.dy_eligible = val;

  }

  

+static inline void kvm_vcpu_set_holding_lock(struct kvm_vcpu *vcpu, bool val)

+{

+    if ( ! vcpu->kvm->using_lock_flag )

+        vcpu->kvm->using_lock_flag = true;

+    vcpu->holding_lock = val;

+}

+

  #else /* !CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */

  

  static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)

@@ -1085,6 +1097,10 @@ static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)

  static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)

  {

  }

+

+static inline void kvm_vcpu_set_holding_lock(struct kvm_vcpu *vcpu, bool val)

+{

+}

  #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */

  #endif

  

diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h

index 2841f86..2c563a1 100644

--- a/include/uapi/linux/kvm_para.h

+++ b/include/uapi/linux/kvm_para.h

@@ -20,6 +20,8 @@

  #define KVM_HC_FEATURES            3

  #define KVM_HC_PPC_MAP_MAGIC_PAGE    4

  #define KVM_HC_KICK_CPU            5

+#define KVM_HC_LOCK_GET            6

+#define KVM_HC_LOCK_RELEASE        7

  

  /*

   * hypercalls use architecture specific

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c

index 03a0381..c3a5046 100644

--- a/virt/kvm/kvm_main.c

+++ b/virt/kvm/kvm_main.c

@@ -232,6 +232,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)

  

      kvm_vcpu_set_in_spin_loop(vcpu, false);

      kvm_vcpu_set_dy_eligible(vcpu, false);

+    kvm_vcpu_set_holding_lock(vcpu, false);

      vcpu->preempted = false;

  

      r = kvm_arch_vcpu_init(vcpu);

@@ -502,6 +503,10 @@ static struct kvm *kvm_create_vm(unsigned long type)

      list_add(&kvm->vm_list, &vm_list);

      spin_unlock(&kvm_lock);

  

+#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT

+    kvm->using_lock_flag = false;

+#endif

+

      return kvm;

  

  out_err:

@@ -1762,9 +1767,16 @@ static bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)

  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT

      bool eligible;

  

-    eligible = !vcpu->spin_loop.in_spin_loop ||

+    if ( ! vcpu->kvm->using_lock_flag )

+    {

+        eligible = !vcpu->spin_loop.in_spin_loop ||

              (vcpu->spin_loop.in_spin_loop &&

               vcpu->spin_loop.dy_eligible);

+    }

+    else

+    {

+        eligible = vcpu->holding_lock; /* if holding any lock, yield to it */

+    }

  

      if (vcpu->spin_loop.in_spin_loop)

          kvm_vcpu_set_dy_eligible(vcpu, !vcpu->spin_loop.dy_eligible);

-- 

1.7.1

~/ref/kvm_git >



Regards
Bin


--------------020002020808040206090104
Content-Type: text/plain; charset="UTF-8"; name="tst.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="tst.log"


System clock jitter measure result. 
Using 8 vCpu SMP guest OS with using hypercall mark getting/leaving
guest OS kernel state also the KVM path to boost the lock holder vCPU.
The max jitter at run time is 6ms
The two 200ms jitter below was from guest OS system initialization
stage instead of run time clock jitter.
======================================================================

11-> sysClkIntShow
OSclock:0x80f8760
-- intrlen:            6804074 [    1999  us]
-- tickLen:           34020374 [    9999  us]
-- tickWin:            5103056 [    1499  us]
-- syncOff:                  0 [       0  us]
-- timeerr:          -17387492 [  -5.111  ms] [0.0004 %] [sync:  -0.071 ms]
-- intrerr: 0xffffffff99f36b1a [  -0.503 sec] [0.0404 %]
+---------+--------------------+--------------------+-------------------------+
|   ts    |        init        |        last        |         time [ms]       |
+---------+--------------------+--------------------+-------------------------+
| cpu_tsc | 0x000000031e754598 | 0x000003de99c1c6f8 |             1246665.096 |
| vxticks | 0x00000000ffff1613 | 0x000000000000fd0d |             1246659.985 |
+---------+--------------------+--------------------+-------------------------+
+---------+--------------------+--------------------+-------------------------+
| counter |        count       |      time [ms]     |  delta  [ms]      [%]   |
+---------+--------------------+--------------------+---------------+---------+
| cpu_tsc |      4241201332576 |        1246665.096 |        +0.000 | +0.0000 |
| vxticks |             124666 |        1246659.985 |        -5.111 | -0.0004 |
| clk_obj |             124666 |        1246659.985 |        +5.040 | +0.0004 |
| clkintr |             623081 |        1246161.839 |      -503.257 | -0.0404 |
+---------+--------------------+--------------------+---------------+---------+

OSclock [0x80f8760] interrupt-source histogram
-- clk freq: 500 Hz
-- clk intr: 623082
+------+---------------------+----------------------------+
| pos# |    Interval [ms]    |     clk ticks          %   |
+------+---------------------+-------------------+--------+
|    0 |   0.000 ..    0.308 |                40 |   0.01 |
|    1 |   0.308 ..    0.616 |                16 |   0.00 |
|    2 |   0.616 ..    0.925 |                22 |   0.00 |
|    3 |   0.925 ..    1.233 |                14 |   0.00 |
|    4 |   1.233 ..    1.541 |                16 |   0.00 |
|    5 |   1.541 ..    1.849 |                51 |   0.01 |
|    6 |   1.849 ..    2.158 |            622769 |  99.95 |
|    7 |   2.158 ..    2.466 |                43 |   0.01 |
|    8 |   2.466 ..    2.774 |                13 |   0.00 |
|    9 |   2.774 ..    3.082 |                13 |   0.00 |
|   10 |   3.082 ..    3.390 |                17 |   0.00 |
|   11 |   3.390 ..    3.699 |                11 |   0.00 |
|   12 |   3.699 ..    4.007 |                 4 |   0.00 |
|   13 |   4.007 ..    4.315 |                 5 |   0.00 |
|   14 |   4.315 ..    4.623 |                 3 |   0.00 |
|   15 |   4.623 ..    4.932 |                 2 |   0.00 |
|   16 |   4.932 ..    5.240 |                 1 |   0.00 |
|   17 |   5.240 ..    5.548 |                 5 |   0.00 |
|   18 |   5.548 ..    5.856 |                26 |   0.00 |
|   19 |   5.856 ..    6.164 |                 8 |   0.00 |
|   20 |   6.164 ..    6.473 |                 2 |   0.00 |
|  663 | 204.350 ..  204.658 |                 1 |   0.00 |
|  668 | 205.891 ..  206.199 |                 1 |   0.00 |
+------+---------------------+-------------------+--------+
| ---- |                     |            623083 | 100.00 |
+------+---------------------+-------------------+--------+




System clock jitter measure result. 
Using 8 vCpu SMP guest OS without hypercall and the vanilla KVM PLE handler.
The system clock jitter (run time) in guest OS coule be bigger than 400ms.
======================================================================


11-> sysClkIntShow
OSclock:0x8055760
-- intrlen:            6804067 [    1999  us]
-- tickLen:           34020337 [   10000  us]
-- tickWin:            5103050 [    1499  us]
-- syncOff:                  0 [       0  us]
-- timeerr:          -22314665 [  -6.559  ms] [0.0009 %] [sync:  -0.032 ms]
-- intrerr: 0xfffffffaca02d1f3 [  -6.579 sec] [0.9233 %]
+---------+--------------------+--------------------+-------------------------+
|   ts    |        init        |        last        |         time [ms]       |
+---------+--------------------+--------------------+-------------------------+
| cpu_tsc | 0x00000003359de5e8 | 0x000002379389f1d2 |              712496.568 |
| vxticks | 0x00000000ffff160f | 0x0000000000002c60 |              712490.008 |
+---------+--------------------+--------------------+-------------------------+
+---------+--------------------+--------------------+-------------------------+
| counter |        count       |      time [ms]     |  delta  [ms]      [%]   |
+---------+--------------------+--------------------+---------------+---------+
| cpu_tsc |      2423937305578 |         712496.568 |        +0.000 | +0.0000 |
| vxticks |              71249 |         712490.008 |        -6.559 | -0.0009 |
| clk_obj |              71249 |         712490.008 |        +6.527 | +0.0009 |
| clkintr |             352959 |         705917.967 |     -6578.601 | -0.9233 |
+---------+--------------------+--------------------+---------------+---------+

OSclock [0x8055760] interrupt-source histogram
-- clk freq: 500 Hz
-- clk intr: 352959
+------+---------------------+----------------------------+
| pos# |    Interval [ms]    |     clk ticks          %   |
+------+---------------------+-------------------+--------+
|    0 |   0.000 ..    0.308 |               270 |   0.08 |
|    1 |   0.308 ..    0.616 |               160 |   0.05 |
|    2 |   0.616 ..    0.925 |               165 |   0.05 |
|    3 |   0.925 ..    1.233 |               200 |   0.06 |
|    4 |   1.233 ..    1.541 |               182 |   0.05 |
|    5 |   1.541 ..    1.849 |               591 |   0.17 |
|    6 |   1.849 ..    2.158 |            349872 |  99.13 |
|    7 |   2.158 ..    2.466 |               530 |   0.15 |
|    8 |   2.466 ..    2.774 |               151 |   0.04 |
|    9 |   2.774 ..    3.082 |               123 |   0.03 |
|   10 |   3.082 ..    3.390 |                87 |   0.02 |
|   11 |   3.390 ..    3.699 |                65 |   0.02 |
|   12 |   3.699 ..    4.007 |                53 |   0.02 |
|   13 |   4.007 ..    4.315 |                38 |   0.01 |
|   14 |   4.315 ..    4.623 |                27 |   0.01 |
|   15 |   4.623 ..    4.932 |                34 |   0.01 |
|   16 |   4.932 ..    5.240 |                44 |   0.01 |
|   17 |   5.240 ..    5.548 |                24 |   0.01 |
|   18 |   5.548 ..    5.856 |                37 |   0.01 |
|   19 |   5.856 ..    6.164 |                32 |   0.01 |
|   20 |   6.164 ..    6.473 |                22 |   0.01 |
|   21 |   6.473 ..    6.781 |                30 |   0.01 |
|   22 |   6.781 ..    7.089 |                21 |   0.01 |
|   23 |   7.089 ..    7.397 |                12 |   0.00 |
|   24 |   7.397 ..    7.706 |                17 |   0.00 |
|   25 |   7.706 ..    8.014 |                13 |   0.00 |
|   26 |   8.014 ..    8.322 |                 3 |   0.00 |
|   27 |   8.322 ..    8.630 |                 9 |   0.00 |
|   28 |   8.630 ..    8.938 |                 7 |   0.00 |
|   29 |   8.938 ..    9.247 |                 7 |   0.00 |
|   30 |   9.247 ..    9.555 |                 3 |   0.00 |
|   31 |   9.555 ..    9.863 |                 2 |   0.00 |
|   32 |   9.863 ..   10.171 |                 8 |   0.00 |
|   33 |  10.171 ..   10.479 |                 6 |   0.00 |
|   34 |  10.479 ..   10.788 |                 1 |   0.00 |
|   35 |  10.788 ..   11.096 |                 3 |   0.00 |
|   36 |  11.096 ..   11.404 |                 6 |   0.00 |
|   37 |  11.404 ..   11.712 |                 1 |   0.00 |
|   38 |  11.712 ..   12.021 |                 1 |   0.00 |
|   39 |  12.021 ..   12.329 |                 2 |   0.00 |
|   40 |  12.329 ..   12.637 |                 2 |   0.00 |
|   41 |  12.637 ..   12.945 |                 3 |   0.00 |
|   42 |  12.945 ..   13.253 |                 4 |   0.00 |
|   44 |  13.562 ..   13.870 |                 2 |   0.00 |
|   45 |  13.870 ..   14.178 |                 3 |   0.00 |
|   46 |  14.178 ..   14.486 |                 2 |   0.00 |
|   47 |  14.486 ..   14.795 |                 5 |   0.00 |
|   48 |  14.795 ..   15.103 |                 3 |   0.00 |
|   49 |  15.103 ..   15.411 |                 1 |   0.00 |
|   50 |  15.411 ..   15.719 |                 2 |   0.00 |
|   51 |  15.719 ..   16.027 |                 3 |   0.00 |
|   53 |  16.336 ..   16.644 |                 2 |   0.00 |
|   54 |  16.644 ..   16.952 |                 2 |   0.00 |
|   56 |  17.260 ..   17.569 |                 2 |   0.00 |
|   57 |  17.569 ..   17.877 |                 1 |   0.00 |
|   58 |  17.877 ..   18.185 |                 1 |   0.00 |
|   60 |  18.493 ..   18.801 |                 1 |   0.00 |
|   62 |  19.110 ..   19.418 |                 1 |   0.00 |
|   64 |  19.726 ..   20.034 |                 1 |   0.00 |
|   65 |  20.034 ..   20.343 |                 1 |   0.00 |
|   66 |  20.343 ..   20.651 |                 1 |   0.00 |
|   67 |  20.651 ..   20.959 |                 1 |   0.00 |
|   71 |  21.884 ..   22.192 |                 2 |   0.00 |
|   75 |  23.117 ..   23.425 |                 1 |   0.00 |
|   76 |  23.425 ..   23.733 |                 1 |   0.00 |
|   81 |  24.966 ..   25.274 |                 2 |   0.00 |
|   82 |  25.274 ..   25.582 |                 1 |   0.00 |
|   83 |  25.582 ..   25.891 |                 3 |   0.00 |
|   85 |  26.199 ..   26.507 |                 1 |   0.00 |
|   87 |  26.815 ..   27.123 |                 1 |   0.00 |
|   90 |  27.740 ..   28.048 |                 1 |   0.00 |
|   91 |  28.048 ..   28.356 |                 2 |   0.00 |
|   99 |  30.514 ..   30.822 |                 1 |   0.00 |
|  101 |  31.130 ..   31.438 |                 1 |   0.00 |
|  107 |  32.980 ..   33.288 |                 1 |   0.00 |
|  111 |  34.212 ..   34.521 |                 1 |   0.00 |
|  119 |  36.678 ..   36.986 |                 1 |   0.00 |
|  120 |  36.986 ..   37.295 |                 1 |   0.00 |
|  122 |  37.603 ..   37.911 |                 1 |   0.00 |
|  128 |  39.452 ..   39.760 |                 1 |   0.00 |
|  129 |  39.760 ..   40.069 |                 1 |   0.00 |
|  130 |  40.069 ..   40.377 |                 1 |   0.00 |
|  137 |  42.226 ..   42.534 |                 1 |   0.00 |
|  138 |  42.534 ..   42.843 |                 1 |   0.00 |
|  140 |  43.151 ..   43.459 |                 1 |   0.00 |
|  144 |  44.384 ..   44.692 |                 1 |   0.00 |
|  161 |  49.623 ..   49.932 |                 1 |   0.00 |
|  164 |  50.548 ..   50.856 |                 1 |   0.00 |
|  182 |  56.096 ..   56.404 |                 1 |   0.00 |
|  189 |  58.254 ..   58.562 |                 1 |   0.00 |
|  192 |  59.178 ..   59.487 |                 1 |   0.00 |
|  214 |  65.959 ..   66.267 |                 1 |   0.00 |
|  230 |  70.891 ..   71.199 |                 1 |   0.00 |
|  258 |  79.521 ..   79.829 |                 1 |   0.00 |
|  279 |  85.993 ..   86.302 |                 1 |   0.00 |
|  300 |  92.466 ..   92.774 |                 1 |   0.00 |
|  309 |  95.240 ..   95.548 |                 1 |   0.00 |
|  339 | 104.487 ..  104.795 |                 1 |   0.00 |
|  411 | 126.679 ..  126.987 |                 1 |   0.00 |
|  434 | 133.768 ..  134.076 |                 1 |   0.00 |
|  463 | 142.706 ..  143.014 |                 1 |   0.00 |
|  532 | 163.973 ..  164.281 |                 1 |   0.00 |
|  537 | 165.514 ..  165.823 |                 1 |   0.00 |
|  538 | 165.823 ..  166.131 |                 1 |   0.00 |
|  631 | 194.487 ..  194.795 |                 1 |   0.00 |
|  634 | 195.412 ..  195.720 |                 1 |   0.00 |
|  707 | 217.912 ..  218.220 |                 1 |   0.00 |
|  728 | 224.384 ..  224.693 |                 1 |   0.00 |
|  735 | 226.542 ..  226.850 |                 1 |   0.00 |
|  772 | 237.946 ..  238.254 |                 1 |   0.00 |
|  924 | 284.796 ..  285.104 |                 1 |   0.00 |
| 1346 | 414.865 ..  415.173 |                 1 |   0.00 |
| 1360 | 419.180 ..  419.488 |                 1 |   0.00 |
+------+---------------------+-------------------+--------+
| ---- |                     |            352959 | 100.00 |
+------+---------------------+-------------------+--------+

--------------020002020808040206090104--
