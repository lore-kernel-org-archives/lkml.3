Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3JCXS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:18:28 -0400
Received: from asmtp.lnxw.com ([207.21.185.2]:51386 "EHLO asmtp.lnxw.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab3JCXS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:18:27 -0400
From: Alexey Neyman <stilor@att.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] Fix coalescing host bridge windows in arch/x86/pci/acpi.c
Date: Thu, 3 Oct 2013 16:16:07 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34-020634-generic; KDE/4.4.5; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Feng Tang <feng.tang@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6362938.J7ZtNEOFpc@mistral> <CAErSpo6XCu4ROJCh5=+7zwupjbtobowoNeF1PcXEvdg349C_pg@mail.gmail.com>
In-Reply-To: <CAErSpo6XCu4ROJCh5=+7zwupjbtobowoNeF1PcXEvdg349C_pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310031616.08617.stilor@att.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 03, 2013 12:14:38 pm Bjorn Helgaas wrote:
> On Mon, Sep 23, 2013 at 12:15 AM, Alexey Neyman <stilor@att.net> wrote:
> > [Resending due to no response to the original message in a week]
> > 
> > Hi all,
> > 
> > I have a board with a BIOS bug that reports the following I/O port
> > regions in _CRS on one of the host bridges:
> > 
> > 0x0000-0x03af // #0
> > 0x03e0-0x0cf7 // #1
> > 0x03b0-0x03bb // #2
> > 0x03c0-0x03df // #3
> > 0x0000-0xdfff // #4
> > 0xf000-0xffff // #5
> > 
> > Obviously, region number #4 is erroneous as it overlaps with regions
> > #0..3. The code in coalesce_windows() in arch/x86/pci/acpi.c attempts to
> > recover from such kind of BIOS bugs by merging the overlapping regions.
> > Current code expands region #0 to 0x0000-0xdffff and makes region #4
> > ignored. As a result, overlap of the expanded region #0 with regions
> > #1..3 remains undetected (as the inner loop already compared them with
> > region #0). As a result, regions #1..3 are inserted into the resource
> > tree even though they overlap with adjusted region #0 - which later
> > results in resource conflicts for PCI devices with IO ports in one of
> > those regions (e.g., for an PCI IDE controller in legacy mode - which
> > has port 0x3f6). The kernel then refuses to initialize these devices.
> > 
> > The fix: instead of expanding res1 and ignoring res2, do the opposite.
> > The res2 window is yet to be compared against all windows between res1
> > and res2 (regions #1..3 in the above example), so the resulting resource
> > map will include just the expanded region - and will ignore any
> > overlapping ones.
> > 
> > Signed-off-by: Alexey Neyman <stilor@att.net>
> 
> Can you please open a report at http://bugzilla.kernel.org, assign it
> to drivers/pci, and attach a complete dmesg log?

https://bugzilla.kernel.org/show_bug.cgi?id=62511

I am not at liberty to disclose full hardware configuration of the board, as 
it is a proprietary prototype board not in production. I've provided the 
relevant messages from dmesg though.

Regards,
Alexey.
