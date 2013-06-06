Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3FFQNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:13:36 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:12844 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753463Ab3FFQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:13:34 -0400
Message-ID: <51B0B52C.1090807@itdev.co.uk>
Date: Thu, 06 Jun 2013 17:13:32 +0100
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
References: <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com> <51AF8730.4010507@itdev.co.uk> <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com> <51AFA02B.3000604@itdev.co.uk> <20130605210715.GA16013@core.coreip.homeip.net> <51AFAF6D.7050204@itdev.co.uk> <20130606100346.GC1883@sirena.org.uk> <51B0651D.3090902@itdev.co.uk> <20130606105530.GT31367@sirena.org.uk> <51B06FE4.7040805@itdev.co.uk> <20130606131638.GX31367@sirena.org.uk>
In-Reply-To: <20130606131638.GX31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> I'm sorry, this just doesn't seem plausible.  The data is going to be on
> the running system and accessed via the kernel - as soon as people start
> using this back door they're going to be revealing what they're
> accessing and the information is going to be present in the binary blobs.
> You're only revealing that the parameters are present, not what they
> mean, and if it's a big concern then do something like strip down the
> data file that gets shipped in production to just the controls that are
> being accessed.

I am not a legal expert, but I have described what you suggest to people
who are more expert in the NDA terms and they say I cannot implement a
solution which exposes the names of all the parameters. In any case,
although having a data file which maps all the parameters is a good idea,
they don't exist at present time, so it's really a moot point in terms of
reaching a usable solution.

Without the register names all you really have is the object protocol that
we started with, you would end up accessing

/sys/bus/i2c/drivers/atmel_mxt_ts/1-0020/objectX/registerX

rather than parsing the object table once when your program started, then
performing a read/write to offset X.

And we wouldn't have won anything, because the user could still write to
the register that turns off reporting (for example) by mistake with both
methods.

And I would then have to write a user-space program that stuck it all back
together and simulated the register access interface so our existing tools
would work properly, and it would probably introduce a bunch of new bugs.

> Again, the fact that you have shipped this stuff doesn't make much
> difference here - you really should work with upstream on interfaces
> like this sooner rather than later otherwise you're going to have to
> cope with pushback.

I appreciate your feedback. In the end the only way to find what will be
accepted is to post patches and try to justify the technical decisions made.

You may dislike the way that these chips have been implemented, but in the
end I can't rip it all up and redesign, I'm only the driver guy and I have
to try and improve things in an incremental fashion from where they
currently are.

The other patches in this series are much more important. If the answer is
that I need to remove this particular change from the series and rework the
driver on top of regmap (or design something new) to meet this requirement,
then that is disappointing. But so be it, we want to be working upstream so
we want to solve this problem upstream.

>> If we expose every single parameter as a get/set as you suggest, we haven't
>> added anything that stops a binary of the wrong version doing something
>> stupid. We've just added a complex API to the same underlying thing, which
>> gains nothing.
> 
> So this goes back to what I was saying before about the interface being
> badly designed - if the API you have to present is really this complex
> then you've got a big problem in kernel or out of kernel.

Touch controllers are inherently complex system with a lot of configurable
parameters. The fact that it's complex and changes quickly doesn't make it
badly designed per se.
