Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbaH0Lbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:31:44 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:18046
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755973AbaH0Lbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:31:42 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjgvav2zR0lYke3SB9WxJlS05vhXWzggABBfwCAAQnBQIABpkoAgAAIh7A=
Date: Wed, 27 Aug 2014 11:30:54 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140825174132.GA17681@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
In-Reply-To: <20140827104408.GC1827@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(199003)(189002)(13464003)(51704005)(164054003)(51914003)(81156004)(46406003)(106116001)(107046002)(54356999)(77982001)(26826002)(77096002)(93886004)(85306004)(85852003)(97736001)(110136001)(79102001)(33656002)(95666004)(106466001)(4396001)(15975445006)(1411001)(99396002)(47776003)(20776003)(16796002)(74502001)(74662001)(68736004)(23726002)(81342001)(83322001)(76176999)(50466002)(15202345003)(84676001)(92726001)(92566001)(55846006)(87936001)(83072002)(97756001)(86612001)(31966008)(69596002)(64706001)(44976005)(81542001)(86362001)(19580395003)(6806004)(80022001)(90102001)(21056001)(46102001)(2656002)(50986999)(76482001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0721;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0316567485
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler
> On Tue, Aug 26, 2014 at 10:30:54AM +0000, Dexuan Cui wrote:
> 
> > Actually I found the direct cause of the panic: sometimes
> > vmbus_post_msg() can return 4 (HV_STATUS_INVALID_ALIGNMENT), but
> > vmbus_open() doesn't propagate this error to the caller
> > synthvid_connect_vsp(), and vmbus_open() " goto error1"  and frees the
> > ringbuffer! So later the access to ring_buffer->read_index is caught
> > by CONFIG_DEBUG_PAGEALLOC.
> >
> > I don't see any "invalid alignment" here... and I can't explain why
> > vcpus=4 seems OK... Debugging WIP.
I think I found out why we got HV_STATUS_INVALID_ALIGNMENT:
according to Hypervisor Top Level Functional Specification(available at
http://blogs.msdn.com/b/virtual_pc_guy/archive/2014/02/17/updated-hypervisor-top-level-functional-specification.aspx),
do_hypercall() fails due to HV_STATUS_INVALID_ALIGNMENT, if "the
specified input or output GPA pointer is not aligned to 8 bytes",
or, "the specified input or output parameter lists spans pages".
Here the 'input' can rarely across the page boundary, especially when 
CONFIG_DEBUG_PAGEALLOC is on.

I'm making a patch for this. 

> >
> > BTW, please try the attached patch.  With it, the VM doesn't panic in
> > my side with vcpus=1 and can boot to shell prompt(looks the boot-up is
> > very slow. I have to wait for several minutes...)
> 
> A quick tip: inline patches tend to be better than attachments on LKML.
> This is because if the mimetype of the attachment is something like
> octet/stream then various tools (e.g.
> https://lkml.org/lkml/2014/8/26/271 and
> https://patchwork.kernel.org/project/LKML/list/?submitter=100981 ) won't
> archive/extract the patch...
OK, thanks for the reminder! 
I'll use inline patches(I hope my mail client has been configured to be smart
enough to not "auto-format" my inline patches...).

> I rebased your patch on top of the K.Y.'s "Drivers: hv: vmbus: Eliminate
> calls to BUG_ON()" patch set (see below). The combination no longer
> triggers the bug and it doesn't take too long to boot but the network
> interface fails to work (which I believe is .
the sentence is accidently trimmed here? :-)

> 
> Rebased vmbus open fixes patch.
The patch doesn't resolve all the issues.

> Boot dmesg output (there's no line that mentions retries). The
> framebuffer window also didn't resize itself:
> 
> [    7.848030] hv_vmbus: registering driver hyperv_fb
> [    7.859759] hyperv_fb: Unable to open vmbus channel
> [    7.871812] hyperv_fb: Unable to connect to VSP
We still see hyperv_fb can't work.

Thanks,
-- Dexuan
