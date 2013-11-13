Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab3KMSY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:24:27 -0500
Received: from mout.gmx.net ([212.227.17.22]:65122 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758796Ab3KMSYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:24:20 -0500
Date: Wed, 13 Nov 2013 19:24:15 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Marek Vasut <marex@denx.de>
Cc: wsa@the-dreams.de, jacmet@sunsite.dk, baohua.song@csr.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: busses: Do not print error message in syslog if no
 ACK received
Message-ID: <20131113182415.GA1458@thinkpad.fritz.box>
References: <1384278336-3694-1-git-send-email-wernerandy@gmx.de>
 <201311121900.59305.marex@denx.de>
 <20131112182344.GA5012@thinkpad.fritz.box>
 <201311121933.41038.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201311121933.41038.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:xbf80NpEgC2K86PRGPeZ/5v3yXu3VweBSJ9A11jJsCtco7aPj5+
 JYs63zL6L9GqBc3t++A/rDw2kSt24h1jyVqDm8OhiaVAncswt4f8QZEXtDVHv6siLA8I9Qf
 Lb4EFRz7Tf1QkaFCxLM8nTpauiOhvs0J6So3uYeHMob0dS+yQqX79NYUJCpuv4N08Y4NJOn
 v9cJrCNBXYDcBUtUk0FQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 07:33:40PM +0100, Marek Vasut wrote:
> Dear Andreas Werner,
> 
> > On Tue, Nov 12, 2013 at 07:00:59PM +0100, Marek Vasut wrote:
> > > Dear Andreas Werner,
> > > 
> > > > Using the i2c-eg20t driver and call i2cdetect or probe on the bus,
> > > > the driver will print a lot of error messages if there was no ACK
> > > > received.
> > > > 
> > > > i2cdetect normally print a table with all the available devices. If
> > > > there is no device on the address, the table will be empty.
> > > > Currently with the i2c-eg20t driver, the table is not visible because
> > > > the error messages destroy the table.
> > > > 
> > > > Error message: pch_i2c_getack return -71
> > > > 
> > > > This patch prevent the driver to print the messages to syslog if debug
> > > > is not set.
> > > > 
> > > > Tested on Intel Atom E6xx and Eg20t Chipset.
> > > > 
> > > > Signed-off-by: Andreas Werner <wernerandy@gmx.de>
> > > > ---
> > > > 
> > > >  drivers/i2c/busses/i2c-eg20t.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/i2c/busses/i2c-eg20t.c
> > > > b/drivers/i2c/busses/i2c-eg20t.c index 0f37529..b10c651 100644
> > > > --- a/drivers/i2c/busses/i2c-eg20t.c
> > > > +++ b/drivers/i2c/busses/i2c-eg20t.c
> > > > @@ -322,7 +322,7 @@ static s32 pch_i2c_getack(struct i2c_algo_pch_data
> > > > *adap) reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
> > > > 
> > > >  	if (reg_val != 0) {
> > > > 
> > > > -		pch_err(adap, "return%d\n", -EPROTO);
> > > > +		pch_dbg(adap, "return%d\n", -EPROTO);
> > > > 
> > > >  		return -EPROTO;
> > > >  	
> > > >  	}
> > > 
> > > I'd just kill the pch_err() line altogether:
> >   But why? I think there a few pch_err message which are interesting to
> > have in syslog, without building the dbg driver.
> 
> See below for explanation why this one particular pch_err() line can go. Sorry 
> if I was not clear enough, I meant only this one particular pch_err() line, NOT 
> all of them.
> 
> > 
> > > if (reg_val)
> > > 
> > > 	return -EPROTO;
> > > 
> > > That is because if you look at the only caller of this function, which is
> > > pch_i2c_wait_for_check_xfer(), you will see that at the only place where
> > > pch_i2c_getack() is called there is already pch_dbg():
> > > 
> > > 369         if (pch_i2c_getack(adap)) {
> > > 370                 pch_dbg(adap, "Receive NACK for slave address"
> > > 371                         "setting\n");
> > > 372                 return -EIO;
> > > 373         }
> > >
Sorry i misunderstood that. You are absolutly right, thats the best solution for that.
Remove the pch_err at getack so that only the pch_dbg get printed where getack is called.
This should be enough information.

 
> > > btw. (idea for subsequent patch) this pch_dbg() should be fixed to be a
> > > one- liner /wrt the text so we can grep for the error messages. Such
> > > text arg should never be split in multiple lines in kernel.
> > 
> >   Ok i will wait a few days for further comments to this patch and then
> >   i will resend the patch with a one liner message.
> 
> Sure, wait at least for Wolfram's consent on this please ;-)
> 
> Best regards,
> Marek Vasut
