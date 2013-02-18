Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3BSAwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 19:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814Ab3BSAwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 19:52:33 -0500
Date: Mon, 18 Feb 2013 19:59:55 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Gleb Natapov <gleb@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [Bisected][-next-20130204+] [x86/kvm] udevd:[97]: segfault at
 ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
Message-ID: <20130218225955.GA6166@amt.cnet>
References: <1360715210.31472.20.camel@thor.lan>
 <511AE0A7.2000101@linux.intel.com>
 <20130213105129.GB9817@redhat.com>
 <1360756629.4803.5.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360756629.4803.5.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 06:57:09AM -0500, Peter Hurley wrote:
> On Wed, 2013-02-13 at 12:51 +0200, Gleb Natapov wrote:
> > On Tue, Feb 12, 2013 at 04:39:03PM -0800, H. Peter Anvin wrote:
> > > On 02/12/2013 04:26 PM, Peter Hurley wrote:
> > > > With -next-20130204+ in ubuntu 12.10 VM (so the 80x25 VGA
> > > > device/console):
> > > > 
> > > > [    0.666410] udevd[97]: starting version 175
> > > > [    0.674043] udevd[97]: udevd:[97]: segfault at ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
> > > > 
> > > > and boots to an initramfs prompt.
> > > > 
> > > > git bisect (log attached) blames:
> > > > 
> > > > commit 7b5c4a65cc27f017c170b025f8d6d75dabb11c6f
> > > > Merge: 3596f5b 949db15
> > > > Author: H. Peter Anvin <hpa@linux.intel.com>
> > > > Date:   Fri Jan 25 16:31:21 2013 -0800
> > > > 
> > > >     Merge tag 'v3.8-rc5' into x86/mm
> > > >     
> > > >     The __pa() fixup series that follows touches KVM code that is not
> > > >     present in the existing branch based on v3.7-rc5, so merge in the
> > > >     current upstream from Linus.
> > > >     
> > > >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > > > 
> > > > 
> > > > This only happens with the VGA device/console but that is the default
> > > > configuration for Ubuntu/KVM because it blacklists pretty much every fb
> > > > driver.
> > > > 
> > > 
> > > I am guessing this is another bad use of __pa()... need to look into that.

Can't find this commit on kvm.git or linux-2.6.git. Is it reproducible
there?

> > He is using 64bit guest and on those __pa() happens to be working. Is it
> > possible that slow_virt_to_phys() does not work as expected? Peter (the
> > bug reporter :)) can you run your guest kernel with loglevel=7 and
> > attach send me console output?
> 
> Attached.
> 
> BTW, this message happens on 'good' boots too:
> 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at /home/peter/src/kernels/next/arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall+0x22/0x60()
> [    0.000000] Hardware name: Bochs
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.8.0-next-20130204-xeon #20130204
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8105812f>] warn_slowpath_common+0x7f/0xc0
> [    0.000000]  [<ffffffff8105818a>] warn_slowpath_null+0x1a/0x20
> [    0.000000]  [<ffffffff81d20521>] pvclock_init_vsyscall+0x22/0x60
> [    0.000000]  [<ffffffff81d20480>] kvm_setup_vsyscall_timeinfo+0x74/0xd8
> [    0.000000]  [<ffffffff81d201d1>] kvm_guest_init+0xd0/0xe9
> [    0.000000]  [<ffffffff81d13f7c>] setup_arch+0xbee/0xcaf
> [    0.000000]  [<ffffffff816cbceb>] ? printk+0x61/0x63
> [    0.000000]  [<ffffffff81d0cbc3>] start_kernel+0xd3/0x3f0
> [    0.000000]  [<ffffffff81d0c5e4>] x86_64_start_reservations+0x2a/0x2c
> [    0.000000]  [<ffffffff81d0c6d7>] x86_64_start_kernel+0xf1/0x100
> [    0.000000] ---[ end trace b47bb564b2d6ec76 ]---
> 
> Regards,
> Peter Hurley

Sending a patch for this, thanks for the report.

