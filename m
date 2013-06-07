Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3FGPMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:12:30 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:35620 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756038Ab3FGPM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:12:27 -0400
Message-ID: <51B1F859.1010504@itdev.co.uk>
Date: Fri, 07 Jun 2013 16:12:25 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com> <51AFA02B.3000604@itdev.co.uk> <20130605210715.GA16013@core.coreip.homeip.net> <51AFAF6D.7050204@itdev.co.uk> <20130606100346.GC1883@sirena.org.uk> <51B0651D.3090902@itdev.co.uk> <20130606105530.GT31367@sirena.org.uk> <51B06FE4.7040805@itdev.co.uk> <20130606131638.GX31367@sirena.org.uk> <51B0B52C.1090807@itdev.co.uk> <20130606164629.GG31367@sirena.org.uk>
In-Reply-To: <20130606164629.GG31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Jun 06, 2013 at 05:13:32PM +0100, Nick Dyer wrote:
> 
>> I am not a legal expert, but I have described what you suggest to people
>> who are more expert in the NDA terms and they say I cannot implement a
>> solution which exposes the names of all the parameters. In any case,
> 
> Who said anything about names?  I'd assume the userspace stuff is
> eventually talking to the device based on numbers of some kind and I'd
> expect that this would be what ends up in the API.

OK. But if user-space is talking to the device based on register numbers, a
binary attribute seems like the correct way to present that - isn't that
what they're designed for?

>> And we wouldn't have won anything, because the user could still write to
>> the register that turns off reporting (for example) by mistake with both
>> methods.
> 
> You'd not have access to the entire device register map which seems like
> a win

Not really.

The chip itself will enforce which registers are read-only (by ignoring
writes) or write-only (by returning zeros if read). Encoding all this
information in the driver would just make it more brittle in the face of
touch controller firmware updates.

It would be possible for the driver to intermediate for some of the
registers that it cares about. For example, if we change the screen width
then the driver could reinitialise the input device. But I can't see that
it makes sense if you are changing several settings in a row for the input
device to be reinitialised several times. It is far less buggy to provide a
single way of tearing down everything and reinitialising (which could be
simply triggered from user space) than to encode all of the dependencies
(which is bound to introduce bugs).

It's not laziness, it's trying to push policy into user space.

>> Touch controllers are inherently complex system with a lot of configurable
>> parameters. The fact that it's complex and changes quickly doesn't make it
>> badly designed per se.
> 
> Having lots of configuration and having the parameters change regularly
> doesn't immediately mean that it has to be complex - the requirement is
> very common, touchscreens aren't too remarkable here.  The usual thing
> is for the kernel to understand how to transfer data back and forth but
> not the content of the data.

Sure, that's what I'm trying to accomplish. It's just that as far as I can
see it makes more sense to use the established protocol that these chips
have implemented rather than trying to bodge something else over the top or
crowbar it into a different model that will cause abstraction problems. We
have thought about this problem at great length, and discussed it on these
lists, and with other kernel engineers at customers, etc.
