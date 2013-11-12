Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3KLSdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:33:51 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:50818 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3KLSdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:33:47 -0500
X-Auth-Info: /6r/CKMnVBDQihTZ7wbTgCuDA0MC43drfproDMdmmBo=
From: Marek Vasut <marex@denx.de>
To: Andreas Werner <wernerandy@gmx.de>
Subject: Re: [PATCH] I2C: busses: Do not print error message in syslog if no ACK received
Date: Tue, 12 Nov 2013 19:33:40 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: wsa@the-dreams.de, jacmet@sunsite.dk, baohua.song@csr.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1384278336-3694-1-git-send-email-wernerandy@gmx.de> <201311121900.59305.marex@denx.de> <20131112182344.GA5012@thinkpad.fritz.box>
In-Reply-To: <20131112182344.GA5012@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201311121933.41038.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andreas Werner,

> On Tue, Nov 12, 2013 at 07:00:59PM +0100, Marek Vasut wrote:
> > Dear Andreas Werner,
> > 
> > > Using the i2c-eg20t driver and call i2cdetect or probe on the bus,
> > > the driver will print a lot of error messages if there was no ACK
> > > received.
> > > 
> > > i2cdetect normally print a table with all the available devices. If
> > > there is no device on the address, the table will be empty.
> > > Currently with the i2c-eg20t driver, the table is not visible because
> > > the error messages destroy the table.
> > > 
> > > Error message: pch_i2c_getack return -71
> > > 
> > > This patch prevent the driver to print the messages to syslog if debug
> > > is not set.
> > > 
> > > Tested on Intel Atom E6xx and Eg20t Chipset.
> > > 
> > > Signed-off-by: Andreas Werner <wernerandy@gmx.de>
> > > ---
> > > 
> > >  drivers/i2c/busses/i2c-eg20t.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/i2c/busses/i2c-eg20t.c
> > > b/drivers/i2c/busses/i2c-eg20t.c index 0f37529..b10c651 100644
> > > --- a/drivers/i2c/busses/i2c-eg20t.c
> > > +++ b/drivers/i2c/busses/i2c-eg20t.c
> > > @@ -322,7 +322,7 @@ static s32 pch_i2c_getack(struct i2c_algo_pch_data
> > > *adap) reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
> > > 
> > >  	if (reg_val != 0) {
> > > 
> > > -		pch_err(adap, "return%d\n", -EPROTO);
> > > +		pch_dbg(adap, "return%d\n", -EPROTO);
> > > 
> > >  		return -EPROTO;
> > >  	
> > >  	}
> > 
> > I'd just kill the pch_err() line altogether:
>   But why? I think there a few pch_err message which are interesting to
> have in syslog, without building the dbg driver.

See below for explanation why this one particular pch_err() line can go. Sorry 
if I was not clear enough, I meant only this one particular pch_err() line, NOT 
all of them.

> 
> > if (reg_val)
> > 
> > 	return -EPROTO;
> > 
> > That is because if you look at the only caller of this function, which is
> > pch_i2c_wait_for_check_xfer(), you will see that at the only place where
> > pch_i2c_getack() is called there is already pch_dbg():
> > 
> > 369         if (pch_i2c_getack(adap)) {
> > 370                 pch_dbg(adap, "Receive NACK for slave address"
> > 371                         "setting\n");
> > 372                 return -EIO;
> > 373         }
> > 
> > btw. (idea for subsequent patch) this pch_dbg() should be fixed to be a
> > one- liner /wrt the text so we can grep for the error messages. Such
> > text arg should never be split in multiple lines in kernel.
> 
>   Ok i will wait a few days for further comments to this patch and then
>   i will resend the patch with a one liner message.

Sure, wait at least for Wolfram's consent on this please ;-)

Best regards,
Marek Vasut
