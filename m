Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbbAHM6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:58:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53153 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbbAHM6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:58:04 -0500
Message-ID: <634664966adf6af2eff2a712680b1c69.squirrel@www.codeaurora.org>
In-Reply-To: <20150107170646.GX2634@sirena.org.uk>
References: <1420638683-20216-1-git-send-email-ashayj@codeaurora.org>
    <20150107170646.GX2634@sirena.org.uk>
Date: Thu, 8 Jan 2015 12:58:03 -0000
Subject: Re: [PATCH] regulator: core: fix race condition in regulator_put()
From: ashayj@codeaurora.org
To: "Mark Brown" <broonie@kernel.org>
Cc: "Ashay Jaiswal" <ashayj@codeaurora.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "Anirudh Ghayal" <aghayal@codeaurora.org>,
        "David Collins" <collinsd@codeaurora.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark for your review comments.

> On Wed, Jan 07, 2015 at 07:21:23PM +0530, Ashay Jaiswal wrote:
>
>> The regulator framework maintains a list of consumer regulators
>> for a regulator device and protects it from concurrent access
>> using the regulator device's mutex lock.
>
>> In the case of regulator_put() the consumer is removed without
>> holding the regulator device's mutex, resulting in a race condition
>> between any regulator operation which traverses the consumer list
>> and regulator_put() which releases the consumer regulator.
>> Fix this race condition by holding the regulator device's mutex while
>> removing and releasing the consumer regulator.
>
> This is a good spot thanks but I think your analysis here is missing a
> bit - it's not just the list manipulation that affects the rdev, it's
> also the reference count in the rdev and the exclusive flag.  Indeed
> some of this issue applies on the _get() side too, while we do add the
> regulator to the list under the rdev mutex we don't have the mutex when
> we update the reference count meaning that we've got a potential issue
> with that.  That *is* kind of separate though so could be dealt with in
> a separate patch.
>

I have updated the commit message as per your suggestion.
I will try to fix the regulator_get path.

> The lock region also seems too wide, the lock is only needed for the
> operations that affect the rdev not for the operations only on the
> object being freed - holding the lock for too long means impacting other
> users and some of the cleanup is potentially expensive.  The comment at
> the top of the function needs updating too, it currently says that the
> lock is held in the caller but this applies only to the
> regulator_list_mutex.
>
Yes I too agree with your suggestion, updated the lock region to protect
only rdev parameters.
Also updated the comment on top of the _regulator_put function to reflect
regulator_list_mutex lock is held by caller.

I will upload next version of patch incorporating all the review comments.

Ashay Jaiswal


