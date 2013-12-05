Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3LELSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:18:44 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:50181 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3LELSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:18:41 -0500
Message-ID: <52A0610D.50903@linux.com>
Date: Thu, 05 Dec 2013 12:18:37 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        EDAC <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
References: <5298F900.9000208@linux.com> <20131129205628.GA20144@pd.tnic> <52999419.7040600@linux.com> <20131130111214.GB4323@pd.tnic> <20131203022330.GA25136@gchen.bj.intel.com> <20131203170150.GA5369@pd.tnic> <20131204073824.GA22134@gchen.bj.intel.com> <529F76CB.8080601@linux.com> <20131205025741.GA26999@gchen.bj.intel.com>
In-Reply-To: <20131205025741.GA26999@gchen.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-05 03:57 keltezéssel, Chen, Gong írta:
> On Wed, Dec 04, 2013 at 07:39:07PM +0100, Levente Kurusa wrote:
>> Date:	Wed, 04 Dec 2013 19:39:07 +0100
>> From: Levente Kurusa <levex@linux.com>
>> To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Thomas
>>  Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>, "H. Peter
>>  Anvin" <hpa@zytor.com>, x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
>>  LKML <linux-kernel@vger.kernel.org>
>> Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
>> User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
>>  Thunderbird/24.1.0
>>
>> 2013-12-04 08:38, Chen, Gong:
>>> On Tue, Dec 03, 2013 at 06:01:50PM +0100, Borislav Petkov wrote:
>>>> Date: Tue, 3 Dec 2013 18:01:50 +0100
>>>> From: Borislav Petkov <bp@alien8.de>
>>>> To: "Chen, Gong" <gong.chen@linux.intel.com>
>>>> Cc: Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
>>>>  Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>, "H.
>>>>  Peter Anvin" <hpa@zytor.com>, x86@kernel.org, EDAC
>>>>  <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
>>>> Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
>>>> User-Agent: Mutt/1.5.21 (2010-09-15)
>>>>
>>>> Can you please fix your
>>>>
>>>> Mail-Followup-To:
>>>>
>>>> header? It is impossible to reply to your emails without fiddling with
>>>> the To: and Cc: by hand which gets very annoying over time.
>>>
>>> I add some configs in my muttrc. Hope it works.
>>>
>>>>
>>>> On Mon, Dec 02, 2013 at 09:23:30PM -0500, Chen, Gong wrote:
>>>>> I have some concerns about it. if device_register is failed, it will
>>>>> backtraces all kinds of conditions automatically, including put_device
>>>>> definately. So do we really need an extra put_device when it returns
>>>>> failure?
>>>>
>>>> Do you mean the "done:" label in device_add() which does put_device()
>>>> and which gets called by device_register()?
>>>>
>>>
>>> Not only. I noticed that another put_device under label "Error:".
>>>
>>
>> That label is called when we failed to add the kobject to its parent.
>> It just puts the parent of the device. I don't think it has anything
>> to do with us put_device()-ing the actual device too.
>>
> OK, you are right. I read some kobject related codes and get:
> 
> static inline void kref_init(struct kref *kref)
> {
>         atomic_set(&kref->refcount, 1);
> }
> 
> The init refcount is 1, which means even if we meet an error and put_device
> in device_add, we still need an extra put_device to make refcount = 0
> and then release the dev object.

Exactly. This is why the comment you have found later on. :-)
> 
> BTW, from the comments of device_register:
> 
> "NOTE: _Never_ directly free @dev after calling this function, even
>  if it returned an error! Always use put_device() to give up the
>  reference initialized in this function instead. "
> 
> Many caller don't follow this logic. For example:
> in arch/arm/common/locomo.c
> locomo_init_one_child
> ...
>         ret = device_register(&dev->dev);
>         if (ret) {
> out:
>                 kfree(dev);

Umm, but it frees dev which is a container_of dev->dev so dev->dev is not
even freed. This is a memleak as well.
>         }
> ...
>  
> in arch/parisc/kernel/drivers.c
> create_tree_node
> ...
>         if (device_register(&dev->dev)) {
>                 kfree(dev);

Same here.
>                 return NULL;
>         }
> ...
> 
> etc.
> 
> Maybe we need one more patch to fix them all. :-)

Yes, I will post a series which fixes this during the weekend when I am not that busy. :-)

-- 
Regards,
Levente Kurusa
