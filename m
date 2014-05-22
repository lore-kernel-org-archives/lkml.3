Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaEVR40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:56:26 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50483 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaEVR4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:56:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140521233802.GA21575@pd.tnic>
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521231817.26447.55150.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140521233802.GA21575@pd.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 22 May 2014 11:56:03 -0600
Message-ID: <CAErSpo4hcitey+jtZkgpbZsEswJJekStXONct9rrh0aQ_R0h8g@mail.gmail.com>
Subject: Re: [PATCH V5 3/4] x86/PCI: Stop enabling ECS for AMD CPUs after Fam16h
To: Borislav Petkov <bp@alien8.de>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 5:38 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, May 21, 2014 at 05:18:17PM -0600, Bjorn Helgaas wrote:
>> ECS is an AMD mechanism that allows access to extended PCI config space
>> (offsets 256-4096) via I/O ports CF8/CFCh.  We normally use ECAM, i.e.,
>> MMCONFIG, to access that space, but apparently old machines have issues
>> that meant we couldn't use ECAM.
>>
>> The solution was to enable ECS so we could use configuration mechanism #1
>> (I/O ports CF8/CFCh) to access extended config space.  See 831d991821da
>> ("x86: add PCI extended config space access for AMD Barcelona").
>>
>> New machines should be able to use ECAM, which means they don't need the
>> CPU-specific code to enable ECS.  This patch leaves ECS the same on all
>> existing platforms, but stops enabling it on platforms after Fam16h.
>>
>> Those future platforms should be able to use the standard ACPI MCFG/_CBA
>> descriptions of the PCIe ECAM mechanism.
>>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> CC: Robert Richter <rric@kernel.org>
>> ---
>>  arch/x86/pci/amd_bus.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
>> index aa936e3a2019..67dadf179348 100644
>> --- a/arch/x86/pci/amd_bus.c
>> +++ b/arch/x86/pci/amd_bus.c
>> @@ -405,7 +405,9 @@ static int __init amd_postcore_init(void)
>>               return 0;
>>
>>       early_fill_mp_bus_info();
>> -     pci_io_ecs_init();
>> +
>> +     if (boot_cpu_data.x86 <= 0x16)
>
> Fam 0x16, i.e. hex? I think we talked about fam 0x10, i.e. 16 decimal.
>
> Oh well, that's an AMD call now.

I chose Fam16h (0x16) because it looks like that's the newest stuff
that's in the field.  I suspect things would probably work if we
changed this patch to leave ECS disabled on some Fam16h, Fam15h, etc.,
but that would change behavior on existing systems, which obviously
adds some risk.  I didn't think there was much benefit that makes the
risk worthwhile.

My goal is to stop needing CPU-specific changes in the future, not
necessarily to remove the CPU-specific code we already have.

Does that make sense?  I'm not sure whether I understood your real question.

Bjorn
