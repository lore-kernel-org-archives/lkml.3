Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaCNQGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:06:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41048 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaCNQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:06:08 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: ACPICA 20140214 auto-serialize weirds my machine...
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1394813101_1735P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2014 12:05:01 -0400
Message-ID: <14866.1394813101@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1394813101_1735P
Content-Type: text/plain; charset=us-ascii

Surprisingly enough, this hasn't seemed to have bitten many Linux people yet,
Google only finds a BSD thread (where the same ACPICA code is in use):

http://comments.gmane.org/gmane.os.dragonfly-bsd.user/1817

I found this, but haven't tried it yet:

commit 5f1cb4a92e4c4aabd139ff9ca1e11c0e2db2ac59
Author: Lv Zheng <lv.zheng@intel.com>
Date:   Wed Feb 26 10:32:01 2014 +0800

    ACPICA: Remove global option to serialize all control methods.

    With the addition of the auto-serialization feature, this option
    is obsolete and is completely removed. Lv Zheng.

    This patch also updates acpi_serialize kernel parameter using the
    new auto-serialization feature - acpi_gbl_auto_serialize_methods.

This looks like a user nightmare waiting to happen, because:

-   	acpi_serialize	[HW,ACPI] force serialization of AML methods
+	acpi_serialize=	[HW,ACPI] configure auto-serialization of AML methods

Re-using a kernel parameter name with different semantics is just asking for trouble.

I get this in my dmesg, and then I end up with all sorts of ACPI-related
weirdness - everything from 4 or 5 temperature sensors evaporating to it
claiming that my laptop doesn't have a battery bay (it may also be related to
an issue I'm seeing with multiple graphics monitors as well, but I haven't
verified that yet).

We're going to need a better way to deal with this before it gets to
mainline....

[    0.119344] ACPI: Executed 1 blocks of module-level executable AML code
[    0.135282] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
[    0.135288] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.135298] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.135307] ACPI Error: Method parse/execution failed [\EISC] (Node ffff88012d02d560), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.135320] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff88012d02d470), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.135328] ACPI Error: Method parse/execution failed [\ECRB] (Node ffff88012d02d5d8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.135336] ACPI Error: Method parse/execution failed [\ECG5] (Node ffff88012d02d740), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.135343] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EINI] (Node ffff88012d02db00), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.135351] ACPI Error: Method parse/execution failed [\EV3_] (Node ffff88012d0314c0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.135359] ACPI Error: Method parse/execution failed [\_SB_.PCI0._INI] (Node ffff88012d026920), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.135574] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.136283] ACPI: SSDT 0x00000000CE789598 000523 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.138312] ACPI: Dynamic OEM Table Load:
[    0.138316] ACPI: SSDT 0x0000000000000000 000523 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.141483] ACPI: SSDT 0x00000000CE78AA98 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.143683] ACPI: Dynamic OEM Table Load:
[    0.143687] ACPI: SSDT 0x0000000000000000 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.146215] ACPI: SSDT 0x00000000CE790C18 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.148279] ACPI: Dynamic OEM Table Load:
[    0.148282] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.152678] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
[    0.152684] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.152693] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.152702] ACPI Error: Method parse/execution failed [\EISC] (Node ffff88012d02d560), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.152714] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff88012d02d470), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.152722] ACPI Error: Method parse/execution failed [\ECBT] (Node ffff88012d02d588), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.152730] ACPI Error: Method parse/execution failed [\ECG3] (Node ffff88012d02d6c8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.152737] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECIN] (Node ffff88012d02d3d0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.152745] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV._REG] (Node ffff88012d02d3f8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.152818] ACPI: Interpreter enabled
[    0.152828] ACPI: (supports S0)
[    0.152830] ACPI: Using IOAPIC for interrupt routing
[    0.152883] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.156479] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
[    0.156485] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.156494] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.156504] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.UAR1._STA] (Node ffff88012d02fb28), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.156666] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
[    0.156671] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.156680] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.156689] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.LPTE.CLPS] (Node ffff88012d02fcb8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.156702] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.LPTE._STA] (Node ffff88012d02fce0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.162229] ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is too large (1) (20140214/dsmethod-362)
[    0.162234] ACPI Error: Method parse/execution failed [\SMBF] (Node ffff88012d026ec0), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.162244] ACPI Error: Method parse/execution failed [\GENS] (Node ffff88012d026e70), AE_AML_MUTEX_ORDER (20140214/psparse-536)
[    0.162254] ACPI Error: Method parse/execution failed [\EISC] (Node ffff88012d02d560), AE_AML_MUTEX_ORDER (20140214/psparse-536)

(you get the idea.  I get a total of 172 'ACPI Error:' messages before I get to
a single-user prompt)

--==_Exmh_1394813101_1735P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUyMorQdmEQWDXROgAQLLkQ//Ysr9UDcUBpgDqFRmO+bj0lExeHJJ4kZK
neHeysDcGUijBB7gHwK+miuo7Ld/1dUTiGZMf6WikSEFJsz3y7fieB5Wkl74RLhB
EXlk4bKuEcvBo5Xo90aBxbg1AqUUq+r6zwrBSAp9sskGyf9mS6VazjVhQ2SRHXJz
IhI+6HsrRzwjvAfyT4kC2JD0v5FsVFixnXDZp8YnhpNlgLft++2Vh55GwyTHALCK
jE0DaEMIs1ZQ29jiosiTEpu/IJDjl/ZubFPzEa113EyNRauhDA5UQFJRJZ3W61Mp
j4TvT9BfKqXePU79B6w8O7XfoCSGAywRPHO7fUq+gTf/68yJHsWdGXcO+XeeEVcv
5SXINGkKK//8Rl0Pv8V5YQ/JghGAezDuDWT2KLIZh4BF6lC/RHgsuuCA5yCyn5ZC
IVBXJxpXN5ewnrWyiKwHzakvyTh8ixOB/zSUzkWdI+F1StfRRh4JJgc2ggjMBeHi
OV+WnOQ4M0ZOP017W6YkJ9rqp+E3tPCLH+X6mC7TiWqS7gYt6aHfIHBEp5a3vZHc
I4ZaVYqgtWt0LXeHMxkcmhatEcU47YlOUvRqq2GBg1g9xDbk0KOP7SDQ7Ve3xg0O
IESbktkXJ+gFgfW1TXuhS9exFRPMuipfjbW2Xo+rqkncLXb/S7KlIrlAihFI1bxN
Hk1WcQbGXB4=
=ntYI
-----END PGP SIGNATURE-----

--==_Exmh_1394813101_1735P--
