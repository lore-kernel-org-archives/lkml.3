Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaCNQLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:11:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:52497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbaCNQL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:11:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,655,1389772800"; 
   d="scan'208";a="492043379"
Message-ID: <53232A06.9010201@intel.com>
Date: Fri, 14 Mar 2014 17:10:46 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
CC: Lv Zheng <lv.zheng@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: ACPICA 20140214 auto-serialize weirds my machine...
References: <14866.1394813101@turing-police.cc.vt.edu>
In-Reply-To: <14866.1394813101@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/2014 5:05 PM, Valdis Kletnieks wrote:
> Surprisingly enough, this hasn't seemed to have bitten many Linux people yet,
> Google only finds a BSD thread (where the same ACPICA code is in use):
>
> http://comments.gmane.org/gmane.os.dragonfly-bsd.user/1817
>
> I found this, but haven't tried it yet:
>
> commit 5f1cb4a92e4c4aabd139ff9ca1e11c0e2db2ac59
> Author: Lv Zheng <lv.zheng@intel.com>
> Date:   Wed Feb 26 10:32:01 2014 +0800
>
>      ACPICA: Remove global option to serialize all control methods.
>
>      With the addition of the auto-serialization feature, this option
>      is obsolete and is completely removed. Lv Zheng.
>
>      This patch also updates acpi_serialize kernel parameter using the
>      new auto-serialization feature - acpi_gbl_auto_serialize_methods.
>
> This looks like a user nightmare waiting to happen, because:
>
> -   	acpi_serialize	[HW,ACPI] force serialization of AML methods
> +	acpi_serialize=	[HW,ACPI] configure auto-serialization of AML methods
>
> Re-using a kernel parameter name with different semantics is just asking for trouble.
>
> I get this in my dmesg, and then I end up with all sorts of ACPI-related
> weirdness - everything from 4 or 5 temperature sensors evaporating to it
> claiming that my laptop doesn't have a battery bay (it may also be related to
> an issue I'm seeing with multiple graphics monitors as well, but I haven't
> verified that yet).
>
> We're going to need a better way to deal with this before it gets to
> mainline....

We have a commit that removes this command line argument already.

But those messages:

>
> [    0.119344] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.135282] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
> [    0.135288] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.135298] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.135307] ACPI Error: Method parse/execution failed [\EISC] (Node ffff88012d02d560), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.135320] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff88012d02d470), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.135328] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff88012d02d5d8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.135336] ACPI Error: Method parse/execution failed [\ECG5] (Node ffff88012d02d740), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.135343] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EINI] (Node ffff88012d02db00), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.135351] ACPI Error: Method parse/execution failed [\EV3_] (Node ffff88012d0314c0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.135359] ACPI Error: Method parse/execution failed [\_SB_.PCI0._INI] (Node ffff88012d026920), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.135574] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.136283] ACPI: SSDT 0x00000000CE789598 000523 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
> [    0.138312] ACPI: Dynamic OEM Table Load:
> [    0.138316] ACPI: SSDT 0x0000000000000000 000523 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
> [    0.141483] ACPI: SSDT 0x00000000CE78AA98 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
> [    0.143683] ACPI: Dynamic OEM Table Load:
> [    0.143687] ACPI: SSDT 0x0000000000000000 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
> [    0.146215] ACPI: SSDT 0x00000000CE790C18 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
> [    0.148279] ACPI: Dynamic OEM Table Load:
> [    0.148282] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
> [    0.152678] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
> [    0.152684] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.152693] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.152702] ACPI Error: Method parse/execution failed [\EISC] (Node ffff88012d02d560), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.152714] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff88012d02d470), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.152722] ACPI Error: Method parse/execution failed [\ECBT] (Node ffff88012d02d588), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.152730] ACPI Error: Method parse/execution failed [\ECG3] (Node ffff88012d02d6c8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.152737] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECIN] (Node ffff88012d02d3d0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.152745] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV._REG] (Node ffff88012d02d3f8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.152818] ACPI: Interpreter enabled
> [    0.152828] ACPI: (supports S0)
> [    0.152830] ACPI: Using IOAPIC for interrupt routing
> [    0.152883] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.156479] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
> [    0.156485] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.156494] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.156504] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.UAR1._STA] (Node ffff88012d02fb28), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.156666] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
> [    0.156671] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.156680] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.156689] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.LPTE.CLPS] (Node ffff88012d02fcb8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.156702] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.LPTE._STA] (Node ffff88012d02fce0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.162229] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
> [    0.162234] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.162244] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
> [    0.162254] ACPI Error: Method parse/execution failed [\EISC] (Node ffff88012d02d560), AE_AML_MUTEX_ORDER (20140214/psparse-536)
>
> (you get the idea.  I get a total of 172 'ACPI Error:' messages before I get to
> a single-user prompt)

shouldn't be there regardless.

I'm going to look at this issue later today.

Rafael

