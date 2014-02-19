Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaBSGTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:19:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaBSGTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:19:05 -0500
Date: Wed, 19 Feb 2014 14:18:24 +0800
From: WANG Chao <chaowang@redhat.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>, "Jon D. Mason" <jdmason@kudzu.us>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Cc: kexec@lists.infradead.org, discuss@x86-64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: How could we get rid of saved_max_pfn for calgary iommu?
Message-ID: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

arch/x86/kernel/pci-calgary.c is the only user of saved_max_pfn today:

int __init detect_calgary(void)
{
	[..]
	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
					saved_max_pfn : max_pfn) * PAGE_SIZE);
	[..]
}

saved_max_pfn is the real mem size and is calculated by 1st kernel E820
memmap which is passed in by 2nd kernel's boot_params (done by kexec):

	saved_max_pfn = e820_end_of_ram_pfn();

After saved_max_pfn has been set, memmap=exactmap will reset the E820
provided by boot_params and use the user defined E820 instead.

Now we want to get rid of memmap=exactmap and directly pass the E820
memmap by boot_params for some reason (eg. exactmap may exceed the cmdline
size and also isn't compatible with kaslr).

However saved_max_pfn becomes the obstacle for obsoleting exactmap.
Because it needs two conditions: first kernel's E820 map and
memmap=exactmap cmdline.

So I'm wondering if it's possible to get rid of saved_max_pfn totally in
calgary code. Or we can get saved_max_pfn using a different way, for
example calculated in 1st kernel and passed in to 2nd kernel by cmdline.

Thanks
WANG Chao
