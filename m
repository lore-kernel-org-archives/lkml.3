Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3KQLjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 06:39:18 -0500
Received: from mout.gmx.net ([212.227.17.21]:64197 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab3KQLjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 06:39:12 -0500
Date: Sun, 17 Nov 2013 13:39:02 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: khali@linux-fr.org, jacmet@sunsite.dk, hskinnemoen@gmail.com,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] I2C: busses: i2c-eg20t Do not print error message in
 syslog if no ACK received
Message-ID: <20131117123902.GA3834@awedesk.fritz.box>
References: <1384678731-10399-1-git-send-email-wernerandy@gmx.de>
 <20131117110846.GA3093@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131117110846.GA3093@katana>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Provags-ID: V03:K0:ANnaRq3l9tzMyMv2coecwNuxnOoZrI/9Obhv8UzjuQhMI5zwchN
 gsreOMB/LecZgU93vniJBOxBG+bmgsK+d/vUP+SBfOM2jzi90PmvkJopes0899j+ijGapQ+
 S8VgIXWL6xz9ou7EAK3mmrGbYSsqGBMeFBl/2q7GbmmY5Y5KrL7pm0OqTNJFPWp0ndffFDd
 ixtJvS3gBWhcSRFchTv0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 12:08:46PM +0100, Wolfram Sang wrote:
> On Sun, Nov 17, 2013 at 09:58:51AM +0100, Andreas Werner wrote:
> > Revision 2:
> > 	- delete the pch_err completly instead of changing to pch_dbg
> > 	  because there is already a pch_dbg at the function who calls
> > 	  pch_i2c_getack.
> > 	- Fixed message line issue
> 
> I prefer this below "---" after Signed-off.
Ok i will change it next time.
> 
> > 
> > diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
> > index 0f37529..5c39f90 100644
> > --- a/drivers/i2c/busses/i2c-eg20t.c
> > +++ b/drivers/i2c/busses/i2c-eg20t.c
> > @@ -321,10 +321,8 @@ static s32 pch_i2c_getack(struct i2c_algo_pch_data *adap)
> >  	void __iomem *p = adap->pch_base_address;
> >  	reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
> >  
> > -	if (reg_val != 0) {
> > -		pch_err(adap, "return%d\n", -EPROTO);
> > +	if (reg_val != 0)
> >  		return -EPROTO;
> 
> That could be fixed to -ENXIO according to
> Documentation/i2c/fault-codes.
Yes you are right -ENXIO should returned if no ACK was received.
Is there another reason why pch_i2c_getack returned EPROTO?
May be ENXIO was introduced later?
> 
> > @@ -367,8 +365,7 @@ static int pch_i2c_wait_for_check_xfer(struct i2c_algo_pch_data *adap)
> >  	adap->pch_event_flag = 0;
> >  
> >  	if (pch_i2c_getack(adap)) {
> > -		pch_dbg(adap, "Receive NACK for slave address"
> > -			"setting\n");
> > +		pch_dbg(adap, "Receive NACK for slave address setting\n");
> >  		return -EIO;
> 
> What about returning the value we got from pch_i2c_getack?
> 
EIO is almost ok, because EIO means something went wrong when performing
an I/O operation, but yes we can return the value from pch_i2c_getack (ENXIO)
to get more detailed informations whats going wrong exactly (no ACK reveiced).

I think we can just replace the -EIO with -ENXIO or do you want to pick up the return
vale of pch_i2c_getack and return that ?

Regards

Andy


> Regards,
> 
>    Wolfram
> 


