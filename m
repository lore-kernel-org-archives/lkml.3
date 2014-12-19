Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaLSWSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:18:13 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:52962 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaLSWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:18:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXj-vX8TE-8Es83FmJAKDKD_dMNbQkmsaNPyy_nVEag8w@mail.gmail.com>
References: <CAErSpo6UvY10MNidAOFf4Fptv+wL-NsX6JMaU8OvSP6ywWEebQ@mail.gmail.com>
 <CAErSpo63uZeo1feoPjjXpdH43nsbcWh63kpBmxCnckPd0t9yrg@mail.gmail.com>
 <CAE9FiQWV-rKdvSeV-ivME-64QtzCX2Te5DfOVtzr0an=6eOCMA@mail.gmail.com>
 <20141204173411.GA5949@google.com> <CAE9FiQVyBmo+XwDgO97wwe+6TN4+q_cvnBLCuhTM8Fu_e_V5RQ@mail.gmail.com>
 <1417777177.4741.69.camel@kernel.crashing.org> <20141208004735.GA15508@shangw>
 <CAErSpo69c6jXOp+nw2sTSU4vgqGufUQNUEGK4_2+6p-qpyE0vQ@mail.gmail.com>
 <1418074683.13358.1.camel@kernel.crashing.org> <CAErSpo7pMAL5i2aPGV3u5F178bHeQTtjASckKs9NaUbEGaxv3Q@mail.gmail.com>
 <20141208233855.GA15713@shangw> <CAE9FiQXj-vX8TE-8Es83FmJAKDKD_dMNbQkmsaNPyy_nVEag8w@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 19 Dec 2014 15:17:50 -0700
Message-ID: <CAErSpo5OAw6WXRZ3q1JtjMBWk45C-k_s96qm7j+kK0CCNdWToQ@mail.gmail.com>
Subject: Re: Regression: bug 85491: radeon 0000:01:00.0: Fatal error during
 GPU init
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alexey Voronkov <zermond@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexdeucher@gmail.com>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Richard Yang <weiyang@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-kernel for visibility]

For context, this is about a regression caused by 5b28541552ef ("PCI:
Restrict 64-bit prefetchable bridge windows to 64-bit resources"),
which appeared in v3.16.  The bugzilla is at
https://bugzilla.kernel.org/show_bug.cgi?id=85491

The problem is that BIOS programmed an invalid Root Port window
leading to the Radeon device.  The window contains the Radeon device,
so the configuration actually *works* fine, but the window is invalid
because it either overlaps system RAM or starts below the upstream
host bridge window, so Linux discards it:

Zermond's system:
  acpi PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff] (ignored)
  pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
  pci 0000:00:01.0:   bridge window [mem 0xbdf00000-0xddefffff 64bit
pref]  # invalid Root Port window
  pci 0000:00:01.0: can't claim BAR 15 [mem 0xbdf00000-0xddefffff
64bit pref]: address conflict with System RAM [mem
0x00100000-0xbff9ffff]
  pci 0000:01:00.0: can't claim BAR 0 [mem 0xc0000000-0xcfffffff
pref]: no compatible bridge window  # Radeon

Marek's system:
  pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]   (from _CRS)
  pci 0000:00:01.0:   bridge window [mem 0xbdf00000-0xddefffff 64bit
pref]  # invalid Root Port window
  pci 0000:00:01.0: can't claim BAR 15 [mem 0xbdf00000-0xddefffff
64bit pref]: no compatible bridge window
  pci 0000:01:00.0: can't claim BAR 0 [mem 0xc0000000-0xcfffffff
pref]: no compatible bridge window  # Radeon

The Root Port window had the same problem before 5b28541552ef, of
course, since BIOS set it up.  But before 5b28541552ef, Linux assigned
a valid window big enough for the Radeon:

  pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff pref]

After 5b28541552ef, we won't put a 64-bit window below 4GB, so we
assign space above 4GB:

  pci 0000:00:01.0:   bridge window [mem 0x140000000-0x1401fffff 64bit pref]

which is not usable by Radeon, since it only has a 32-bit BAR.

On Mon, Dec 8, 2014 at 5:21 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Dec 8, 2014 at 3:38 PM, Gavin Shan <gwshan@linux.vnet.ibm.com> wrote:
>> On Mon, Dec 08, 2014 at 02:46:00PM -0700, Bjorn Helgaas wrote:
>>>Yeah, I didn't word that very clearly.  I meant that after
>>>5b28541552ef, that 64-bit window is wasted unless there's a 64-bit BAR
>>>below it; we can't even place the window below 4GB and use it for
>>>32-bit prefetchable BARs.
>>>
>>
>> Yes, I agree. It's why I suggested to return error from pbus_size_mem()
>> to indicate the case: 64-bits prefetchable window isn't used and it's
>> still available to be used by child 32-bits prefetchable BARs. Please
>> take a look on the attached draft patch, which helps to explain the idea
>> only.
>
> That would not help. The 00:01.0 on Zermond's system support hotplug. so mem
> pref will be used for 64bit pref.

I don't think it is an improvement to restrict use of the 64bit pref
window to a hypothetical future 64-bit capable device.  The
configuration done by BIOS was optimal for the hardware already in the
machine -- the prefetchable BAR is in a prefetchable window.  I don't
think we should change that configuration just because there's a
possibility of a different device in the future.

Bjorn
