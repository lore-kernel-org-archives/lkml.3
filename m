Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaLALNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:13:46 -0500
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:57056
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753051AbaLALNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:13:45 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Topic: [PATCH v2] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Index: AQHQDVUAKyf1HX4IhEi8aeIlRtK1vpx6lK6Q
Date: Mon, 1 Dec 2014 11:12:53 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E69387@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1417009942-10216-1-git-send-email-vkuznets@redhat.com>
 <1417431161-12845-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1417431161-12845-1-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(189002)(377454003)(51704005)(13464003)(23726002)(106116001)(106466001)(81156004)(54356999)(76176999)(64706001)(47776003)(20776003)(86362001)(107046002)(120916001)(66066001)(99396003)(92726001)(92566001)(50986999)(86612001)(46406003)(84676001)(19580395003)(2656002)(97756001)(1511001)(44976005)(6806004)(86146001)(69596002)(68736004)(21056001)(19580405001)(77096004)(87936001)(2561002)(97736003)(26826002)(33656002)(46102003)(2421001)(95666004)(50466002)(62966003)(31966008)(77156002)(16796002)(55846006)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB604;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB604;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB604;
X-Forefront-PRVS: 0412A98A59
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB604;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Monday, December 1, 2014 18:53 PM
> To: KY Srinivasan; Haiyang Zhang
> Cc: devel@linuxdriverproject.org; Greg Kroah-Hartman; linux-
> kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH v2] Drivers: hv: vmbus: prevent cpu offlining on newer
> hypervisors
> 
> When an SMP Hyper-V guest is running on top of 2012R2 Server and
> secondary
> cpus are sent offline (with echo 0 > /sys/devices/system/cpu/cpu$cpu/online)
> the system freeze is observed. This happens due to the fact that on newer
> hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are distributed
> across all cpus (see init_vp_index() function in drivers/hv/channel_mgmt.c)
> and on cpu offlining nobody reassigns them to CPU0. Prevent cpu offlining
> when vmbus is loaded until the issue is fixed host-side.
> 
> This patch also disables hibernation but it is OK as it is also broken (MCE
> error is hit on resume). Suspend still works.
> 
> Tested with WS2008R2 and WS2012R2.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> ---
> Changes since v1:
> - introduce hv_cpu_hotplug_quirk() function to not spread #ifdefs [Greg KH]
> - add pr_notice() message "hv_vmbus: CPU offlining is not supported by
> hypervisor"
> ---
>  drivers/hv/vmbus_drv.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 4d6b269..2e6b38e 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -32,6 +32,7 @@
>  #include <linux/completion.h>
>  #include <linux/hyperv.h>
>  #include <linux/kernel_stat.h>
> +#include <linux/cpu.h>
>  #include <asm/hyperv.h>
>  #include <asm/hypervisor.h>
>  #include <asm/mshyperv.h>
> @@ -671,6 +672,36 @@ static void vmbus_isr(void)
>  		tasklet_schedule(&msg_dpc);
>  }
> 
> +#ifdef CONFIG_HOTPLUG_CPU
> +static int hyperv_cpu_disable(void)
> +{
> +	return -1;
> +}
> +
> +static void hv_cpu_hotplug_quirk(bool vmbus_loaded)
> +{
> +	/*
> +	 * Offlining a CPU when running on newer hypervisors (WS2012R2,
> Win8,
> +	 * ...) is not supported at this moment as channel interrupts are
> +	 * distributed across all of them.
> +	 */
> +
> +	if ((vmbus_proto_version == VERSION_WS2008) ||
> +	    (vmbus_proto_version == VERSION_WIN7))
> +		return;
> +
> +	if (vmbus_loaded) {
> +		smp_ops.cpu_disable = hyperv_cpu_disable;
> +		pr_notice("CPU offlining is not supported by hypervisor");
> +	} else
> +		smp_ops.cpu_disable = native_cpu_disable;
> +}
> +#else
> +static void hv_cpu_hotplug_quirk(bool vmbus_loaded)
> +{
> +}
> +#endif
> +
>  /*
>   * vmbus_bus_init -Main vmbus driver initialization routine.
>   *
> @@ -711,6 +742,7 @@ static int vmbus_bus_init(int irq)
>  	if (ret)
>  		goto err_alloc;
> 
> +	hv_cpu_hotplug_quirk(true);
>  	vmbus_request_offers();
> 
>  	return 0;
> @@ -964,6 +996,7 @@ static void __exit vmbus_exit(void)
>  	bus_unregister(&hv_bus);
>  	hv_cleanup();
>  	acpi_bus_unregister_driver(&vmbus_acpi_driver);
> +	hv_cpu_hotplug_quirk(false);
>  }

Acked-by: Dexuan Cui <decui@microsoft.com>

