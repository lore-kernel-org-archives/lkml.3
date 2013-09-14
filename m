Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab3INQVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:21:01 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42970 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab3INQVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:21:00 -0400
Message-ID: <52349B09.1000309@kernel.org>
Date: Sat, 14 Sep 2013 18:21:13 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 26/38] iio: pressure-core: st: Clean-up probe() function
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-27-git-send-email-lee.jones@linaro.org> <02cccf68-fdc6-4ac3-a5d7-adfa10fa1c46@email.android.com> <20130911071950.GE11227@lee--X1>
In-Reply-To: <20130911071950.GE11227@lee--X1>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/13 08:19, Lee Jones wrote:
>>> 	err = st_sensors_init_sensor(indio_dev, plat_data);
>>> 	if (err < 0)
>>> -		goto st_press_common_probe_error;
>>> +		return err;
>>>
>>> -	if (pdata->get_irq_data_ready(indio_dev) > 0) {
>>> +	if (irq > 0) {
>>> 		err = st_press_allocate_ring(indio_dev);
>>> 		if (err < 0)
>>> -			goto st_press_common_probe_error;
>>> +			return err;
>>>
>>> 		err = st_sensors_allocate_trigger(indio_dev,
>>> -							ST_PRESS_TRIGGER_OPS);
>>> +						  ST_PRESS_TRIGGER_OPS);
>>> 		if (err < 0)
>>> 			goto st_press_probe_trigger_error;
>>> 	}
>>>
>>> 	err = iio_device_register(indio_dev);
>>> -	if (err)
>>
>> This bit of handling is confusing. I would much rather see the if IRQ at the goto. Here the first thought is why is it not an error if there is no IRQ! 
> 
> I certainly see your point. But surely anyone would see after a second
> or two that we're returning err and not 0 in this case, so the error
> would still be returned, we're not ignoring it. Adding this extra
> comparison saves several lines of code.
> 
> If you think it's 'too' confusing, I'll revert the change.
> 
> Or perhaps a comment:
> 
> /* Only deallocate_[trigger|ring] if they were allocated. */
> or
> /* Only deallocate_[trigger|ring] if we have an IRQ line. */
> or
> /* If no IRQ was specified, just return the error. */
> 

Revert the change.  Whilst not complex to follow it is non obvious to save only
a couple of lines. Adding a comment would take almost as much space as just doing
it the 'easy way'.

>>> +	if (err && irq > 0)
>>> 		goto st_press_device_register_error;
>>>
>>> 	return err;
>>>
>>> st_press_device_register_error:
>>> -	if (pdata->get_irq_data_ready(indio_dev) > 0)
>>> -		st_sensors_deallocate_trigger(indio_dev);
>>> +	st_sensors_deallocate_trigger(indio_dev);
>>> st_press_probe_trigger_error:
>>> -	if (pdata->get_irq_data_ready(indio_dev) > 0)
>>> -		st_press_deallocate_ring(indio_dev);
>>> -st_press_common_probe_error:
>>> +	st_press_deallocate_ring(indio_dev);
>>> +
>>> 	return err;
>>> }
>>> EXPORT_SYMBOL(st_press_common_probe);
>>
> 
