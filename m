Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbbAHNIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:08:21 -0500
Received: from outbound-smtp03.blacknight.com ([81.17.249.16]:35528 "EHLO
	outbound-smtp03.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756728AbbAHNIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:08:19 -0500
Message-ID: <54AE8136.2060400@nexus-software.ie>
Date: Thu, 08 Jan 2015 13:08:06 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie> <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie> <AF233D1473C1364ABD51D28909A1B1B7326E0CC8@PGSMSX105.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B7326E0CC8@PGSMSX105.gar.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/15 00:04, Ong, Boon Leong wrote:

Hi Boon Leong - skipping the simple stuff.

>> +/**
>> + * imr_del_range - Delete an Isolated Memory Region
>> + * @reg: IMR index to remove
>> + * @base: Physical base address of region aligned to 4k
>> + * @size: Physical size of region in bytes
>> + * @return:	-EINVAL on invalid range or out or range id
>> + *		-ENODEV if reg is valid but no IMR exists or is locked
>> + *		0 on success
>> + */
>> +int imr_del(int reg, unsigned long base, unsigned long size);
>
> How about just offer imr delete based index-only as returned by imr_add()?
> We just need to check if that IMR is locked. If locked, then bail out.
> Else, we will zero-out IMR register for that index to remove it.

Hmm.

The MTRR API this is based on allows you to specific an address range 
and I think that makes sense for an IMR API too because - say you want 
to tear down the IMR around the kernel .text area - but you don't know 
which IMR it is.

You'd just do

unsigned long base  = virt_to_phys(&_text);
unsigned long size = virt_to_phys(&_sinittext) - base - IMR_ALIGN;

imr_del(-1, base, size);

Rather than having to know which specific index to kill. Also later 
silicon may have more - or less IMR indices - so deleting based on an 
address range is a valuable feature I think.

> if (!x86_match_cpu(soc_imr_ids) || !iosf_mbi_available()) {
> 	pr_info("IMR init failed due to IOSF_MBI not available or SoC is not Quark.\n");
> 	return -ENODEV;
> } else {
> 	imr_dev.num = QUARK_X1000_IMR_NUM;
> 	imr_dev.reg_base = QUARK_X1000_IMR_REGBASE;
> }

That works for me.

--
BOD

