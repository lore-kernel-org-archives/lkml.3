Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbbAZQLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:11:24 -0500
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:53326
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752657AbbAZQLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:11:20 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Topic: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Index: AQHQOVRHx2JpIeXls06rO07KVbUOyZzSkmjw
Date: Mon, 26 Jan 2015 16:11:17 +0000
Message-ID: <BY2PR0301MB07114BC53D10824940B55423A0350@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417431161-12845-1-git-send-email-vkuznets@redhat.com>
	<1421081411-5759-1-git-send-email-vkuznets@redhat.com>
	<20150125133659.GA21552@kroah.com> <87k309g729.fsf@vitty.brq.redhat.com>
In-Reply-To: <87k309g729.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:2c2b:813b:c98b:1e4b]
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=microsoft.com;
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0776;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-forefront-prvs: 0468FE4A2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(13464003)(51704005)(54206007)(87936001)(40100003)(19580405001)(19580395003)(92566002)(2900100001)(2950100001)(122556002)(2656002)(46102003)(93886004)(86362001)(102836002)(62966003)(77156002)(86612001)(74316001)(76576001)(54606007)(76176999)(54356999)(106116001)(50986999)(99286002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0776;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2015 16:11:17.8288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0776
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Monday, January 26, 2015 2:39 AM
> To: Greg Kroah-Hartman
> Cc: KY Srinivasan; devel@linuxdriverproject.org; Haiyang Zhang; linux-
> kernel@vger.kernel.org; Dexuan Cui
> Subject: Re: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
> hypervisors
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > On Mon, Jan 12, 2015 at 05:50:11PM +0100, Vitaly Kuznetsov wrote:
> >> When an SMP Hyper-V guest is running on top of 2012R2 Server and
> >> secondary cpus are sent offline (with echo 0 >
> >> /sys/devices/system/cpu/cpu$cpu/online)
> >> the system freeze is observed. This happens due to the fact that on
> >> newer hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are
> >> distributed across all cpus (see init_vp_index() function in
> >> drivers/hv/channel_mgmt.c) and on cpu offlining nobody reassigns them
> >> to CPU0. Prevent cpu offlining when vmbus is loaded until the issue is
> fixed host-side.
> >>
> >> This patch also disables hibernation but it is OK as it is also
> >> broken (MCE error is hit on resume). Suspend still works.
> >>
> >> Tested with WS2008R2 and WS2012R2.
> >>
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >> ---
> >> Changes since v2:
> >> - repair the build when vmbus is builded as a module [Greg KH] by saving
> >>   current cpu_disable pointer to previous_cpu_disable and restoring it on
> >>   unload;
> >> - return -ENOSYS (same as native_cpu_disable when
> !CONFIG_HOTPLUG_CPU) instead
> >>   of -1 in hyperv_cpu_disable().
> >>
> >> Changes since v1:
> >> - introduce hv_cpu_hotplug_quirk() function to not spread #ifdefs
> >> [Greg KH];
> >> - add pr_notice() message "hv_vmbus: CPU offlining is not supported by
> >>   hypervisor".
> >> ---
> >>  drivers/hv/vmbus_drv.c | 36
> ++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 36 insertions(+)
> >
> > Doesn't apply to my char-misc-test branch at all :(
> 
> Another mid-air collision with K.Y's "Drivers: hv: vmbus: Implement a
> clockevent device", please use the attached version. No functional changes
> are required, I just fixed the merge conflict (includes).
> 
> Othere than that (and sorry for meddling), would it it be better if you switch
> to 'pull requests' workflow with K.Y? There is a lot of ongoing work in hyperv
> nowdays and such collisions seem otherwise inevitable ...

I will co-ordinate and forward Hyper-V patches to Greg.

K. Y
> 
> --
>   Vitaly

