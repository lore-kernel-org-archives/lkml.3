Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaGAGFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 02:05:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19902 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaGAGFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 02:05:23 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-cb-53b24f9a209a
Message-id: <53B24F9B.7010205@samsung.com>
Date: Tue, 01 Jul 2014 08:05:15 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH] usb: gadget: add claimed field in struct usb_ep
References: <1402906836-12733-1-git-send-email-r.baldyga@samsung.com>
 <20140619150853.GG23782@saruman.home> <53A7C42F.1060603@samsung.com>
 <20140623182725.GD5073@saruman.home> <53A96C23.8040800@samsung.com>
 <20140630183337.GS31442@saruman.home>
In-reply-to: <20140630183337.GS31442@saruman.home>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xq7qz/DcFG3z9YG4x62U7i8XB+/UW
	zYvXs1lc3jWHzWLRslZmi7VH7rI7sHnsn7uG3aNvyypGj+M3tjN5fN4kF8ASxWWTkpqTWZZa
	pG+XwJUx42MLe8F+4Yov3zeyNTA+4u9i5OSQEDCRWPvnKiOELSZx4d56ti5GLg4hgaWMErM/
	nmCCcD4yShyc9RWsildAS2LqtMXsIDaLgKrElU97WUFsNgEdiS3fJ4DViApESNxrPMwKUS8o
	8WPyPRYQW0RAQGL9i0vsIEOZBboYJdZ/PQnkcHAIC7hIHP8kAlIjJPCLUeLcZz8Qm1PASOLs
	jmVgc5iB5u9vncYGYctLbF7zlnkCo8AsJCtmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLS
	vHS95PzcTYyQgP66g3HpMatDjAIcjEo8vC/0NwULsSaWFVfmHmKU4GBWEuHl9AMK8aYkVlal
	FuXHF5XmpBYfYmTi4JRqYMxJ9tJar2pzKu2H/TWdNSbpl6sX3Np36ct8xzj/U3d87Xt6GBd3
	LVp7hk/j7bQngXt6H02fM9VVx0y8wGW/TPqnmXc/iBzOevngr/d3tvS0OXcfbT9lXTnlRfyh
	TboaCd7xmwwbhXxU2L8drz3a2X3JTK7vwhs2obmdTVL3JF4XlOa4xVw9YavEUpyRaKjFXFSc
	CACArdk3RgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 08:33 PM, Felipe Balbi wrote:
> On Tue, Jun 24, 2014 at 02:16:35PM +0200, Robert Baldyga wrote:
>> On 06/23/2014 08:27 PM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Mon, Jun 23, 2014 at 08:07:43AM +0200, Robert Baldyga wrote:
>>>> On 06/19/2014 05:08 PM, Felipe Balbi wrote:
>>>>> On Mon, Jun 16, 2014 at 10:20:36AM +0200, Robert Baldyga wrote:
>>>>>> This field allows to mark ep as claimed in more clear way. Claiming
>>>>>> endpoint by setting driver_data to non-null value is leaky solution
>>>>>> and makes code unreadable.
>>>>>
>>>>> how come ? How can it be unreadable ? how can it be leaky ?
>>>>>
>>>>
>>>> What if gadget will not assign any value to driver_data (just like
>>>> Gadget Zero do)? Endpoint will be seen as not used, and autoconfig will
>>>
>>> huh ??? The gadget isn't the endpoint user, the function is. Look at
>>> f_sourcesink.c and f_loopback.c. If the function doesn't set anything to
>>> driver_data, then that's a bug on the function which needs fixing.
>>>
>>> Moreover, if there's a function which doesn't set driver_data, we could
>>> just as well have a function which doesn't set "claimed", so the problem
>>> is the same.
>>>
>>
>> I mean the function, not the gadget. Sorry for confusion.
>> Mechanism I developed marks endpoint as claimed *inside autoconfig
>> function*. It's significant difference, because there's not possible to
>> forget to mark that endpoint is claimed. When endpoint is returned from
>> autoconfig function, it belongs to function, and the function doesn't
>> need to do anything to claim obtained endpoint - it's already done.
> 
> we still might need to keep driver_data though. Some functions might
> need it. But now that you explained your goal, I can see how that might
> help. Please send a complete patchset also with the implementation for
> ep_autoconfig so we can all review your idea.
> 

The patch that I send contains entire implementation. It's quite simple
idea:
- in ep_matches() we check if ep->claimed is true instead of checking if
ep->driver_data is set
- in usb_ep_autoconfig_ss() we set ep->claimed to true if we have found
suitable endpoint
- usb_ep_autoconfig_reset() we set ep->claimed to false

The struct usb_ep still have field driver_data, which can be used by
function driver. The only difference is that this field is not used to
indicate if endpoint is claimed or not, it just contains assigned pointer.

Best regards
Robert Baldyga
