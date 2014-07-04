Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaGDHUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:20:17 -0400
Received: from goliath.siemens.de ([192.35.17.28]:41933 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaGDHUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:20:16 -0400
Message-ID: <53B6559A.6020406@siemens.com>
Date: Fri, 04 Jul 2014 09:19:54 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Bandan Das <bsd@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com> <53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com> <20140703065955.GA4236@kernel> <jpgk37u8iae.fsf@redhat.com> <20140704025250.GA2849@kernel> <53B63EF2.6000800@siemens.com> <20140704060831.GA3453@kernel>
In-Reply-To: <20140704060831.GA3453@kernel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-04 08:08, Wanpeng Li wrote:
> On Fri, Jul 04, 2014 at 07:43:14AM +0200, Jan Kiszka wrote:
>> On 2014-07-04 04:52, Wanpeng Li wrote:
>>> On Thu, Jul 03, 2014 at 01:27:05PM -0400, Bandan Das wrote:
>>> [...]
>>>> # modprobe kvm_intel ept=0 nested=1 enable_shadow_vmcs=0
>>>>
>>>> The Host CPU - Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
>>>> qemu cmd to run L1 - 
>>>> # qemu-system-x86_64 -drive file=level1.img,if=virtio,id=disk0,format=raw,cache=none,werror=stop,rerror=stop,aio=threads -drive file=level2.img,if=virtio,id=disk1,format=raw,cache=none,werror=stop,rerror=stop,aio=threads -vnc :2 --enable-kvm -monitor stdio -m 4G -net nic,macaddr=00:23:32:45:89:10 -net tap,ifname=tap0,script=/etc/qemu-ifup,downscript=no -smp 4 -cpu Nehalem,+vmx -serial pty
>>>>
>>>> qemu cmd to run L2 -
>>>> # sudo qemu-system-x86_64 -hda VM/level2.img -vnc :0 --enable-kvm -monitor stdio -m 2G -smp 2 -cpu Nehalem -redir tcp:5555::22
>>>>
>>>> Additionally,
>>>> L0 is FC19 with 3.16-rc3
>>>> L1 and L2 are Ubuntu 14.04 with 3.13.0-24-generic
>>>>
>>>> Then start a kernel compilation inside L2 with "make -j3"
>>>>
>>>> There's no call trace on L0, both L0 and L1 are hung (or rather really slow) and
>>>> L1 serial spews out CPU softlock up errors. Enabling panic on softlockup on L1 will give
>>>> a trace with smp_call_function_many() I think the corresponding code in kernel/smp.c that
>>>> triggers this is
>>>>
>>>> WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>>>>                      && !oops_in_progress && !early_boot_irqs_disabled);
>>>>
>>>> I know in most cases this is usually harmless, but in this specific case,
>>>> it seems it's stuck here forever.
>>>>
>>>> Sorry, I don't have a L1 call trace handy atm, I can post that if you are interested.
>>>>
>>>> Note that this can take as much as 30 to 40 minutes to appear but once it does,
>>>> you will know because both L1 and L2 will be stuck with the serial messages as I mentioned
>>>> before. From my side, let me try this on another system to rule out any machine specific
>>>> weirdness going on..
>>>>
>>>
>>> Thanks for your pointing out. 
>>>
>>>> Please let me know if you need any further information.
>>>>
>>>
>>> I just run kvm-unit-tests w/ vmx.flat and eventinj.flat.
>>>
>>>
>>> w/ vmx.flat and w/o my patch applied 
>>>
>>> [...]
>>>
>>> Test suite : interrupt
>>> FAIL: direct interrupt while running guest
>>> PASS: intercepted interrupt while running guest
>>> FAIL: direct interrupt + hlt
>>> FAIL: intercepted interrupt + hlt
>>> FAIL: direct interrupt + activity state hlt
>>> FAIL: intercepted interrupt + activity state hlt
>>> PASS: running a guest with interrupt acknowledgement set
>>> SUMMARY: 69 tests, 6 failures
>>>
>>> w/ vmx.flat and w/ my patch applied 
>>>
>>> [...]
>>>
>>> Test suite : interrupt
>>> PASS: direct interrupt while running guest
>>> PASS: intercepted interrupt while running guest
>>> PASS: direct interrupt + hlt
>>> FAIL: intercepted interrupt + hlt
>>> PASS: direct interrupt + activity state hlt
>>> PASS: intercepted interrupt + activity state hlt
>>> PASS: running a guest with interrupt acknowledgement set
>>>
>>> SUMMARY: 69 tests, 2 failures 
>>
>> Which version (hash) of kvm-unit-tests are you using? All tests up to
>> 307621765a are running fine here, but since a0e30e712d not much is
>> completing successfully anymore:
>>
> 
> I just git pull my kvm-unit-tests to latest, the last commit is daeec9795d.
> 
>> enabling apic
>> paging enabled
>> cr0 = 80010011
>> cr3 = 7fff000
>> cr4 = 20
>> PASS: test vmxon with FEATURE_CONTROL cleared
>> PASS: test vmxon without FEATURE_CONTROL lock
>> PASS: test enable VMX in FEATURE_CONTROL
>> PASS: test FEATURE_CONTROL lock bit
>> PASS: test vmxon
>> FAIL: test vmptrld
>> PASS: test vmclear
>> init_vmcs : make_vmcs_current error
>> FAIL: test vmptrst
>> init_vmcs : make_vmcs_current error
>> vmx_run : vmlaunch failed.
>> FAIL: test vmlaunch
>> FAIL: test vmlaunch
>>
>> SUMMARY: 10 tests, 4 unexpected failures
> 
> 
> /opt/qemu/bin/qemu-system-x86_64 -enable-kvm -device pc-testdev -serial stdio 
> -device isa-debug-exit,iobase=0xf4,iosize=0x4 -kernel ./x86/vmx.flat -cpu host
> 
> Test suite : interrupt
> PASS: direct interrupt while running guest
> PASS: intercepted interrupt while running guest
> PASS: direct interrupt + hlt
> FAIL: intercepted interrupt + hlt
> PASS: direct interrupt + activity state hlt
> PASS: intercepted interrupt + activity state hlt
> PASS: running a guest with interrupt acknowledgement set
> 
> SUMMARY: 69 tests, 2 failures

Somehow I'm missing the other 31 vmx test we have now... Could you post
the full log? Please also post the output of qemu/scripts/kvm/vmxcap on
your test host to compare with what I have here.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
