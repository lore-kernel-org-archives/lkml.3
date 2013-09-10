Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3IJFnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:43:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52097 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3IJFnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:43:50 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <522EB171.6000909@jp.fujitsu.com>
Date: Tue, 10 Sep 2013 14:43:13 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dwmw2@infradead.org
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, kexec@lists.infradead.org, alex.williamson@redhat.com
Subject: Re: [PATCH] intel-iommu: Quiesce devices before disabling IOMMU
References: <1377069354-5056-1-git-send-email-indou.takao@jp.fujitsu.com> <1378717669.2627.239.camel@shinybook.infradead.org>
In-Reply-To: <1378717669.2627.239.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/09 18:07), David Woodhouse wrote:
> On Wed, 2013-08-21 at 16:15 +0900, Takao Indoh wrote:
>>
>> This causes problem on kdump. Devices are working in first kernel, and
>> after switching to second kernel and initializing IOMMU, many DMAR faults
>> occur and it causes problems like driver error or PCI SERR, at last
>> kdump fails. This patch fixes this problem.
> 
> I'm not sure I'd call this a fix.
> 
> If the driver is so broken that it cannot get the device working again
> after a fault, surely the driver needs to be fixed?

Yes,this problem may be solved by fixing driver. Actually megaraid sas
driver is recently fixed for this problem. (See commit 6431f5d7)

But I think root cause of this problem is initializing IOMMU while DMA
is still working, and I want to solve the root cause rather than
handling it in each driver, otherwise we have to fix driver each time we
find this kind of problem.

> 
> If the system is suffering an IRQ storm because device doesn't give up
> after the first few faults, then we should switch off the fault
> *reporting* for that device so that its faults get ignored (until it
> next actually sets up a DMA mapping, or something).

In such a case, yeah limiting messages is enough.

> 
> For the IOMMU code to reset individual devices, just because they still
> have an active DMA mapping even if they're not *doing* DMA, seems wrong.
> You'll even end up resetting devices just because they have an RMRR,
> won't you? (Although I wouldn't lose any sleep over that, I suppose. In
> fact it might be a *feature*... :)
 
Right, current code is resetting devices which *may* be doing DMA. The
ideal way is finding devices which are actually doing DMA and reset only
them but I don't know how we can do this, though I think current code
is sufficient.

Thanks,
Takao Indoh

