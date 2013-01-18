Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab3ARJFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:05:25 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:34268 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187Ab3ARJFT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:05:19 -0500
Subject: Re: [PATCH] platform: Fix platform device resource linking
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130118030017.GA11423@kroah.com>
Date: Fri, 18 Jan 2013 11:05:14 +0200
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <82FE4A4D-DCA8-4C2C-97E7-6B73D424DCF5@antoniou-consulting.com>
References: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com> <20130103224020.GB4571@kroah.com> <CD23CDD8-5740-4649-8876-ADDFCFF30C35@antoniou-consulting.com> <20130117163159.GD1396@kroah.com> <95056678-DF1A-4C49-BEAE-C5EBD7E56405@antoniou-consulting.com> <20130117170719.GB9163@kroah.com> <87DCB3B7-0A5A-42F0-BF9C-0E91B56960C6@antoniou-consulting.com> <20130118030017.GA11423@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Jan 18, 2013, at 5:00 AM, Greg Kroah-Hartman wrote:

> On Thu, Jan 17, 2013 at 07:27:21PM +0200, Pantelis Antoniou wrote:
>>>> In a nutshell, we have to exercise the platform device subsystem, in ways
>>>> that never happened before, so all sorts of weird bugs that no-one has seen
>>>> before.
>>> 
>>> Why do you have to do this?  What are you doing that is so different
>>> from everyone else?  What drivers are you using that trigger this type
>>> of thing?
>>> 
>> 
>> This is all part of a larger patchset; I guess you weren't directly CCed.
>> The name of the patchset is 'Introducing Device Tree Overlays' and is a
>> method of changing the live device tree and have the changes reflected to
>> the kernel's state.
> 
> Ok, no wonder I was confused :)
> 
> How about cc:ing me on the next round of these patches, all of the,
> which will give me the proper background as to what is going on?
> 

Will do. I'm still waiting for some feedback from the DT maintainers, but
I will make sure that you will be CCed on the next revision.

You can of course take a look at it and comment on the current version too. 
  
>>>> In that case, the code path for creating platform devices from DT is
>>>> not the same as the one that is used when creating platform device from
>>>> a board file.
>>> 
>>> Why not?
>>> 
>> 
>> Because while DT creates platform devices, it doesn't use the platform device
>> methods to do so, rather than builds the platform device itself. This is 
>> something that was overlooked.
> 
> Can't this be fixed?  What does the platform device core need to do to
> resolve this?
> 

Hmm, due to historical reasons the two ways of creating platform devices
have diverged. The core of the issue is that while OF creates platform devices
it does so in it's own way.

Take a look at of_device_add()/platform_device_add(), 
of_device_register()/platform_device_register() for example.

It is pretty obvious some bits in platform_device_* are more recent and are missing
in of_device_*.

It might make sense for the of_device_* functions that are duplicating 
platform_device_* functions to be removed, and their functionality to 
be subsumed by platform_device_*, possibly by calling some helper functions
in drivers/of/ when of_node is not NULL. The of_device_* functions can be 
replaced by a direct call to platform_device_* via a define (until all of
the callers get converted).

The problem with doing anything like this would be that a whole bunch of
devices/arches depend on DT, and if anything breaks there will be a lot of
angry people with pitchforks after the culprit.

So without the full force of a core maintainer behind such a move, people
are reluctant to do so.   

> thanks,
> 
> greg k-h

Regards

-- Pantelis

