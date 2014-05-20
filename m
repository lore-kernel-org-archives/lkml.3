Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaETEWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 00:22:37 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38567 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaETEWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 00:22:34 -0400
MIME-Version: 1.0
In-Reply-To: <4292818.mI6kZGgTzd@wuerfel>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
	<CA+sq2Ccok5wtKjCZUkBhhj3WsiqFAoMgHK7LY210aBtMku+8SA@mail.gmail.com>
	<4292818.mI6kZGgTzd@wuerfel>
Date: Tue, 20 May 2014 09:52:33 +0530
Message-ID: <CA+sq2Ce+8YB+02B7zhxTXwropZXv9spy-w=AJ8YXCP69kr-_1A@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] Add support for PCI in AArch64
From: Sunil Kovvuri <sunil.kovvuri@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Scott Lurndal <kdb@lurndal.org>,
        "yu.zhao@intel.com" <yu.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 6:31 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 16 May 2014 16:03:04 Sunil Kovvuri wrote:
>> When the SR-IOV capable device's driver tries to enable sriov
>> (pci_enable_sriov()) it fails to create/add PCI device for each
>> virtual function reporting  "not enough MMIO resources for SR-IOV".
>
> I assume you have checked that there is indeed enough MMIO space
> available, right?
>
Yes, i have checked for enough MMIO space multiple times.

>> In sriov_enable() (drivers/pci/iov.c)
>>
>>  296        for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
>>  297                 bars |= (1 << (i + PCI_IOV_RESOURCES));
>>  298                 res = dev->resource + PCI_IOV_RESOURCES + i;
>>  299                 if (res->parent)
>>  300                         nres++;
>>  301         }
>>  302         if (nres != iov->nres) {
>>  303                 dev_err(&dev->dev, "not enough MMIO resources for
>>  SR-IOV\n");
>>  304                 return -ENOMEM;
>>  305         }
>>
>> Here its checking if physical function's IOV resource has a parent or not.
>> Which is pci-pci bridge in this case. Otherwise it doesn't consider
>> that resource.
>>
>> Added below api to your patch.
>> This will try to claim a resource while creating a PCI device which
>> inturn sets 'res->parent'.
>
> This looks like the wrong approach. The PCI host controller should
> really have been registered with the root 'iomem_resource' during
> the probe of the host controller.
>
>         Arnd
I didn't get this, if a SR-IOV device is connected to a PCI-PCI bridge
and inturn bridge connected to root port. Then the parent bus is not root,
but the bridge.  The issue is either hierarchy should not be checked for
SR-IOV resources or someone should set the hierarchy (i.e parent resources).

Regards,
Sunil.
