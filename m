Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaANTGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:06:45 -0500
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:50647 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751462AbaANTGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:06:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12555:12679:12740:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glove28_39ff9fd954a3c
X-Filterd-Recvd-Size: 2849
Message-ID: <1389726397.24849.47.camel@joe-AO722>
Subject: Re: [PATCH 3/3] i2c: i2c-core: fix coding style issues in i2c-core.c
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 14 Jan 2014 11:06:37 -0800
In-Reply-To: <20140114183845.GD10340@katana>
References: <525C0CDB.6020305@gmail.com> <20140114183845.GD10340@katana>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 19:38 +0100, Wolfram Sang wrote:
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -1737,9 +1737,9 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> >  		for (ret = 0; ret < num; ret++) {
> >  			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=0x%02x, len=%d%s\n",
> >  				ret,
> > -				((msgs[ret].flags & I2C_M_RD) ? 'R' : 'W'),
> > +				msgs[ret].flags & I2C_M_RD ? 'R' : 'W',
> >  				msgs[ret].addr, msgs[ret].len,
> > -				(msgs[ret].flags & I2C_M_RECV_LEN) ? "+" : "");
> > +				msgs[ret].flags & I2C_M_RECV_LEN ? "+" : "");
> 
> Don't spend time changing too much here like the paranthesis. It will
> probably be removed soon in favour of the tracing approach.

That'd be good.  There are a lot of function tracing style
dev_dbg uses in i2c-core that can be removed.

Just an fyi not to Raghavendra:

This sort of loop could have been further modified removing
the unnecessary #if DEBUG/#endif too

Also, reusing ret for a loop index is efficient, but a bit odd.

Maybe something like:

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index d74c0b3..5ca078e 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1758,14 +1758,13 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	 */
 
 	if (adap->algo->master_xfer) {
-#ifdef DEBUG
-		for (ret = 0; ret < num; ret++) {
-			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=0x%02x, "
-				"len=%d%s\n", ret, (msgs[ret].flags & I2C_M_RD)
-				? 'R' : 'W', msgs[ret].addr, msgs[ret].len,
-				(msgs[ret].flags & I2C_M_RECV_LEN) ? "+" : "");
-		}
-#endif
+		int i;
+
+		for (i = 0; i < num; i++)
+			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=0x%02x, len=%d%s\n",
+				ret, msgs[i].flags & I2C_M_RD ? 'R' : 'W',
+				msgs[i].addr, msgs[i].len,
+				msgs[i].flags & I2C_M_RECV_LEN ? "+" : "");
 
 		if (in_atomic() || irqs_disabled()) {
 			ret = i2c_trylock_adapter(adap);


