Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaIYPt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:49:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaIYPtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:49:24 -0400
Message-ID: <54243978.3030501@canonical.com>
Date: Thu, 25 Sep 2014 11:49:12 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit
 mmio
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>	<1386546869-31900-3-git-send-email-yinghai@kernel.org>	<CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>	<CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>	<CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>	<CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>	<52A8BAC5.70006@canonical.com>	<CAE9FiQV8mfF6SMTbZN5H+DmyuM0663wQyoKYJDa7MiBR4i7XQg@mail.gmail.com>	<52D01D82.5070202@canonical.com>	<CAE9FiQUD0XvPJNFNMoqX6J67TKuGcj+pSbj+iPUf=fvC-4UXOQ@mail.gmail.com>	<54189BCE.2010206@canonical.com> <CAE9FiQX1pfciTcuF3_eggQLCn=LvTSLTT0UZxTb+z_RaLHwgJQ@mail.gmail.com>
In-Reply-To: <CAE9FiQX1pfciTcuF3_eggQLCn=LvTSLTT0UZxTb+z_RaLHwgJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 06:27 PM, Yinghai Lu wrote:
> On Tue, Sep 16, 2014 at 1:21 PM, Joseph Salisbury
> <joseph.salisbury@canonical.com> wrote:
>> A new bug[0] was opened due to enabling PCI_REALLOC_ENABLE_AUTO, which
>> is similar to the original bug[1] we discussed.
>>
>> Just wondering if there have been any additional ideas on realloc since
>> this was last discussed?
>>
>> [0] http://pad.lv/1363313
>> [1] http://pad.lv/1245938
> This one looks different, that LSI card support SRIOV, but BIOS does not
> allocate resource to SRIOV bar.
> We release old resource and ...reallocate resource to them with two retries.
>
> [    0.321983] pci_bus 0000:00: max bus depth: 1 pci_try_num: 2
> [    0.322010] pci 0000:00:03.0: BAR 15: assigned [mem
> 0xef800000-0xef8fffff pref]
> [    0.322025] pci 0000:01:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
> [    0.322033] pci 0000:01:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
> [    0.322040] pci 0000:01:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
> [    0.322042] pci 0000:01:00.0: BAR 6: assigned [mem
> 0xef800000-0xef87ffff pref]
> [    0.322051] pci 0000:01:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
> [    0.322053] pci 0000:01:00.0: BAR 9: can't assign mem (size 0x400000)
> [    0.322061] pci 0000:01:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
> [    0.322063] pci 0000:01:00.0: BAR 7: assigned [mem
> 0xfbd00000-0xfbd3ffff 64bit]
> [    0.322070] pci 0000:00:03.0: PCI bridge to [bus 01]
> [    0.322073] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
> [    0.322077] pci 0000:00:03.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
> [    0.322080] pci 0000:00:03.0:   bridge window [mem
> 0xef800000-0xef8fffff pref]
> [    0.322142] pci_bus 0000:00: No. 2 try to assign unassigned res
> [    0.322143] release child resource [mem 0xfbd00000-0xfbd3ffff 64bit]
> [    0.322144] release child resource [mem 0xfbd80000-0xfbdbffff 64bit]
> [    0.322145] release child resource [mem 0xfbdfc000-0xfbdfffff 64bit]
> [    0.322147] pci 0000:00:03.0: resource 14 [mem
> 0xfbd00000-0xfbdfffff] released
> [    0.322148] pci 0000:00:03.0: PCI bridge to [bus 01]
> [    0.322156] pci 0000:00:03.0: bridge window [mem
> 0x00100000-0x001fffff] to [bus 01] add_size 500000
> [    0.322174] pci 0000:00:03.0: res[14]=[mem 0x00100000-0x001fffff]
> get_res_add_size add_size 500000
> [    0.322176] pci 0000:00:03.0: BAR 14: assigned [mem 0xefb00000-0xf00fffff]
> [    0.322185] pci 0000:01:00.0: reg 0x174: [mem 0xfbd00000-0xfbd03fff 64bit]
> [    0.322192] pci 0000:01:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
> [    0.322194] pci 0000:01:00.0: res[9]=[mem
> 0x00000000-0xffffffffffffffff 64bit] get_res_add_size add_size 400000
> [    0.322196] pci 0000:01:00.0: res[7]=[mem
> 0x00000000-0xffffffffffffffff 64bit] get_res_add_size add_size 40000
> [    0.322198] pci 0000:01:00.0: BAR 3: assigned [mem
> 0xefb00000-0xefb3ffff 64bit]
> [    0.322211] pci 0000:01:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
> [    0.322212] pci 0000:01:00.0: BAR 9: assigned [mem
> 0xefb40000-0xeff3ffff 64bit]
> [    0.322219] pci 0000:01:00.0: BAR 1: assigned [mem
> 0xeff40000-0xeff43fff 64bit]
> [    0.322232] pci 0000:01:00.0: reg 0x174: [mem 0xfbd00000-0xfbd03fff 64bit]
> [    0.322234] pci 0000:01:00.0: BAR 7: assigned [mem
> 0xeff44000-0xeff83fff 64bit]
> [    0.322241] pci 0000:00:03.0: PCI bridge to [bus 01]
> [    0.322244] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
> [    0.322248] pci 0000:00:03.0:   bridge window [mem 0xefb00000-0xf00fffff]
> [    0.322251] pci 0000:00:03.0:   bridge window [mem
> 0xef800000-0xef8fffff 64bit pref]
>
> So the resource realloc do work as expected. but LSI firmware has some
> problem again?
>
> We may need to add command after the reset the bridge resource.
>
> Can you get bootlog with "pci=earlydump"?
>
> Thanks
>
> Yinghai
Hi Yinghai,

The user collected earlydump data, which can be found here:
https://launchpadlibrarian.net/185141163/dmesg-pci%3Dearlydump
