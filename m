Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaK0DkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:40:03 -0500
Received: from mail-bn1bbn0103.outbound.protection.outlook.com ([157.56.111.103]:21357
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752938AbaK0DkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:40:01 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Topic: [PATCH] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Index: AQHQCe7eSWkBInuhpUS4yGk6C482hpxzzoEg
Date: Thu, 27 Nov 2014 03:24:48 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E63EAE@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1417009942-10216-1-git-send-email-vkuznets@redhat.com>
 <20141127030254.GA28028@kroah.com>
In-Reply-To: <20141127030254.GA28028@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(377454003)(199003)(24454002)(13464003)(164054003)(51704005)(97736003)(86362001)(19580395003)(62966003)(64706001)(66066001)(6806004)(19580405001)(44976005)(84676001)(92566001)(92726001)(77096003)(77156002)(20776003)(26826002)(86612001)(2656002)(87936001)(106116001)(33656002)(23726002)(86146001)(107046002)(81156004)(106466001)(95666004)(55846006)(4396001)(21056001)(46406003)(76176999)(50986999)(97756001)(54356999)(31966008)(16796002)(120916001)(99396003)(46102003)(68736004)(69596002)(50466002)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB607;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB607;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB607;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB607;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB073;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of Greg Kroah-Hartman
> Sent: Thursday, November 27, 2014 11:03 AM
> To: Vitaly Kuznetsov
> Cc: devel@linuxdriverproject.org; Haiyang Zhang; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] Drivers: hv: vmbus: prevent cpu offlining on newer
> hypervisors
> 
> On Wed, Nov 26, 2014 at 02:52:22PM +0100, Vitaly Kuznetsov wrote:
> > When an SMP Hyper-V guest is running on top of 2012R2 Server and
> secondary
> > cpus are sent offline (with echo 0 >
> /sys/devices/system/cpu/cpu$cpu/online)
> > the system freeze is observed. This happens due to the fact that on newer
> > hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are
> distributed
> > across all cpus (see init_vp_index() function in
> drivers/hv/channel_mgmt.c)
> > and on cpu offlining nobody reassigns them to CPU0. Prevent cpu
> offlining
> > when vmbus is loaded until the issue is fixed host-side.
> >
> > This patch also disables hibernation but it is OK as it is also broken (MCE
> > error is hit on resume). Suspend still works.
> >
> > Tested with WS2008R2 and WS2012R2.
> >
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >  drivers/hv/vmbus_drv.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> > index 4d6b269..9a82249 100644
> > --- a/drivers/hv/vmbus_drv.c
> > +++ b/drivers/hv/vmbus_drv.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/completion.h>
> >  #include <linux/hyperv.h>
> >  #include <linux/kernel_stat.h>
> > +#include <linux/cpu.h>
> >  #include <asm/hyperv.h>
> >  #include <asm/hypervisor.h>
> >  #include <asm/mshyperv.h>
> > @@ -671,6 +672,13 @@ static void vmbus_isr(void)
> >  		tasklet_schedule(&msg_dpc);
> >  }
> >
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +static int hyperv_cpu_disable(void)
> > +{
> > +	return -1;
> > +}
> > +#endif
> > +
> >  /*
> >   * vmbus_bus_init -Main vmbus driver initialization routine.
> >   *
> > @@ -711,6 +719,12 @@ static int vmbus_bus_init(int irq)
> >  	if (ret)
> >  		goto err_alloc;
> >
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +	if ((vmbus_proto_version != VERSION_WS2008) &&
> > +	    (vmbus_proto_version != VERSION_WIN7))
> > +		smp_ops.cpu_disable = hyperv_cpu_disable;
> > +#endif
> > +
> >  	vmbus_request_offers();
> >
> >  	return 0;
> > @@ -964,6 +978,11 @@ static void __exit vmbus_exit(void)
> >  	bus_unregister(&hv_bus);
> >  	hv_cleanup();
> >  	acpi_bus_unregister_driver(&vmbus_acpi_driver);
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +	if ((vmbus_proto_version != VERSION_WS2008) &&
> > +	    (vmbus_proto_version != VERSION_WIN7))
> > +		smp_ops.cpu_disable = native_cpu_disable;
> > +#endif
> >  }
> 
> #ifdef in a .c file is not a good idea to do if at all possible, please
> only put this in one place, using a function call to "hide" the mess.
> 
> greg k-h

Hi Vitaly,
The idea of the patch is good to me.

I agree with Greg.
BTW, maybe hv_cpu_hotplug_quirk() is a better name?

Thanks,
-- Dexuan
