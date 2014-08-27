Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935755AbaH0SqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:46:00 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:35676
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935468AbaH0Sp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:45:59 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>, Dexuan Cui <decui@microsoft.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjYjJn6yhiZAUmfcA+tXSCe25vhYa6AgAA9PQCAARoEAIABlgcAgAANEQCAAAyZgIAAIPwAgAAi6gCAABhF8A==
Date: Wed, 27 Aug 2014 18:45:55 +0000
Message-ID: <51ae44fcae424365a6d78f3597175d77@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140825174132.GA17681@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827121559.GA14286@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827161900.GA25326@sucs.org>
In-Reply-To: <20140827161900.GA25326@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(24454002)(189002)(377454003)(199003)(85306004)(90102001)(64706001)(108616004)(93886004)(76576001)(19580395003)(33646002)(19580405001)(83322001)(81342001)(2421001)(20776003)(105586002)(2656002)(99396002)(46102001)(101416001)(31966008)(76176999)(74502001)(50986999)(54356999)(106116001)(1511001)(79102001)(74662001)(95666004)(86362001)(77096002)(21056001)(85852003)(76482001)(106356001)(107046002)(4396001)(80022001)(74316001)(81542001)(87936001)(86612001)(92566001)(99286002)(83072002)(77982001)(575784001)(7059011)(24736002)(3826002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Wednesday, August 27, 2014 9:19 AM
> To: Dexuan Cui
> Cc: KY Srinivasan; Greg Kroah-Hartman; Haiyang Zhang;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
> ffff880077800004 (hv_ringbuffer_write)
> 
> On Wed, Aug 27, 2014 at 02:14:02PM +0000, Dexuan Cui wrote:
> > > -----Original Message-----
> > > From: Sitsofe Wheeler
> > > Sent: Wednesday, August 27, 2014 20:16 PM
> >
> > > > I'm making a patch for this.
> > Please see the end of the mail for the inline patch and try it.
> > (the patch hasn't been rebased against KY's patchset)
> 
> <snip>
> 
> > BTW, with the patch below, hyperv_fb can work now, BUT,
> > *occasionally*,
> > storvsc_probe() -> ... -> vmbus_open() -> can fail due to
> > HV_STATUS_INVALID_ALIGNMENT...
> 
> I applied your new patch on top of KY's pieces (it applied cleanly) and while it
> doesn't blow up, one warning is printed out and the UP boot seemed to stall
> after input: TPPS/2 message (but pressing ctrl-alt-delete allows the system to
> reboot cleanly).

First let me thank you guys for looking into this issue. Looking at your dmesg, it looked like storvsc probe failed as Dexuan had seen. Since the failure appears to be alignment related, perhaps we could test with allocating a page all the time (and getting rid of the kmalloc). Sitsofe, here is a patch based on Dexuan's patch. If this works, I will probably minimize failure cases by pre-allocating per-cpu pages for this.:

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index edfc848..0ca0cba 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -217,25 +217,17 @@ int hv_post_message(union hv_connection_id connection_id,
                  enum hv_message_type message_type,
                  void *payload, size_t payload_size)
 {
-       struct aligned_input {
-               u64 alignment8;
-               struct hv_input_post_message msg;
-       };

        struct hv_input_post_message *aligned_msg;
        u16 status;
-       unsigned long addr;

        if (payload_size > HV_MESSAGE_PAYLOAD_BYTE_COUNT)
                return -EMSGSIZE;

-       addr = (unsigned long)kmalloc(sizeof(struct aligned_input), GFP_ATOMIC);
-       if (!addr)
+       aligned_msg = (struct hv_input_post_message *)get_zeroed_page(GFP_ATOMIC);
+       if (!aligned_msg)
                return -ENOMEM;

-       aligned_msg = (struct hv_input_post_message *)
-                       (ALIGN(addr, HV_HYPERCALL_PARAM_ALIGN));
-
        aligned_msg->connectionid = connection_id;
        aligned_msg->message_type = message_type;
        aligned_msg->payload_size = payload_size;
@@ -244,7 +236,7 @@ int hv_post_message(union hv_connection_id connection_id,
        status = do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL)
                & 0xFFFF;

-       kfree((void *)addr);
+       free_page((unsigned long)aligned_msg);

        return status;
 }
--
1.7.4.1

