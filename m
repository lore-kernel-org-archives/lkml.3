Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaEEInH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:43:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37014 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935AbaEEInF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:43:05 -0400
Message-ID: <53674F0C.5040101@ti.com>
Date: Mon, 5 May 2014 11:42:52 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 2/7] Input: pixcir_i2c_ts: Initialize interrupt mode
 and power mode
References: <1398861392-8959-1-git-send-email-rogerq@ti.com> <1398861392-8959-3-git-send-email-rogerq@ti.com> <20140430162950.GA13624@core.coreip.homeip.net>
In-Reply-To: <20140430162950.GA13624@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 04/30/2014 07:29 PM, Dmitry Torokhov wrote:
> Hi Roger,
> 
> On Wed, Apr 30, 2014 at 03:36:27PM +0300, Roger Quadros wrote:
>> +static int pixcir_stop(struct pixcir_i2c_ts_data *ts)
>> +{
>> +	struct device *dev = &ts->client->dev;
>> +	int ret;
>> +
>> +	/* exit ISR if running, no more report parsing */
>> +	ts->exiting = true;
>> +	mb();	/* update status before we synchronize irq */
>> +
>> +	/* disable ISR from running again */
>> +	disable_irq(ts->client->irq);
>> +
>> +	/* wait till running ISR complete */
>> +	synchronize_irq(ts->client->irq);
>> +
>> +	/* disable interrupt generation */
>> +	ret = pixcir_int_enable(ts, 0);
>> +	if (ret)
>> +		dev_err(dev, "Failed to disable interrupt generation\n");
>> +
>> +	/* restore IRQ */
>> +	enable_irq(ts->client->irq);
>> +
>> +	return ret;
> 
> Should not this be:
> 
> 	pixcir_int_enable(ts, 0);
> 	ts->exiting = true;
> 	mb();
> 	synchronize_irq(ts->client->irq);
> 
> Why do we also need to disable/enable irq?

Yes, you are right. It seems the problem with v2 was that order of mb() and synchronize_irq() were
reversed and thus causing the suspend/resume problem. I tried with your suggestion and it works.
I'll send a revised series.

> 
> By the way, disable_irq() implies synchronize_irq().

OK.

cheers,
-roger
