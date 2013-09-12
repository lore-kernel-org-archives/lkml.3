Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3ILAgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:36:51 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:31478
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316Ab3ILAgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:36:50 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: vmbus: fix error return code in
 vmbus_connect()
Thread-Topic: [PATCH] Drivers: hv: vmbus: fix error return code in
 vmbus_connect()
Thread-Index: AQHOruDXfDzmhxyj6EW2aZqcUVuzqJnA9YdQgABJ94CAAAFCwA==
Date: Thu, 12 Sep 2013 00:36:46 +0000
Message-ID: <3e6ec2c583e14f17af1a5d2bd6aaab82@SN2PR03MB061.namprd03.prod.outlook.com>
References: <CAPgLHd-5dt70Tn+3SXXu9QudpwpHaO1FNf-LZWQmDq413KLbQg@mail.gmail.com>
	<7463564f181640d2ad9658ce0ef7a7b5@SN2PR03MB061.namprd03.prod.outlook.com>
 <CAPgLHd_7MKG75y0NiXFVV-w8dtRWPdT8CtrMWyN_a1LM0MD9Lw@mail.gmail.com>
In-Reply-To: <CAPgLHd_7MKG75y0NiXFVV-w8dtRWPdT8CtrMWyN_a1LM0MD9Lw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::5]
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(479174003)(377454003)(24454002)(13464003)(51704005)(189002)(199002)(81816001)(56816003)(59766001)(81686001)(76796001)(76786001)(50986001)(80976001)(77096001)(77982001)(56776001)(54316002)(47736001)(47976001)(49866001)(63696002)(76576001)(65816001)(79102001)(54356001)(74366001)(74316001)(76482001)(33646001)(31966008)(74662001)(83322001)(19580395003)(19580405001)(46102001)(83072001)(47446002)(74502001)(51856001)(4396001)(74876001)(53806001)(80022001)(81342001)(69226001)(74706001)(81542001)(24736002)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ed43::5;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> Sent: Wednesday, September 11, 2013 5:26 PM
> To: KY Srinivasan
> Cc: Haiyang Zhang; yongjun_wei@trendmicro.com.cn;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Drivers: hv: vmbus: fix error return code in
> vmbus_connect()
> 
> On 09/12/2013 04:03 AM, KY Srinivasan wrote:
> >
> >> -----Original Message-----
> >> From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> >> Sent: Wednesday, September 11, 2013 4:20 AM
> >> To: KY Srinivasan; Haiyang Zhang
> >> Cc: yongjun_wei@trendmicro.com.cn; devel@linuxdriverproject.org; linux-
> >> kernel@vger.kernel.org
> >> Subject: [PATCH] Drivers: hv: vmbus: fix error return code in vmbus_connect()
> >>
> >> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >>
> >> Fix to return -EINVAL in the version check error handling
> >> case instead of 0, as done elsewhere in this function.
> > The return will not be zero in this case. If you look at the function
> > vmbus_negotiate_version(), in case the host refuses the version, the
> > return value will be set to -ECONNREFUSED
> 
> look at the code:
> 
>  196         do {
>  197                 ret = vmbus_negotiate_version(msginfo, version);
>  198                 if (ret)
>  199                         goto cleanup;
>  200
>  201                 if (vmbus_connection.conn_state == CONNECTED)
>  202                         break;
>  203
>  204                 version = vmbus_get_next_version(version);
>  205         } while (version != VERSION_INVAL);
>  206
>  207         if (version == VERSION_INVAL)
>  208                 goto cleanup;
> 
> if function vmbus_negotiate_version() return error, the code
> will goto cleanup.
> 
> If 'version == VERSION_INVAL' is true, I think we tried all
> of the VERSION_WS2008/VERSION_WIN7/VERSION_WIN8, but still
> can not get the connection.

When you try a given version, vmbus_negotiate_version() returns an error code
if the host does not support that version. Hence, in this code you will not be able to
run on anything prior to ws2012. I have already sent in a patch to fix that - if we timeout
only then we jump to cleanup. In any event, if we tried all versions and none was acceptable
to the host, we would return the value from vmbus_negotiate_version().

K. Y
> 
> 
> 
> 

