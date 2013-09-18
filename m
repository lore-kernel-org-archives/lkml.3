Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab3IRJlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:41:05 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42678 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3IRJlB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:41:01 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-04-5239752be6b4
From: Tomasz Figa <t.figa@samsung.com>
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] serial: samsung: add support for manual RTS setting
Date: Wed, 18 Sep 2013 11:40:51 +0200
Message-id: <2325055.YfxTctqBtd@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <5238A8B1.9080105@inov.pt>
References: <1378894107-7904-1-git-send-email-jose.goncalves@inov.pt>
 <2486439.1yKjlWu5X1@amdc1227> <5238A8B1.9080105@inov.pt>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xq7rapZZBBvufiVs0L17PZvH/0WtW
	i49Na5ksLu+aw2Yx4/w+Joszi3vZLQ6/aWd1YPd4vP0uk8f+uWvYPfq2rGL02H5tHrPH501y
	AaxRXDYpqTmZZalF+nYJXBmnprxmKmgSq/i3dhJTA+MHgS5GDg4JAROJvudMXYycQKaYxIV7
	69m6GLk4hASWMkr877kB5XQxSczunMEKUsUmoCbxueERG4gtIuAuMWXGekaQImaB34wSUz4e
	YQKZKizgIbH6YgpIDYuAqsSex/PAenkFNCVeXn4Jto1fQF3i3banYLaogKvEp4Ub2UFaOYHi
	zXvkIPY2MEpse7yKDaJXUOLH5HssIDazgLbEk3cXWCFsHYne79+YJzAKzkJSNgtJ2SwkZQsY
	mVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihAT/lx2Mi49ZHWIU4GBU4uG9UG4RJMSaWFZc
	mXuIUYKDWUmEVzLLMkiINyWxsiq1KD++qDQntfgQIxMHp1QDYz6fwr5js7slTnyPU7+RkOZp
	3Gq0ZCP7ZDZOw0M7dyxklmaskrcLLdzX/bZWRJ15ctJHZz/J7bHBCVVLj/xy+Woa1FAfPvHd
	RgMfzqQORtG7XSsWlOfcdBZbYmW12ClP3e7Qfun0Djm/+RzCQYEOT3bJsau6a9YeOcLbJ2U0
	c7vg2+sO2xcrsRRnJBpqMRcVJwIAlJvgRVwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 of September 2013 20:08:33 José Miguel Gonçalves wrote:
> On 17-09-2013 16:21, Tomasz Figa wrote:
> > I had the following scenario in mind:
> > 1) enable CRTSCTS,
> > 2) set RTS status using the IOCTL,
> > 3) disable CRTSCTS,
> > 4) do something,
> > 5) enable CRTSCTS again.
> > 
> > I would expect that the value set in point 2 would be still valid after
> > point 5, while it will be reset.
> 
> Maybe I'm missing something but, as I see it, as soon as you enable AFC
> in the UART controller the RTS pin is no more manually controllable, so
> after point 5 the pin is set automattically by the controller according
> with the Rx FIFO contents. Don't you want to say instead that the value
> set in 2) will be valid in 4)?

Ahh, right, I inverted CRTSCTS bit polarity in points 1, 3 and 5. It should 
be:
1) disable CRTSCTS,
2) set RTS status using the IOCTL,
3) enable CRTSCTS,
4) do something,
5) disable CRTSCTS again.

> >> Regarding port capability, if it's decided to validate it in
> >> s3c24xx_serial_get_mctrl() and s3c24xx_serial_set_mctrl() it should
> >> also
> >> be validated here. The question is how to validate for the full
> >> spectrum
> >> of SoCs that this driver supports?
> > 
> > Hmm, since the driver is already broken in this aspect, ignoring this
> > in
> > your patch might be fine for now. A follow up patch fixing this would
> > be
> > welcome, though. However I don't have any good idea how to implement
> > this at the moment.
> > 
> > First thing that comes to my mind is using the variant data structures
> > to store information about per port capability (different port FIFO
> > sizes are already handled like this), but this would imply splitting
> > some of the groups, as S5PC100 supports modem control for different
> > subset of ports than S3C64xx, while they both use the same variant
> > data.
> > 
> > Using device tree, this could be passed as an extra property, but some
> > of the platforms using samsung serial driver can be booted without
> > device tree, so it wouldn't cover all the cases.
> 
> So, as I understand, for now is enough to resubmit the patch with the
> UMCON register setting in s3c24xx_serial_set_termios() preserving the
> previous manual setting of the RTS pin, correct? I was thinking in
> something like this:
> 
>      umcon = rd_regb(port, S3C2410_UMCON);
>      if (termios->c_cflag & CRTSCTS) {
>          umcon |= S3C2410_UMCOM_AFC;
>          umcon &= ~S3C2412_UMCON_AFC_8; // Disable RTS when RX FIFO
> contains 63 bytes } else {
>          umcon &= ~S3C2410_UMCOM_AFC;
>      }
>      wr_regl(port, S3C2410_UMCON, umcon);

Yes, this looks fine.

Best regards,
Tomasz

