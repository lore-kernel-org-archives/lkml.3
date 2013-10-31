Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3JaGs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:48:27 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41532 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3JaGsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <5270BBD5.2080403@huawei.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
	<CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
	<20131015024452.GA31951@srcf.ucam.org>
	<20131016202123.GA17866@google.com>
	<CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
	<CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com>
	<CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
	<5270BBD5.2080403@huawei.com>
Date: Wed, 30 Oct 2013 23:48:24 -0700
X-Google-Sender-Auth: tKjR-KQ_m5sQrJthziKhtR4LmKg
Message-ID: <CAE9FiQVfE1f-sN2=4cd3Dg49ar7zOb6dy-Cet=ubhY2irobbbg@mail.gmail.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
From: Yinghai Lu <yinghai@kernel.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:57 AM, Yijing Wang <wangyijing@huawei.com> wrote:
>>>> Bisection points to 928bea964827d7824b548c1f8e06eccbbc4d0d7d .
>>>
>>> This is "PCI: Delay enabling bridges until they're needed" by Yinghai.
>>
>> that double disabling should be addressed by:
>>
>> https://lkml.org/lkml/2013/4/25/608
>>
>> [PATCH] PCI: Remove duplicate pci_disable_device for pcie port
>
> Hi Yinghai and Bjorn,
>    I found a related issue in the latest Bjorn/pci-next branch.
>
> Now if we remove the pcie port device in the system, there is a warning occured.
> It seems introduced after commit 928bea9 "PCI: Delay enabling bridges until they're needed".
>
> [ 2124.129478] ------------[ cut here ]------------
> [ 2124.129490] WARNING: CPU: 3 PID: 7 at drivers/pci/pci.c:1424 pci_disable_device+0x90/0xa0()
> [ 2124.129492] Device pcieport
> [ 2124.129492] disabling already-disabled device

yes. that is pcie port driver problem.

| 928bea delay bridge enabling, and it's pci_is_enabled checking will prevent
| pci bridge get enabled second time, so enable_cnt will be only 1. instead of
| 2. if we enable bridge at first and then pcie port driver.
