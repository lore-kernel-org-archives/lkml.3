Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaFREW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 00:22:58 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:47794 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaFREWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 00:22:55 -0400
MIME-Version: 1.0
In-Reply-To: <53A10C21.8070101@zytor.com>
References: <CA+5PVA4srNrj2xqMYH40N13rV+jC-PbLdyNpoURomTq48cJNBA@mail.gmail.com>
 <CA+5PVA7gL6T2eXAy6G4hGJzhKZ_8KHd0qauKqzuHAP4oTJ97QA@mail.gmail.com>
 <CALCETrXG=752GrPhP8zKJUciiagCVRO0kenDOqL78eP73Y3ryA@mail.gmail.com>
 <5398749B.4090209@zytor.com> <CALCETrXMxn1-qqTkf271+=7F1Aiy7c=rNsnq9cRoB=e1k-Q3UQ@mail.gmail.com>
 <CALCETrUVudD++7i679xVW_NvvVUmHpUqdufjbguQciT5k5sguQ@mail.gmail.com> <53A10C21.8070101@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Jun 2014 21:22:34 -0700
Message-ID: <CALCETrU2JMsanD__Re+18htJX07paaNBmryej_MigvXqnYbNjA@mail.gmail.com>
Subject: Re: vdso_install target broken post-3.15
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 8:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/17/2014 08:45 PM, Andy Lutomirski wrote:
>> On Tue, Jun 17, 2014 at 3:54 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> Just a heads up: gdb can't debug the vdso on 3.16-rc1.  I filed a bug:
>>>
>>> https://sourceware.org/bugzilla/show_bug.cgi?id=17064
>>>
>>> We may need to extend the fake section header hack to all vdso
>>> versions and stick the ELF notes in there.
>>
>> I have a semi-working implementation of a workaround, bit it adds a
>> fair amount of extra crud to the image, and it's pushing my
>> configuration past a page boundary.  I suspect that, if we're willing
>> to abuse the ELF format a bit more, I can get the overhead down,
>> though.
>>
>> Are we okay with regressing here until binutils gets fixed?
>>
>
> Probably not... although I guess it depends just how bad it really is.

AFAICT the only issue is that gdb will fail to find installed debug
info on systems that install it into .build-id, which AFAIK means
Fedora and similar users who install kernel RPMs.  This won't effect
anyone who installs their own kernel, since it never worked correctly
for those users anyway.

Fortunately, Fedora ought to be able to update its gdb and/or binutils
rpm by the time that 3.16 kernel RPMs show up.  Josh, is this
workable?  In my experience, I've never had a sourceware.org bug
fixed, but I have had bugzilla.redhat.org bugs fixed.  I'm looking at
the binutils code, and I'm kind of scared of it.  Also, I don't have
an FSF copyright assignment on file.

I filed this Fedora bug:

https://bugzilla.redhat.com/show_bug.cgi?id=1110598

Let's see what happens.  Can we give this a little while?

I wrote this:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/vdso_sections

but it's bad: I'm not allocating space properly, so it doesn't
reliably build.  Also, it wastes space, and I'd rather just get rid of
this crap.

--Andy
