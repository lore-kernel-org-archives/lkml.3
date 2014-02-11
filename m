Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaBKRG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:06:28 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63300 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaBKRG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:06:27 -0500
Date: Tue, 11 Feb 2014 09:06:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1] da9052: ONKEY: use correct register bit for key status
Message-ID: <20140211170621.GA13049@core.coreip.homeip.net>
References: <201402111610.s1BGAXJo056493@swsrvapps-02.lan>
 <20140211162857.GA12106@core.coreip.homeip.net>
 <24DF37198A1E704D9811D8F72B87EB51BCFD52F3@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51BCFD52F3@NB-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:57:47PM +0000, Opensource [Anthony Olech] wrote:
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: 11 February 2014 16:29
> ..[snip]..
> > >  static void da9052_onkey_query(struct da9052_onkey *onkey)  {
> > > -	int key_stat;
> > > +	int ret, key_stat;
> > >
> > > -	key_stat = da9052_reg_read(onkey->da9052,
> > DA9052_EVENT_B_REG);
> > > -	if (key_stat < 0) {
> > > +	ret = da9052_reg_read(onkey->da9052, DA9052_STATUS_A_REG);
> > > +	if (ret < 0) {
> > >  		dev_err(onkey->da9052->dev,
> > > -			"Failed to read onkey event %d\n", key_stat);
> > > +			"Failed to read onkey event err=%d\n", ret);
> > > +		key_stat = false;
> > 
> > Why do you need this assignment? Also, key_stat is integer, why are we
> > using boolean values for it?
> > 
> > >  	} else {
> > >  		/*
> > >  		 * Since interrupt for deassertion of ONKEY pin is not
> > >  		 * generated, onkey event state determines the onkey
> > >  		 * button state.
> > >  		 */
> > > -		key_stat &= DA9052_EVENTB_ENONKEY;
> > > +		if (ret & DA9052_STATUSA_NONKEY)
> > > +			key_stat = false;
> > > +		else
> > > +			key_stat = true;
> > 
> > It seems to me that the relevant changes are replacement of
> > DA9052_EVENT_B_REG -> DA9052_STATUS_A_REG in da9052_reg_read()
> > and doing:
> > 
> > 		key_stat &= DA9052_STATUSA_NONKEY;
> > 		input_report_key(onkey->input, KEY_POWER, !key_stat);
> > 
> > Right?
> 
> Right as far as the register and the bit within it.
> 
> However, should the register read fail due to the PMIC not responding
> on the i2c bus then the previous code would just loop round the work
> queue.  By explicitly using key_stat as a boolean it makes the code
> very clear that in the case of failure a 'false' value is set.

Then it should be defined as boolean.

> As it
> was the negative value of the error code would be treated as true,
> since -EFAULT being non-zero will be treated as true.

This is however not what your patch description said it does; it only
mentioned the incorrect register assignment. Maybe we shoudl do the
following then:

	...
	} else {
		bool pressed = !(ret & DA9052_STATUSA_NONKEY);

		input_report_key(onkey->input, KEY_POWER, pressed);
		input_sync(onkey->input);

		if (pressed)
			schedule_work(...);
	}

And mention that we are changing polling (no longer re-poll on read
errors) in addition to changing register/bits used.

Thanks.

-- 
Dmitry
