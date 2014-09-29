Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaI2NyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:54:25 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55043 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaI2NyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:54:23 -0400
Message-ID: <1411998865.5395.5.camel@iivanov-dev>
Subject: Re: [PATCH v2] thermal: Add QPNP PMIC temperature alarm driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Collins <collinsd@codeaurora.org>
Date: Mon, 29 Sep 2014 16:54:25 +0300
In-Reply-To: <54254C4E.3070807@smartplayin.com>
References: <1411651825-14240-1-git-send-email-iivanov@mm-sol.com>
	 <54254C4E.3070807@smartplayin.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 16:51 +0530, Kiran Padwal wrote:
> On Thursday 25 September 2014 07:00 PM, Ivan T. Ivanov wrote:
> > Add support for the temperature alarm peripheral found inside
> > Qualcomm plug-and-play (QPNP) PMIC chips.  The temperature alarm
> > peripheral outputs a pulse on an interrupt line whenever the
> > thermal over temperature stage value changes.  Implement an ISR
> > to manage this interrupt.
> > 
> 
> <snip>
> 
> > + * This function updates the internal temp value based on the
> > + * current thermal stage and threshold as well as the previous stage
> > + */
> > +static int qpnp_tm_update_temp_no_adc(struct qpnp_tm_chip *chip)
> > +{
> > +	unsigned int stage;
> > +	int rc;
> > +	u8 reg;
> > +
> > +	rc = qpnp_tm_read(chip, QPNP_TM_REG_STATUS, &reg);
> > +	if (rc < 0)
> > +		return rc;
> > +
> > +	stage = reg & STATUS_STAGE_MASK;
> 
> During compilation, getting a waring as below,
> 
> drivers/thermal/qpnp-temp-alarm.c: In function ‘qpnp_tm_update_temp_no_adc’:
> drivers/thermal/qpnp-temp-alarm.c:135:8: warning: ‘reg’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   stage = reg & STATUS_STAGE_MASK;

Could you share compiler version and options which you are using.
I am unable to trigger this warning. Looking code I can not 
see how this could happen.

> 
> > +
> > +	if (stage > chip->stage) {
> > +		/* increasing stage, use lower bound */
> > +		chip->temp = (stage - 1) * TEMP_STAGE_STEP +
> > +			     chip->thresh * TEMP_THRESH_STEP +
> > +			     TEMP_STAGE_HYSTERESIS + TEMP_THRESH_MIN;
> > +	} else if (stage < chip->stage) {
> > +		/* decreasing stage, use upper bound */
> > +		chip->temp = stage * TEMP_STAGE_STEP +
> > +			     chip->thresh * TEMP_THRESH_STEP -
> > +			     TEMP_STAGE_HYSTERESIS + TEMP_THRESH_MIN;
> > +	}
> > +
> > +	chip->stage = stage;
> > +
> > +	return 0;
> > +}
> > +
> 
> <snip>
> 
> > +
> > +#define QPNP_TM_PM_OPS	(&qpnp_tm_pm_ops)
> > +#else
> > +#define QPNP_TM_PM_OPS	NULL
> > +#endif
> > +
> > +static struct of_device_id qpnp_tm_match_table[] = {
> 
> It must be static const struct of_device_id, because all OF functions handle it as const.

Sure, will fix it.

Thank you,
Ivan

