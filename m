Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaAHHsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:48:40 -0500
Received: from ext190.halfdog.net ([88.116.147.190]:52607 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbaAHHse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:48:34 -0500
Message-ID: <52CD022E.9040107@halfdog.net>
Date: Wed, 08 Jan 2014 07:45:50 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24a1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
References: <52BF4A80.3010503@halfdog.net> <52BF8AEE.6020904@zytor.com> <52C089AC.4000401@halfdog.net> <52C0C9F4.50101@zytor.com> <52C196C3.1040300@halfdog.net> <52C31027.2030101@zytor.com> <20131231192106.GA22535@phenom.dumpdata.com> <52C347F0.8070902@zytor.com>
In-Reply-To: <52C347F0.8070902@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Update to the issue:

* Although first observed with virtual-8086 mode, the bug is not
specific to virtual-8086 mode, it can be triggered with normal x86
userspace code also, even with better reproducibility.

* Ben Hutchings looked at the Debian bug report [1], he failed to
reproduce on his hardware, so it might be specific to some CPU models
(currently my AMD E-350 is only machine known to be affected).

* When deactivating mmap_min_addr, the NULL-dereferences during
task-switch is exploitable, works both on native hardware and within
VirtualBox. See [2] for POC to gain root privileges.

* It seems, that when changing the FPU control word with "fstcw" just
before exit of the process, then another process could suffer when
doing __do_switch, probably related to the xsave instruction and a x86
processor bug workaround, see "noxsave" switch [3]: [BUGS=X86]
Disables x86 extended register state save and restore using xsave. The
kernel will fallback to enabling legacy floating-point and sse state.

hd

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=733551
[2]
http://www.halfdog.net/Security/2013/Vm86SyscallTaskSwitchKernelPanic/
[3] https://www.kernel.org/doc/Documentation/kernel-parameters.txt

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLNAjEACgkQxFmThv7tq+44FACfeDHQHK71+7tZawm9Ftjw7Hvp
j04AmwY04UwG9clERS3e1HisM2swbo1i
=KoQL
-----END PGP SIGNATURE-----
