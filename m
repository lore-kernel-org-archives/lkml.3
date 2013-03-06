Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3CFAjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:39:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:44789 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab3CFAjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:39:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="295445867"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [3.9-rc1 x86] Bug in ioremap code?
Thread-Topic: [3.9-rc1 x86] Bug in ioremap code?
Thread-Index: AQHOGf1OIHQkEDynbE+CmdhsV+IBtZiX0Ohw
Date: Wed, 6 Mar 2013 00:39:20 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220528C0896@ORSMSX105.amr.corp.intel.com>
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp>
 <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp>
 <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp>
 <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp>
 <20130305180650.GD4914@pd.tnic>
 <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp>
 <51366E6F.1050409@linux.intel.com> <513683DC.3070405@linux.vnet.ibm.com>
 <51368692.4090204@linux.intel.com>
In-Reply-To: <51368692.4090204@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@linux.intel.com]
> Sent: Tuesday, March 05, 2013 3:58 PM
> To: Dave Hansen
> Cc: Tetsuo Handa; bp@alien8.de; linux-kernel@vger.kernel.org; Yu,
> Fenghua
> Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
> 
> Fenghua,
> 
> Could you look at this thread and see if you can see what the problem
> is?
> 
> 	-hpa
> 
> On 03/05/2013 03:46 PM, Dave Hansen wrote:
> > Not sure if it's related by 3.9-rc1 gets in to a reboot loop for me.
> I
> > assume it's triple-faulting.  The last line on the console I see is:
> >
> > [    0.085702] SMP alternatives: lockdep: fixing up alternatives
> > [    0.086859] smpboot: Booting Node   0, Processors [    0.086859]
> > smpboot: Booting Node   0, Processors  #1 OK
> >  #1 OK
> >
> > I bisected it down to the neighborhood of c47f39e.  After that, I get
> > some compile errors:
> >
> >> arch/x86/built-in.o: In function `generic_load_microcode':
> >> microcode_intel.c:(.text+0x28195): undefined reference to
> `microcode_sanity_check'
> >> microcode_intel.c:(.text+0x281ab): undefined reference to
> `get_matching_microcode'

The bisect warnings are because the early load microcode patchset doesn't separate patches right for bisect.

> >
> > Turning off CONFIG_MICROCODE:

Turning off CONFIG_MICROCODE should not compile the microcode code including early loading microcode code. With this configuration, microcode code should not be in debugging scope.

> >
> > -CONFIG_MICROCODE=y
> > -CONFIG_MICROCODE_INTEL=y
> > -# CONFIG_MICROCODE_AMD is not set
> > -CONFIG_MICROCODE_OLD_INTERFACE=y
> > -CONFIG_MICROCODE_INTEL_LIB=y
> > -CONFIG_MICROCODE_INTEL_EARLY=y
> > -CONFIG_MICROCODE_EARLY=y
> > +# CONFIG_MICROCODE is not set
> >
> > lets it boot again and fixes those compile errors.  This is with this
> > config:
> >
> > 	http://i-love.sakura.ne.jp/tmp/config-3.9-rc1
> >
> > running under a kvm guest:
> >
> > qemu-system-x86_64 -append 'earlyprintk=ttyS0,115200,keep
> > console=ttyS0,115200 nmi_watchdog=0 root=/dev/sda1 bootmem_debug'
> > -kernel vmlinuz -usbdevice tablet  -vnc :1 -net user -net
> > nic,model=e1000  -hda sarge-amd64-runme-1G.img -m 10240 -smp 2
> >


