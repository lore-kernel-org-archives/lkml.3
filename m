Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3IRFdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 01:33:17 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:40051 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3IRFdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 01:33:06 -0400
MIME-Version: 1.0
In-Reply-To: <878uyuzxp0.fsf@rustcorp.com.au>
References: <20130724071757.GA30970@gondor.apana.org.au> <87siz38q2t.fsf@rustcorp.com.au>
 <20130725020329.GA14625@gondor.apana.org.au> <CAKi4VA+=1vOOt0BqdQHQaeF1hP3DrRtCL_ObXY0cPeO7S_MtYw@mail.gmail.com>
 <87ob7x37p6.fsf@rustcorp.com.au> <CAKi4VALAu0ek6tYhb_Ls34hNU1Omjhv=QJDaACAp_0gpRy98HA@mail.gmail.com>
 <878uyuzxp0.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Wed, 18 Sep 2013 02:32:45 -0300
Message-ID: <CAMOw1v7RhTfWu0K64ndxXdET9JQjg7Pr3DWKGMSM9gN9_pviJQ@mail.gmail.com>
Subject: Re: [PATCH] modules: add support for soft module dependencies
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Andreas Robinson <andr345@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        David Miller <davem@davemloft.net>, tim.c.chen@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        linux-modules <linux-modules@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 11:10 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
>> On Thu, Sep 12, 2013 at 9:07 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
>>>> On Wed, Jul 24, 2013 at 11:03 PM, Herbert Xu
>>>> <herbert@gondor.apana.org.au> wrote:
>>>>> On Thu, Jul 25, 2013 at 09:32:02AM +0930, Rusty Russell wrote:
>>>>>> Herbert Xu <herbert@gondor.apana.org.au> writes:
>>>>>> > Hi Rusty:
>>>>>> >
>>>>>> > I don't know why this patch never went into the kernel, even
>>>>>> > though the corresponding features have been added to modprobe
>>>>>> > in most if not all distros.
>>>>>>
>>>>>> Because Andreas never sent me the patch?  This is the first I've *heard*
>>>>>> of this feature.  Looks like it didn't hit lkml either.  And what was
>>>>>> 2/2?
>>>>>
>>>>> 2/2 was the patch to actually use this in crc32c.
>>>>>
>>>>>> It's not how I would have done this: post-deps are more flexibly done at
>>>>>> runtime, because the module may have to do work to figure out what to
>>>>>> pull in.  But since it already exists, I'll apply this patch: it doesn't
>>>>>> cost the kernel anything.
>>>>
>>>> But it did cause boot failures. The file modules.softdep file was
>>>> supposed to be informational until now. That's why depmod put a
>>>> comment saying to "copy on user's discretion to /etc/modules.d"
>>>> instead of parsing it directly.
>>>
>>> I'm happy to change this macro to create a modinfo line like
>>> "softdep:<modname>"
>>
>> how is that solving the issue that this macro can be used to designate
>> a mandatory or optional dependency
>> (https://lkml.org/lkml/2013/9/10/371)? If we decide the dependency is
>> mandatory we can very well let modprobe use that dependency during
>> module load
>
> I'm very close to sending Linus a revert commit at this point, since
> there's no consensus on what it's for.
>
> *Clearly* softdep shouldn't indicate a mandatory dependency.  We already
> have a way (several) to make mandatory dependencies!
>
> And the "pre:" vs "post:" thing is just weird.  If a module wants a post
> dependency, you can request_module() it from a workqueue.
>
>>> ie. tools like mkinitrd could pick it up and try to find a matching
>>> module, but depmod would ignore it.
>>
>> Some mkinitrd-like use whatever depmod/modprobe tells them it's
>> needed. So kmod still needs to know about it.
>
> It sounds like we should create a separate tool, which takes a list of
> modules and spits out the full pathname of all dependencies.  *That*
> tool should include soft dependencies.
>
>>> It's really up to Lucas, since this affects him.
>>
>> IMO  saying "this is an optional dependency and we can work without"
>> doesn't buy us much. Distros will end up putting the soft dep in
>> /etc/modules.d, kmod will always use them anyway and failing to load
>> the soft dep will fail the module load. I'd like to have no distro
>> files in /etc/modules.d in future.
>
> I assumed modprobe would handle soft dependencies in modules and try to
> pull them in, but *not* fail if they don't work.

Iff the module doesn't *exist*. If it failed to load or failed for any
other reason then we will abort trying to load the other module.
However this is one thing we can change in modprobe to make it
consistent and more predictable. But we really need to reach a
consensus.

>
> The previous way of doing this was:
>         install foo modprobe foo_softdep 2>/dev/null; modprobe --ignore-install foo $CMDLINE_OPTS

I just hope this is in no way an incentive for people using install commands ;-)


Lucas De Marchi
