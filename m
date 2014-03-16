Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaCPNIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 09:08:19 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:38806 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaCPNIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 09:08:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140316115546.GA11935@nazgul.tnic>
References: <20140224162400.GE16457@pd.tnic>
	<4205942.Tp8ltEsv6e@vostro.rjw.lan>
	<20140316115546.GA11935@nazgul.tnic>
Date: Sun, 16 Mar 2014 14:08:16 +0100
Message-ID: <CABPqkBSmes+ee19iVh0EHvMQ=7TAzN3Fx1BKdOZ-2iuk5L0ugw@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
From: Stephane Eranian <eranian@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        lkml <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

Thanks for the analysis.

On Sun, Mar 16, 2014 at 12:55 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Mar 15, 2014 at 03:15:04PM +0100, Rafael J. Wysocki wrote:
>> I've just gone throught this.
>
> Thanks.
>
>> So the problem is that we have the PNP "system" driver whose only purpose seems
>> to be to reserve system resources so that the PCI layer doesn't assign them to
>> new devices on hotplug (disclaimer: I didn't invent it, I only read the code and
>> comments in there).
>>
>> It does that for ACPI device objects having the "PNP0C02" and "PNP0C01" IDs.
>
> Right, pnp 00:01 is PNP0C02.
>
>> Apparently, snb_uncore_imc_init_box() steps on a range already reserved by that
>> driver on your box.  And this doesn't seem to be a coincidence, because the ACPI
>> device object in question probably *does* correspond to the memory controller
>> that the uncore driver attempts to use.
>>
>> I'm not sure how to address that right now to be honest.  Arguably, the PNP
>> "system" driver should be replaced with something saner, but still the
>> resources it claims need to be kept out of reach of the PCI's resource
>> allocation code.
>
> Well, I'm only conjecturing here but there should be a way for the
> uncore code to tell the PNP "system" driver to free this resource
> because uncore is going to use it now. Or something to that effect.
>
I agree. The snb_uncore_imc() is making real (good) use of the device.
It needs to own it. So we need a way to free the resource from the PNP
system or  a way to tell PNP need to grab it on systems with the
snb_uncore_imc() support. Does that kind of API exist?

Where do I look to prevent PNP from grabbing the IMC?
