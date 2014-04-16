Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161627AbaDPPD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:03:29 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:54853 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319AbaDPPD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:03:26 -0400
Date: Wed, 16 Apr 2014 10:03:23 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Luis Henriques <luis.henriques@canonical.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>
Subject: Re: BUG: using __this_cpu_write() in preemptible [00000000] code:
 systemd-udevd/497
In-Reply-To: <20140415155453.54d0ca97ca88905594b5100f@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1404160958440.9704@gentwo.org>
References: <87mwfn4gah.fsf@canonical.com> <20140415155453.54d0ca97ca88905594b5100f@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Andrew Morton wrote:

> On Tue, 15 Apr 2014 00:55:50 +0100 Luis Henriques <luis.henriques@canonical.com> wrote:
>
> > (Cc'ing both lis3lv02d and ACPI maintainers)
> >
> > Since commit 188a81409ff7de1c5aae947a96356ddd8ff4aaa3 ("percpu: add
> > preemption checks to __this_cpu ops") I've been seeing the following:
> >
> > [   10.485588] hp_accel: hardware type HPB64xx found
> > [   10.485772] BUG: using __this_cpu_write() in preemptible [00000000] code: systemd-udevd/497
> > [   10.485777] caller is __this_cpu_preempt_check+0x13/0x20
> > [   10.485781] CPU: 3 PID: 497 Comm: systemd-udevd Tainted: G        W     3.15.0-rc1 #9
> > [   10.485783] Hardware name: Hewlett-Packard HP EliteBook 8470p/179B, BIOS 68ICF Ver. F.02 04/27/2012
> > [   10.485785]  ffffffff81a14db5 ffff88022c80b8e0 ffffffff81604ba4 0000000000000003
> > [   10.485789]  ffff88022c80b908 ffffffff81313431 0000000000000000 0000000000000032
> > [   10.485793]  00000000000003e8 ffff88022c80b918 ffffffff81313473 ffff88022c80b928
> > [   10.485796] Call Trace:
> > [   10.485802]  [<ffffffff81604ba4>] dump_stack+0x4e/0x7a
> > [   10.485805]  [<ffffffff81313431>] check_preemption_disabled+0xe1/0xf0
> > [   10.485808]  [<ffffffff81313473>] __this_cpu_preempt_check+0x13/0x20
> > [   10.485813]  [<ffffffff810e4eb8>] touch_nmi_watchdog+0x28/0x40
>
> Presumably touch_softlockup_watchdog() being called with preemption
> enabled.  Which is a legitimate thing to do and there's no point in
> disabling preemption just to squish a runtime warning.
>
> Christoph, this thing has iirc caught a couple of very minor bugs but
> it is being quite a pain in the rear.   I'm inclined to revert?

Well this preemption check functionality was strongly desired by Peter
Zilkstra and Ingo Molnar and made a precondition for more extensive use of
the this_cpu operations. My patches to various subsystems were rejected
because these operations were deemed unsafe without those checks.

The simple thing to do in these cases is to use switch from __this_cpu_*
to raw_cpu ops to squish these warnings.
