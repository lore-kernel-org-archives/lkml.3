Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3IQPV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:21:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19149 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3IQPV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:21:56 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-86-523873923395
From: Tomasz Figa <t.figa@samsung.com>
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] serial: samsung: add support for manual RTS setting
Date: Tue, 17 Sep 2013 17:21:46 +0200
Message-id: <2486439.1yKjlWu5X1@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <52385327.9020706@inov.pt>
References: <1378894107-7904-1-git-send-email-jose.goncalves@inov.pt>
 <35383907.gKXZyKLrYq@amdc1227> <52385327.9020706@inov.pt>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xq7qTii2CDD7slLdoXryezeL/o9es
	Fh+b1jJZXN41h81ixvl9TBZnFveyWxx+087qwO7xePtdJo/9c9ewe/RtWcXosf3aPGaPz5vk
	AlijuGxSUnMyy1KL9O0SuDIO9bxmKnimXXFz8xHWBsb3Sl2MnBwSAiYSLx9dYoSwxSQu3FvP
	1sXIxSEksJRR4mz3diini0liy8f97CBVbAJqEp8bHrGB2CICVRKrFvWyghQxC5xglLj4egfQ
	KA4OYQEPidUXU0BqWARUJTo777CA2LwCmhJtG5+wgtj8AuoS77Y9ZQKxRQVcJT4t3Ag2nxMo
	PuvFNBaIxY2MEqt2nIRqFpT4MfkemM0soC3x5N0FVghbR6L3+zfmCYyCs5CUzUJSNgtJ2QJG
	5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIRHwZQfj4mNWhxgFOBiVeHg/yJgHCbEmlhVX
	5h5ilOBgVhLhbcm2CBLiTUmsrEotyo8vKs1JLT7EyMTBKdXAGFOkacMqI7TEzUzrMKP8N0NF
	3dxVx7KqZG6cDV//beHFtX+PeMtfqrnkx7m5keGO5ZfNJ80e9Tl+SlFxszefWxdw7TFb+MOt
	E/ayXBTOt/x7tSWsNm66X6pf1bfPXLl/+u9uLGj9tbr08seEJruD3T+L7jPMufzz96TDIruF
	g5uPnvS6MH/9XyWW4oxEQy3mouJEADAF4WteAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ccing Greg and Sylwester]

