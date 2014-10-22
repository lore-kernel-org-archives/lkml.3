Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaJVNVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:21:08 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:44366 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaJVNVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:21:04 -0400
Message-ID: <5447AF1F.1060806@gmail.com>
Date: Wed, 22 Oct 2014 16:20:31 +0300
From: Giedrius Statkevicius <giedriuswork@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Darren Hart <dvhart@infradead.org>
CC: eric.piel@tremplin-utc.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] platform: hp_accel: add a i8042 filter to remove
 accelerometer data
References: <1413665962-3830-1-git-send-email-giedriuswork@gmail.com> <20141021214508.GF20951@vmdeb7>
In-Reply-To: <20141021214508.GF20951@vmdeb7>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014.10.22 00:45, Darren Hart wrote:
> On Sat, Oct 18, 2014 at 11:59:22PM +0300, Giedrius Statkevicius wrote:
>> Hello,
> 
> Hi Giedrius,
> 
>> this patch fixes bug #84941 from the kernel bugzilla. Basically, it
>> seems that the accelerometer sends some signals as button presses
>> through the keyboard bus. The keys in the report are 0xa5-0xa8 but in
>> the filter function they are reported as 0x25-0x28. This patch adds a
> 
> Does this mean you were able to test it? On which platform did you test?
> 

Sorry for not being specific enough. I have a HP ProBook 4540s laptop
with the sensor in it. It's ACPI id is HPQ6000. The reason I made this
patch is because I've been getting the following problem:

When I move the laptop I noticed that atkbd doesn't recognize some
keyboard "presses" which I wasn't doing and complains about that. The
range of the codes is in the patch: 0x25 - 0x28. The purpose of this
patch is to make hp_accel filter these out from the keyboard data
stream.

I've been testing this patch out on my system for about 5 days and
haven't ran into any issues.

>> i8042 filter that removes these scancodes from the keyboard stream in a
>> similar fashion to how idealpad_sidebar.c does this. I've done a RFC
>> because I'm not sure if there is more portable way to do this and if
>> these codes are the same for all machines. So could please someone
>> respond who uses this driver and tell which invalid keypresses appear
>> (if they do) in your `dmesg` that are reported by atkbd?
>>
>> Also, I'm not sure if there is a publicly available documentation for hp
>> 3d driveguard (I couldn't find it). That would definetly make it clear
>> if this patch is correct or not.
>>
>> Adding a signed off by line incase you find this patch good and want to
>> apply it.
>>
>> Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
> 
> As it appears this is untested and you are looking for testers, I'm going to
> wait for a Tested-by from someone with hardware. Please follow-up if that fails
> to happen.

My questions are these:
- Does any system with the accelerometer whose ACPI id is HPQ0004 or
  HPQ6007 run into the same issues?
- If so, what are the scancodes reported by atkbd?
- If not, then where can I find some documentation to find about this?
  HP doesn't seem to have published any.

If other people have the same issue with the same scancodes on 
accelerometers with different ACPI ids we can go ahead and do what this
patch does without reacting to what hardware the user has.

And a general question about what other people think of doing this?
Maybe there is some better way I don't know of.

> 
> More below...
> 
[...]
>> +static bool hp_accel_i8042_filter(unsigned char data, unsigned char str,
>> +				  struct serio *port)
>> +{
>> +	static bool extended;
>> +
>> +	if (str & I8042_STR_AUXDATA)
>> +		return false;
>> +
>> +	if (data == 0xe0) {
>> +		extended = true;
>> +		return true;
> 
> If you are going to return, why bother setting extended?
> 
>> +	}
>> +
>> +	if (!extended)
>> +		return false;
> 
> I'm now confused :-)
> 
>> +
>> +	extended = false;
> 
> Wait... what?
> 
> Please review the use of extended here as well as the possibility
> of using it uninitialized.
I'll review it and try to write it to be more concise and clearer. To be
honest, I have used drivers/input/misc/ideapad_slidebar.c as a model to
write this function and I didn't like the way it is written. I just
thought: "Hey, this one driver already was checked by someone and does a
very similar thing so why reinvent the wheel?"

> 
>> +	if (likely(data != ACCEL_1) && likely(data != ACCEL_2) &&
>> +	    likely(data != ACCEL_3) && likely(data != ACCEL_4)) {
>> +		serio_interrupt(port, 0xe0, 0);
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>  static int lis3lv02d_add(struct acpi_device *device)
>>  {
>>  	int ret;
>> @@ -326,6 +360,11 @@ static int lis3lv02d_add(struct acpi_device *device)
>>  	if (ret)
>>  		return ret;
>>  
>> +	/* filter to remove accelerometer data from keyboard bus stream */
>> +	ret = i8042_install_filter(hp_accel_i8042_filter);
>> +	if (ret)
>> +		i8042_remove_filter(hp_accel_i8042_filter);
> 
> If it failed to install, you don't need to remove it afterward. See
> the implementation for i8042_install_filter().
> 
Thanks for mentioning this. When we discuss the issues mentioned
previously I'll resend the fixed patch in the canonical and proper form.

Thanks,
Giedrius
