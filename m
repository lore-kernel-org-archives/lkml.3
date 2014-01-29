Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaA2HXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 02:23:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:13956 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaA2HXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 02:23:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,740,1384329600"; 
   d="scan'208";a="472474238"
Message-ID: <52E8AC7C.5070903@intel.com>
Date: Wed, 29 Jan 2014 15:23:40 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, Felipe Balbi <balbi@ti.com>
CC: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linus.walleij@linaro.org, gnurou@gmail.com,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] gpio-intel-mid: fix the incorrect return of idle callback
References: <52E76F71.4080304@intel.com> <20140128164937.GA30226@saruman.home> <20140128172413.GA31821@psi-dev26.jf.intel.com> <20140128181206.GB31977@saruman.home> <20140129001357.GA13185@psi-dev26.jf.intel.com>
In-Reply-To: <20140129001357.GA13185@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 2014年01月29日 08:13, David Cohen 写道:
> On Tue, Jan 28, 2014 at 12:12:06PM -0600, Felipe Balbi wrote:
>> On Tue, Jan 28, 2014 at 09:24:13AM -0800, David Cohen wrote:
>>> On Tue, Jan 28, 2014 at 10:49:37AM -0600, Felipe Balbi wrote:
>>>> On Tue, Jan 28, 2014 at 04:50:57PM +0800, xinhui.pan wrote:
>>>>> From: "xinhui.pan" <xinhuiX.pan@intel.com>
>>>>>
>>>>> intel_gpio_runtime_idle should return correct error code if it do fail.
>>>>> make it more correct even though -EBUSY is the most possible return value.
>>>>>
>>>>> Signed-off-by: bo.he <bo.he@intel.com>
>>>>> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
>>>>> ---
>>>>>  drivers/gpio/gpio-intel-mid.c |    4 +++-
>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-mid.c
>>>>> index d1b50ef..05749a3 100644
>>>>> --- a/drivers/gpio/gpio-intel-mid.c
>>>>> +++ b/drivers/gpio/gpio-intel-mid.c
>>>>> @@ -394,7 +394,9 @@ static const struct irq_domain_ops intel_gpio_irq_ops = {
>>>>>  
>>>>>  static int intel_gpio_runtime_idle(struct device *dev)
>>>>>  {
>>>>> -	pm_schedule_suspend(dev, 500);
>>>>> +	int err = pm_schedule_suspend(dev, 500);
>>>>> +	if (err)
>>>>> +		return err;
>>>>>  	return -EBUSY;
>>>>
>>>> wait, is it only me or this would look a lot better as:
>>>>
>>>> static int intel_gpio_runtime_idle(struct device *dev)
>>>> {
>>>> 	return pm_schedule_suspend(dev, 500);
>>>> }
>>>
>>> The reply to your suggestion is probably in this commit :)
>>>
>>> ---
>>> commit 45f0a85c8258741d11bda25c0a5669c06267204a
>>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> Date:   Mon Jun 3 21:49:52 2013 +0200
>>>
>>>     PM / Runtime: Rework the "runtime idle" helper routine
>>> ---
>>>
>>> We won't return 0 from here.
>>
>> so you never want to return 0, why don't you, then:
>>
>> static int intel_gpio_runtime_idle(struct device *dev)
>> {
>> 	pm_schedule_suspend(dev, 500);
>> 	return -EBUSY;
>> }
> 
> That's how it is currently :)
> 
> But this patch is making the function to return a different code in case
> of error. IMHO there is not much fuctional gain with it, but I see
> perhaps one extra info for tracing during development.
> 
> Anyway, I'll let Xinhui to do further comment since he's the author.
> 
> Br, David
> 
hi ,David & Balbi
  I checked several drivers yesterday to see how they use pm_schedule_suspend 
then found one bug in i2c. Also I noticed  gpio. 
I think returning a correct error code is important.So I change -EBUSY 
to *err*. To be honest,current code works well. 
>>
>> just like drivers/tty/serial/mfd.c::serial_hsu_runtime_idle() is doing ?
>>
>> -- 
>> balbi
> 
> 