On Tuesday 17 of September 2013 14:03:35 José Miguel Gonçalves wrote:
> Hi Tomasz,
> 
> On 17-09-2013 11:18, Tomasz Figa wrote:
> > Hi José,
> > 
> > Please see my comments below.
> > 
> > On Wednesday 11 of September 2013 11:08:27 José Miguel Gonçalves wrote:
> >> The Samsung serial driver currently does not support setting the
> >> RTS pin with an ioctl(TIOCMSET) call. This patch adds this support.
> >> 
> >> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> >> ---
> >> 
> >>   drivers/tty/serial/samsung.c |   17 ++++++++++++++---
> >>   1 file changed, 14 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/drivers/tty/serial/samsung.c
> >> b/drivers/tty/serial/samsung.c
> >> index f3dfa19..e5dd808 100644
> >> --- a/drivers/tty/serial/samsung.c
> >> +++ b/drivers/tty/serial/samsung.c
> >> @@ -407,7 +407,14 @@ static unsigned int
> >> s3c24xx_serial_get_mctrl(struct
> >> uart_port *port)
> >> 
> >>   static void s3c24xx_serial_set_mctrl(struct uart_port *port,
> >>   unsigned
> >> 
> >> int mctrl) {
> >> -	/* todo - possibly remove AFC and do manual CTS */
> >> +	unsigned int umcon = rd_regl(port, S3C2410_UMCON);
> >> +
> >> +	if (mctrl & TIOCM_RTS)
> >> +		umcon |= S3C2410_UMCOM_RTS_LOW;
> >> +	else
> >> +		umcon &= ~S3C2410_UMCOM_RTS_LOW;
> >> +
> >> +	wr_regl(port, S3C2410_UMCON, umcon);
> > 
> > I wonder if port capability shouldn't be considered here. Depending on
> > SoC, only selected ports provide modem control capability.
> > 
> > For example on S3C64xx only ports 0 and 1 support modem control, while
> > ports 2 and 3 don't.
> 
> Same for S3C2416. I also wondered that, but while I have information for
> all S3C24xx chips and for those a simple test ( port->line < 2) would
> validate this, I don't know about other SoCs this driver supports.
> Bearing this in mind and also that the current implementation of
> s3c24xx_serial_get_mctrl() does not check also for which port it
> applies, I opted for this solution.

See below.

> >>   }
> >>   
> >>   static void s3c24xx_serial_break_ctl(struct uart_port *port, int
> >> 
> >> break_state) @@ -774,8 +781,6 @@ static void
> >> s3c24xx_serial_set_termios(struct uart_port *port, if
> >> (termios->c_cflag
> >> & CSTOPB)
> >> 
> >>   		ulcon |= S3C2410_LCON_STOPB;
> >> 
> >> -	umcon = (termios->c_cflag & CRTSCTS) ? S3C2410_UMCOM_AFC : 0;
> >> -
> >> 
> >>   	if (termios->c_cflag & PARENB) {
> >>   	
> >>   		if (termios->c_cflag & PARODD)
> >>   		
> >>   			ulcon |= S3C2410_LCON_PODD;
> >> 
> >> @@ -792,6 +797,12 @@ static void s3c24xx_serial_set_termios(struct
> >> uart_port *port,
> >> 
> >>   	wr_regl(port, S3C2410_ULCON, ulcon);
> >>   	wr_regl(port, S3C2410_UBRDIV, quot);
> >> 
> >> +
> >> +	if (termios->c_cflag & CRTSCTS)
> >> +		umcon = S3C2410_UMCOM_AFC;
> > 
> > Is it correct to override the last manual RTS value set to this
> > register
> > when activating manual flow control?
> > 
> > Shouldn't the code be more like the following:
> > 	umcon = rd_regb(port, S3C2410_UMCON);
> > 	if (termios->c_cflag & CRTSCTS)
> > 	
> > 		umcon |= S3C2410_UMCOM_AFC;
> > 	
> > 	else
> > 	
> > 		umcon &= ~S3C2410_UMCOM_AFC;
> > 	
> > 	wr_regl(port, S3C2410_UMCON, umcon);
> > 
> > Probably port capability should be considered here as well.
> 
> Looking at the S3C24xx user manuals I've seen that if you set the
> automatic flow control (AFC) with the S3C2410_UMCOM_AFC mask, the UART
> controller ignores the manual RTS setting value with the
> S3C2410_UMCOM_RTS_LOW bitmask, so it is not necessary to do that. Also,
> the upper bits of UMCON control the FIFO level to trigger the AFC and
> you should initialize these bits when using AFC (I've set these to 0 to
> use full FIFO, as it was previously).

I had the following scenario in mind:
1) enable CRTSCTS,
2) set RTS status using the IOCTL,
3) disable CRTSCTS,
4) do something,
5) enable CRTSCTS again.

I would expect that the value set in point 2 would be still valid after 
point 5, while it will be reset.

> Regarding port capability, if it's decided to validate it in
> s3c24xx_serial_get_mctrl() and s3c24xx_serial_set_mctrl() it should also
> be validated here. The question is how to validate for the full spectrum
> of SoCs that this driver supports?

Hmm, since the driver is already broken in this aspect, ignoring this in 
your patch might be fine for now. A follow up patch fixing this would be 
welcome, though. However I don't have any good idea how to implement this 
at the moment.

First thing that comes to my mind is using the variant data structures to 
store information about per port capability (different port FIFO sizes are 
already handled like this), but this would imply splitting some of the 
groups, as S5PC100 supports modem control for different subset of ports 
than S3C64xx, while they both use the same variant data.

Using device tree, this could be passed as an extra property, but some of 
the platforms using samsung serial driver can be booted without device 
tree, so it wouldn't cover all the cases.

Best regards,
Tomasz

P.S. Please remember to add all the relevant people to Cc when sending 
patches. You can use scripts/get_maintainer.pl to find them.

