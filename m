Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3IXDtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 23:49:18 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:19512 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3IXDtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 23:49:17 -0400
Message-ID: <52410B49.3050306@huawei.com>
Date: Tue, 24 Sep 2013 11:47:21 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexey Neyman <stilor@att.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Feng Tang <feng.tang@intel.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix coalescing host bridge windows in arch/x86/pci/acpi.c
References: <6362938.J7ZtNEOFpc@mistral>
In-Reply-To: <6362938.J7ZtNEOFpc@mistral>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/23 14:15, Alexey Neyman wrote:
> [Resending due to no response to the original message in a week]
> 
> Hi all,
> 
> I have a board with a BIOS bug that reports the following I/O port regions in 
> _CRS on one of the host bridges:
> 
> 0x0000-0x03af // #0
> 0x03e0-0x0cf7 // #1
> 0x03b0-0x03bb // #2
> 0x03c0-0x03df // #3
> 0x0000-0xdfff // #4
> 0xf000-0xffff // #5
> 
> Obviously, region number #4 is erroneous as it overlaps with regions #0..3. 
> The code in coalesce_windows() in arch/x86/pci/acpi.c attempts to recover from 
> such kind of BIOS bugs by merging the overlapping regions. Current code 
> expands region #0 to 0x0000-0xdffff and makes region #4 ignored. As a result, 
> overlap of the expanded region #0 with regions #1..3 remains undetected (as 
> the inner loop already compared them with region #0). As a result, regions 
> #1..3 are inserted into the resource tree even though they overlap with 
> adjusted region #0 - which later results in resource conflicts for PCI devices 
> with IO ports in one of those regions (e.g., for an PCI IDE controller in 
> legacy mode - which has port 0x3f6). The kernel then refuses to initialize 
> these devices.
> 
> The fix: instead of expanding res1 and ignoring res2, do the opposite. The 
> res2 window is yet to be compared against all windows between res1 and res2 
> (regions #1..3 in the above example), so the resulting resource map will 
> include just the expanded region - and will ignore any overlapping ones.
> 
> Signed-off-by: Alexey Neyman <stilor@att.net>
> 

It looks fine to me, but I have no platform to test it. :)


-- 
Thanks!
Yijing

