Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaBKQ5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:57:55 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.110]:25688 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbaBKQ5v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:57:51 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-4.tower-193.messagelabs.com!1392137868!1737976!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David Dajun Chen" <david.chen@diasemi.com>
Subject: RE: [PATCH V1] da9052: ONKEY: use correct register bit for key
 status
Thread-Topic: [PATCH V1] da9052: ONKEY: use correct register bit for key
 status
Thread-Index: AQHPJ0PNTqAx6W9icUWcVcja7qYrIJqwPjGAgAADhKA=
Date: Tue, 11 Feb 2014 16:57:47 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51BCFD52F3@NB-EX-MBX02.diasemi.com>
References: <201402111610.s1BGAXJo056493@swsrvapps-02.lan>
 <20140211162857.GA12106@core.coreip.homeip.net>
In-Reply-To: <20140211162857.GA12106@core.coreip.homeip.net>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.126]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 11 February 2014 16:29
..[snip]..
> >  static void da9052_onkey_query(struct da9052_onkey *onkey)  {
> > -	int key_stat;
> > +	int ret, key_stat;
> >
> > -	key_stat = da9052_reg_read(onkey->da9052,
> DA9052_EVENT_B_REG);
> > -	if (key_stat < 0) {
> > +	ret = da9052_reg_read(onkey->da9052, DA9052_STATUS_A_REG);
> > +	if (ret < 0) {
> >  		dev_err(onkey->da9052->dev,
> > -			"Failed to read onkey event %d\n", key_stat);
> > +			"Failed to read onkey event err=%d\n", ret);
> > +		key_stat = false;
> 
> Why do you need this assignment? Also, key_stat is integer, why are we
> using boolean values for it?
> 
> >  	} else {
> >  		/*
> >  		 * Since interrupt for deassertion of ONKEY pin is not
> >  		 * generated, onkey event state determines the onkey
> >  		 * button state.
> >  		 */
> > -		key_stat &= DA9052_EVENTB_ENONKEY;
> > +		if (ret & DA9052_STATUSA_NONKEY)
> > +			key_stat = false;
> > +		else
> > +			key_stat = true;
> 
> It seems to me that the relevant changes are replacement of
> DA9052_EVENT_B_REG -> DA9052_STATUS_A_REG in da9052_reg_read()
> and doing:
> 
> 		key_stat &= DA9052_STATUSA_NONKEY;
> 		input_report_key(onkey->input, KEY_POWER, !key_stat);
> 
> Right?

Right as far as the register and the bit within it.

However, should the register read fail due to the PMIC not responding on the i2c bus then the previous code would just loop round the work queue.
By explicitly using key_stat as a boolean it makes the code very clear that in the case of failure a 'false' value is set. As it was the negative value of the error code would be treated as true, since -EFAULT being non-zero will be treated as true.

Tony Olech

> Thanks.
> Dmitry
