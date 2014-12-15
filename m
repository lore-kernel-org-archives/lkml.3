Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaLOOAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:00:18 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33113 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaLOOAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:00:13 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-cb-548ee96a7487
Message-id: <548EE964.2050504@samsung.com>
Date: Mon, 15 Dec 2014 15:00:04 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        ARM/CLKDEV SUPPORT <linux-arm-kernel@lists.infradead.org>,
        GPIO SUBSYSTEM <linux-gpio@vger.kernel.org>,
        DRM PANEL DRIVERS <dri-devel@lists.freedesktop.org>,
        "ARM/S5P EXYNOS AR..." <linux-samsung-soc@vger.kernel.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [RFC 01/15] drivers/base: add track framework
References: <548B7653.7020004@gmail.com> <20141215125557.GB11764@sirena.org.uk>
In-reply-to: <20141215125557.GB11764@sirena.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xy7pZL/tCDBb+Y7eY+vAJm8X8I+dY
	La58fc9mce7VIxaLA392MFo0L17PZjHp/gQWiwtPe9gsvl3pYLKY8mc5k8Wmx9dYLTbP/8No
	cXnXHDaLGef3MVncvsxrsfbIXXaLpxMuslm07j3CbvFz1zwWB2GPluYeNo+ds+6ye2xa1cnm
	cefaHjaP/XPXsHvc7z7O5LF5Sb1H35ZVjB7Hb2xn8vi8SS6AK4rLJiU1J7MstUjfLoErY3bz
	QeaCbbIVbyZ3MzcwLhfvYuTkkBAwkbh+6CEThC0mceHeerYuRi4OIYGljBIHrnSwQjifGCV+
	zjrPBlLFK6AlMevpO0YQm0VAVWLZy8Ng3WwCmhJ/N98EqxEViJD4sOorVL2gxI/J91hAbBEB
	ZYmr3/eygAxlFtjCJjFjyjRWkISwgJXE7a1zmUFsIQF/ib9nP4I1cwoYSxya9RloAQdQg57E
	/YtaIGFmAXmJzWveMk9gFJiFZMUshKpZSKoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/d
	xAiJxS87GBcfszrEKMDBqMTDm7C3N0SINbGsuDL3EKMEB7OSCG/b/b4QId6UxMqq1KL8+KLS
	nNTiQ4xMHJxSDYwl3Mk1jHOzf81mmnbpwdskX8N5LsfZy9PS35jYL/kRL2Hm93+Hz3qumX6x
	hUlfNJefNricsDEixqsmcMO3pczabStFflY9NZb+9FdH7kbWbIMXvn8X70yfqPjayEio3s6u
	sSngaU+Vrt3XaM1p4vIXtINCDp+a/f/hJsa8wJel37Ycj6j+d0GJpTgj0VCLuag4EQB1z27R
	owIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 01:55 PM, Mark Brown wrote:
> On Sat, Dec 13, 2014 at 12:12:19AM +0100, AH wrote:
>> Mark Brown wrote on 12.12.2014 17:36:
>>> On Wed, Dec 10, 2014 at 04:48:19PM +0100, Andrzej Hajda wrote:
>>>> +		kfree(ptask);
>>>> +
>>>> +		if (empty)
>>>> +			break;
>>>> +
>>>> +		track_process_task(track, task);
>>> ...we then go and do some other stuff, including processing that task,
>>> without the lock or or any other means I can see of excluding other
>>> users before going round and removing the task.  This seems to leave us
>>> vulnerable to double execution.
>> No, if you look at track_add_task function you will see that the queue is
>> processed only if it is initially empty, otherwise the task is only added to
>> the queue, so it will be processed after processing earlier tasks.
>> So the rule is that if someone add task to the queue it checks if the queue
>> is empty, in such case it process all tasks from the queue until
>> the queue becomes empty, even the tasks added by other processed.
>> This way all tasks are serialized.
> This is all pretty fiddly and seems fragile - if nothing else the code
> seems undercommented since the above is only going to be apparent with
> following through multiple functions and we're relying on both owner and
> list emptiness with more than one place where a task can get processed.

I have changed it already to test queue owner, this way it should
be more clear.

>
>>> I'm also unclear what is supposed to happen if adding a notification
>>> races with removing the thing being watched.
>> The sequence should be always as follows:
>> 1. create thing, then call track_up(thing).
>> ...
>> 2. call track_down(thing) then remove thing.
>> If we put 1 into probe and 2 into remove callback of the driver it will be
>> safe - we are synchronised by device_lock. But if, for some reason, we want
>> to create object after probe we should do own synchronization or just put
>> device_lock around 1. The same applies if we want to remove
>> object earlier. This is the comment above about. I will expand it to more
>> verbose explanation.
> You can't rely on the device lock here since this isn't tied to kobjects
> or anything at all - it's a freestanding interface someone could pick up
> and use in another context.  Besides, that isn't really my concern - my
> concern is what happens if something asks to wait for 
But I do not rely here on device_lock, I just point out that 1 and 2
should be
synchronized and as a common way is to put such things into probe
and remove, device_lock can do the synchronization for us in such case,
so no need for additional synchronization.

And to make everything clear, track_up will not be called by the driver
directly,
it shall be called by respective resource framework functions, for example
by regulator_register and regulator_unregister.

And regarding your initial/real concern, I guess you mean this one:
>> I'm also unclear what is supposed to happen if adding a notification
>> races with removing the thing being watched.
I guess you mean registering notifier and removal of thing it is
supposed to watch.
As all track tasks are serialized these two will be serialized also so
we can have
only two scenarios:
1.
  a) register notifier
  - thing is up, so notifier will be immediately called with info that
the thing is up
  b) remove thing
  - thing will be down, so notifier will be called with info that the
thing will be removed
2.
  a) remove thing
  - notifier is not yet registered, so callback will not be called,
  b) register notifier
  - thing is already removed, so callback will not be called.

I hope this is what you were asking for.

Regards
Andrzej

