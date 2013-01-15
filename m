Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab3AOByF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:54:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54837 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab3AOByC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:54:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
	<CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
	<CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
	<CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
	<CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
Date: Tue, 15 Jan 2013 09:53:59 +0800
Message-ID: <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 1:30 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Jan 13, 2013 at 11:15 PM, Ming Lei <ming.lei@canonical.com> wrote:
>>
>> The deadlock problem is caused by calling request_module() inside
>> async function of do_scan_async(), and it was introduced by Linus's
>> below commit:
>>
>> commit d6de2c80e9d758d2e36c21699117db6178c0f517
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Fri Apr 10 12:17:41 2009 -0700
>>
>>     async: Fix module loading async-work regression
>>
>> IMO, maybe the commit isn't a proper fix, considered the
>> below fact:
>>
>> - it isn't good to allow async function to be marked as __init
>
> Immaterial. For modules, __init is a non-issue. For non-modules, the
> synchronization elsewhere is sufficient.

Looks 5d38258ec026921a7b266f4047ebeaa75db358e5(ACPI battery:
fix async boot oops) addresses the issue of __init for modules.

>
>> - any user mode shouldn't expect that the device is ready just
>> after completing of 'insmod'
>
> Bullshit. That expectation is just a fact. People insmod a device
> driver, and mount the device immediately in scripts.

I mean we can let the device node populated in probe() first,
but let open() wait for completion of the async probe(). Maybe my
expression is not accurate, here the 'device isn't ready' just means
that the async probe() isn't completed, and doesn't mean the device
node doesn't come.

>
> We do not say "user mode shouldn't". Seriously. EVER. User mode
> *does*, and we deal with it. Learn it now, and stop ever saying that
> again.
>
> This is really starting to annoy me. Kernel developers who say "user
> mode should be fixes to not do that" should go somewhere else. The
> whole and *only* point of a kernel is to hide these kinds of issues
> from user mode, and make things "just work" in user mode. User mode
> should not ever worry about "oh, doing X can trigger a module load, so
> now the device might not be available immediately, so I should delay
> and re-try until it is".
>
> That's just f*cking crazy talk.
>
> We have a very simple rule in the kernel: we don't break user space. EVER.

No, I don't mean we should break user space, see above.

>
> Learn that rule. I don't ever want to hear "any user mode shouldn't
> expect" again. User mode *does* expect. End of discussion.
>
>> - from view of driver, introducing async_synchronize_full() after
>> do_one_initcall() inside do_init_module() is like a sync probe
>> for drivers built as module, and cause this kind of deadlock easily.
>>
>> So could we revert the commit and fix the previous problems just
>> case by case? or other better fix?
>
> There's no way in hell we take a "fix things one by one" approach.
> It's not going to work. And your suggestion seems to not do async
> discovery of devices in general, which is a *much* worse fix than
> anything else. It's just crazy.

I will try to figure out one patch to address the scsi block async probe
issue first, and see if it can fix the problem by moving add_disk()
into sd_probe()
and calling async_synchronize_full_domain(&scsi_sd_probe_domain)
in the entry of sd_open().

>
> But there are other approaches we might take. We might move the call to
>
>     async_synchronize_full();
>
> to other places. For example, maybe we're better off doing it at
> block/char device open instead?

Looks it is similar with the above idea, but we have to remove the
async_synchronize_full() in do_init_module() together.

Thanks,
--
Ming Lei
