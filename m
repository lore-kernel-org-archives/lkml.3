Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaHRPCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbaHRPCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:02:07 -0400
Date: Mon, 18 Aug 2014 11:02:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Antw: Re: Some problems with HP DL380 G8 BIOS and SLES11 SP3
Message-ID: <20140818150201.GO49576@redhat.com>
References: <53EB9EC9020000A100016A4D@gwsmtp1.uni-regensburg.de>
 <20140814174658.GV49576@redhat.com>
 <53F1B57C020000A100016AD8@gwsmtp1.uni-regensburg.de>
 <20140818124404.GL49576@redhat.com>
 <53F22030020000A100016B05@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F22030020000A100016B05@gwsmtp1.uni-regensburg.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 03:48:00PM +0200, Ulrich Windl wrote:
> >>> Don Zickus <dzickus@redhat.com> schrieb am 18.08.2014 um 14:44 in Nachricht
> <20140818124404.GL49576@redhat.com>:
> > On Mon, Aug 18, 2014 at 08:12:44AM +0200, Ulrich Windl wrote:
> >> >>> Don Zickus <dzickus@redhat.com> schrieb am 14.08.2014 um 19:46 in Nachricht
> >> <20140814174658.GV49576@redhat.com>:
> >> > On Wed, Aug 13, 2014 at 05:22:17PM +0200, Ulrich Windl wrote:
> >> >> Hello!
> >> >> 
> >> >> Running the current SLES11 SP3 kernel on a HP DL380 G8 server, there are 
> >> > some kernel messages that indicate a bug either in the kernel or in the HP 
> >> > BIOS. Maybe someone can explain, so I can try to get it fixed whatever 
> > party 
> >> > broke it...
> >> >> 
> >> >> Linux kernel is "3.0.101-0.35-default (geeko@buildhost) (gcc version 4.3.4 
> >> > [gcc-4_3-branch revision 152973]" (latest).
> >> >> HP server is "HP ProLiant DL380p Gen8, BIOS P70 02/10/2014" (latest)
> >> > 
> >> > Yes, it is because you are letting the firmware dynamically control your
> >> > cpu frequency.  In order to accomplish they need to use a perf counter or
> >> > two, hence the conflict.  Set the firmware setting to OS control and the
> >> > problem goes away.  Contact HP for those instructions, they are very aware
> >> > of this problem and recommend OS control to all high end servers.
> >> 
> >> Hi!
> >> 
> >> Thanks for answering, but the BIOS has set power management to "OS control" 
> > (see attachment). So I guess it must be something different.
> > 
> > Hmm, sounds like it.  Regardless, the error message indicates the counters
> > are in use most likely by the BIOS.  So you can ask HP what is going on.
> > 
> > I assume this is a normal bootup and not a kdump crash kernel, correct?
> 
> Yes, it's a normal boot. I'm afraid the standard hardware support at HP does not care much about such issues (I remember those Xeon bugs that caused memory errors during longer idle phases (in the G7 server) that are fixed be recent microcode updates: HP changed memory modules, and they changed the board, but it took very long until they updated the BIOS).
> 
> Is there any more information I can provide to narrow down the problem?

Not really.. see below..

<snip>

> >> >> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> >> >> CPU0: Intel(R) Xeon(R) CPU E5-2630 v2 @ 2.60GHz stepping 04
> >> >> Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Broken BIOS 
> >> > detec
> >> >> ted, complain to your hardware vendor.
> >> >> [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)

what happens here is we walk the PMU to see if one of them is enabled.
And sure enough the fixed counters (38d) have counter 1 and 2 enabled
(330) before the kernel even touches them.

The assumption is if someone is using them, then anything the kernel does
with them could be inaccurate.

My contacts with HP here tell me that if the power control is setting to
OS, then the counters should be unused and not be set (and we have seen
that here at Red Hat).

There isn't much more I can say and I am not really motivated to walk
through all your BIOS options to verify everything. :-)

At least with RHEL kernels, there is supposed to be published HP
whitepapers detailing all this and what to do.

Cheers,
Don

> >> >> Intel PMU driver.
> >> >> ... version:                3
> >> >> ... bit width:              48
> >> >> ... generic registers:      4
> >> >> ... value mask:             0000ffffffffffff
> >> >> ... max period:             000000007fffffff
> >> >> ... fixed-purpose events:   3
> >> >> ... event mask:             000000070000000f
> >> >> NMI watchdog enabled, takes one hw-pmu counter.
> >> >> Booting Node   0, Processors  #1
> >> >> [...]
