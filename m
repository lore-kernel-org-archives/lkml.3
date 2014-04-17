Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaDQULX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:11:23 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:50694 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaDQULP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:11:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140417194853.GG4321@pd.tnic>
References: <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan> <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic> <20140416203138.GA17661@google.com>
 <20140416223122.GA2767@redhat.com> <20140416225600.GA23781@google.com>
 <20140417104533.GB8215@pd.tnic> <20140417182637.GA2098@google.com> <20140417194853.GG4321@pd.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 17 Apr 2014 14:10:54 -0600
Message-ID: <CAErSpo47rmmVMQs7gOcpFpGzH+13x0aYjsLYOSQWVKUE+ikUSw@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 1:48 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Apr 17, 2014 at 12:26:37PM -0600, Bjorn Helgaas wrote:
>> Thanks a lot for testing this out and debugging my issues.
>>
>> Here's a new version that looks for both device IDs I know about.
>>
>> I'm still nervous about the modeset problem Dave is seeing.  Since the
>> original patch wouldn't find an 8086:0c00 device on Dave's system, it
>> should have done nothing.  But since it caused a modesetting problem,
>> there's something else doing on that I don't understand.
>
> Yeah, this is strange, to put it mildly. This quirk wouldnt've done
> anything besides the iteration over the pci devices with pci_get_device.
> Which wouldn't do anything (refcount increment or so) if it didn't find
> the device, right?

Right.

> Bah, today is the day of the strange bugs. :-\
>
>> PNP: Work around BIOS defects in Intel MCH area reporting
>>
>> From: Bjorn Helgaas <bhelgaas@google.com>
>>
>> Work around BIOSes that don't report the entire Intel MCH area.
>>
>> MCHBAR is not an architected PCI BAR, so MCH space is usually reported as a
>> PNP0C02 resource.  The MCH space was once 16KB, but is 32KB in newer parts.
>> Some BIOSes still report a PNP0C02 resource that is only 16KB, which means
>> the rest of the MCH space is consumed but unreported.
>>
>> This can cause resource map sanity check warnings or (theoretically) a
>> device conflict if we assigned the unreported space to another device.
>>
>> The Intel perf event uncore driver tripped over this when it claimed the
>> MCH region:
>>
>>   resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01
>>   Info: mapping multiple BARs. Your kernel is fine.
>>
>> To prevent this, if we find a PNP0C02 resource that covers part of the MCH
>> space, extend it to cover the entire space.
>>
>> Link: http://lkml.kernel.org/r/20140224162400.GE16457@pd.tnic
>> Reported-by: Borislav Petkov <bp@alien8.de>
>
> Yep, this one works fine:
>
> [    0.403855] pnp 00:01: [Firmware Bug]: PNP resource [mem 0xfed10000-0xfed13fff] covers only part of 0000:00:00.0 Intel MCH; extending to [mem 0xfed10000-0xfed17fff]
>
> Acked-by: Borislav Petkov <bp@suse.de>
> Tested-by: Borislav Petkov <bp@suse.de>

>> +     region.end = region.start + 32*1024 - 1 ;

> checkpatch complains about a trailing space before the semicolon.

Thanks!  I hate typos like that.

I'll fix this, add your tested-by and ack, and send to Rafael.

Bjorn
