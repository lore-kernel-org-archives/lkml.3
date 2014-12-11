Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbaLKAVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:21:13 -0500
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:60980
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758546AbaLKAVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:21:11 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Michal Hocko <mhocko@suse.cz>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the
 memory hot-add code
Thread-Topic: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the
 memory hot-add code
Thread-Index: AQHQEOOmuVgs+XxEC0aWqcTs3cVwiZyFztOAgACs+YCAAIHigIAAFYwAgAAITACAAnA0MA==
Date: Thu, 11 Dec 2014 00:21:09 +0000
Message-ID: <BY2PR0301MB07118CFD9B32FEBE4E0C9921A0630@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417826471-21131-1-git-send-email-kys@microsoft.com>
 <1417826498-21172-1-git-send-email-kys@microsoft.com>
 <1417826498-21172-2-git-send-email-kys@microsoft.com>
 <20141208150445.GB29102@dhcp22.suse.cz> <54864F27.8010008@jp.fujitsu.com>
 <20141209090843.GA11373@dhcp22.suse.cz> <5486CE2E.4070409@jp.fujitsu.com>
 <20141209105532.GB11373@dhcp22.suse.cz>
In-Reply-To: <20141209105532.GB11373@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 0422860ED4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(479174003)(51704005)(377454003)(13464003)(24454002)(199003)(377424004)(189002)(120916001)(106116001)(19580395003)(19580405001)(97736003)(99396003)(40100003)(4396001)(93886004)(46102003)(122556002)(64706001)(105586002)(20776003)(33656002)(99286002)(92566001)(106356001)(68736005)(86612001)(15975445007)(102836002)(86362001)(101416001)(74316001)(54606007)(77156002)(62966003)(31966008)(50986999)(2656002)(21056001)(76576001)(54206007)(87936001)(107046002)(76176999)(54356999)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michal Hocko [mailto:mhocko@suse.cz]
> Sent: Tuesday, December 9, 2014 2:56 AM
> To: Yasuaki Ishimatsu
> Cc: KY Srinivasan; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; linux-mm@kvack.org
> Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the
> memory hot-add code
> 
> On Tue 09-12-14 19:25:50, Yasuaki Ishimatsu wrote:
> > (2014/12/09 18:08), Michal Hocko wrote:
> [...]
> > >Doesn't udev retry the operation if it gets EBUSY or EAGAIN?
> >
> > It depend on implementation of udev.rules. So we can retry
> > online/offline operation in udev.rules.
> [...]
> 
> # Memory hotadd request
> SUBSYSTEM=="memory", ACTION=="add",
> DEVPATH=="/devices/system/memory/memory*[0-9]",
> TEST=="/sys$devpath/state", RUN+="/bin/sh -c 'echo online >
> /sys$devpath/state'"
> 
> OK so this is not prepared for a temporary failures and retries.
> 
> > >And again, why cannot we simply make the onlining fail or try_lock
> > >and retry internally if the event consumer cannot cope with errors?
> >
> > Did you mean the following Srinivasan's first patch looks good to you?
> >   https://lkml.org/lkml/2014/12/2/662
> 
> Heh, I was just about to post this. Because I haven't noticed the previous
> patch yet. Yeah, Something like that. Except that I would expect EAGAIN or
> EBUSY rather than ERESTARTSYS which should never leak into userspace. And
> that would happen here AFAICS because signal_pending will not be true
> usually.
Michal,

I agree that the fix to this problem must be outside the clients of  add_memory() and that
is the reason I had sent that patch:  https://lkml.org/lkml/2014/12/2/662. Let me know if
you want me to resend this patch with the correct return value.

Regards,

K. Y
> 
> So there are two options. Either make the udev rule more robust and retry
> within RUN section or do the retry withing online_pages (try_lock and go into
> interruptible sleep which gets signaled by finished add_memory()). The later
> option is safer wrt. the userspace because the operation wouldn't fail
> unexpectedly.
> Another option would be generating the sysfs file after all the internal
> initialization is done and call it outside of the memory hotplug lock.
> 
> --
> Michal Hocko
> SUSE Labs
