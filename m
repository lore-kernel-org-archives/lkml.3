Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbaHYODZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:03:25 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:20998
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932613AbaHYODX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:03:23 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjgvav2zR0lYke3SB9WxJlS05vhXWzg
Date: Mon, 25 Aug 2014 14:02:21 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <20140820092630.GA1478@sucs.org>
In-Reply-To: <20140820092630.GA1478@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.85]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(377454003)(199003)(164054003)(13464003)(189002)(77982001)(44976005)(81342001)(87936001)(85852003)(83072002)(85306004)(4396001)(110136001)(64706001)(81156004)(69596002)(23726002)(81542001)(106116001)(83322001)(80022001)(107046002)(106466001)(46406003)(47776003)(85806002)(20776003)(99396002)(46102001)(50986999)(76176999)(54356999)(1411001)(16796002)(84676001)(95666004)(74502001)(97756001)(76482001)(77096002)(97736001)(31966008)(92566001)(6806004)(33656002)(74662001)(86362001)(79102001)(92726001)(26826002)(2656002)(68736004)(21056001)(86612001)(55846006)(90102001)(50466002);DIR:OUT;SFP:;SCL:1;SRVR:CH1PR03MB623;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03142412E2
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler
> Sent: Wednesday, August 20, 2014 17:27 PM
> 
> While booting a Hyper-V 3.17.0-rc1 guest on a 2012 R2 host a BUG was
> triggered while registering hyperv_fb which in turn caused a panic.
> Various kernel debugging options (CONFIG_DEBUG_PAGEALLOC,
> CONFIG_SLUB_DEBUG=y...) were on at the time. This only seems to happen
> if the guest is being booted with only one CPU allocated to it.
 
Hi Sitsofe,
I can reproduce the exact issue with the same commit + your kconfig + UP
guest (SMP guest seems ok.)

> [    7.645526] hv_vmbus: registering driver hyperv_fb
> [    7.657553] BUG: unable to handle kernel paging request at
> ffff880077800004
> [    7.658224] IP: [<ffffffff8159a7ac>] hv_ringbuffer_write+0x7c/0x150
> [    7.658224] PGD 2da9067 PUD 2dac067 PMD 7fa27067 PTE
> 8000000077800060
> [    7.658224] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
It seems 
hv_ringbuffer_write() -> 
    hv_get_ringbuffer_availbytes():
        reading rbi->ring_buffer->read_index causes a page fault.

It looks rbi->ring_buffer was unmapped somehow according to the
semantics of CONFIG_DEBUG_PAGEALLOC??? Or, was there a memory
corruption somewhere?

It looks the panic will disappear if the guest isn't configured with a 
"Network Adapter ".

Thanks,
-- Dexuan
