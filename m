Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbaFYRMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:12:38 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:45412
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757754AbaFYRMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:12:36 -0400
Message-ID: <53AB02F4.1090701@chelsio.com>
Date: Wed, 25 Jun 2014 10:12:20 -0700
From: Casey Leedom <leedom@chelsio.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, tiwai@suse.de,
        chunkeey@googlemail.com, cocci@systeme.lip6.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Philip Oswald <poswald@suse.com>,
        Santosh Rastapur <santosh@chelsio.com>,
        Jeffrey Cheung <jcheung@suse.com>, David Chang <dchang@suse.com>,
        Hariprasad Shenai <hariprasad@chelsio.com>
Subject: Re: [PATCH 2/3] cxgb4: make configuration load use request_firmware_direct()
References: <1403649583-12707-1-git-send-email-mcgrof@do-not-panic.com> <1403649583-12707-3-git-send-email-mcgrof@do-not-panic.com> <D46B557B-AF4A-4E60-8D83-6181D406C64F@chelsio.com> <20140625015048.GI27687@wotan.suse.de>
In-Reply-To: <20140625015048.GI27687@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/24/14 18:50, Luis R. Rodriguez wrote:
> On Tue, Jun 24, 2014 at 03:54:44PM -0700, Casey Leedom wrote:
>> [[ Hopefully this makes it through to the kernel.org lists -- I’m using the
>>    Mac OS/X Mailer and it’s not clear how to force it not to use HTML format.
>>    -- Casey ]]
>>
>>    So does request_firmware_direct() only fail if the requested file is not
>>    present on the file system or does it fail in other cases as well?
> Same as before they are the same exact call with the only difference
> being udev is not used as an extra helper, so it saves the extra
> delay caused by udev. That's all.
>
>>    If it’s the former, then the change to cxgb4 is fine.
>>
>>    But if it’s the latter, then it’s definitely not okay.  While the driver
>>    _can_ continue running without the local on-disk Firmware Configuration
>>    File, that file can be used to significantly change the behavior and
>>    capabilities of the adapter and is user-customizable.  If a user makes
>>    changes to the local on-disk Firmware Configuration File and these are
>>    randomly silently ignored this will lead to highly annoying support issues.
> This just avoids udev, the request goes directly to the filesystem. The
> failure will happen when the file is not present just as before, the
> only difference here is skipping udev, it doesn't suffer from the extra
> 60 second timeout. There's another possible failure, when
> usermodehelper_read_trylock() fails but that is just as the code was before
> so this change doesn't introduce that as a new false check. When that
> triggers yout get a nasty WARN_ON() just as before.

   Huh, okay.  I guess I'm confused about the value of 
request_firmware() and the User Device helper.  If 
request_firmware_direct() just goes to the file system to grab the file 
and returns with ENOENT if it's not there, then you could replace every 
usage of request_firmware() in the cxgb4 driver as far as I can see ...  
Either the files are there and we'll use them or they won't be and we'll 
have to cope with that.  Am I missing something?

   And again, this definitely isn't going to solve the problem that 
started this whole line of research: we're still going to time out the 
load of cxgb4 if there are multiple 10Gb/s BT adapters in a system and 
we need to load each one with both base firmware and PHY firmware.

Casey

> One thing to note though is that the kernel firmware loader does not
> log any failure to the kernel ring buffer if the firmware is not on the
> filesystem, while the udev loader is a bit more chatty:
>
> [ 2463.666120] platform fake-dev.0: Direct firmware load failed with error -2
> [ 2463.666129] platform fake-dev.0: Falling back to user helper
>
> Stuffing a print into the non-udev approach upstream seems a bit excessive
> though (unless folks disagree), so if you want the driver to be a bit more
> informative I think its best to place this feedback on the driver for now.
>
> I see the driver does provide this information already though so is any
> additional prints really desirable ?
>
>          dev_info(adapter->pdev_dev, "Successfully configured using Firmware "\
>                   "Configuration File \"%s\", version %#x, computed checksum %#x\n",
>                   config_name, finiver, cfcsum);
>
>    Luis

