Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaGMSaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:30:30 -0400
Received: from fallback-out2.mxes.net ([216.86.168.191]:12660 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896AbaGMSaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:30:24 -0400
Message-ID: <53C2CFFF.2040508@minsoft.com>
Date: Sun, 13 Jul 2014 11:29:19 -0700
From: Sanford Rockowitz <rockowitz@minsoft.com>
Organization: Minaret Software
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: stub: Add support for SMBus block commands
References: <1404742983-27303-1-git-send-email-linux@roeck-us.net>	<20140708215453.0677d3ed@endymion.delvare>	<53BC4F15.9030608@roeck-us.net>	<20140712112019.618d8a03@endymion.delvare>	<53C14ECD.7050105@roeck-us.net>	<20140713092127.4bedfa18@endymion.delvare>	<53C2A016.2070906@roeck-us.net> <20140713171343.0a4ba58d@endymion.delvare> <53C2A9E1.2080807@roeck-us.net>
In-Reply-To: <53C2A9E1.2080807@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgive me for jumping in.   I'm a noob at I2C.   But I have built a 
couple substantial error injection frameworks over the years, one for a 
mainframe DBMS and one for Java's checked exceptions.   So while I have 
nothing useful to say about how to inject exceptions here, I have 
thought a lot about use cases.

Failing all the time is the necessary first step.  It allows for testing 
error paths without manually inserting a failure and recompiling, and 
makes it possible to build unit tests.

Failing randomly (or pseudo-randomly) is important for testing the 
overall recovery mechanism, particularly where you have an inherently 
unreliable subsystem like networks or I2C.   By changing the failure 
rate you can explore, for example, at what point the failure rate of the 
lower level system becomes so great that it makes the upper level system 
unreliable.

The one use case I would add, and it may be outside the scope here, is 
data errors.  I've been using the DDC protocol over I2C to communicate 
with monitors.  The DDC Get Capabilities request entails multiple 
write/read exchanges, with responses of up to 37 bytes each.   Most of 
the time this works ok, but I have one monitor that produces a high 
volume of data errors (double bytes or missing bytes).   This is only 
detected by examining the data itself (fixed fields and checksum).

Sanford



On 07/13/2014 08:46 AM, Guenter Roeck wrote:
> On 07/13/2014 08:13 AM, Jean Delvare wrote:
>> On Sun, 13 Jul 2014 08:04:54 -0700, Guenter Roeck wrote:
>>> On 07/13/2014 12:21 AM, Jean Delvare wrote:
>>>> Hi Guenter,
>>>>
>>>> On Sat, 12 Jul 2014 08:05:49 -0700, Guenter Roeck wrote:
>>>>> Any idea how we could inject errors ? Error path testing would be 
>>>>> quite useful.
>>>>
>>>> Good idea. This should probably be done with a sysfs attribute so that
>>>> it can be turned on and off as desired. Off by default, of course. 
>>>> Some
>>>> other subsystems already support error injection, you could check how
>>>> they are doing it, do that we do not diverge needlessly.
>>>>
>>>> Do you think there is any value in failing with different error codes,
>>>> or just -EIO is enough?
>>>
>>> How about writing the error code to return into the attribute ?
>>> Write anything negative, and it is returned as error. Write 0,
>>> and the driver works as normal.
>>
>> This is smart, I like it :)
>>
>>>> Do you think it should fail all the time when error injection is
>>>> enabled, or is there a value in having only a certain % of commands
>>>> fail?
>>>
>>> For my purposes I would want it to fail reliably. We could add some 
>>> fanciness,
>>> though: Provide a second attribute which specifies how many 
>>> operations should
>>> pass before the first failure.
>>
>> Let's start simple and just implement what you need.
>>
>
> I would actually benefit from both. The ability to return an error 
> unconditionally
> lets me test the first error path. The ability to return an error 
> starting with the
> n-th transfer lets me test the n-th error path.
>
> Guenter
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

