Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaESInH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:43:07 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36956 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaESInF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:43:05 -0400
Message-ID: <5379C3A7.1090404@ahsoftware.de>
Date: Mon, 19 May 2014 10:41:11 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 2/9] dt: deps: dependency based device creation
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-3-git-send-email-holler@ahsoftware.de>	<20140514140534.897F8C4153D@trevor.secretlab.ca>	<53777113.3070909@gmail.com> <20140518145922.9D59FC40D85@trevor.secretlab.ca>
In-Reply-To: <20140518145922.9D59FC40D85@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.05.2014 16:59, schrieb Grant Likely:
> Hi Tomasz,
>
> Thanks for weighing in on this. Thoughts and comments below.
>
> On Sat, 17 May 2014 16:24:19 +0200, Tomasz Figa <tomasz.figa@gmail.com> wrote:

> registration order. Alexander had to hook into the driver registration
> patch to get the optimal probe order. For device order to be effective,

I had to hook into the driver registration to get information about the 
(available) drivers. Without the hook it is currently impossible to 
identify drivers before they start doing things.

To reccover, I had to solve several problems:

- Getting dependencies (happens almost automatically by using phandle 
references)
- Get them to the kernel (done by using a new property)
- Build order (already a solved problem, think at make)
- Identify available drivers (invented hook, "well done" is meant in 
regard to this feature, I needed a name and found "well done" apropriate 
because it too might stimulate driver authors to use it)
- Check out how to handle/start/register devices and drivers (in order).

I think the last one is the most unfinished and questionable part.

The part to identify drivers could be done much better by linking an 
array of struct platform_driver, but in order to use such an array, 
drivers have to be done "well done" too (which means no action before 
probe). So that well-done hook can be seen as an intermediate step.

> Having said that, there are some things that I worry about. I worry
> about the cost of doing dependency sorting, both in calculating the
> dependency tree and in pushing back probe calls to the end of initcalls.

Building and calculating the dependency tree just needs a few ms and I 
think it's much faster than what is necessary afterwards, all those 
string compares to match drivers/devices.

But this string compares already do happen, and I think this part could 
optimized a lot, when a list of drivers and their compatibility strings 
is available. Then it's possible to build a hash or e.g. radix tree 
which leads from the compatibility string to the available driver(s).

> I worry that incorrect dependency information will cause some devices to
> not get bound (say because the kernel things the dependency isn't met
> when it actually is).

All (not started) drivers and (unbounded) devices can still be 
registered/bound after those which appear in the order. That would be 
just like before.

But as said, the whole handling which happens after the order was build 
is done quick & dirty, done with missing knownledge about the device 
model, and might contain a lot of bugs and even might need that some 
drivers will be changed.

Therefor all changes disappear when CONFIG_OF_DEPENDENCIES is disabled. 
So tested platforms might use it (taking advantage of a deterministic 
order in order to get rid of hardcoded stuff to fix the order) and 
others don't have to care.

So, as already said, I've posted these patches to make evaluation easy, 
without the need to discuss just ideas but something real to play with 
(in order to get something happen on this front, not just hardcoded 
hacks done in individual drivers because such passes maintainers easier).

I didn't cared much about form or how to split those patches into more 
convenient parts. That is stuff where I just do it like a maintainer 
does want it. I did them as I like them, and I don't want to end up in a 
time wasting discussions about form, style or similiar questions.

So if anyone would be comfortable to merge these patches (for evaluation 
by others) in other form or splitted in more parts, I will just hear and do.

I also don't have any objections in changes in the stuff which happens 
after the order was build. In fact I would even like it if someone with 
more experience with the driver model would do it. I just had to do 
something there too, otherwise it would still have been just an idea 
which wouldn't offer much motivation to actually look at it.

Regards,

Alexander Holler
