Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3IQTJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:09:14 -0400
Received: from lmv.inov.pt ([146.193.64.2]:56544 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab3IQTJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:09:11 -0400
Message-ID: <5238A8B1.9080105@inov.pt>
Date: Tue, 17 Sep 2013 20:08:33 +0100
From: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] serial: samsung: add support for manual RTS setting
References: <1378894107-7904-1-git-send-email-jose.goncalves@inov.pt> <35383907.gKXZyKLrYq@amdc1227> <52385327.9020706@inov.pt> <2486439.1yKjlWu5X1@amdc1227>
In-Reply-To: <2486439.1yKjlWu5X1@amdc1227>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-09-2013 16:21, Tomasz Figa wrote:
> I had the following scenario in mind:
> 1) enable CRTSCTS,
> 2) set RTS status using the IOCTL,
> 3) disable CRTSCTS,
> 4) do something,
> 5) enable CRTSCTS again.
>
> I would expect that the value set in point 2 would be still valid after
> point 5, while it will be reset.

Maybe I'm missing something but, as I see it, as soon as you enable AFC in the 
UART controller the RTS pin is no more manually controllable, so after point 5 the 
pin is set automattically by the controller according with the Rx FIFO contents. 
Don't you want to say instead that the value set in 2) will be valid in 4)?

>
>> Regarding port capability, if it's decided to validate it in
>> s3c24xx_serial_get_mctrl() and s3c24xx_serial_set_mctrl() it should also
>> be validated here. The question is how to validate for the full spectrum
>> of SoCs that this driver supports?
> Hmm, since the driver is already broken in this aspect, ignoring this in
> your patch might be fine for now. A follow up patch fixing this would be
> welcome, though. However I don't have any good idea how to implement this
> at the moment.
>
> First thing that comes to my mind is using the variant data structures to
> store information about per port capability (different port FIFO sizes are
> already handled like this), but this would imply splitting some of the
> groups, as S5PC100 supports modem control for different subset of ports
> than S3C64xx, while they both use the same variant data.
>
> Using device tree, this could be passed as an extra property, but some of
> the platforms using samsung serial driver can be booted without device
> tree, so it wouldn't cover all the cases.

So, as I understand, for now is enough to resubmit the patch with the UMCON 
register setting in s3c24xx_serial_set_termios() preserving the previous manual 
setting of the RTS pin, correct? I was thinking in something like this:

     umcon = rd_regb(port, S3C2410_UMCON);
     if (termios->c_cflag & CRTSCTS) {
         umcon |= S3C2410_UMCOM_AFC;
         umcon &= ~S3C2412_UMCON_AFC_8; // Disable RTS when RX FIFO contains 63 bytes
     } else {
         umcon &= ~S3C2410_UMCOM_AFC;
     }
     wr_regl(port, S3C2410_UMCON, umcon);

> Best regards,
> Tomasz
>
> P.S. Please remember to add all the relevant people to Cc when sending
> patches. You can use scripts/get_maintainer.pl to find them.

OK, sorry for that.

Bet regards,
José Gonçalves
