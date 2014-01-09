Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaAIW6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:58:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45735 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaAIW6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:58:20 -0500
Date: Thu, 9 Jan 2014 23:58:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: halfdog <me@halfdog.net>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
Message-ID: <20140109225815.GI11594@pd.tnic>
References: <52C0C9F4.50101@zytor.com>
 <52C196C3.1040300@halfdog.net>
 <52C31027.2030101@zytor.com>
 <20131231192106.GA22535@phenom.dumpdata.com>
 <52C347F0.8070902@zytor.com>
 <52CD022E.9040107@halfdog.net>
 <52CD8E10.3010204@zytor.com>
 <20140108193655.GD5098@pd.tnic>
 <52CDC316.4050503@halfdog.net>
 <52CDD3AE.4030301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52CDD3AE.4030301@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 02:39:42PM -0800, H. Peter Anvin wrote:
> It is obviously critical here that we get a handle on if this is a
> CPU-specific problem that we might have to work around or a general
> problem with the Linux code.

Ok, I was able to reproduce with

http://www.halfdog.net/Security/2013/Vm86SyscallTaskSwitchKernelPanic/FpuStateTaskSwitchShmemXattrHandlersOverwriteWithNullPage.c

here on the latest linus+tip, see OOPS below:

$ AFLAGS=--32 decodecode < ~/fpu.oops

...

Code is:

All code
========
   0:   89 d8                   mov    %ebx,%eax
   2:   e8 8c 96 00 00          call   0x9693
   7:   85 c0                   test   %eax,%eax
   9:   0f 85 9c 00 00 00       jne    0xab
   f:   fa                      cli
  10:   e8 7e bd 08 00          call   0x8bd93
  15:   e9 6f 00 00 00          jmp    0x89
  1a:   c7 83 a0 02 00 00 01    movl   $0x1,0x2a0(%ebx)
  21:   00 00 00
  24:   64 89 1d ac a7 8a c1    mov    %ebx,%fs:0xc18aa7ac
  2b:*  0f 77                   emms            <-- trapping instruction
  2d:   db 83 a0 02 00 00       fildl  0x2a0(%ebx)
  33:   89 f6                   mov    %esi,%esi
  35:   89 f6                   mov    %esi,%esi
  37:   eb 27                   jmp    0x60
  39:   b8 ff ff ff ff          mov    $0xffffffff,%eax
  3e:   8b                      .byte 0x8b
  3f:   bb                      .byte 0xbb

Code starting with the faulting instruction
===========================================
   0:   0f 77                   emms
   2:   db 83 a0 02 00 00       fildl  0x2a0(%ebx)
   8:   89 f6                   mov    %esi,%esi
   a:   89 f6                   mov    %esi,%esi
   c:   eb 27                   jmp    0x35
   e:   b8 ff ff ff ff          mov    $0xffffffff,%eax
  13:   8b                      .byte 0x8b
  14:   bb                      .byte 0xbb

which points at EMMS, which gets runtime-replaced in:

static inline int restore_fpu_checking(struct task_struct *tsk)
{
	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
	   is pending.  Clear the x87 state here by setting it to fixed
	   values. "m" is a random variable that should be in L1 */
	alternative_input(
		ASM_NOP8 ASM_NOP2,
		"emms\n\t"		/* clear stack tags */
		"fildl %P[addr]",	/* set F?P to defined value */
		X86_FEATURE_FXSAVE_LEAK,
		[addr] "m" (tsk->thread.fpu.has_fpu));

	return fpu_restore_checking(&tsk->thread.fpu);
}

Now, judging by the exception type and if I'm not mistaken, we get an
#MF which, according to the EMMS documentation means we get an #MF
exception because an unmasked x87 floating-point exception was pending.

Now, we most likely have done FXSAVE before that and this one doesn't
check for pending unmasked x87 floating-point exceptions and we have
CR0.NE=1b which means in that case that a numeric exception gets
generated.

Yadda, yadda, all is fine but why do we have any pending x87 FPU
exceptions then where we shouldn't? I dunno - I've never warmed up to
the FPU diddling in the kernel. I'll try to wrap my head around this
later...

---
localhost vmunix: [  364.177380] fpu exception: 0000 [#1] PREEMPT SMP
localhost vmunix: [  364.185005] Modules linked in: ipv6 radeon snd_hda_codec_conexant rtl8192ce rtl_pci snd_hda_codec_hdmi rtlwifi snd_hda_intel mac80211 snd_hda_codec snd_hwdep usbhid snd_pcm cfg80211 rtsx_pci_sdmmc snd_page_alloc drm_kms_helper mmc_core snd_timer rtsx_pci rtl8192c_common ttm thinkpad_acpi nvram snd ohci_pci ehci_pci ohci_hcd mfd_core button ac video battery ehci_hcd pcspkr thermal k10temp soundcore
localhost vmunix: [  364.209743] CPU: 1 PID: 1200 Comm: find Tainted: G        W    3.13.0-rc7+ #4
localhost vmunix: [  364.217947] Hardware name: LENOVO 30515QG/30515QG, BIOS 8RET30WW (1.12 ) 09/15/2011
localhost vmunix: [  364.226231] task: f4104980 ti: f3800000 task.ti: f3800000
localhost vmunix: [  364.234511] EIP: 0060:[<c10026b8>] EFLAGS: 00010002 CPU: 1
localhost vmunix: [  364.242734] EIP is at math_state_restore+0x48/0x1a0
localhost vmunix: [  364.250939] EAX: f3801fb4 EBX: f4104980 ECX: 0000007b EDX: ffffffff
localhost vmunix: [  364.259188] ESI: 089c58f8 EDI: c1003510 EBP: f3801fa0 ESP: f3801f98
localhost vmunix: [  364.267364]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
localhost vmunix: [  364.275542] CR0: 80050033 CR2: b75d6f32 CR3: 331f9000 CR4: 000007d0
localhost vmunix: [  364.283758] Stack:
localhost vmunix: [  364.291834]  f3801fb4 c1003510 f3801fac c1003535 089c39f8 bf8b8e88 c155c96b 089c39f8
localhost vmunix: [  364.300213]  00000000 00000029 089c58f8 00000000 bf8b8e88 080681fc 0000007b 0000007b
localhost vmunix: [  364.308631]  00000000 c1003510 ffffffff 0805e0f8 00000073 00010206 bf8b8e30 0000007b
localhost vmunix: [  364.316985] Call Trace:
localhost vmunix: [  364.325104]  [<c1003510>] ? smp_thermal_interrupt+0x20/0x20
localhost vmunix: [  364.333300]  [<c1003535>] do_device_not_available+0x25/0x40
localhost vmunix: [  364.341458]  [<c155c96b>] error_code+0x5f/0x64
localhost vmunix: [  364.349541]  [<c1003510>] ? smp_thermal_interrupt+0x20/0x20
localhost vmunix: [  364.357649] Code: 89 d8 e8 8c 96 00 00 85 c0 0f 85 9c 00 00 00 fa e8 7e bd 08 00 e9 6f 00 00 00 c7 83 a0 02 00 00 01 00 00 00 64 89 1d ac a7 8a c1 <0f> 77 db 83 a0 02 00 00 89 f6 89 f6 eb 27 b8 ff ff ff ff 8b bb
localhost vmunix: [  364.375367] EIP: [<c10026b8>] math_state_restore+0x48/0x1a0 SS:ESP 0068:f3801f98
localhost vmunix: [  364.383830] ---[ end trace c8241b0abe86a792 ]---

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
