Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaCKJfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:35:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51358 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaCKJfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:35:22 -0400
Message-ID: <531ED8CC.4010903@ti.com>
Date: Tue, 11 Mar 2014 11:35:08 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Henrik Rydberg <rydberg@euromail.se>, <dmitry.torokhov@gmail.com>,
        <jcbian@pixcir.com.cn>, <dmurphy@ti.com>, <mugunthanvnm@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 4/8] Input: pixcir_i2c_ts: Use Type-B Multi-Touch protocol
References: <1393428486-15001-1-git-send-email-rogerq@ti.com> <1393428486-15001-5-git-send-email-rogerq@ti.com> <531B3331.9050008@euromail.se> <531D7E66.1070300@ti.com> <20140310163701.GA30397@saruman.home>
In-Reply-To: <20140310163701.GA30397@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 06:37 PM, Felipe Balbi wrote:
> On Mon, Mar 10, 2014 at 10:57:10AM +0200, Roger Quadros wrote:
>> Hi Henrik,
>>
>> On 03/08/2014 05:11 PM, Henrik Rydberg wrote:
>>> Hi Roger,
>>>
>>> the MT implementation seems mostly fine, just one curiosity:
>>>
>>>>  static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
>>>>  {
>>>>  	struct pixcir_i2c_ts_data *tsdata = dev_id;
>>>>  	const struct pixcir_ts_platform_data *pdata = tsdata->chip;
>>>> +	struct pixcir_report_data report;
>>>>  
>>>>  	while (!tsdata->exiting) {
>>>> -		pixcir_ts_poscheck(tsdata);
>>>> -
>>>> -		if (gpio_get_value(pdata->gpio_attb))
>>>> +		/* parse packet */
>>>> +		pixcir_ts_parse(tsdata, &report);
>>>> +
>>>> +		/* report it */
>>>> +		pixcir_ts_report(tsdata, &report);
>>>> +
>>>> +		if (gpio_get_value(pdata->gpio_attb)) {
>>>> +			if (report.num_touches) {
>>>> +				/*
>>>> +				 * Last report with no finger up?
>>>> +				 * Do it now then.
>>>> +				 */
>>>> +				input_mt_sync_frame(tsdata->input);
>>>> +				input_sync(tsdata->input);
>>>
>>> Why is this special handling needed?
>>
>> This is needed because the controller doesn't always report when all fingers
>> have left the screen. e.g. report might contain 3 fingers touched and then
>> gpio_attb line is de-asserted. There's no report with 0 fingers touched even
>> if the user's fingers have left the screen. So we never detect a BUTTON_UP.
>>
>> Without this s/w workaround we observe side effects like buttons being pressed
>> but not released. To me it looks like a bug in the controller.
> 
> the other way would be to *also* use IRQF_TRIGGER_RISING, then you get
> an IRQ when fingers leave the screen. No ?
> 

Yes that is also possible but it involves an additional interrupt context switch.
Sometimes the controller does report 0 finger touches before de-asserting the ATTB line and so
this additional interrupt is not needed by the approach I used.

cheers,
-roger
