Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaGDHnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:43:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:45465 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaGDHnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:43:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,599,1400050800"; 
   d="dump'?scan'208";a="565158137"
Date: Fri, 4 Jul 2014 15:39:23 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Bandan Das <bsd@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1
 since race
Message-ID: <20140704073923.GA7188@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
 <53B3CA6A.4050902@siemens.com>
 <jpgy4wb9g5t.fsf@redhat.com>
 <20140703065955.GA4236@kernel>
 <jpgk37u8iae.fsf@redhat.com>
 <20140704025250.GA2849@kernel>
 <53B63EF2.6000800@siemens.com>
 <20140704060831.GA3453@kernel>
 <53B6559A.6020406@siemens.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <53B6559A.6020406@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 04, 2014 at 09:19:54AM +0200, Jan Kiszka wrote:
>On 2014-07-04 08:08, Wanpeng Li wrote:
>> On Fri, Jul 04, 2014 at 07:43:14AM +0200, Jan Kiszka wrote:
>>> On 2014-07-04 04:52, Wanpeng Li wrote:
>>>> On Thu, Jul 03, 2014 at 01:27:05PM -0400, Bandan Das wrote:
>>>> [...]
>>>>> # modprobe kvm_intel ept=0 nested=1 enable_shadow_vmcs=0
>>>>>
>>>>> The Host CPU - Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
>>>>> qemu cmd to run L1 - 
>>>>> # qemu-system-x86_64 -drive file=level1.img,if=virtio,id=disk0,format=raw,cache=none,werror=stop,rerror=stop,aio=threads -drive file=level2.img,if=virtio,id=disk1,format=raw,cache=none,werror=stop,rerror=stop,aio=threads -vnc :2 --enable-kvm -monitor stdio -m 4G -net nic,macaddr=00:23:32:45:89:10 -net tap,ifname=tap0,script=/etc/qemu-ifup,downscript=no -smp 4 -cpu Nehalem,+vmx -serial pty
>>>>>
>>>>> qemu cmd to run L2 -
>>>>> # sudo qemu-system-x86_64 -hda VM/level2.img -vnc :0 --enable-kvm -monitor stdio -m 2G -smp 2 -cpu Nehalem -redir tcp:5555::22
>>>>>
>>>>> Additionally,
>>>>> L0 is FC19 with 3.16-rc3
>>>>> L1 and L2 are Ubuntu 14.04 with 3.13.0-24-generic
>>>>>
>>>>> Then start a kernel compilation inside L2 with "make -j3"
>>>>>
>>>>> There's no call trace on L0, both L0 and L1 are hung (or rather really slow) and
>>>>> L1 serial spews out CPU softlock up errors. Enabling panic on softlockup on L1 will give
>>>>> a trace with smp_call_function_many() I think the corresponding code in kernel/smp.c that
>>>>> triggers this is
>>>>>
>>>>> WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>>>>>                      && !oops_in_progress && !early_boot_irqs_disabled);
>>>>>
>>>>> I know in most cases this is usually harmless, but in this specific case,
>>>>> it seems it's stuck here forever.
>>>>>
>>>>> Sorry, I don't have a L1 call trace handy atm, I can post that if you are interested.
>>>>>
>>>>> Note that this can take as much as 30 to 40 minutes to appear but once it does,
>>>>> you will know because both L1 and L2 will be stuck with the serial messages as I mentioned
>>>>> before. From my side, let me try this on another system to rule out any machine specific
>>>>> weirdness going on..
>>>>>
>>>>
>>>> Thanks for your pointing out. 
>>>>
>>>>> Please let me know if you need any further information.
>>>>>
>>>>
>>>> I just run kvm-unit-tests w/ vmx.flat and eventinj.flat.
>>>>
>>>>
>>>> w/ vmx.flat and w/o my patch applied 
>>>>
>>>> [...]
>>>>
>>>> Test suite : interrupt
>>>> FAIL: direct interrupt while running guest
>>>> PASS: intercepted interrupt while running guest
>>>> FAIL: direct interrupt + hlt
>>>> FAIL: intercepted interrupt + hlt
>>>> FAIL: direct interrupt + activity state hlt
>>>> FAIL: intercepted interrupt + activity state hlt
>>>> PASS: running a guest with interrupt acknowledgement set
>>>> SUMMARY: 69 tests, 6 failures
>>>>
>>>> w/ vmx.flat and w/ my patch applied 
>>>>
>>>> [...]
>>>>
>>>> Test suite : interrupt
>>>> PASS: direct interrupt while running guest
>>>> PASS: intercepted interrupt while running guest
>>>> PASS: direct interrupt + hlt
>>>> FAIL: intercepted interrupt + hlt
>>>> PASS: direct interrupt + activity state hlt
>>>> PASS: intercepted interrupt + activity state hlt
>>>> PASS: running a guest with interrupt acknowledgement set
>>>>
>>>> SUMMARY: 69 tests, 2 failures 
>>>
>>> Which version (hash) of kvm-unit-tests are you using? All tests up to
>>> 307621765a are running fine here, but since a0e30e712d not much is
>>> completing successfully anymore:
>>>
>> 
>> I just git pull my kvm-unit-tests to latest, the last commit is daeec9795d.
>> 
>>> enabling apic
>>> paging enabled
>>> cr0 = 80010011
>>> cr3 = 7fff000
>>> cr4 = 20
>>> PASS: test vmxon with FEATURE_CONTROL cleared
>>> PASS: test vmxon without FEATURE_CONTROL lock
>>> PASS: test enable VMX in FEATURE_CONTROL
>>> PASS: test FEATURE_CONTROL lock bit
>>> PASS: test vmxon
>>> FAIL: test vmptrld
>>> PASS: test vmclear
>>> init_vmcs : make_vmcs_current error
>>> FAIL: test vmptrst
>>> init_vmcs : make_vmcs_current error
>>> vmx_run : vmlaunch failed.
>>> FAIL: test vmlaunch
>>> FAIL: test vmlaunch
>>>
>>> SUMMARY: 10 tests, 4 unexpected failures
>> 
>> 
>> /opt/qemu/bin/qemu-system-x86_64 -enable-kvm -device pc-testdev -serial stdio 
>> -device isa-debug-exit,iobase=0xf4,iosize=0x4 -kernel ./x86/vmx.flat -cpu host
>> 
>> Test suite : interrupt
>> PASS: direct interrupt while running guest
>> PASS: intercepted interrupt while running guest
>> PASS: direct interrupt + hlt
>> FAIL: intercepted interrupt + hlt
>> PASS: direct interrupt + activity state hlt
>> PASS: intercepted interrupt + activity state hlt
>> PASS: running a guest with interrupt acknowledgement set
>> 
>> SUMMARY: 69 tests, 2 failures
>
>Somehow I'm missing the other 31 vmx test we have now... Could you post
>the full log? Please also post the output of qemu/scripts/kvm/vmxcap on
>your test host to compare with what I have here.

