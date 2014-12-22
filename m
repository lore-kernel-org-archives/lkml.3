Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaLVOe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:34:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60545 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaLVOeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:34:24 -0500
Date: Mon, 22 Dec 2014 15:34:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm ML <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: guest hanging on rc1
Message-ID: <20141222143421.GA4403@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,

so I installed an old SUSE guest (SLES10, kernel is 2.6.16 + enterprise
stuff) and it was booting and all was fine but this week not anymore.

Host kernel is 3.19-rc1 + tip/master. I did miss some kvm config options
initially so I did

$ make kvmconfig

and it added those (see diff at the end).

Now, when I go to the monitor and do

(qemu) p $eip
0xffffffff80120e7e

This address is in kvm_register_clock() on the guest kernel:

ffffffff80120dd2 <kvm_register_clock>:
ffffffff80120dd2:       55                      push   %rbp
ffffffff80120dd3:       53                      push   %rbx
ffffffff80120dd4:       48 83 ec 08             sub    $0x8,%rsp
ffffffff80120dd8:       65 8b 34 25 24 00 00    mov    %gs:0x24,%esi
ffffffff80120ddf:       00 
ffffffff80120de0:       31 c0                   xor    %eax,%eax
ffffffff80120de2:       83 3d 7f a8 33 00 00    cmpl   $0x0,0x33a87f(%rip)        # ffffffff8045b668 <use_kvm_time>
ffffffff80120de9:       0f 84 91 00 00 00       je     ffffffff80120e80 <kvm_register_clock+0xae>
ffffffff80120def:       48 63 d6                movslq %esi,%rdx
ffffffff80120df2:       48 c7 c0 80 04 43 80    mov    $0xffffffff80430480,%rax
ffffffff80120df9:       48 8b 14 d5 20 42 3f    mov    -0x7fc0bde0(,%rdx,8),%rdx
ffffffff80120e00:       80 
ffffffff80120e01:       4c 8b 42 08             mov    0x8(%rdx),%r8
ffffffff80120e05:       4a 8d 14 00             lea    (%rax,%r8,1),%rdx
ffffffff80120e09:       48 b8 ff ff ff 7f ff    movabs $0xffffffff7fffffff,%rax
ffffffff80120e10:       ff ff ff 
ffffffff80120e13:       48 39 c2                cmp    %rax,%rdx
ffffffff80120e16:       8d 8a 00 00 00 80       lea    -0x80000000(%rdx),%ecx
ffffffff80120e1c:       77 02                   ja     ffffffff80120e20 <kvm_register_clock+0x4e>
ffffffff80120e1e:       89 d1                   mov    %edx,%ecx
ffffffff80120e20:       48 c7 c0 80 04 43 80    mov    $0xffffffff80430480,%rax
ffffffff80120e27:       83 c9 01                or     $0x1,%ecx
ffffffff80120e2a:       4a 8d 14 00             lea    (%rax,%r8,1),%rdx
ffffffff80120e2e:       48 b8 ff ff ff 7f ff    movabs $0xffffffff7fffffff,%rax
ffffffff80120e35:       ff ff ff 
ffffffff80120e38:       89 cd                   mov    %ecx,%ebp
ffffffff80120e3a:       48 39 c2                cmp    %rax,%rdx
ffffffff80120e3d:       76 07                   jbe    ffffffff80120e46 <kvm_register_clock+0x74>
ffffffff80120e3f:       b8 00 00 00 80          mov    $0x80000000,%eax
ffffffff80120e44:       eb 0a                   jmp    ffffffff80120e50 <kvm_register_clock+0x7e>
ffffffff80120e46:       48 b8 00 00 00 00 00    movabs $0x7f0000000000,%rax
ffffffff80120e4d:       7f 00 00 
ffffffff80120e50:       48 8d 04 02             lea    (%rdx,%rax,1),%rax
ffffffff80120e54:       48 89 c2                mov    %rax,%rdx
ffffffff80120e57:       48 c1 ea 20             shr    $0x20,%rdx
ffffffff80120e5b:       48 85 ff                test   %rdi,%rdi
ffffffff80120e5e:       89 d3                   mov    %edx,%ebx
ffffffff80120e60:       74 11                   je     ffffffff80120e73 <kvm_register_clock+0xa1>
ffffffff80120e62:       49 89 f8                mov    %rdi,%r8
ffffffff80120e65:       31 c0                   xor    %eax,%eax
ffffffff80120e67:       48 c7 c7 f4 7a 31 80    mov    $0xffffffff80317af4,%rdi
ffffffff80120e6e:       e8 b7 4a 01 00          callq  ffffffff8013592a <printk>
ffffffff80120e73:       b9 12 00 00 00          mov    $0x12,%ecx
ffffffff80120e78:       89 e8                   mov    %ebp,%eax
ffffffff80120e7a:       89 da                   mov    %ebx,%edx
ffffffff80120e7c:       0f 30                   wrmsr  
ffffffff80120e7e:       31 c0                   xor    %eax,%eax		<--- rIP
ffffffff80120e80:       5a                      pop    %rdx
ffffffff80120e81:       5b                      pop    %rbx
ffffffff80120e82:       5d                      pop    %rbp
ffffffff80120e83:       c3                      retq   

