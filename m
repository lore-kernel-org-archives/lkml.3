Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3IPXcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:32:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42784 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846Ab3IPXcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:32:03 -0400
Message-ID: <523794EE.10505@hurleysoftware.com>
Date: Mon, 16 Sep 2013 19:31:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexey Neyman <stilor@att.net>
CC: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH PING] Fix coalescing of host bridge windows in arch/x86/pci/acpi.c
References: <201309121719.17447.stilor@att.net> <201309160941.54844.stilor@att.net>
In-Reply-To: <201309160941.54844.stilor@att.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc Bjorn Helgaas, Rafael Wysocki, linux-acpi ]

On 09/16/2013 12:41 PM, Alexey Neyman wrote:
> Hi all,
>
> Could anybody review/commit the patch?

LKML is a pretty general list and maintainers don't typically
trawl the list for more work to do. The get_maintainer script
can be used to help determine to whom to address a patch.

peter@thor:~/src/kernels/next$ ./scripts/get_maintainer.pl -f arch/x86/pci/acpi.c
Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE...)
Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...)
"H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...)
x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Bjorn Helgaas <bhelgaas@google.com> (commit_signer:5/8=62%)
"Rafael J. Wysocki" <rafael.j.wysocki@intel.com> (commit_signer:3/8=38%)
Feng Tang <feng.tang@intel.com> (commit_signer:1/8=12%)
Yijing Wang <wangyijing@huawei.com> (commit_signer:1/8=12%)
Mike Yoknis <mike.yoknis@hp.com> (commit_signer:1/8=12%)
linux-kernel@vger.kernel.org (open list)

Regards,
Peter Hurley

PS - You'll want to inline your patch as well because as you can see
replies don't include it.

> Regards,
> Alexey.
>
> On Thursday, September 12, 2013 05:19:16 pm Alexey Neyman wrote:
>> Hi all,
>>
>> I have a board with a BIOS bug that reports the following I/O port regions
>> in _CRS on one of the host bridges:
>>
>> 0x0000-0x03af // #0
>> 0x03e0-0x0cf7 // #1
>> 0x03b0-0x03bb // #2
>> 0x03c0-0x03df // #3
>> 0x0000-0xdfff // #4
>> 0xf000-0xffff // #5
>>
>> Obviously, region number #4 is erroneous as it overlaps with regions #0..3.
>> However, code in coalesce_windows() in arch/x86/pci/acpi.c attempts to
>> recover from such kind of BIOS bugs by merging the overlapping regions.
>> Current code expands region #0 to 0x0000-0xdffff and makes region #4
>> ignored. As a result, overlap of the expanded region #0 with regions #1..3
>> remains undetected. As a result, regions #1..3 are inserted into the
>> resource tree as if they were consumers of the 0x0000-0xdfff regions, and
>> devices that have resources in one of these regions (e.g. 0x3f6 for legacy
>> IDE) have a resource conflict - the kernel does not initialize them.
>>
>> The attached patch makes the code in coalesce_windows() instead ignore res1
>> (which is already dealt with), possibly expanding res2 instead. As res2 has
>> not been reached in the outer loop in coalesce_windows(), the code will
>> then check for overlaps of the just-expanded resource with the rest of the
>> resources.
>>
>> Regards,
>> Alexey.

