Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbaISVqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:46:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbaISVqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:46:46 -0400
Message-ID: <541CA442.5080201@suse.de>
Date: Fri, 19 Sep 2014 23:46:42 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Kim Phillips <kim.phillips@freescale.com>,
        Yoder Stuart-B08248 <stuart.yoder@freescale.com>,
        Rivera Jose-B46482 <German.Rivera@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>	 <20140915184451.962a3a19c4940792d182f10a@freescale.com>	 <541A5CF1.8000409@freescale.com>	 <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>	 <20140918152233.41647ee517393816bb35b72a@freescale.com>	 <541B9D5F.20008@freescale.com>	 <20140919121912.197b15bd3b79fb90d7f97602@freescale.com>	 <3e06c5d2f97e446c8a9d8d8211c69a3e@CY1PR0301MB0748.namprd03.prod.outlook.com>	 <20140919152453.9a7095a77c0752998ed8621b@freescale.com>	 <541C92F9.1020805@suse.de> <1411159315.13320.81.camel@snotra.buserror.net>
In-Reply-To: <1411159315.13320.81.camel@snotra.buserror.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19.09.14 22:41, Scott Wood wrote:
> On Fri, 2014-09-19 at 22:32 +0200, Alexander Graf wrote:
>>
>> On 19.09.14 22:24, Kim Phillips wrote:
>>> On Fri, 19 Sep 2014 14:06:32 -0500
>>> Yoder Stuart-B08248 <stuart.yoder@freescale.com> wrote:
>>>
>>>>>>>>>>> +/**
>>>>>>>>>>> + * @brief    Management Complex firmware version information
>>>>>>>>>>> + */
>>>>>>>>>>> +#define MC_VER_MAJOR 2
>>>>>>>>>>> +#define MC_VER_MINOR 0
>>>>>>>>>>
>>>>>>>>>> code should be adjusted to run on all *compatible* versions of h/w,
>>>>>>>>>> not strictly the one set in these defines.
>>>>>>>>> This comment is not precise enough be actionable.
>>>>>>>>> What exactly you want to be changed  here?
>>>>>>>>
>>>>>>>> I think the easy thing to do is to convert the exact version check into a ranged version check: have
>>>>> minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the
>>>>> version at all - or only for the major version and guarantee that the major version indicates backwards
>>>>> compatibility.
>>>>>>>
>>>>>>> yes, this was my point: elsewhere I noticed the code denies to run
>>>>>>> iff those defines are not matched exactly: that code should change
>>>>>>> to run as Alex describes.
>>>>>>>
>>>>>> As I mentioned in the reply to Alex, I will remove the minor version check.
>>>>>
>>>>> the code should be able to run on all subsequent versions of the
>>>>> h/w, even in the major version case.
>>>>
>>>> You're right, in the future if there are future major versions we would want this
>>>> same driver to function on multiple versions of the hardware.  But at this
>>>> point in time we don't know what future evolutions there will be and we 
>>>> need the check to error out for now.
>>>
>>> why?  We have to make the standard assumption that newer versions
>>> will be backward compatible, in which case the driver should be left
>>> to run.
>>
>> How much is the interface set in stone? Can we indicate to the MC that
>> we want version x of the protocol? Then the MC can tell us whether it's
>> compatible or not.
> 
> I don't trust that new versions will be 100% backwards compatible
> (though I hope they will be), but do we normally bother making a driver
> refuse to run on newer versions?  Sure, if we need to explicitly match a
> comptible string or PCI ID, the match will be rejected if the driver
> doesn't know about it, but if it's a version in a register we usually
> only check for known issues with certain versions.

If the major number is defined as "this interface is incompatible", it
really is on the same lines as a PCI ID or a new compatible string, no?

So IMHO having a version check on the major version is reasonable as a
sanity check.

>  
>>>>   The driver will have to be changed
>>>> in the future to dynamically deal with different versions.
>>>>
>>>> We could add a TODO in the driver to note that.
>>>
>>> "TODO: add support for new h/w versions" is almost universally true
>>> for all drivers, we don't need to write that down.
>>>
>>> Support for new h/w versions with new features should be
>>> incrementally added once they're known.
>>
>> The "version id" is basically the equivalent of the pci device id. We
>> don't add wildcards there either for unknown pieces of hardware, so
>> limiting to driver to "known good" devices is sane IMHO.
> 
> How would you go about adding a wildcard to a PCI ID even if you wanted
> to?  Version information on PCI is not separate from device
> identification.

Yup. Hence you can't expect a new version of e1000 to work with an old
driver for example - it will have a new PCI ID. So on most hardware, we
do have major version checks through that interface. If you want, the
"revision" config space field in PCI could be the equivalent of a minor
version number here - drivers still match because the device ID itself
still matches.

The alternative to the approach taken here would be to have an "mc
bridge device" that gets proper device tree compatible versioning.
Overall the matching and compatibility decision would then lie in the
device tree.

Speaking of which, how does Linux find this new bus? I couldn't find
anything that describes the device tree bindings, but maybe I just
missed them.


Alex