right after we've written the 0x12 MSR, i.e. MSR_KVM_SYSTEM_TIME.

So something broke somewhere and the guest won't boot anymore. Even if I
try to boot the iso image which I used to install it, its kernel hangs
there too. Not the same VA though:

(qemu) p $eip
0xffffffff8011b172
(qemu)

but the exact same place:

(qemu) x/20i 0xffffffff8011b150
0xffffffff8011b150:  je     0x7fff8011b167
0xffffffff8011b152:  mov    %rdi,%r8
0xffffffff8011b155:  mov    %ebp,%ecx
0xffffffff8011b157:  xor    %esi,%esi
0xffffffff8011b159:  mov    $0xffffffff802ee1ac,%rdi
0xffffffff8011b160:  xor    %eax,%eax
0xffffffff8011b162:  callq  0x7fff8012a562
0xffffffff8011b167:  mov    $0x12,%ecx
0xffffffff8011b16c:  mov    %ebp,%eax
0xffffffff8011b16e:  mov    %ebx,%edx
0xffffffff8011b170:  wrmsr  
0xffffffff8011b172:  xor    %eax,%eax			<--- rIP
0xffffffff8011b174:  pop    %rdx
0xffffffff8011b175:  pop    %rbx
0xffffffff8011b176:  pop    %rbp
0xffffffff8011b177:  retq   
0xffffffff8011b178:  push   %rbp
0xffffffff8011b179:  mov    %edi,%ebp
0xffffffff8011b17b:  push   %rbx
0xffffffff8011b17c:  sub    $0x8,%rsp

Right after the MSR write.

Any ideas how to debug this further? :)

Thanks.


--- /boot/config-3.19.0-rc1+    2014-12-22 11:20:13.015922953 +0100
+++ .config     2014-12-22 13:31:24.030189420 +0100
@@ -336,7 +336,15 @@ CONFIG_X86_FEATURE_NAMES=y
 CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
 CONFIG_SCHED_OMIT_FRAME_POINTER=y
 # CONFIG_KVMTOOL_TEST_ENABLE is not set
-# CONFIG_HYPERVISOR_GUEST is not set
+CONFIG_HYPERVISOR_GUEST=y
+CONFIG_PARAVIRT=y
+# CONFIG_PARAVIRT_DEBUG is not set
+# CONFIG_PARAVIRT_SPINLOCKS is not set
+# CONFIG_XEN is not set
+CONFIG_KVM_GUEST=y
+# CONFIG_KVM_DEBUG_FS is not set
+# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
+CONFIG_PARAVIRT_CLOCK=y
 CONFIG_NO_BOOTMEM=y
 # CONFIG_MEMTEST is not set
 CONFIG_MK8=y
@@ -1126,6 +1134,7 @@ CONFIG_VIRTIO_BLK=y
 # CONFIG_SENSORS_APDS990X is not set
 # CONFIG_HMC6352 is not set
 # CONFIG_DS1682 is not set
+# CONFIG_VMWARE_BALLOON is not set
 # CONFIG_BMP085_I2C is not set
 # CONFIG_USB_SWITCH_FSA9480 is not set
 # CONFIG_SRAM is not set
@@ -2708,6 +2717,7 @@ CONFIG_VIRTIO_PCI=y
 #
 # Microsoft Hyper-V guest support
 #
+# CONFIG_HYPERV is not set
 # CONFIG_STAGING is not set
 # CONFIG_X86_PLATFORM_DEVICES is not set
 # CONFIG_CHROME_PLATFORMS is not set


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