They are in attachment. 

Regards,
Wanpeng Li 

>
>Thanks,
>Jan
>
>-- 
>Siemens AG, Corporate Technology, CT RTC ITP SES-DE
>Corporate Competence Center Embedded Linux

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=vmxcap

Basic VMX Information
  Revision                                 18
  VMCS size                                1024
  VMCS restricted to 32 bit addresses      no
  Dual-monitor support                     yes
  VMCS memory type                         6
  INS/OUTS instruction information         yes
  IA32_VMX_TRUE_*_CTLS support             yes
pin-based controls
  External interrupt exiting               yes
  NMI exiting                              yes
  Virtual NMIs                             yes
  Activate VMX-preemption timer            yes
  Process posted interrupts                no
primary processor-based controls
  Interrupt window exiting                 yes
  Use TSC offsetting                       yes
  HLT exiting                              yes
  INVLPG exiting                           yes
  MWAIT exiting                            yes
  RDPMC exiting                            yes
  RDTSC exiting                            yes
  CR3-load exiting                         default
  CR3-store exiting                        default
  CR8-load exiting                         yes
  CR8-store exiting                        yes
  Use TPR shadow                           yes
  NMI-window exiting                       yes
  MOV-DR exiting                           yes
  Unconditional I/O exiting                yes
  Use I/O bitmaps                          yes
  Monitor trap flag                        yes
  Use MSR bitmaps                          yes
  MONITOR exiting                          yes
  PAUSE exiting                            yes
  Activate secondary control               yes
secondary processor-based controls
  Virtualize APIC accesses                 yes
  Enable EPT                               yes
  Descriptor-table exiting                 yes
  Enable RDTSCP                            yes
  Virtualize x2APIC mode                   yes
  Enable VPID                              yes
  WBINVD exiting                           yes
  Unrestricted guest                       yes
  APIC register emulation                  no
  Virtual interrupt delivery               no
  PAUSE-loop exiting                       yes
  RDRAND exiting                           yes
  Enable INVPCID                           yes
  Enable VM functions                      yes
  VMCS shadowing                           yes
  EPT-violation #VE                        no
VM-Exit controls
  Save debug controls                      default
  Host address-space size                  yes
  Load IA32_PERF_GLOBAL_CTRL               yes
  Acknowledge interrupt on exit            yes
  Save IA32_PAT                            yes
  Load IA32_PAT                            yes
  Save IA32_EFER                           yes
  Load IA32_EFER                           yes
  Save VMX-preemption timer value          yes
