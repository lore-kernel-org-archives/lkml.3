Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3CEXqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:46:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42356 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab3CEXqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:46:46 -0500
Message-ID: <513683DC.3070405@linux.vnet.ibm.com>
Date: Tue, 05 Mar 2013 15:46:36 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, bp@alien8.de,
        linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp> <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp> <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp> <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp> <51366E6F.1050409@linux.intel.com>
In-Reply-To: <51366E6F.1050409@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030523-7182-0000-0000-000005A82509
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if it's related by 3.9-rc1 gets in to a reboot loop for me.  I
assume it's triple-faulting.  The last line on the console I see is:

[    0.085702] SMP alternatives: lockdep: fixing up alternatives
[    0.086859] smpboot: Booting Node   0, Processors [    0.086859]
smpboot: Booting Node   0, Processors  #1 OK
 #1 OK

I bisected it down to the neighborhood of c47f39e.  After that, I get
some compile errors:

> arch/x86/built-in.o: In function `generic_load_microcode':
> microcode_intel.c:(.text+0x28195): undefined reference to `microcode_sanity_check'
> microcode_intel.c:(.text+0x281ab): undefined reference to `get_matching_microcode'

Turning off CONFIG_MICROCODE:

-CONFIG_MICROCODE=y
-CONFIG_MICROCODE_INTEL=y
-# CONFIG_MICROCODE_AMD is not set
-CONFIG_MICROCODE_OLD_INTERFACE=y
-CONFIG_MICROCODE_INTEL_LIB=y
-CONFIG_MICROCODE_INTEL_EARLY=y
-CONFIG_MICROCODE_EARLY=y
+# CONFIG_MICROCODE is not set

lets it boot again and fixes those compile errors.  This is with this
config:

	http://i-love.sakura.ne.jp/tmp/config-3.9-rc1

running under a kvm guest:

qemu-system-x86_64 -append 'earlyprintk=ttyS0,115200,keep
console=ttyS0,115200 nmi_watchdog=0 root=/dev/sda1 bootmem_debug'
-kernel vmlinuz -usbdevice tablet  -vnc :1 -net user -net
nic,model=e1000  -hda sarge-amd64-runme-1G.img -m 10240 -smp 2

