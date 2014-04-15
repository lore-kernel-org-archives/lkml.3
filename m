Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaDOWy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:54:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaDOWyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:54:55 -0400
Date: Tue, 15 Apr 2014 15:54:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: Re: BUG: using __this_cpu_write() in preemptible [00000000] code:
 systemd-udevd/497
Message-Id: <20140415155453.54d0ca97ca88905594b5100f@linux-foundation.org>
In-Reply-To: <87mwfn4gah.fsf@canonical.com>
References: <87mwfn4gah.fsf@canonical.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 00:55:50 +0100 Luis Henriques <luis.henriques@canonical.com> wrote:

> (Cc'ing both lis3lv02d and ACPI maintainers)
> 
> Since commit 188a81409ff7de1c5aae947a96356ddd8ff4aaa3 ("percpu: add
> preemption checks to __this_cpu ops") I've been seeing the following:
> 
> [   10.485588] hp_accel: hardware type HPB64xx found
> [   10.485772] BUG: using __this_cpu_write() in preemptible [00000000] code: systemd-udevd/497
> [   10.485777] caller is __this_cpu_preempt_check+0x13/0x20
> [   10.485781] CPU: 3 PID: 497 Comm: systemd-udevd Tainted: G        W     3.15.0-rc1 #9
> [   10.485783] Hardware name: Hewlett-Packard HP EliteBook 8470p/179B, BIOS 68ICF Ver. F.02 04/27/2012
> [   10.485785]  ffffffff81a14db5 ffff88022c80b8e0 ffffffff81604ba4 0000000000000003
> [   10.485789]  ffff88022c80b908 ffffffff81313431 0000000000000000 0000000000000032
> [   10.485793]  00000000000003e8 ffff88022c80b918 ffffffff81313473 ffff88022c80b928
> [   10.485796] Call Trace:
> [   10.485802]  [<ffffffff81604ba4>] dump_stack+0x4e/0x7a
> [   10.485805]  [<ffffffff81313431>] check_preemption_disabled+0xe1/0xf0
> [   10.485808]  [<ffffffff81313473>] __this_cpu_preempt_check+0x13/0x20
> [   10.485813]  [<ffffffff810e4eb8>] touch_nmi_watchdog+0x28/0x40

Presumably touch_softlockup_watchdog() being called with preemption
enabled.  Which is a legitimate thing to do and there's no point in
disabling preemption just to squish a runtime warning.

Christoph, this thing has iirc caught a couple of very minor bugs but
it is being quite a pain in the rear.   I'm inclined to revert?
