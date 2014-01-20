Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaATO0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:26:47 -0500
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:27087
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753759AbaATO0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:26:43 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>
Subject: RE: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHPE1IcCA6lalTOXEyjRgC6v+JOLpqNPxeAgAAUL1CAAAwNgIAAEZOQ///614CAAD8uqA==
Date: Mon, 20 Jan 2014 14:26:39 +0000
Message-ID: <d2d7153f082c46ee93d62fe56e6a80db@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1389938684-29467-1-git-send-email-b35083@freescale.com>
 <1389938684-29467-3-git-send-email-b35083@freescale.com>
 <20140120074019.GF26823@intel.com>
 <43d79ce905e24e9bb58ef49ac19db7d7@BL2PR03MB467.namprd03.prod.outlook.com>
 <20140120093541.GX26823@intel.com>
 <f173c2531461478899818365e06df437@BL2PR03MB467.namprd03.prod.outlook.com>,<20140120102007.GC26823@intel.com>
In-Reply-To: <20140120102007.GC26823@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [180.184.99.38]
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(189002)(51704005)(199002)(377454003)(24454002)(2656002)(66066001)(65816001)(69226001)(92566001)(76482001)(93136001)(74876001)(54356001)(47976001)(49866001)(87266001)(4396001)(53806001)(77982001)(79102001)(56776001)(47736001)(59766001)(74366001)(54316002)(47446002)(87936001)(93516002)(551934002)(31966008)(74662001)(74706001)(86362001)(81816001)(90146001)(74316001)(74502001)(80022001)(46102001)(50986001)(81542001)(76796001)(81342001)(19580405001)(83322001)(76576001)(80976001)(56816005)(83072002)(85852003)(76786001)(85306002)(19580395003)(63696002)(81686001)(33646001)(51856001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB210;H:BL2PR03MB467.namprd03.prod.outlook.com;CLIP:180.184.99.38;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Vinod Koul <vinod.koul@intel.com>
Sent: Monday, January 20, 2014 6:20 PM
To: Lu Jingchang-B35083
Cc: dan.j.williams@intel.com; arnd@arndb.de; shawn.guo@linaro.org; pawel.moll@arm.com; mark.rutland@arm.com; swarren@wwwdotorg.org; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; devicetree@vger.kernel.org; Wang Huan-B18965
Subject: Re: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support

On Mon, Jan 20, 2014 at 11:05:03AM +0000, Jingchang Lu wrote:
>> > > > > +     struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
>> > > > > +     struct dma_slave_config *cfg = (void *)arg;
>> > > > > +     unsigned long flags;
>> > > > > +     LIST_HEAD(head);
>> > > > > +
>> > > > > +     switch (cmd) {
>> > > > > +     case DMA_TERMINATE_ALL:
>> > > > > +             spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
>> > > > > +             fsl_edma_disable_request(fsl_chan);
>> > > > > +             fsl_chan->edesc = NULL;
>> > > > > +             vchan_get_all_descriptors(&fsl_chan->vchan, &head);
>> > > > > +             spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
>> > > > > +             vchan_dma_desc_free_list(&fsl_chan->vchan, &head);
>> > > > > +             return 0;
> >> > > well what happens to the current ongoing transactions, i don't see
> >> those
> >> > > getting
> >> > > terminated?
> >> > The fsl_edma_disable_request(fsl_chan) would end the channel's ongoing
> >> transaction, then
> >> > the eDMA would not response to device dma request, and the
> >> vchan_dma_desc_free_list()
> >> > will release all associate memory. Thanks.
> >> Can you explain a bit more how terminate will happen, given taht you are
> >> using
> >> same thing for pause?
>> It works just like an interrupt controller on irq enable and disable. It has a register called
>> set/clear enable request register(SERQ/CERQ) to enable or disable the DMA request for a given
>> channel. It won't transfer data any more with the enable request register cleared. So for the
>> pause and terminate the pause is the same. And there is no other way to stop the channels.
>well then it is not pause! If you jave no way to stop the channel, you cant
>claim to support pause and resume!

>>Also, for terminate this will be problematic. Assuming you are doing transfers
>and terminate is invoked. Then you will disable irq. The transfers may get stuck
>and periphral clock may go away after transfer so current transaction never gets
>completed, how do we recovery from this?
The clear enable request would isolate the dma request from the eDMA engine, 
and the eDMA engine could not receive any dma request from the device any more,
so the transmission is stopped, all the channel parameters will not be changed any more, and the
eDMA engine will not do any transmission for that channel until the request is enabled
by set enable request. And the channel parameters could be changed when the enable request
cleared.
We have tested the eDMA drive with the SAI audio driver which uses the cyclic dma tranfer, and it
work well.
Thanks.

>Alstly, have you looked at edma driver already existing, any similarties in teh
>controller with that?
Yes, I have notice the TI's edma driver, but they are not the same. So we implement this driver.

Best Regards,
Jingchang