Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3HFK0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:26:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:19310 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3HFK0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:26:19 -0400
Message-ID: <5200CF46.1070703@atmel.com>
Date: Tue, 6 Aug 2013 11:26:14 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@linuxdriverproject.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] staging: ozwpan: Increment port number for new device.
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com> <1375724415-10801-3-git-send-email-rupesh.gujare@atmel.com> <20130805175302.GJ5051@mwanda> <51FFF244.9000604@atmel.com> <20130805202338.GO5051@mwanda>
In-Reply-To: <20130805202338.GO5051@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/13 21:23, Dan Carpenter wrote:
> On Mon, Aug 05, 2013 at 07:43:16PM +0100, Rupesh Gujare wrote:
>> On 05/08/13 18:53, Dan Carpenter wrote:
>>> On Mon, Aug 05, 2013 at 06:40:13PM +0100, Rupesh Gujare wrote:
>>>> This patch fixes crash issue when there is quick cycle of
>>>> de-enumeration & enumeration due to loss of wireless link.
>>>>
>>>> It is found that sometimes new device (or coming back device)
>>>> returns very fast, even before USB core read out hub status,
>>>> resulting in allocation of same port, which results in unstable
>>>> system & crash.
>>>>
>>>> Above issue is resolved by making sure that we always assign
>>>> new port to new device, making sure that USB core reads correct
>>>> hub status.
>>>>
>>> This feels like papering over the problem.  Surely the real fix
>>> would be to improve the reference counting.
>>>
>>> This patch is probably effective but it makes the code more subtle
>>> and it shows that we don't really understand what we are doing with
>>> regards to reference counting.
>>>
>>>
>> Probably this is easier way to fix issue, since we don't have
>> reference count for ports & we rely on flags to check port status.
>> Any suggestions are appreciated.
> To be honest, I wish someone would just go through and make this
> look more like kernel style.  It's very ugly to look at.  Even a
> very cursory patch series would make a big difference:
>
> [patch 1/6] Add a blank line between declaractions and code.
> [patch 2/6] Add a blank line between functions
> [patch 3/6] Make oz_hcd_pd_arrived() return a struct pointer (instead of a void pointer)
> [patch 4/6] Make oz_hcd_pd_departed() take a struct pointer
> [patch 5/6] Swap arguments of oz_ep_alloc() to match kmalloc()
> [patch 6/6] Remove unneeded initializers
>
> Also it's better to separate the success path from the failure path
> because it means fewer intend levels.  The way oz_hcd_pd_arrived()
> looks now it's easy to think we free "ep" but actually we do this
> spaghetti thing of setting it to NULL on success.  This function
> should just be:
>
> 	frob();
> 	frob();
> 	ret = frob();
> 	if (ret)
> 		goto err_put;
> 	frob();
> 	frob();
> 	ret = frob();
> 	if (ret)
> 		goto err_free_ep;
> 	frob();
> 	frob();
> 	put();
> 	return hport;
>
> err_free_ep:
> 	free_ep();
> err_put:
> 	put();
> 	return NULL;
>
> But instead it is:
>
> 	frob();
> 	ret = frob();
> 	if (ret) {
> 		unlock();
> 		goto out;
> 	}
> 	frob();
> 	ret = frob();
> 	if (ret success) {
> 		frob();
> 		frob();
> 		ep = NULL;
> 		frob();
> 		unlock();
> 		frob();
> 	} else {
> 		unlock();
> 	}
> out:
> 	if (ep)
> 		free_ep();
> 	put();
> 	return something;
>
> In the second example most of the code is indented.  It's so hard
> to read because there are unlocks scattered throughout.  Meanwhile,
> if you separate success and failure then there are only two unlocks,
> one for success and one for failure.
>
> In the current code you have to set "ep" to NULL on the success path
> and then test it and or free it.  If you separate them out then it's
> obvious that "ep" is not freed on success.
>
> If you separate them out then it's clear that we return NULL on
> failure.  In the current code you have to scroll back to the start
> of the function.
>
> Obviously it's not an emergency to fix any of these style issues but
> it will need to be addressed eventually before it moves out of
> staging.  I think as well that just cleaning things up helps to
> fix bugs.
>

Thank you Dan, really appreciate your comments. Your suggestions sounds 
perfectly well.
I will work on it, once this patch series is applied to staging tree.

I am assuming that you have no objection for it, & I will follow up with 
above style nits in follow on patches.

-- 
Regards,
Rupesh Gujare

