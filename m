Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaJGGdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 02:33:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32702 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaJGGdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 02:33:21 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-2c-5433892ef61e
Message-id: <5433892C.80109@samsung.com>
Date: Tue, 07 Oct 2014 08:33:16 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com, andrzej.p@samsung.com,
        k.opasiak@samsung.com
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
 <20141007022851.GA13956@saruman>
In-reply-to: <20141007022851.GA13956@saruman>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xy7p6ncYhBvc+iljMetnOYnHwfr1F
	8+L1bBa3J05js7i8aw6bxaJlrcwWC463sDqwe+yfu4bdY92fV0wefVtWMXocv7GdyePzJrkA
	1igum5TUnMyy1CJ9uwSujPetdxgLbktUzFh2gKmB8YNwFyMnh4SAicTWrXuZIWwxiQv31rN1
	MXJxCAksZZTofrqPBcL5yCjxddEZsCpeAQ2JdSdmsoPYLAKqEhN6FoPF2QR0JLZ8n8AIYosK
	REicvLuHHaJeUOLH5HssILaIgIDE+heX2EGGMgvMYZS4s+4HWLOwgKXEvEVzgWwOoG1pEvd3
	K4GEOQV0JTrm/mMFCTML6Encv6gFEmYWkJfYvOYt8wRGgVlINsxCqJqFpGoBI/MqRtHU0uSC
	4qT0XEO94sTc4tK8dL3k/NxNjJAA/7KDcfExq0OMAhyMSjy8GwyNQ4RYE8uKK3MPMUpwMCuJ
	8G6pAArxpiRWVqUW5ccXleakFh9iZOLglGpgnCibPmHVYSfnrOOM2Vw5gpEZIZfLed1mqrBE
	ah7Z4f3d+hzfDKFlL08bxlUET10rvWuyl4BX7on+r2onC630j6+4LG4YxbaktmRBZssry8um
	bO+ru/qcA+vvWfwrm1lzY3Xth7kcjr+6uqSehhUz3NjybumtOxVi7hnPWt598Mr4O/P2iYha
	JZbijERDLeai4kQAUjvKrE4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 04:28 AM, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Oct 06, 2014 at 01:25:14PM +0200, Robert Baldyga wrote:
>> Since we can compose gadgets from many functions, there is the problem
>> related to gadget breakage while FunctionFS daemon being closed. In some
>> cases it's strongly desired to keep gadget alive for a while, despite
>> FunctionFS files are closed, to allow another functions to complete
>> some presumably critical operations.
>>
>> For this purpose this patch introduces "zombie" mode. It can be enabled
>> by setting mount option "zombie=1", and results with defering function
>> closure to the moment of reopening ep0 file or filesystem umount.
>>
>> When ffs->state == FFS_ZOMBIE:
>> - function is still binded and visible to host,
>> - setup requests are automatically stalled,
>> - all another transfers are refused,
>> - opening ep0 causes function close, and then FunctionFS is ready for
>>   descriptors and string write,
>> - umount of functionfs cause function close.
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> 
> Can you further explain how do you trigger this ? Do I understand
> correctly that you composed a gadget using configfs and that gadget has
> functionfs + another gadget ?
> 

Yes, I compose configfs gadget from functionfs + another gadget, and
when functionfs daemon closes ep files, entire gadget get disconnected
from host. FFS function is userspace code so there is no way to know
when it will close files (it doesn't matter what is the reason of this
situation, it can be daemon logic, program breakage, process kill or any
other). So when we have another function in gadget which, for example,
sends some amount of data, does some software update or implements some
real-time functionality, we may want to keep the gadget connected
despite FFS function is no longer functional. We can't just remove one
of functions from gadget since it has been enumerated, so the only way
we can do that is to make broken FFS function "zombie". It will be still
visible to host but it will no longer implement it's functionality.

> Then what do you need to do the trigger the issue, and what really _is_
> the issue ? Is gadget disconnecting from host too early ? Do you see a
> crash ? Memory leak ? Any logs available ? Any steps to reproduce ?
> 

You simply compose gadget from, for example, ethernet and functionfs.
You try to send some huge file through ftp, and in meantime FFS function
breaks. If FFS hasn't enabled "zombie" mode, entire gadget will be
disconnected and data transmission will fail. If "zombie" mode is
enabled, then FFS function after daemon breakage will become "zombie"
and will be nonfunctional, but ethernet gadget will be still active and
data transfer will be completed.

> Quite frankly, I don't really like this "zombie" mode. <joke> I know
> there's a "The Walking Dead" hype right now, but this is too much.
> </joke>
>

I see, but after all I couldn't find more descriptive name for this feature.

> Anyway, please giver me further details of how to get this done.
> 

Best regards,
Robert Baldyga