VM-Entry controls
  Load debug controls                      default
  IA-64 mode guest                         yes
  Entry to SMM                             yes
  Deactivate dual-monitor treatment        yes
  Load IA32_PERF_GLOBAL_CTRL               yes
  Load IA32_PAT                            yes
  Load IA32_EFER                           yes
Miscellaneous data
  VMX-preemption timer scale (log2)        5
  Store EFER.LMA into IA-32e mode guest control yes
  HLT activity state                       yes
  Shutdown activity state                  yes
  Wait-for-SIPI activity state             yes
  IA32_SMBASE support                      yes
  Number of CR3-target values              4
  MSR-load/store count recommenation       0
  IA32_SMM_MONITOR_CTL[2] can be set to 1  yes
  VMWRITE to VM-exit information fields    yes
  MSEG revision identifier                 0
VPID and EPT capabilities
  Execute-only EPT translations            yes
  Page-walk length 4                       yes
  Paging-structure memory type UC          yes
  Paging-structure memory type WB          yes
  2MB EPT pages                            yes
  1GB EPT pages                            yes
  INVEPT supported                         yes
  EPT accessed and dirty flags             yes
  Single-context INVEPT                    yes
  All-context INVEPT                       yes
  INVVPID supported                        yes
  Individual-address INVVPID               yes
  Single-context INVVPID                   yes
  All-context INVVPID                      yes
  Single-context-retaining-globals INVVPID yes
VM Functions
  EPTP Switching                           yes


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="vmx.flat.dump"

enabling apic
paging enabled
cr0 = 80010011
cr3 = 7fff000
cr4 = 20
PASS: test vmxon with FEATURE_CONTROL cleared
PASS: test vmxon without FEATURE_CONTROL lock
PASS: test enable VMX in FEATURE_CONTROL
PASS: test FEATURE_CONTROL lock bit
PASS: test vmxon
PASS: test vmptrld
PASS: test vmclear
PASS: test vmptrst
PASS: test vmxoff

Test suite : vmenter
PASS: test vmlaunch
PASS: test vmresume

Test suite : preemption timer
PASS: Keep preemption value
PASS: Save preemption value
PASS: busy-wait for preemption timer
PASS: preemption timer during hlt
PASS: preemption timer with 0 value

Test suite : control field PAT
PASS: Exit save PAT
PASS: Exit load PAT
PASS: Entry load PAT

Test suite : control field EFER
PASS: Exit save EFER
PASS: Exit load EFER
PASS: Entry load EFER

Test suite : CR shadowing
PASS: Read through CR0
PASS: Read through CR4
PASS: Write through CR0
PASS: Write through CR4
PASS: Read shadowing CR0
PASS: Read shadowing CR4
PASS: Write shadowing CR0 (same value)
PASS: Write shadowing CR4 (same value)
PASS: Write shadowing different X86_CR0_TS
PASS: Write shadowing different X86_CR0_MP
PASS: Write shadowing different X86_CR4_TSD
PASS: Write shadowing different X86_CR4_DE

Test suite : I/O bitmap
PASS: I/O bitmap - I/O pass
PASS: I/O bitmap - I/O width, byte
PASS: I/O bitmap - I/O direction, in
PASS: I/O bitmap - trap in
PASS: I/O bitmap - I/O width, word
PASS: I/O bitmap - I/O direction, out
PASS: I/O bitmap - trap out
PASS: I/O bitmap - I/O width, long
PASS: I/O bitmap - I/O port, low part
PASS: I/O bitmap - I/O port, high part
PASS: I/O bitmap - partial pass
PASS: I/O bitmap - overrun
PASS: I/O bitmap - ignore unconditional exiting
PASS: I/O bitmap - unconditional exiting

Test suite : instruction intercept
PASS: HLT
PASS: INVLPG
PASS: MWAIT
PASS: RDPMC
PASS: RDTSC
PASS: MONITOR
PASS: PAUSE
PASS: WBINVD
PASS: CPUID
PASS: INVD

Test suite : EPT framework
PASS: EPT basic framework
PASS: EPT misconfigurations
PASS: EPT violation - page permission
FAIL: EPT violation - paging structure

Test suite : interrupt
PASS: direct interrupt while running guest
PASS: intercepted interrupt while running guest
PASS: direct interrupt + hlt
FAIL: intercepted interrupt + hlt
PASS: direct interrupt + activity state hlt
PASS: intercepted interrupt + activity state hlt
`ASS: running a guest with interrupt acknowledgement set

SUMMARY: 69 tests, 2 failures


--UlVJffcvxoiEqYs2--
