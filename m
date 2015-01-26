Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbbAZXyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:54:01 -0500
Received: from mail-bn1on0138.outbound.protection.outlook.com ([157.56.110.138]:62666
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757637AbbAZXx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:53:58 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Topic: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors
Thread-Index: AQHQOVRHx2JpIeXls06rO07KVbUOyZzTA2yAgAAQdEA=
Date: Mon, 26 Jan 2015 23:53:53 +0000
Message-ID: <BY2PR0301MB0711E231353FDCA108D52D2AA0350@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417431161-12845-1-git-send-email-vkuznets@redhat.com>
 <1421081411-5759-1-git-send-email-vkuznets@redhat.com>
 <20150125133659.GA21552@kroah.com> <87k309g729.fsf@vitty.brq.redhat.com>
 <20150126225429.GA17514@kroah.com>
In-Reply-To: <20150126225429.GA17514@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::3]
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=microsoft.com;
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0775;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0775;
x-forefront-prvs: 0468FE4A2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(164054003)(13464003)(377454003)(51704005)(76576001)(99286002)(33656002)(2900100001)(102836002)(93886004)(122556002)(40100003)(76176999)(46102003)(54356999)(50986999)(54606007)(106116001)(2656002)(87936001)(86362001)(19580395003)(19580405001)(74316001)(86612001)(92566002)(62966003)(77156002)(2950100001)(54206007)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0775;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2015 23:53:53.3001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0775
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0743;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, January 26, 2015 2:54 PM
> To: Vitaly Kuznetsov
> Cc: KY Srinivasan; devel@linuxdriverproject.org; Haiyang Zhang; linux-
> kernel@vger.kernel.org; Dexuan Cui
> Subject: Re: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer
> hypervisors
> 
> On Mon, Jan 26, 2015 at 11:38:54AM +0100, Vitaly Kuznetsov wrote:
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> >
> > > On Mon, Jan 12, 2015 at 05:50:11PM +0100, Vitaly Kuznetsov wrote:
> > >> When an SMP Hyper-V guest is running on top of 2012R2 Server and
> > >> secondary cpus are sent offline (with echo 0 >
> > >> /sys/devices/system/cpu/cpu$cpu/online)
> > >> the system freeze is observed. This happens due to the fact that on
> > >> newer hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are
> > >> distributed across all cpus (see init_vp_index() function in
> > >> drivers/hv/channel_mgmt.c) and on cpu offlining nobody reassigns
> > >> them to CPU0. Prevent cpu offlining when vmbus is loaded until the
> issue is fixed host-side.
> > >>
> > >> This patch also disables hibernation but it is OK as it is also
> > >> broken (MCE error is hit on resume). Suspend still works.
> > >>
> > >> Tested with WS2008R2 and WS2012R2.
> > >>
> > >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > >> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > >> ---
> > >> Changes since v2:
> > >> - repair the build when vmbus is builded as a module [Greg KH] by
> saving
> > >>   current cpu_disable pointer to previous_cpu_disable and restoring it
> on
> > >>   unload;
> > >> - return -ENOSYS (same as native_cpu_disable when
> !CONFIG_HOTPLUG_CPU) instead
> > >>   of -1 in hyperv_cpu_disable().
> > >>
> > >> Changes since v1:
> > >> - introduce hv_cpu_hotplug_quirk() function to not spread #ifdefs
> > >> [Greg KH];
> > >> - add pr_notice() message "hv_vmbus: CPU offlining is not supported by
> > >>   hypervisor".
> > >> ---
> > >>  drivers/hv/vmbus_drv.c | 36
> ++++++++++++++++++++++++++++++++++++
> > >>  1 file changed, 36 insertions(+)
> > >
> > > Doesn't apply to my char-misc-test branch at all :(
> >
> > Another mid-air collision with K.Y's "Drivers: hv: vmbus: Implement a
> > clockevent device", please use the attached version. No functional
> > changes are required, I just fixed the merge conflict (includes).
> >
> > Othere than that (and sorry for meddling), would it it be better if
> > you switch to 'pull requests' workflow with K.Y? There is a lot of
> > ongoing work in hyperv nowdays and such collisions seem otherwise
> > inevitable ...
> 
> This is a trivial number of patches for this subsystem, so no, a git workflow
> isn't needed.  But if KY would collect the patches up and send them to me for
> all hyperv patches from now on, that would make these types of issues go
> away, KY, can you do that from now on?

Will do.

Thanks,

K. Y
> 
> thanks,
> 
> greg k-h
