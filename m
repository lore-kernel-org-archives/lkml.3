Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbbALQMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:12:07 -0500
Received: from smtp-out-148.synserver.de ([212.40.185.148]:1074 "EHLO
	smtp-out-148.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbALQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:12:03 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6721
Message-ID: <54B3F24F.2010508@metafoo.de>
Date: Mon, 12 Jan 2015 17:11:59 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: Simplify IIO provider access locking mechanism
References: <1420817893-5858-1-git-send-email-iivanov@mm-sol.com>			 <54AFF6C4.9020306@metafoo.de> <1420818639.28652.5.camel@mm-sol.com>		 <54AFF9D3.7000007@metafoo.de> <1420820083.28652.7.camel@mm-sol.com>	 <54AFFEF9.5080408@metafoo.de> <1421070898.28652.13.camel@mm-sol.com>
In-Reply-To: <1421070898.28652.13.camel@mm-sol.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 02:54 PM, Ivan T. Ivanov wrote:
>
> On Fri, 2015-01-09 at 17:16 +0100, Lars-Peter Clausen wrote:
>> On 01/09/2015 05:14 PM, Ivan T. Ivanov wrote:
>>> On Fri, 2015-01-09 at 16:54 +0100, Lars-Peter Clausen wrote:
>>>> On 01/09/2015 04:50 PM, Ivan T. Ivanov wrote:
>>>>> On Fri, 2015-01-09 at 16:41 +0100, Lars-Peter Clausen wrote:
>>>>>> On 01/09/2015 04:38 PM, Ivan T. Ivanov wrote:
>>>>>>> Instead of checking whether provider module is still
>>>>>>> loaded on every access to device just lock module to
>>>>>>> memory when client get reference to provider device.
>>>>>>>
>>>>>>
>>>>>> This has nothing to do with the module, it's about the device. In the Linux
>>>>>> device driver model as device can be unbound at any time and the IIO
>>>>>> framework needs to handle this.
>>>>>>
>>>>>
>>>>> Hm. Probably i am missing something here, but is this
>>>>> still true if we have reference to device structure?
>>>>
>>>> Yes, that only prevents the memory of device from being freed. But the
>>>> device can still be unbound from the driver.
>>>>
>>>> Think of e.g. a USB device that is pulled from the USB connector. Nothing
>>>> you can do in software about having the device disappear.
>>>>
>>>
>>> Agree, but I think that the patch is still valid. Module
>>> have to be pinned in memory as long as there are device
>>> driver users.
>>
>> No, the idea of the Linux driver model is that you can remove the module of
>> a driver at any time, which will unbind the device from the driver. Once you
>> reinsert the module the device will be re-bound to the driver.
>
> I will say that device can be unbind at any time and not that module be can
> unload at any time. But yes, and I'm not saying the opposite. There are a
> lot of examples in kernel, where you can not unload driver if it is used by
> another driver. See kernel-haking.tmpl.

If you remove the module the driver will be unregistered. Unregistering the 
driver will unbind all devices currently bound to the driver. This will 
invoke the drivers remove callback for those devices. In the remove callback 
the device is supposed to release all resource etc. that depend on the 
driver module being loaded. So there is no need to increase the module 
refcount and prevent it from being removed if there is a device registered 
for the driver.

- Lars


