Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaLJLUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:20:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:47470 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaLJLUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:20:39 -0500
Message-ID: <54882C7F.4010901@arm.com>
Date: Wed, 10 Dec 2014 11:20:31 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>
Subject: Re: [PATCH v3 04/13] irqchip: GICv3: ITS command queue
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com> <1416839720-18400-5-git-send-email-marc.zyngier@arm.com> <5487B7E5.2080104@huawei.com>
In-Reply-To: <5487B7E5.2080104@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/14 03:03, Yun Wu (Abel) wrote:
> On 2014/11/24 22:35, Marc Zyngier wrote:
> 
> [...]
> 
>> +static struct its_collection *its_build_mapd_cmd(struct its_cmd_block *cmd,
>> +                                              struct its_cmd_desc *desc)
>> +{
>> +     unsigned long itt_addr;
>> +     u8 size = order_base_2(desc->its_mapd_cmd.dev->nr_ites);
> 
> If @nr_ites is 1, then @size becomes 0, and... (see below)
> 
>> +
>> +     itt_addr = virt_to_phys(desc->its_mapd_cmd.dev->itt);
>> +     itt_addr = ALIGN(itt_addr, ITS_ITT_ALIGN);
>> +
>> +     its_encode_cmd(cmd, GITS_CMD_MAPD);
>> +     its_encode_devid(cmd, desc->its_mapd_cmd.dev->device_id);
>> +     its_encode_size(cmd, size - 1);
> 
> here (size - 1) becomes the value of ~0, which will exceed the maximum
> supported bits of identifier.

Well, the problem is that nr_ites should never be 1, as it effectively
means "don't use any bit to index the ITE". And it also means we cannot
have an ITT that's not a strict power of two.

So while this is indeed a bug, the root of the problem is elsewhere.

I'll cook a fix, thanks for the report.

	M.
-- 
Jazz is not dead. It just smells funny...
