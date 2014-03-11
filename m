Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaCKEt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 00:49:27 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:37883
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbaCKEtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 00:49:25 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z54eehz98dIc89bh936eI542I1432Id799h4015Idbb0izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1d7338h1de098h177df4h17326ah8275bh8275dh1de097h186068hz2fh95h109h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
From: Suneel Garapati <suneel.garapati@xilinx.com>
To: Soren Brinkmann <sorenb@xilinx.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Michal Simek <michals@xilinx.com>
CC: git <git@xilinx.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] i2c-cadence: Do not let signals interrupt I2C transfers
Thread-Topic: [PATCH] i2c-cadence: Do not let signals interrupt I2C transfers
Thread-Index: AQHPPFGzEZhsY7pg8UiMRXC2bNGJEZraWWAAgAD3IUA=
Date: Tue, 11 Mar 2014 04:49:16 +0000
References: <1394449954-10797-1-git-send-email-mike.looijmans@topic.nl>
 <20140310215952.GF13293@xsjandreislx>
In-Reply-To: <20140310215952.GF13293@xsjandreislx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.97.56]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <b6f0755f-cfc9-4962-851f-5eeac767e93e@AM1EHSMHS008.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2B4naKN022492

Hi Mike/Soren,

> -----Original Message-----
> From: SÃ¶ren Brinkmann [mailto:soren.brinkmann@xilinx.com]
> Sent: Tuesday, March 11, 2014 03:30
> To: Mike Looijmans; Michal Simek
> Cc: git; wsa@the-dreams.de; linux-i2c@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] i2c-cadence: Do not let signals interrupt I2C transfers
>
> Hi Mike,
>
> The cadence driver is not in mainline yet. I think for our vendor tree we can
> pretty much take it this way.
> Regarding getting this into mainline, I'll send another iteration of the change
> set and include these changes.
>
> On Mon, 2014-03-10 at 12:12PM +0100, Mike Looijmans wrote:
> > Pressing CTRL-C while communicating with an I2C device leads to
> > erratic behaviour. The cause is that the controller will interrupt the
> > I2C transfer in progress, and leave the client device in an undefined
> > state. Many drivers do not handle error return codes on I2C transfers.
> > The calling driver has no way of telling how much of the transfer has
> > actually completed, so it cannot reliably determine the device's state.
> >
> > The best solution here is to not handle signals in the I2C bus driver
> > at all, but always complete a transaction before returning control.
> >
> > See for a related patch and discussion on this topic:
> > http://lkml.org/lkml/2014/1/9/246
>
> Can we get your Signed-off-by, please?
>
> > ---
> >  drivers/i2c/busses/i2c-cadence.c |   12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-cadence.c
> > b/drivers/i2c/busses/i2c-cadence.c
> > index 86713d6..32ce2ee 100644
> > --- a/drivers/i2c/busses/i2c-cadence.c
> > +++ b/drivers/i2c/busses/i2c-cadence.c
> > @@ -452,16 +452,12 @@ static int cdns_i2c_process_msg(struct cdns_i2c
> *id, struct i2c_msg *msg,
> >                     cdns_i2c_msend(id);
> >
> >             /* Wait for the signal of completion */
> > -           ret = wait_for_completion_interruptible_timeout(
> > -                                                   &id->xfer_done, HZ);
> > -           if (ret < 1) {
> > +           ret = wait_for_completion_timeout(&id->xfer_done, HZ);
> > +           if (ret == 0) {
>
> To match the style used throughout the file this should just be
>       if (!ret) {
Instead of discarding Ctrl+C, Can we wait until the current msg transfer completes
[to avoid client undefined state or re-init the host to a known state]

I see da-vinci driver handling in a similar way.

Regards,
Suneel

>
>
> Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>
>       Thanks,
>       SÃ¶ren



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
