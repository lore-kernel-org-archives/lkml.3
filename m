Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaIXR52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:57:28 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:33258 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaIXR50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:57:26 -0400
Date: Wed, 24 Sep 2014 17:56:52 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Daniel Mack <daniel@caiaq.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: core: downgrade log severity to info when
 descriptor unavailable
In-Reply-To: <20140924051851.GA6519@kroah.com>
Message-ID: <alpine.DEB.2.11.1409241736520.2919@localhost.localdomain>
References: <Pine.LNX.4.44L0.1409231021190.1322-100000@iolanthe.rowland.org> <alpine.DEB.2.11.1409231905460.3223@localhost.localdomain> <alpine.DEB.2.11.1409231909590.7196@localhost.localdomain> <20140924051851.GA6519@kroah.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Greg Kroah-Hartman wrote:
> On Tue, Sep 23, 2014 at 07:12:40PM +0000, Scot Doyle wrote:
>> According to commit 0cce2eda19923e5e5ccc8b042dec5af87b3ffad0
>>     USB: fix LANGID=0 regression
>>
>> usb devices are not required to report string descriptors. Since they are
>> optional, log an info message instead of an error message.
>>
>> Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
>> ---
>>  drivers/usb/core/message.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
>> index 0c8a7fc..da2f1f2 100644
>> --- a/drivers/usb/core/message.c
>> +++ b/drivers/usb/core/message.c
>> @@ -780,8 +780,12 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
>>  	 * deal with strings at all. Set string_langid to -1 in order to
>>  	 * prevent any string to be retrieved from the device */
>>  	if (err < 0) {
>> -		dev_err(&dev->dev, "string descriptor 0 read error: %d\n",
>> -					err);
>> +		if (err == -EPIPE)
>> +			dev_info(&dev->dev,
>> +				 "string descriptor 0 read error: -EPIPE\n");
>> +		else
>> +			dev_err(&dev->dev,
>> +				"string descriptor 0 read error: %d\n", err);
>
> What real difference does this patch make?  What would a user do with
> -EPIPE?

Not much difference, except e.g. a log line that isn't red.

> And USB devices _are_ required to provide a string descriptor if they
> provide a string id, so your changelog body doesn't make much sense.  I
> suggest rewriting it to say they aren't required to provide a string
> descriptor for string "0".
>
> But even then, I don't understand the goal of this patch.

I'm happy to drop this patch request, since in my case the return value is 
-ENODATA, which is covered by the other patch: "[RFC PATCH] usb: core: log 
more general message on malformed LANGID descriptor"

