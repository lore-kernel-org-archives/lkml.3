Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab3LDQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:09:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32263 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab3LDQJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:09:24 -0500
Date: Wed, 4 Dec 2013 11:09:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH] cpuidle: Check for dev before deregistering it.
Message-ID: <20131204160911.GB391@pegasus.dumpdata.com>
References: <1386086398-3686-1-git-send-email-konrad.wilk@oracle.com>
 <3652709.SMvyaH5n9G@vostro.rjw.lan>
 <529EF184.3090000@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529EF184.3090000@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 10:10:28AM +0100, Daniel Lezcano wrote:
> On 12/03/2013 10:33 PM, Rafael J. Wysocki wrote:
> >On Tuesday, December 03, 2013 10:59:58 AM Konrad Rzeszutek Wilk wrote:
> >>If not, we could end up in the unfortunate situation where
> >>we dereference a NULL pointer b/c we have cpuidle disabled.
> >>
> >>This is the case when booting under Xen (which uses the
> >>ACPI P/C states but disables the CPU idle driver) - and can
> >>be easily reproduced when booting with cpuidle.off=1.
> >>
> >>BUG: unable to handle kernel NULL pointer dereference at           (null)
> >>IP: [<ffffffff8156db4a>] cpuidle_unregister_device+0x2a/0x90
> >>.. snip..
> >>Call Trace:
> >>  [<ffffffff813b15b4>] acpi_processor_power_exit+0x3c/0x5c
> >>  [<ffffffff813af0a9>] acpi_processor_stop+0x61/0xb6
> >>  [<ffffffff814215bf>] __device_release_driver+0fffff81421653>] device_release_driver+0x23/0x30
> >>  [<ffffffff81420ed8>] bus_remove_device+0x108/0x180
> >>  [<ffffffff8141d9d9>] device_del+0x129/0x1c0
> >>  [<ffffffff813cb4b0>] ? unregister_xenbus_watch+0x1f0/0x1f0
> >>  [<ffffffff8141da8e>] device_unregister+0x1e/0x60
> >>  [<ffffffff814243e9>] unregister_cpu+0x39/0x60
> >>  [<ffffffff81019e03>] arch_unregister_cpu+0x23/0x30
> >>  [<ffffffff813c3c51>] handle_vcpu_hotplug_event+0xc1/0xe0
> >>  [<ffffffff813cb4f5>] xenwatch_thread+0x45/0x120
> >>  [<ffffffff810af010>] ? abort_exclusive_wait+0xb0/0xb0
> >>  [<ffffffff8108ec42>] kthread+0xd2/0xf0
> >>  [<ffffffff8108eb70>] ? kthread_create_on_node+0x180/0x180
> >>  [<ffffffff816ce17c>] ret_from_fork+0x7c/0xb0
> >>  [<ffffffff8108eb70>] ? kthread_create_on_node+0x180/0x180
> >>
> >>This problem also appears in 3.12 and could be a candidate for backport.
> >>
> >>CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> >>CC: Daniel Lezcano <daniel.lezcano@linaro.org>
> >>CC: linux-pm@vger.kernel.org
> >>Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >
> >Applied, thanks!
> >
> >>---
> >>  drivers/cpuidle/cpuidle.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >>diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> >>index 2a991e4..a55e68f 100644
> >>--- a/drivers/cpuidle/cpuidle.c
> >>+++ b/drivers/cpuidle/cpuidle.c
> >>@@ -400,7 +400,7 @@ EXPORT_SYMBOL_GPL(cpuidle_register_device);
> >>   */
> >>  void cpuidle_unregister_device(struct cpuidle_device *dev)
> >>  {
> >>-	if (dev->registered == 0)
> >>+	if (!dev || dev->registered == 0)
> >>  		return;
> >>
> >>  	cpuidle_pause_and_lock();
> 
> Oops, wait. Are we sure the problem is coming from cpuidle ?

It is acpi_processor_power_exit assuming that the cpuidle is
initialized. It could be fixed there too, but there are multiple
entries in cpuidle where it does the : "if (!dev) return .."
so I figured this should be done as well here.

> 
> The cpuidle_unregister_device is called with a NULL pointer, that
> shouldn't happen.

It does :-)
> 
> Konrad, you say that could be easily reproduced. How do you produce
> it ? Unplugging a cpu ?

Yes. 
