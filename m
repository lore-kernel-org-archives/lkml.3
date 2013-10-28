Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab3J1Rfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:35:32 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61428 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab3J1Rfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:35:30 -0400
MIME-Version: 1.0
In-Reply-To: <20131028173056.GF11209@redhat.com>
References: <525BD08C.2080101@t-online.de> <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
 <alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
 <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
 <CA+55aFyb72qoZ1Tjpb+=q-6+GmwoOXjfntY_zZnf300gg3d1Hg@mail.gmail.com>
 <CA+55aFxuVpDo3LvmG9j-Hu7sENLTcsB6_CY2TA4mE-k+CuTeGg@mail.gmail.com>
 <CA+55aFz9ewd7VhCKDxJUzY4PGH7E3N-xMr=pDGQxf1PyNd1W1w@mail.gmail.com>
 <20131027212407.GA17439@kroah.com> <CAErSpo5NmBDqRA3URAQPmw4iC3xvpDdd9JFROuftLJE1YsbPhA@mail.gmail.com>
 <20131028173056.GF11209@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Oct 2013 11:35:09 -0600
Message-ID: <CAErSpo4YgTgapdUcMwMWZzQqDHn8AcGu-OPQfWbP4svUerr0Ow@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
To: Veaceslav Falico <vfalico@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:30 AM, Veaceslav Falico <vfalico@redhat.com> wrote:
> On Mon, Oct 28, 2013 at 11:23:41AM -0600, Bjorn Helgaas wrote:
>>
>> [+cc Veaceslav]
>>
>> On Sun, Oct 27, 2013 at 3:24 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> On Sun, Oct 27, 2013 at 09:13:29PM +0000, Linus Torvalds wrote:
>>>>
>>>> .. and one more case of freeing a delayed work object (likely a kobject
>>>> again):
>>>>
>>>> This time it looks like it's in the PCI layer, freeing the msi irq
>>>> information.
>>>>
>>>> It looks like that code simply does
>>>>
>>>>     kobject_del(&entry->kobj);
>>>>     kobject_put(&entry->kobj);
>>>>     list_del(&entry->list);
>>>>     kfree(entry);
>>>>
>>>> and the problem is that the "entry->kobj" may have *other* references
>>>> to it, thanks to people accessing it through /sys, so despite doing a
>>>> kojbect_del/kobject_put(), it's not at all ok to then do a "kfree()"
>>>> on it. The embedded kobj might still be in use.
>>>>
>>>> Afaik, that code should do the kfree() on the kobject in the _release_
>>>> method, not synchronously like that.
>>>>
>>>> We already have a msi_kobj_release(), I'm wondering why that doesn't
>>>> do the kfree().
>>>>
>>>> Bjorn? Yinghai? Greg, comments about that msi kobj usage?
>>>
>>>
>>> Ick, it really should be doing a kfree() in the release only.  Bjorn has
>>> had a bunch of changes in this area recently, perhaps they are in
>>> linux-next waiting for 3.13, and I've talked to him about getting rid of
>>> all of the kobjects for msi files, as I don't think it's needed at all.
>>
>>
>> IIRC, you said you might take a look at converting this to attributes
>> on the train back home, so I haven't looked into it myself :)
>>
>>> Bjorn, don't you have a fix for this problem already done somewhere?
>>
>>
>> Yep, this is clearly wrong, and Veaceslav has a patch that moves the
>> kfree() to the release function.  I've been waiting for a consolidated
>> repost of all his MSI-related fixes, but maybe he's been waiting for
>> *me*.
>
>
> https://lkml.org/lkml/2013/10/9/170
>
> My patchset is ready to be applied, in its v2 state.
>
> Except that the bits with kobject_del() (theoretical race) - which are done
> in your patch "kobject: remove kset from sysfs immediately in
> kset_unregister()", though I didn't see it accepted.
>
> Should I re-send the patchset?

Can you please repost it?  That will be easier for me than digging
individual messages out of the archives.  Thanks, and sorry for my
confusion.

Bjorn
