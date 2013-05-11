Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3EKUKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 16:10:51 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50856 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3EKUKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 16:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130510171054.GA27479@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
 <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com>
 <20130510125826.GA553@redhat.com> <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com>
 <20130510153638.GA8179@redhat.com> <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com>
 <20130510171054.GA27479@redhat.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Sat, 11 May 2013 17:10:30 -0300
Message-ID: <CAKi4VAK7KA6WyVkuw+QMBnzF63b-67Gq-VmhWBs69Q0Wnc7wNw@mail.gmail.com>
Subject: Re: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 2:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 05/10, Lucas De Marchi wrote:
>>
>> On Fri, May 10, 2013 at 12:36 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > Well, personally I think it would be better to use kasprintf(), see the
>> > patch I sent (it is actually wrong, needs kfree(args) before return).
>> >
>> > Or. How about the patch below? It should be split into 2 changes:
>> >
>> >         1. Introduce __argv_split(). It can have more callers, for
>> >            example do_coredump() and ftrace_function_filter_re()
>> >            can use it to avoid kstrndup() + kfree().
>> >
>> >         2. Change call_modprobe() to use kasprintf() + __argv_split().
>>
>> Seems better. In your previous version I was troubled about
>> duplicating the string twice.
>
> Oh, compared to other things we need to do this is nothing ;)
>
> But to me it just looks better this way.
>
>> Now it's weird freeing a
>> user-allocated-string,
>
> This is fine, the "weird" thing is that it frees the string even if
> fails. But this simplifies the usage.
>
>> but I think it's a good tradeoff and covers other use cases as you
>> pointed out as well.
>
> OK, good.
>
>> Ok. I'll give it a try.
>
> Please wait a bit, I'll send v2. See below.
>
>> > -char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
>> > +char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
>
> No. This is incompatible change, we shouldn't do this.

But then what option do we have? I don't think any distro writing to
sysctl would stop working without "-q --". And if they are indeed
using this during boot, I think they would be much safer to just
change to set this at compile time like this patch is trying to do.
Otherwise, the options are really ugly:

1) always give "-q --" by putting this on the kasprintf() call:
kasprintf(GFP_KERNEL, "%s -q -- %s", modprobe_command, module_name).
2) provide a proc_dostring_modprobe, which ensures "-q --" is appended
to the provided path

(2) is ugly as (1), but would apply just to not break current setups
and if set in Kconfig it's "-q --"-free.


>
>> > +       args = kasprintf(GFP_KERNEL, "%s %s", modprobe_path, module_name);
>
> This should be kasprintf("%s -q -- %s").
>
> And it needs a comment to explain that we are safe even if we race
> with proc_dostring().

ok

Lucas De Marchi
