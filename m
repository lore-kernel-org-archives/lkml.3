Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbbAFN42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:56:28 -0500
Received: from outbound-smtp06.blacknight.com ([81.17.249.39]:58673 "EHLO
	outbound-smtp06.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054AbbAFN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:56:27 -0500
Message-ID: <54ABE989.8060701@nexus-software.ie>
Date: Tue, 06 Jan 2015 13:56:25 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Darren Hart <dvhart@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: Add IMR support to Quark/Galileo
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie> <20150106055959.GA59754@vmdeb7>
In-Reply-To: <20150106055959.GA59754@vmdeb7>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/15 06:00, Darren Hart wrote:
>> Galileo:
>> Intel's Arduino compatible Galileo boards boot to Linux with IMRs protecting
>> the compressed kernel image and boot params data structure. The memory that
>
> What is the motivation behind this?

The main motivation is to place an IMR around the kernel which if 
violated by a wayward DMA transaction would immediately cause an IMR 
violation. Secondary motivation is demonstration of usage of IMRs in a 
run-time context and validation of the IMR enabling code for setup not 
just tear-down.

An IMR around the run-time kernel .text area, is what the BSP does and 
so I thought it was worth maintaining.

To be clear though, the requirement is to sanitize boot time IMRs, the 
setup of an IMR around the run-time kernel is optional, the system will 
run just fine without it.

>> the compressed kernel and boot params data structure is in, is marked as
>> usable memory by the EFI memory map. As a result it is possible for memory
>
> Based on your response to the above, is marking this memory as usable a bad idea
> in general? Or just bad in certain situations?

The EFI memory map is 100% correct. The area of memory that grub places 
a compressed kernel image should be reusable by kernel.

>> A DMA to a region of memory by a system agent which is not allowed access
>> this memory result in a system reset. Without tearing down the IMRs placed
>> around the compressed kernel image and boot params data structure there is a
>> high risk of triggering an inadvertent system reset when performing DMA
>> actions with any of the peripherals that support DMA in Quark such as the
>> MMC, Ethernet or USB host/device.
>>
>> Therefore Galileo specific platform code is the second component of this
>> patchset. The platform code tears-down every unlocked IMR to ensure no
>
> The firmware sets these IMRs, but does not lock them then, correct?

Correct. Firmware locks the IMRs around ACPI runtime data data.

In the patch here, we cycle though every unlocked IMR and zap it - which 
will include tear-down of the IMRs placed around the compressed kernel 
image and boot params data structure. Firmware puts those IMRs in place 
to ensure no invalid DMA, SMM access to the compressed kernel image 
during boot can take place.


