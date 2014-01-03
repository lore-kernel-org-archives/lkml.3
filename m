Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaACXLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 18:11:36 -0500
Received: from ext190.halfdog.net ([88.116.147.190]:52594 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaACXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:11:35 -0500
Message-ID: <52C742CD.1080500@halfdog.net>
Date: Fri, 03 Jan 2014 23:07:57 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24a1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sanitize FPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
References: <52BF4A80.3010503@halfdog.net> <52BF8AEE.6020904@zytor.com> <52C089AC.4000401@halfdog.net> <52C0C9F4.50101@zytor.com> <52C196C3.1040300@halfdog.net> <52C31027.2030101@zytor.com> <20131231192106.GA22535@phenom.dumpdata.com> <52C347F0.8070902@zytor.com>
In-Reply-To: <52C347F0.8070902@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> On 12/31/2013 11:21 AM, Konrad Rzeszutek Wilk wrote:
>> 
>> So, I am wondering if this is related to " x86/fpu: CR0.TS should
>> be set before trap into PV guest's #NM exception handle" which
>> does have a similar pattern - you do enough of the task switches
>> and the FPU is screwed.
>> 
>> See
>> http://mid.gmane.org/1383720072-6242-1-git-send-email-gaoyang.zyh@taobao.com
>>
>>
>> 
(I thought there was a thread about this on LKML too but I can't
>> find it).
> 
> That would be a bug in Xen, so I guess you're surmising a similar
> bug in VirtualBox?

Not sure on that yet, but the whole thing is getting even more
funnier, the longer I can play with it. Here is some more information
from my latest tests:

* Although first observed with virtual-8086 mode, the bug is not
specific to virtual-8086 mode, it can be triggered with normal x86
userspace code also, even with better reproducibility.

* It seems, that when changing the FPU control word with "fstcw" just
before exit of the process, then another process could suffer when
doing __do_switch

* By having two rogue processes writing data to each other via a
socket, time and code-position of OOPS can be influenced.

* When deactivating mmap_min_addr, the NULL-dereferences during
task-switch are exploitable, but I did not get full ring-0 code
execution yet, putting EIP to the NULL-seg seem to have failed,
perhaps wrong RPL? Hoping to fix that during next days.

You can find the new improved test code at [1].

hd

[1]
http://www.halfdog.net/Security/2013/Vm86SyscallTaskSwitchKernelPanic/FpuStateTaskSwitchOops.c


- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLHQrwACgkQxFmThv7tq+4C+wCfZ0a0LhaJqI7DW78ZFGbnzIyu
6H8AnROrUklhvdbAGV5+7/ELEzPikU7T
=jKjH
-----END PGP SIGNATURE-----
