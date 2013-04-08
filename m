Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790Ab3DHI5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:57:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51955 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759647Ab3DHI5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:57:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51628663.9040604@jp.fujitsu.com>
Date: Mon, 08 Apr 2013 17:57:07 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: dwmw2@infradead.org
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
References: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com>  <20130326144629.GB2727@8bytes.org> <51527D74.9080209@jp.fujitsu.com>  <20130327103122.GK30540@8bytes.org> <51591EEE.60401@jp.fujitsu.com>  <20130402140546.GA15687@8bytes.org> <515BD638.8070307@jp.fujitsu.com>  <1364977479.28127.15.camel@i7.infradead.org>  <515D1429.40707@jp.fujitsu.com> <1365085489.28127.64.camel@i7.infradead.org>
In-Reply-To: <1365085489.28127.64.camel@i7.infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/04 23:24), David Woodhouse wrote:
> On Thu, 2013-04-04 at 14:48 +0900, Takao Indoh wrote:
>>
>> - DMAR fault messages floods and second kernel does not boot. Recently I
>>    saw similar report. https://lkml.org/lkml/2013/3/8/120
> 
> Right. So the fix for that is to make the subsequent errors silent,
> until/unless we actually get a request to create a mapping for the given
> device.
> 
>> - igb driver detectes error on linkup and kdump via network fails.
> 
> That's a driver bug, IIRC. It was failing to completely reset the
> hardware. It's fixed now, isn't it?

No, it can be reproduced with latest kernel(3.9.0-rc6).

> 
>> - On a certain platform, though kdump itself works, PCIe error like
>>    Unexpected Completion is detected and it gets hardware degraded.
> 
> More information required.

When I tested intel_iommu on a certain machine, the following error
message was logged in its firmware, and I/O board got abnormal status.
05:00.0 is igb, so I think this was caused by DMA error on igb. This
occurs before igb driver loading, so this cannot be fixed in driver.

    PCI: Unexpected Completion Bus: 5 Device: 0x00 Function: 0x00

Anyway, I'm thinking we should introduce something framework to clean
all devices to stop DMA at boot time rather than dealing with the
problem in each driver. And one of the way I found is resetting devcies
by PCIe layer. If DMAR is disabled in init_dmars(), we can have a
chance to handle devices to stop DMA in PCI layer, like qci-quirk. This
is one of the reason why I propose this patch.

Thanks,
Takao Indoh

