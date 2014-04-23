Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbaDWJu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:50:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61862 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbaDWJur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <87zjjcfwz1.fsf@rustcorp.com.au>
References: <20131127220746.GA11255@order.stressinduktion.org>
 <1385826152-17531-1-git-send-email-ynvich@gmail.com> <87a9g9s27z.fsf@rustcorp.com.au>
 <1386660574.7152.203.camel@host5.omatika.ru> <87zjjcfwz1.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 23 Apr 2014 06:50:27 -0300
Message-ID: <CAKi4VA+nHVPckqLYF6X9tjq2mvAZ0OFLsROxxH-6Y1G9+OqmZA@mail.gmail.com>
Subject: Re: [PATCH v2] fix printk output
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sergei Ianovich <ynvich@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 2:14 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Sergei Ianovich <ynvich@gmail.com> writes:
>> On Tue, 2013-12-10 at 15:59 +1030, Rusty Russell wrote:
>>> BTW, did you actually hit this?
>>
>> # modprobe usb_storage
>> [  600.807274] usbcore: registered new interface driver usb-storage
>> # modprobe -r usb_storage
>> [  604.216318] waiting module removal not supported: please upgrade[
>> 604.222164] usbcore: deregistering interface driver usb-storage
>> # modprobe -V
>> kmod version 9
>>
>> I am using the latest kmod package from emdebian unstable-grip.
>
> Sorry, was off on leave.
>
> Hmm, Lucas intimated that kmod version 11 started passing this flag
> correctly.

Sorry... rmmod was correctly updated but I forgot modprobe. My bad.
Then when I enforced it on libkmod, modprobe ended up doing the right
thing.

>
> In fact, kmod's modprobe *never* used the O_NONBLOCK
> (ie. KMOD_REMOVE_NOWAIT) flag, until it was finally enforced in
>
> commit 7ab8804448377fb6b8854f2dd288608db01bb43b
> Author: Lucas De Marchi <lucas.demarchi@intel.com>
> Date:   Fri Sep 20 01:30:07 2013 -0500
>
> See: tools/modprobe.c at that commit:
>
>         static int rmmod_do_remove_module(struct kmod_module *mod)
>         {
>                 const char *modname = kmod_module_get_name(mod);
>                 struct kmod_list *deps, *itr;
>                 int flags = 0, err;
> ...
>                 if (force)
>                         flags |= KMOD_REMOVE_FORCE;
>
>                 err = kmod_module_remove_module(mod, flags);
>
> Perhaps we need to just get rid of the kernel message, since we're
> getting far too many false reports :(

Now that I realize only kmod 16 has the fix... maybe. But I think this
commit could be easily backported to older versions if distros would
like to avoid the upgrade (even if they should not since latest
releases were more targeted to bug fixes). I'll try to push this or a
similar patch downstream to package maintainers.

Again, sorry about that.


Lucas De Marchi
