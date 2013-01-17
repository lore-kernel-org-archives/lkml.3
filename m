Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab3AQQub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:50:31 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:42487 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab3AQQua convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:50:30 -0500
Subject: Re: [PATCH] platform: Fix platform device resource linking
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130117163159.GD1396@kroah.com>
Date: Thu, 17 Jan 2013 18:50:19 +0200
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <95056678-DF1A-4C49-BEAE-C5EBD7E56405@antoniou-consulting.com>
References: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com> <20130103224020.GB4571@kroah.com> <CD23CDD8-5740-4649-8876-ADDFCFF30C35@antoniou-consulting.com> <20130117163159.GD1396@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17, 2013, at 6:31 PM, Greg Kroah-Hartman wrote:

> On Fri, Jan 04, 2013 at 12:43:46AM +0200, Pantelis Antoniou wrote:
>> Hi Greg,
>> 
>> On Jan 4, 2013, at 12:40 AM, Greg Kroah-Hartman wrote:
>> 
>>> On Fri, Jan 04, 2013 at 12:31:10AM +0200, Pantelis Antoniou wrote:
>>>> Platform device removal uncovered a number of problems with
>>>> the way resources are handled in the core platform code.
>>>> 
>>>> Resources now form child/parent linkages and this requires
>>>> proper linking of the resources. On top of that the OF core
>>>> directly creates it's own platform devices. Simplify things
>>>> by providing helper functions that manage the linking properly.
>>>> 
>>>> Two functions are provided:
>>>> 
>>>> platform_device_link_resources(), which links all the
>>>> linkable resources (if not already linked).
>>>> 
>>>> and platform_device_unlink_resources(), which unlinks all the
>>>> resources.
>>> 
>>> Who would call these functions, and why?
>>> 
>>> And why have we never seen problems with removing platform devices
>>> previously?
>>> 
>> 
>> Have you tried removing devices that were created via DT and 
>> not using platform data?
> 
> Don't you think that answering two questions with another question as
> something that isn't very helpful?  :)
> 
> Dropped from my queue, please resend when you can provide the needed
> information.
> 
> thanks,
> 

That's not very nice, but anyway...

In a nutshell, we have to exercise the platform device subsystem, in ways
that never happened before, so all sorts of weird bugs that no-one has seen
before.

In that case, the code path for creating platform devices from DT is
not the same as the one that is used when creating platform device from
a board file.

Take a look at platform_device_add() in drivers/base/platform.c and
drivers/of/device.c

platform_device_add() properly links the resources by using insert_resource(),
while of_device_add() doesn't bother with it. Now when we try to unregister
the device everything will is fine in the platform device case, since the resources
are linked properly. In the DT case we will crash spectacularly in 
__release_resource at the first line (p = &old->parent->child), since no-one bothered
to fill in the parent pointer.

That's what the patches do; first the code in platform_device_add() that perform the
resource linking is factored as a separate function (platform_device_link_resources).

The platform_device_unlink_resources() function, just makes things more clearer. 

> greg k-h

Regards

-- Pantelis

