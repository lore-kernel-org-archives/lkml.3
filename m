Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaFRPNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:13:17 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:61674 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaFRPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4MJdCwbcWAxnbnp3uDWoDvuqJ+GtyH0rix5Jsig3+vJA@mail.gmail.com>
References: <CA+5PVA4srNrj2xqMYH40N13rV+jC-PbLdyNpoURomTq48cJNBA@mail.gmail.com>
 <CA+5PVA7gL6T2eXAy6G4hGJzhKZ_8KHd0qauKqzuHAP4oTJ97QA@mail.gmail.com>
 <CALCETrXG=752GrPhP8zKJUciiagCVRO0kenDOqL78eP73Y3ryA@mail.gmail.com>
 <5398749B.4090209@zytor.com> <CALCETrXMxn1-qqTkf271+=7F1Aiy7c=rNsnq9cRoB=e1k-Q3UQ@mail.gmail.com>
 <CALCETrUVudD++7i679xVW_NvvVUmHpUqdufjbguQciT5k5sguQ@mail.gmail.com>
 <53A10C21.8070101@zytor.com> <CALCETrU2JMsanD__Re+18htJX07paaNBmryej_MigvXqnYbNjA@mail.gmail.com>
 <CA+5PVA4MJdCwbcWAxnbnp3uDWoDvuqJ+GtyH0rix5Jsig3+vJA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Jun 2014 08:12:55 -0700
Message-ID: <CALCETrVU2qksHZUDA+QGba1JM81B6g=OM3WAAnXhLr+t1w8gwQ@mail.gmail.com>
Subject: Re: vdso_install target broken post-3.15
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 6:09 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Wed, Jun 18, 2014 at 12:22 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, Jun 17, 2014 at 8:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 06/17/2014 08:45 PM, Andy Lutomirski wrote:
>>>> On Tue, Jun 17, 2014 at 3:54 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>> Just a heads up: gdb can't debug the vdso on 3.16-rc1.  I filed a bug:
>>>>>
>>>>> https://sourceware.org/bugzilla/show_bug.cgi?id=17064
>>>>>
>>>>> We may need to extend the fake section header hack to all vdso
>>>>> versions and stick the ELF notes in there.
>>>>
>>>> I have a semi-working implementation of a workaround, bit it adds a
>>>> fair amount of extra crud to the image, and it's pushing my
>>>> configuration past a page boundary.  I suspect that, if we're willing
>>>> to abuse the ELF format a bit more, I can get the overhead down,
>>>> though.
>>>>
>>>> Are we okay with regressing here until binutils gets fixed?
>>>>
>>>
>>> Probably not... although I guess it depends just how bad it really is.
>>
>> AFAICT the only issue is that gdb will fail to find installed debug
>> info on systems that install it into .build-id, which AFAIK means
>> Fedora and similar users who install kernel RPMs.  This won't effect
>> anyone who installs their own kernel, since it never worked correctly
>> for those users anyway.
>
> For some reason I thought SLES/OpenSUSE did build-id as well.
>

Could be.  I'm pretty sure that Debian and such don't reliably use it,
which is major reason why I dislike them.

>> Fortunately, Fedora ought to be able to update its gdb and/or binutils
>> rpm by the time that 3.16 kernel RPMs show up.  Josh, is this
>> workable?  In my experience, I've never had a sourceware.org bug
>
> Getting binutils fixed in rawhide typically isn't a problem if the
> reporter and upstream are persistent.  Getting it fixed in a more
> stable Fedora release is a bit more work and really depends on how
> invasive the fix is.
>
>> fixed, but I have had bugzilla.redhat.org bugs fixed.  I'm looking at
>> the binutils code, and I'm kind of scared of it.  Also, I don't have
>> an FSF copyright assignment on file.
>>
>> I filed this Fedora bug:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=1110598
>>
>> Let's see what happens.  Can we give this a little while?
>
> I think that really depends on who all is using build-id for their
> debuginfo stuff and how much upstream cares about breaking them.  Even
> if it's contained to Fedora derived distros, getting binutils fixed in
> RHEL for this is much harder.  I have no idea how SLES/OpenSUSE would
> contain this if they are using build-id.

Would this be needed in RHEL-like things?

The actual breakage isn't that bad: gdb will be unable to reliably
breakpoint in the __vdso and it may also be unable to reliably
backtrace from the vdso.  In limited testing, it could unwind the
backtrace just fine, presumably using frame pointers, but it didn't
show the vdso function in the backtrace.  (glibc ought to be able to
unwind the vdso just fine -- I haven't tested it, but I can't imagine
glibc parsing section headers just for unwind unfo.)  Since there's no
support right now for build-id links in home-built kernels, 3.16 and
newer distro kernels will behave just like home-built kernels.  (If
there are non-kernel-RPM build-id users, it would be a very different
story, but I don't think that such users exist.)

But RHEL doesn't update to new major kernel releases, right?  So it
won't be affected until RHEL 8, at which point there ought to be a new
gdb.  Oracle will be affected, but unless they actually complain or
depend on this kind of gdb support, I don't know whether this matters
much.

>
>> I wrote this:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/vdso_sections
>>
>> but it's bad: I'm not allocating space properly, so it doesn't
>> reliably build.  Also, it wastes space, and I'd rather just get rid of
>> this crap.
>
> The "if/when binutils gets fixed" is really the crux of the issue.
> Unless the upstream kernel puts a hard requirement on a fixed binutils
> version, we can't really depend on people having a fixed binutils.  If
> that code were to get added, it would like stay for a very long time.

The RHBZ bug is already getting some attention.

My inclination is to give this at least a week or two and then, if it
looks like binutils won't get fixed, to clean up and submit my
workaround.

Note that my workaround also causes 'file' and 'readelf -n' to work
correctly on the stripped images, but that shouldn't matter for anyone
except people who manually generate on-disk stripped images
specifically for testing file and readelf, so this seems unimportant.

--Andy
