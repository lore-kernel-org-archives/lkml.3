Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968007Ab3HISIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:08:35 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:39186 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965075Ab3HISIe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:08:34 -0400
Subject: Re: [PATCH 3/5] omap: Properly handle resources for omap_devices
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <87ioze7rfx.fsf@kernel.org>
Date: Fri, 9 Aug 2013 21:08:23 +0300
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt_Cousson?= <benoit.cousson@gmail.com>,
        Paul Walmsley <paul@pwsan.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Koen Kooi <koen@circuitco.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9212EC22-CD28-4D32-8EE0-F291B93719A6@antoniou-consulting.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com> <1375775624-12250-4-git-send-email-panto@antoniou-consulting.com> <87a9kt2vd8.fsf@linaro.org> <A4346403-362E-4E74-9C5E-07509CBC0BF4@antoniou-consulting.com> <87mwoqao95.fsf@kernel.org> <B929744A-C23A-41F6-A9AC-C18571A1F39B@antoniou-consulting.com> <87ioze7rfx.fsf@kernel.org>
To: Kevin Hilman <khilman@linaro.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Aug 9, 2013, at 7:35 PM, Kevin Hilman wrote:

> Pantelis Antoniou <panto@antoniou-consulting.com> writes:
> 
>> Hi
>> On Aug 9, 2013, at 6:16 PM, Kevin Hilman wrote:
>> 
>>> Pantelis Antoniou <panto@antoniou-consulting.com> writes:
>>> 
>>>> Hi Kevin,
>>>> 
>>>> On Aug 7, 2013, at 9:45 PM, Kevin Hilman wrote:
>>>> 
>>>>> [fixing address for Benoit]
>>>>> 
>>>>> Pantelis Antoniou <panto@antoniou-consulting.com> writes:
>>>>> 
>>>>>> omap_device relies on the platform notifier callbacks managing resources
>>>>>> behind the scenes. The resources were not properly linked causing crashes
>>>>>> when removing the device.
>>>>>> 
>>>>>> Rework the resource modification code so that linking is performed properly,
>>>>>> and make sure that no resources that have no parent (which can happen for DMA
>>>>>> & IRQ resources) are ever left for cleanup by the core resource layer.
>>>>>> 
>>>>>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>>>>> 
>>>>> This one failed my "took more than 15 minutes to understand" test.  The
>>>>> changelog is rather vague (especially about what "properly" means), and
>>>>> the combination of moving code and changing it makes the patch rather
>>>>> clunky to read, so I remain a bit confused about what the actual problem
>>>>> is.  Please elaborate.
>>>>> 
>>>>> Also, could you share a crash dump as well as details about how to
>>>>> reproduce this problem?
>>>>> 
>>>>> Thanks,
>>>>> 
>>>>> Kevin
>>>> 
>>>> It's the full patchset that fixes the problem:
>>>> 
>>>> Let me illustrate:
>>>> 
>>>> The kernel I use is located at:
>>>> 
>>>> git@github.com:pantoniou/linux-beagle-track-mainline.git
>>>> branch: merge-20130806 (there are topic branches for other stuff too)
>>> 
>>> Sorry, I don't have the time to go through a bunch of out of tree
>>> branches to figure this out.  Can you create a simpler test case to
>>> reproduce this?  e.g. Does this happen when building the serial driver
>>> as a module and then removing it?  If not, why not?
>> 
>> What 'bunch of out of tree branches'? There is a single merge branch against
>> current mainline. 
> 
> And That branch contains multiple other branches (as you stated yourself
> above), many of which look to be out of tree:
> 
> $ git log --oneline --merges  panto/master..panto/merge-20130806
> 031297e Merge branch 'lcdc-fixes' into merge-20130806
> 44cf018 Merge branch 'usb-fixes' into merge-20130806
> 3cc739b Merge branch 'tscadc' into merge-20130806
> f0ec35d Merge branch 'capemgr' into merge-20130806
> 4d87712 Merge branch 'general-fixes' into merge-20130806
> 04535fb Merge branch 'pinctrl-fixes' into merge-20130806
> 5115b55 Merge branch 'i2c-fixes' into merge-20130806
> e96edf5 Merge branch 'capes' into merge-20130806
> 1eb1779 Merge branch 'dts-fixes' into merge-20130806
> ca12149 Merge branch 'mmc-fixes' into merge-20130806
> 41ed7a0 Merge branch 'pdev-fixes' into merge-20130806
> 2ba9995 Merge branch 'of-fixes' into merge-20130806
> 38b5cb4 Merge branch 'dtc-overlays' into merge-20130806
> 167648d Merge branch 'dtc-fixes' into merge-20130806
> 2f7de02 Merge branch 'reset' into merge-20130806
> 
> $ git log --oneline --no-merges panto/master..panto/merge-20130806 |wc -l
> 85
> 

Yes, but they have nothing to do with the problem at hand; the only
branch that matters i pdev-fixes.

>> And no you don't trigger this by removing a module.
>> 
>> platform_driver_unregister() != platform_device_register().
>> 
>> I'll try to figure out something simpler, but it's pretty damn obvious that
>> something is not right there. 
> 
> I agree something does not seem right, and never said otherwise.  I'm
> simply looking for an easy way to reproduce it with mainline.  
> 
> Since it's so "damn obvious", I'll accept the insult and agree to being
> a moron.  Please educate me by making it even more obvious with a way to
> reproduce it against mainline.
> 

You can't reproduce it via rmmod'ing a module; it's not the same code path.
That you need to do is to call platform_device_unregister() for the affected
device on a DT enabled board.

The only platform that triggers it currently is the beaglebone with DT
overlays support.

To get it to trigger on something simpler, I'll have to write a pretty
elaborate module where I register the device and then immediately unregister
it.

>> Do you think fixing problems in that part of platform device removal
>> was something I did because I didn't have other things to do?
> 
> Settle down, I said nothing of the sort.
> 
> On the contrary, I assumed you were being a generous citizen of the
> community and contributing back your fixes, and as a developer of this
> part of the kernel, I'm trying to help.  If I didn't care, I wouldn't
> have responded in the first place.
> 

OK

>> It is broken and I'm trying to get it fixed. Are you?
> 
> I was, but your accusatory tone is reducing my motivation to help.
> 

I guess that's a fair accusation; sorry for coming out a bit strong here.

Anyway, I'll see what it takes to come up with a test module that exhibits the issue
easier.

> Kevin
> 

Regards

-- Pantelis

