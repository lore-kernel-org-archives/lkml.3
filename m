Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaBMSaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:30:15 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:22957 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaBMSaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:30:13 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat9gdPvzeGM
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 1 of 1]: musb: fixed a potential NULL pointer dereference.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20140212162009.GA23327@kroah.com>
Date: Thu, 13 Feb 2014 19:30:08 +0100
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <53D0520F-01E8-40A4-83C0-B15BFEC51116@goldelico.com>
References: <AAE255E2-8388-48FD-B728-D633862DBFB4@goldelico.com> <20140212142945.GA9172@kroah.com> <D56478EB-6936-4DFC-94F9-2A9A3CC217F1@goldelico.com> <20140212162009.GA23327@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 12.02.2014 um 17:20 schrieb Greg Kroah-Hartman:

> On Wed, Feb 12, 2014 at 04:35:12PM +0100, Dr. H. Nikolaus Schaller wrote:
>> 
>> Am 12.02.2014 um 15:29 schrieb Greg Kroah-Hartman:
>> 
>>> On Wed, Feb 12, 2014 at 11:08:22AM +0100, Dr. H. Nikolaus Schaller wrote:
>>>> fixed a potential NULL pointer dereference.
>>>> 
>>>>   Rationale:
>>>>   this is the only location in the musb driver where the
>>>>   otg->gadget pointer is dereferenced. Assuming that it
>>>>   is never NULL is not only potentially unsafe but was
>>>>   observed in the wild on a GTA04 (OMAP3/TPS65950 based
>>>>   board) when trying to boot a device tree based 3.14-rc2
>>>>   kernel with USB cable plugged in.
>>>> 
>>>>   DT boot appears to modify the order in which components
>>>>   (gadget driver) are loaded and linked and therefore
>>>>   an early musb interrupt triggers with a NULL gadget
>>>>   pointer ending in a kernel panic.
>>>> 
>>>>   Since a non-existing gadget can never be "active" we
>>>>   simply use a 0 value for musb->is_active.
>>>> 
>>>>   Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>>> 
>>> Please don't attach patches, our tools don't like them at all.
>> 
>> Sorry. That was by accident. Here is the patch appended.
> 
> That's better, but we need a "clean" patch to be able to apply it for
> real :)

Ok, please take it as a "bug report" and documentation how a
workaround could look like - and not as a fix to be applied.

> 
>>> And shouldn't we fix the root problem here, not just gloss over the fact
>>> that this pointer is NULL at this point in time?  Fixing the real issue
>>> should be the correct solution, right?
>> 
>> Well,
>> I must admit that I have no idea what the root cause could be 
>> (because I neither know the musb nor the gadget subsystems)
>> or if it is intended and just something in the initialization
>> sequence has changed.
>> 
>> I have done one more test and it appears to be in a non-device-tree
>> 3.14-rc1 as well. We did not see it in a 3.12.7 kernel on the same hardware.
> 
> Ah, can you run 'git bisect' to track down the real problem here?  We
> don't like papering over problems like this, that doesn't help anyone
> out.

Well,I can't promise anything. Bisecting kernel panic problems means
compiling, flashing a SD cards, booting, looking at the result, telling git
the outcome and compiling a different commit.

I tried and failed immediately because the proposed bisects did
not even compile or boot on our hardware.

The problem appears to be that if we want to bisect e.g.

	(3.12.7 + private extensions) ... (3.14-rc1 + adapted private extensions)

that git bisect finds the common ancestor and presents some commit
in the middle. And that one does not "interpolate" between the required
private extensions but is some mainline version that we can't even
compile (first problem is with our defconfig not being available).

But we need these extensions to make the kernel run on our board and
are in the (uncompleted) middle of upstreaming them. So I think bisecting
works only on boards that are already completely supported by mainline.
Or at least at the "bisect good" commit.

So to me it appears that the faster approach would be if someone who
understands how musb interacts with the gadget setup/loading mechanism
helps to look into the code.

Hope we can find someone with more insights on the code than me,
Nikolaus Schaller

