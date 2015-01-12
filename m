Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbbALSyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:54:20 -0500
Received: from mail-bl2on0106.outbound.protection.outlook.com ([65.55.169.106]:27648
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753854AbbALSyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:54:16 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Topic: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Index: AQHQLofcx2JpIeXls06rO07KVbUOyZy803uA
Date: Mon, 12 Jan 2015 18:54:13 +0000
Message-ID: <BY2PR0301MB07113924DEAAE3D776AC44E7A0430@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417431161-12845-1-git-send-email-vkuznets@redhat.com>
 <1421081411-5759-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421081411-5759-1-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0775;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0775;
x-forefront-prvs: 0454444834
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(377454003)(51704005)(199003)(189002)(40100003)(19580405001)(19580395003)(99286002)(2656002)(50986999)(92566002)(76176999)(2501002)(97736003)(106116001)(64706001)(74316001)(102836002)(46102003)(86362001)(575784001)(62966003)(2900100001)(77156002)(2950100001)(54606007)(87936001)(105586002)(54356999)(68736005)(33656002)(101416001)(76576001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0775;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2015 18:54:13.5161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0775
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Monday, January 12, 2015 8:50 AM
> To: KY Srinivasan; devel@linuxdriverproject.org
> Cc: Haiyang Zhang; Greg Kroah-Hartman; linux-kernel@vger.kernel.org;
> Dexuan Cui
> Subject: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
> hypervisors
> 
> When an SMP Hyper-V guest is running on top of 2012R2 Server and
> secondary
> cpus are sent offline (with echo 0 >
> /sys/devices/system/cpu/cpu$cpu/online)
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
Thank you.
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
> Changes since v2:
> - repair the build when vmbus is builded as a module [Greg KH] by saving
>   current cpu_disable pointer to previous_cpu_disable and restoring it on
>   unload;
> - return -ENOSYS (same as native_cpu_disable when
> !CONFIG_HOTPLUG_CPU) instead
>   of -1 in hyperv_cpu_disable().
> 
> Changes since v1:
> - introduce hv_cpu_hotplug_quirk() function to not spread #ifdefs [Greg
> KH];
> - add pr_notice() message "hv_vmbus: CPU offlining is not supported by
>   hypervisor".
> ---
>  drivers/hv/vmbus_drv.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 4d6b269..233da0b 100644
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
> @@ -671,6 +672,39 @@ static void vmbus_isr(void)
>  		tasklet_schedule(&msg_dpc);
>  }
> 
> +#ifdef CONFIG_HOTPLUG_CPU
> +static int hyperv_cpu_disable(void)
> +{
> +	return -ENOSYS;
> +}
> +
> +static void hv_cpu_hotplug_quirk(bool vmbus_loaded)
> +{
> +	static void *previous_cpu_disable;
> +
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
> +		previous_cpu_disable = smp_ops.cpu_disable;
> +		smp_ops.cpu_disable = hyperv_cpu_disable;
> +		pr_notice("CPU offlining is not supported by hypervisor\n");
> +	} else if (previous_cpu_disable)
> +		smp_ops.cpu_disable = previous_cpu_disable;
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
> @@ -711,6 +745,7 @@ static int vmbus_bus_init(int irq)
>  	if (ret)
>  		goto err_alloc;
> 
> +	hv_cpu_hotplug_quirk(true);
>  	vmbus_request_offers();
> 
>  	return 0;
> @@ -964,6 +999,7 @@ static void __exit vmbus_exit(void)
>  	bus_unregister(&hv_bus);
>  	hv_cleanup();
>  	acpi_bus_unregister_driver(&vmbus_acpi_driver);
> +	hv_cpu_hotplug_quirk(false);
>  }
> 
> 
> --
> 1.9.3

