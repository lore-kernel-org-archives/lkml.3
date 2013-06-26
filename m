Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3FZPz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:55:58 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:33291 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591Ab3FZPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:55:57 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2013 11:55:56 EDT
X-RRZE-Submit-IP: 131.188.11.52
Message-ID: <3109bea2ac0947fd544042e51bcb75ad.squirrel@faumail.uni-erlangen.de>
In-Reply-To: <51CAF4C9.20407@redhat.com>
References: <1372182701-12256-1-git-send-email-michael.banken@mathe.stud.uni-erlangen.de>
    <51CAF4C9.20407@redhat.com>
Date: Wed, 26 Jun 2013 17:45:14 +0200
Subject: Re: [PATCH] Added a check for NULL pointer in hid_add_device
From: michael.banken@mathe.stud.uni-erlangen.de
To: "Benjamin Tissoires" <benjamin.tissoires@redhat.com>
Cc: "Michael Banken" <michael.banken@mathe.stud.uni-erlangen.de>,
        linux-kernel@vger.kernel.org, rydberg@euromail.se,
        srinivas.pandruvada@intel.com, erazor_de@users.sourceforge.net,
        jkosina@suse.cz, lorenz@badgers.com,
        linux-kernel@i4.informatik.uni-erlangen.de,
        linux-input@vger.kernel.org
User-Agent: SquirrelMail/1.4.23 [SVN]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The idea was to make the creation of an empty hid device while inside the
kernel easier. This problem came up, when I was writing a kernel module
driver for a usb temperature sensor. The sensors were supposed to be
recognized in lm-sensors, which does not recognize usb devices. The
solution in this case was to create an empty hid device to hook it up to
sysfs.
In some older implementations of this driver the solution to this problem
was creating an empty hid device to hook it up to sysfs.
These older implementations of the driver are not working anymore, unless
built with the change I am suggesting, because in the current version
their method of creating the hid device causes a NULL pointer dereference
at the point where I added the check.

The reason, why I believe this change to be completely harmless is that in
the case where there actually is a NULL pointer the function would
dereference it anyway immediately after the line where I added the check.
The only problem that to my understanding could possibly arise is delaying
the inevitable oops for a little while.

best regards,
Michael

On 06/25/2013 4:03 PM, Benjamin Tissoires wrote:
> Hi Michael,
>
> On 06/25/2013 07:51 PM, Michael Banken wrote:
>> This check greatly simplifies creating a dummy hid device.
>
> Could you elaborate a little here? If you want to create a hid device
> from the user space, I encourage you to use uhid, which is available
> since v3.6.
>
>> With this check in place a hid dummy can be created simply by allocating
>> and adding the device.
>> This used to be possible in earlier Kernel versions.
>>
>> Signed-off-by: Michael Banken
>> <michael.banken@mathe.stud.uni-erlangen.de>
>> Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
>> ---
>>  drivers/hid/hid-core.c |   37 ++++++++++++++++++++-----------------
>>  1 file changed, 20 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index 0951a9a..88c573e 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -2289,24 +2289,27 @@ int hid_add_device(struct hid_device *hdev)
>>  	if (hid_ignore(hdev))
>>  		return -ENODEV;
>>
>> -	/*
>> -	 * Read the device report descriptor once and use as template
>> -	 * for the driver-specific modifications.
>> -	 */
>> -	ret = hdev->ll_driver->parse(hdev);
>> -	if (ret)
>> -		return ret;
>> -	if (!hdev->dev_rdesc)
>> -		return -ENODEV;
>> -
>> -	/*
>> -	 * Scan generic devices for group information
>> -	 */
>> -	if (hid_ignore_special_drivers ||
>> -	    !hid_match_id(hdev, hid_have_special_driver)) {
>> -		ret = hid_scan_report(hdev);
>> +	if (hdev->ll_driver != NULL) {
>
> I am concerned by the fact that *every* hid specific driver will have to
> call hid_hw_start and hid_hw_stop at some point. These 2 functions  are
> not protected against a null pointer in hdev->ll_driver, so allowing
> here a null pointer will introduce a kernel oops later.
>
> I think it would be safer to have:
> if (!hdev->ll_driver)
> 	return -ENODEV;
>
> But if I understood correctly, this is not your point.
> So definitively, I need your usage scenarios of such hid "dummy" device.
>
> Cheers,
> Benjamin
>
>> +		/*
>> +		 * Read the device report descriptor once and use as template
>> +			 * for the driver-specific modifications.
>> +		 */
>> +		ret = hdev->ll_driver->parse(hdev);
>>  		if (ret)
>> -			hid_warn(hdev, "bad device descriptor (%d)\n", ret);
>> +			return ret;
>> +		if (!hdev->dev_rdesc)
>> +			return -ENODEV;
>> +
>> +		/*
>> +		 * Scan generic devices for group information
>> +		 */
>> +		if (hid_ignore_special_drivers ||
>> +		    !hid_match_id(hdev, hid_have_special_driver)) {
>> +			ret = hid_scan_report(hdev);
>> +			if (ret)
>> +				hid_warn(hdev,
>> +					"bad device descriptor (%d)\n", ret);
>> +		}
>>  	}
>>
>>  	/* XXX hack, any other cleaner solution after the driver core
>>
>
>


