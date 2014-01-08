Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbaAHVb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:31:28 -0500
Received: from ext190.halfdog.net ([88.116.147.190]:52616 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaAHVbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:31:25 -0500
Message-ID: <52CDC316.4050503@halfdog.net>
Date: Wed, 08 Jan 2014 21:28:54 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24a1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
References: <52BF4A80.3010503@halfdog.net> <52BF8AEE.6020904@zytor.com> <52C089AC.4000401@halfdog.net> <52C0C9F4.50101@zytor.com> <52C196C3.1040300@halfdog.net> <52C31027.2030101@zytor.com> <20131231192106.GA22535@phenom.dumpdata.com> <52C347F0.8070902@zytor.com> <52CD022E.9040107@halfdog.net> <52CD8E10.3010204@zytor.com> <20140108193655.GD5098@pd.tnic>
In-Reply-To: <20140108193655.GD5098@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Borislav Petkov wrote:
> On Wed, Jan 08, 2014 at 09:42:40AM -0800, H. Peter Anvin wrote:
>> Adding Borislav.
>> 
>> Boris, do you happen to know of any erratum on AMD E-350 which
>> may be in play here?
> 
> Interesting. Well, nothing looks even remotely related from looking
> at the F14h rev guide here:
> 
> http://developer.amd.com/wordpress/media/2012/10/47534_14h_Mod_00h-0Fh_Rev_Guide.pdf
>
>  Btw, hd (if that is your real name :-)), can you post
> /proc/cpuinfo?

Of course (you can also find it in the Debian bug report [1]):

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 20
model		: 1
model name	: AMD E-350 Processor
stepping	: 0
microcode	: 0x5000028
cpu MHz		: 1596.563
cache size	: 512 KB
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm constant_tsc nonstop_tsc extd_apicid aperfmperf pni
monitor ssse3 cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy
abm sse4a misalignsse 3dnowprefetch ibs skinit wdt arat hw_pstate npt
lbrv svm_lock nrip_save pausefilter
bogomips	: 3193.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

> I think I might have a E-350 here too and I could try to reproduce.
> Btw, how exactly do you trigger?
> 
> You run
> FpuStateTaskSwitchShmemXattrHandlersOverwriteWithNullPage.c first
> to modify shmem_xattr_handlers and then 
> ManipulatedXattrHandlerForPrivEscalation.c? You need a 32-bit
> kernel and userspace, right? Anything else?

Yes: I used the standard Debian Sid 468 kernel (32bit), the first tool
might just trigger the OOPS to early, this seems to be harmless to the
kernel, so one can invoke it until the handler pointer was modified.
Since I hardcoded the Debian kernel addresses (copied from
System.map), this is very unlikly to give you root on another kernel,
but the math OOPS should be reproducible.


Does this sound fishy (from [2])?

"There is no need to save any active fpu state to the task structure
memory if the task is dead. Just drop the state instead."

My rogue process might interfere with that: change control registers,
cause exception and then exit quickly


Or could it be invalid CPU-features detection, perhaps related to [3]?

The math-restore/__do_switch combination occurred already in older bug
reports, e.g. [4] (very close), [5] (similar, poor info). )))OOPS "EIP
is at math_state_restore"((( seems to be suitable search expression.


[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=733551
[2] http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/02182.html
[3] http://lkml.indiana.edu/hypermail/linux/kernel/0905.2/02599.html
[4] https://lkml.org/lkml/2008/6/16/146
[5] http://bugzilla.xensource.com/bugzilla/show_bug.cgi?id=1536

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLNww0ACgkQxFmThv7tq+4LngCeI/ZVFtzEy9RDpVP9Jk46tzGs
9h8Ani/YO9FsUOpcKxiXovJkTPiKuI4e
=InkM
-----END PGP SIGNATURE-----
