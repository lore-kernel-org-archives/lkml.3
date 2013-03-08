Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209Ab3CHCVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:21:09 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5545 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3CHCVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:21:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 07 Mar 2013 18:14:58 -0800
Message-ID: <51394B10.5070903@nvidia.com>
Date: Fri, 8 Mar 2013 11:21:04 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable regulator
References: <1362590238-27692-1-git-send-email-achew@nvidia.com> <20130307071102.GB3451@avionic-0098.mockup.avionic-design.de> <513867CD.4030201@nvidia.com> <20130307112723.GA2593@avionic-0098.mockup.avionic-design.de> <643E69AA4436674C8F39DCC2C05F7638629CA50EB4@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F7638629CA50EB4@HQMAIL03.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 06:07 AM, Andrew Chew wrote:
>> From: Thierry Reding [mailto:thierry.reding@avionic-design.de]
>> Sent: Thursday, March 07, 2013 3:27 AM
>> To: Alex Courbot
>> Cc: Andrew Chew; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable
>> regulator
>>
>> * PGP Signed by an unknown key
>>
>> On Thu, Mar 07, 2013 at 07:11:25PM +0900, Alex Courbot wrote:
>>> On 03/07/2013 04:11 PM, Thierry Reding wrote:
>>>>> +	bool			en_supply_enabled;
>>>>
>>>> This boolean can be dropped. As discussed in a previous thread, the
>>>> pwm-backlight driver shouldn't need to know about any other uses of
>>>> the regulator.
>>>
>>> Sorry for being obstinate - but I'm still not convinced we can get rid
>>> of it. I checked the regulator code, and as you mentioned in the
>>> previous version, calls to regulator_enable() and
>>> regulator_disable() *must* be balanced in this driver.
>>>
>>> Without this variable we would call regulator_enable() every time
>>> pwm_backlight_enable() is called (and same thing when disabling).
>>> Now imagine the driver is asked to set the following intensities: 5,
>>> 12, then 0. You would have two calls to regulator_enable() but only
>>> one to regulator_disable(), which would result in the enable GPIO
>>> remaining active even though it would be shut down. Or I missed
>>> something obvious.
>>>
>>> The regulator must be enabled/disabled on transitions from/to 0, and
>>> AFAICT there is no way for this driver to detect them.
>>
>> Yes, that's true, but I don't think it should be solved for just this one
>> regulator. Instead if we need to track the enable state we might as well track
>> it for *any* resource so that the PWM isn't enabled/disabled twice either.
>
> That makes sense, but I'm confused due to previous comments.  The most
> obvious way to do this seems to be to have a bool track the enable state.
> Do you still want me to do away with this bool?  I can satisfy your very
> last comment by keeping the bool (renaming it to something more generic)
> and encapsulating the pwm_enable()/pwm_disable() call within.

I think that's what Thierry meant, yes.

>> I expect that if the changes are split up then the board-setup code changes
>> need to be done prior to the driver change. Using the lookup tables should
>> make this easy because they aren't tied to the platform data and can be
>> added independently. The patches should probably go through the same
>> subsystem tree to take care of the dependencies.
>>
>> Keeping everything in one patch would work too, but it's certainly more
>> chaotic.
>
> Am I supposed to handle those patches?  I'm concerned that I don't have
> hardware to test properly, but I can give it a shot if it's my responsibility.

Yes, if you introduce incompatibilities you have the burden of 
performing the transition without breaking things at any single point of 
the git history. Since this is just about adding a dummy regulator, it 
should go fine even without testing. And in the event it does not, 
that's what linux-next is for.

Make sure you also update the dts of current device tree users, as they 
will break, too.

What I don't know is if you should update all users in one big patch, or 
instead provide one patch per platform changed. Maybe Thierry can 
provide some guidance here.

Alex.

