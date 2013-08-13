Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab3HMKzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:55:38 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:12570 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3HMKzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:55:37 -0400
Message-ID: <520A10A3.5080303@hp.com>
Date: Tue, 13 Aug 2013 18:55:31 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        bhelgaas@google.com, Jingbai Ma <jingbai.ma@hp.com>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>
Subject: Re: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption issue
 after unsetting BSP flag
References: <5200BFB3.2050202@jp.fujitsu.com>
In-Reply-To: <5200BFB3.2050202@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 05:19 PM, HATAYAMA Daisuke wrote:
> Hello,
> 
> I've addressing kdump restriction that there's only one cpu available
> on the kdump 2nd kernel. Now I need to check if the following CPU0 SMI
> corruption issue fixed in the following commit can again be reproduced
> by unsetting BSP flag of the boot cpu:
> 
> commit 74b5820808215f65b70b05a099d6d3c969b82689
> Author: Bjorn Helgaas<bjorn.helgaas@hp.com>
> Date:   Wed Jul 29 15:54:25 2009 -0600
> 
>      ACPI: bind workqueues to CPU 0 to avoid SMI corruption
> 
>      On some machines, a software-initiated SMI causes corruption unless the
>      SMI runs on CPU 0.  An SMI can be initiated by any AML, but typically it's
>      done in GPE-related methods that are run via workqueues, so we can avoid
>      the known corruption cases by binding the workqueues to CPU 0.
> 
>      References:
>          http://bugzilla.kernel.org/show_bug.cgi?id=13751
>          https://bugs.launchpad.net/bugs/157171
>          https://bugs.launchpad.net/bugs/157691
> 
>      Signed-off-by: Bjorn Helgaas<bjorn.helgaas@hp.com>
>      Signed-off-by: Len Brown<len.brown@intel.com>
> 
> The reason is that in the current situation, I have two ideas to deal
> with the avove kdump restriction:
> 
>    1) Disable BSP at the 2nd kernel, posted at:
>      [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
>      https://lkml.org/lkml/2012/10/16/15
> 
>    2) Unset BSP flag at the 1st kernel, suggested by Eric Biederman
>       during the discussion of the idea 1).
> 
> On the idea 1), BSP is disabled on the kdump 2nd kernel. My conclusion
> is that we have no method to reset BSP, i.e. recover BPS's healthy
> state, while we can recover AP by means of INIT as described in MP
> specification.
> 
> The idea 2) is simpler. We unset BSP flag of the boot cpu at 1st
> kernel. The behaviour when receiving INIT depends on whether or not
> BSP flag is set or not on its MSR; we can set and unset BSP flag of
> MSR freely at runtime. (I don't mean we should).
> 
> So, next thing I should do is to evalute risk of the idea 2). In fact,
> during the discussion of the idea 1), HPA pointed out that some kind
> of firmware affects if BSP flag is unset. Also, maybe from the same
> reason, recently introduced cpu0 hot-plugging feature by Fenghua Yu
> doesn't appear to unset BSP flag.
> 
> The biggest problem next is that I don't have any machines reported in
> the bugzilla articles; this issue inherently depends on firmware.
> 
> So, could anyone help testing the idea 2) above if you have which of
> the following machines? (or other ones that can lead to the same bug)
> 
> - HP Compaq 6910p
> - HP Compaq 6710b
> - HP Compaq 6710s
> - HP Compaq 6510b
> - HP Compaq 2510p
> 
> I prepared a small programs for this test. See the attached file.
> The steps to try to reproduce the bug is as follows:
> 
>    1. $ tar xf bsp_flag_modules.tar.gz; cd bsp_flag_modules
>    2. $ make # to build these programs
>    3. $ insmod unsetbspflag.ko # to unset BSP flag of the boot cpu
>    4. $ insmod getcpuinfo.ko # to confirm if BSP flag of the boot cpu has
>                              # been unset.
>       $ dmesg | tail
>    5. Close the lid of the machine.
>    6. Wait some minutes if necessary.
>    7. Open the lid and you can see oops on the screen if bug has
>      successfully been reproduced.
> 

I couldn't find any model list above, but found one HP EliteBook 6930p.
I tested this machine with kernel 2.6.30 first. After resuming from
suspend, system hang.

Then, I tested with kernel 3.11.0-rc5, it worked well, could resume from
suspend without any problem.

Next, I tested your program to clear BSP flag, I found the
unsetbspflag.ko didn't work everytime, sometimes I have to execute
insmod/rmmod several times to clear the BSP flag. (I used your
getcpuinfo.ko to check the BSP flag)

cpu: 0 bios_apic: 0 apic: 0 AP
cpu: 1 bios_apic: 1 apic: 1 AP

I suspended it, and them resumed it. This machine resumed from suspend
successfully, but the BSP flag has been set back:

cpu: 0 bios_apic: 0 apic: 0 BSP
cpu: 1 bios_apic: 1 apic: 1 AP

That's all my observation. Hope it's helpful.

-- 
Thanks,
Jingbai Ma
