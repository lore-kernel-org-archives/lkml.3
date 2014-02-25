Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaBYH0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:26:37 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53523 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbaBYH0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:26:36 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Peter Chen <peter.chen@freescale.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 23:26:26 -0800
Subject: RE: [PATCH 3/6] usb: gadget: mv_udc: clear corresponding interrupt
 when flush fifo
Thread-Topic: [PATCH 3/6] usb: gadget: mv_udc: clear corresponding interrupt
 when flush fifo
Thread-Index: Ac8x1OPknrN099Y2RCifgmcsCSWNFQAJbwCA
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135AB@SC-VEXCH4.marvell.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-4-git-send-email-zhangwm@marvell.com>
 <20140225015923.GE7540@shlinux1.ap.freescale.net>
In-Reply-To: <20140225015923.GE7540@shlinux1.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-25_01:2014-02-25,2014-02-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402240226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1P7QhFp020450



> -----Original Message-----
> From: Peter Chen [mailto:peter.chen@freescale.com]
> Sent: 2014Äê2ÔÂ25ÈÕ 9:59
> To: Neil Zhang
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 3/6] usb: gadget: mv_udc: clear corresponding interrupt
> when flush fifo
> 
> On Mon, Feb 24, 2014 at 04:03:13PM +0800, Neil Zhang wrote:
> > The interruts are useless when this endpoint is going to be flushed.
> > Especially in the enumeration phase, let's take get device description
> > for example.
> > 1. Device doesn't ACK the status package from host in time due to irq
> > is disabled by some module.
> > 2. Host find no ACK in time, and send another request.
> 
> Why device does not send NAK at that time?
> Besides, you can try to prime status at data stage, it can also avoid the
> problem usb 2.0 8.5.3.3 "Error Handling on the Last Data Transaction"
> described.
> 
> > 3. Device gets the chance to handle the interrupt, the sequence is as
> > following.
> > 	a. Flush pending requests in ep0.
> > 	b. Queue a request in ep0 according to host's request and change
> > 	   the ep0 state to DATA_STATE_XMIT.
> > 	c. Handle the pending interrupt for the last status package. But
> > 	   actually it will check the new added request instead of the status
> > 	   package and because of wront ep0 state, device will request an
> 
> %s/wront/wrong


Thanks for the catch.
> 
> Peter
> 
> > 	   unexpected status package from host.
> > 	d. The ep0 state is going mad.
> >
> > The solution is that we need clear the pending corresponding interrupt
> > as well as flush endpoint.
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  drivers/usb/gadget/mv_udc_core.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/usb/gadget/mv_udc_core.c
> > b/drivers/usb/gadget/mv_udc_core.c
> > index 657ac5c..d5a9bdf 100644
> > --- a/drivers/usb/gadget/mv_udc_core.c
> > +++ b/drivers/usb/gadget/mv_udc_core.c
> > @@ -692,6 +692,8 @@ static void mv_ep_fifo_flush(struct usb_ep *_ep)
> >  		}
> >  		loops--;
> >  	} while (readl(&udc->op_regs->epstatus) & bit_pos);
> > +
> > +	writel(bit_pos, &udc->op_regs->epcomplete);
> >  }
> >
> >  /* queues (submits) an I/O request to an endpoint */
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> 

Best Regards,
Neil Zhang

> --
> 
> Best Regards,
> Peter Chen

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
