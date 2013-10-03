Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3JCTPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:15:04 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:37077 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3JCTPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:15:01 -0400
MIME-Version: 1.0
In-Reply-To: <6362938.J7ZtNEOFpc@mistral>
References: <6362938.J7ZtNEOFpc@mistral>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 Oct 2013 13:14:38 -0600
Message-ID: <CAErSpo6XCu4ROJCh5=+7zwupjbtobowoNeF1PcXEvdg349C_pg@mail.gmail.com>
Subject: Re: [PATCH] Fix coalescing host bridge windows in arch/x86/pci/acpi.c
To: Alexey Neyman <stilor@att.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Feng Tang <feng.tang@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:15 AM, Alexey Neyman <stilor@att.net> wrote:
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

Can you please open a report at http://bugzilla.kernel.org, assign it
to drivers/pci, and attach a complete dmesg log?

Thanks,
  Bjorn
