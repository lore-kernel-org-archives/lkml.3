Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaBTAEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:04:24 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:44600 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBTAEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:04:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
References: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
Date: Wed, 19 Feb 2014 17:04:22 -0700
Message-ID: <CAPoiz9yuLg4exX58bh5=XumgAmYNq-9kPjc+f1wa8kMU3-dBbg@mail.gmail.com>
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
From: Jon Mason <jdmason@kudzu.us>
To: WANG Chao <chaowang@redhat.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, kexec@lists.infradead.org,
        discuss@x86-64.org, x86@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:18 PM, WANG Chao <chaowang@redhat.com> wrote:
> Hi, All
>
> arch/x86/kernel/pci-calgary.c is the only user of saved_max_pfn today:
>
> int __init detect_calgary(void)
> {
>         [..]
>         specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
>                                         saved_max_pfn : max_pfn) * PAGE_SIZE);
>         [..]
> }

IIUC, the purpose of this code is to reuse the TCE table from the
previous kernel.  Thus, it needs to be of the same size as the
pre-kdump kernel.  It is using the max_pfn to determine the TCE table
size in the non-kdump case.  If there is another way to determine the
size it used before, then I am fine making the change to use that way.

Thanks,
Jon

> saved_max_pfn is the real mem size and is calculated by 1st kernel E820
> memmap which is passed in by 2nd kernel's boot_params (done by kexec):
>
>         saved_max_pfn = e820_end_of_ram_pfn();
>
> After saved_max_pfn has been set, memmap=exactmap will reset the E820
> provided by boot_params and use the user defined E820 instead.
>
> Now we want to get rid of memmap=exactmap and directly pass the E820
> memmap by boot_params for some reason (eg. exactmap may exceed the cmdline
> size and also isn't compatible with kaslr).
>
> However saved_max_pfn becomes the obstacle for obsoleting exactmap.
> Because it needs two conditions: first kernel's E820 map and
> memmap=exactmap cmdline.
>
> So I'm wondering if it's possible to get rid of saved_max_pfn totally in
> calgary code. Or we can get saved_max_pfn using a different way, for
> example calculated in 1st kernel and passed in to 2nd kernel by cmdline.
>
> Thanks
> WANG Chao
