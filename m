Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaK0JwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:52:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaK0JwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:52:14 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drivers: hv: vmbus: prevent cpu offlining on newer hypervisors
References: <1417009942-10216-1-git-send-email-vkuznets@redhat.com>
	<20141127030254.GA28028@kroah.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E63EAE@HKNPRD3002MB017.064d.mgd.msft.net>
Date: Thu, 27 Nov 2014 10:52:06 +0100
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E63EAE@HKNPRD3002MB017.064d.mgd.msft.net>
	(Dexuan Cui's message of "Thu, 27 Nov 2014 03:24:48 +0000")
Message-ID: <874mtl0y49.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

>> -----Original Message-----
>> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
>> Behalf Of Greg Kroah-Hartman
>> Sent: Thursday, November 27, 2014 11:03 AM
>> To: Vitaly Kuznetsov
>> Cc: devel@linuxdriverproject.org; Haiyang Zhang; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] Drivers: hv: vmbus: prevent cpu offlining on newer
>> hypervisors
>> 
>> On Wed, Nov 26, 2014 at 02:52:22PM +0100, Vitaly Kuznetsov wrote:
>> > When an SMP Hyper-V guest is running on top of 2012R2 Server and
>> secondary
>> > cpus are sent offline (with echo 0 >
>> /sys/devices/system/cpu/cpu$cpu/online)
>> > the system freeze is observed. This happens due to the fact that on newer
>> > hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are
>> distributed
>> > across all cpus (see init_vp_index() function in
>> drivers/hv/channel_mgmt.c)
>> > and on cpu offlining nobody reassigns them to CPU0. Prevent cpu
>> offlining
>> > when vmbus is loaded until the issue is fixed host-side.
>> >
>> > This patch also disables hibernation but it is OK as it is also broken (MCE
>> > error is hit on resume). Suspend still works.
>> >
>> > Tested with WS2008R2 and WS2012R2.
>> >
>> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> > ---
>> >  drivers/hv/vmbus_drv.c | 19 +++++++++++++++++++
>> >  1 file changed, 19 insertions(+)
>> >
>> > diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
>> > index 4d6b269..9a82249 100644
>> > --- a/drivers/hv/vmbus_drv.c
>> > +++ b/drivers/hv/vmbus_drv.c
>> > @@ -32,6 +32,7 @@
>> >  #include <linux/completion.h>
>> >  #include <linux/hyperv.h>
>> >  #include <linux/kernel_stat.h>
>> > +#include <linux/cpu.h>
>> >  #include <asm/hyperv.h>
>> >  #include <asm/hypervisor.h>
>> >  #include <asm/mshyperv.h>
>> > @@ -671,6 +672,13 @@ static void vmbus_isr(void)
>> >  		tasklet_schedule(&msg_dpc);
>> >  }
>> >
>> > +#ifdef CONFIG_HOTPLUG_CPU
>> > +static int hyperv_cpu_disable(void)
>> > +{
>> > +	return -1;
>> > +}
>> > +#endif
>> > +
>> >  /*
>> >   * vmbus_bus_init -Main vmbus driver initialization routine.
>> >   *
>> > @@ -711,6 +719,12 @@ static int vmbus_bus_init(int irq)
>> >  	if (ret)
>> >  		goto err_alloc;
>> >
>> > +#ifdef CONFIG_HOTPLUG_CPU
>> > +	if ((vmbus_proto_version != VERSION_WS2008) &&
>> > +	    (vmbus_proto_version != VERSION_WIN7))
>> > +		smp_ops.cpu_disable = hyperv_cpu_disable;
>> > +#endif
>> > +
>> >  	vmbus_request_offers();
>> >
>> >  	return 0;
>> > @@ -964,6 +978,11 @@ static void __exit vmbus_exit(void)
>> >  	bus_unregister(&hv_bus);
>> >  	hv_cleanup();
>> >  	acpi_bus_unregister_driver(&vmbus_acpi_driver);
>> > +#ifdef CONFIG_HOTPLUG_CPU
>> > +	if ((vmbus_proto_version != VERSION_WS2008) &&
>> > +	    (vmbus_proto_version != VERSION_WIN7))
>> > +		smp_ops.cpu_disable = native_cpu_disable;
>> > +#endif
>> >  }
>> 
>> #ifdef in a .c file is not a good idea to do if at all possible, please
>> only put this in one place, using a function call to "hide" the mess.
>> 
>> greg k-h
>
> Hi Vitaly,
> The idea of the patch is good to me.
>
> I agree with Greg.
> BTW, maybe hv_cpu_hotplug_quirk() is a better name?

My idea was that eventually this function will start doing something
real (e.g. switching channels to cpu0 if it doesn't happen fully
host-side) so I called it with a general name 'hyperv_cpu_disable'.

I'll try addressing our and Greg's comments in v2, thanks!

>
> Thanks,
> -- Dexuan

-- 
  Vitaly
