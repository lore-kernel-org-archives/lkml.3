Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaCNPYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:24:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42458 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbaCNPXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:23:49 -0400
MIME-Version: 1.0
In-Reply-To: <1394801518.6416.38.camel@x230.lan>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	<1394726363.25122.16.camel@x230>
	<20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	<1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
Date: Fri, 14 Mar 2014 08:23:49 -0700
X-Google-Sender-Auth: FGaNzo052K3kfYqIbyeDKbzJtzo
Message-ID: <CAGXu5jLZcWh5WD0L8s3Q-GXdXCMnA57qtjfdFfQbv0fxYcuCTQ@mail.gmail.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 5:51 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Fri, 2014-03-14 at 12:22 +0000, One Thousand Gnomes wrote:
>> > Have you actually looked at these patches? I've looked at every case of
>> > RAWIO in the kernel. For cases that are hardware specific and tied to
>> > fairly old hardware, I've ignored them. For cases which provide an
>>
>> Yes I have - and it's not exactly localised: it modifies stuff all over
>> the tree when it shouldn't need to. It's a security policy. If it leaks
>> policy all over the kernel then the implementation model is *wrong*.
>
> But you keep talking about MSRs despite there being a patch that limits
> access to MSRs. If you have specific examples of privilege escalations
> that are possible even with these patches then please, mention them.
>
>> > >default behaviour for capable(x) in fact be
>> > >
>> > >        capable(x & ~secure_forbidden)
>> > >
>> > >for a measured kernel and add a
>> > >
>> > >        capable_always()
>> > >
>> > >for the cases you want to not break.
>> >
>> > We could do that, but now the behaviour of the patchset is far less
>> > obvious. capable(CAP_SYS_RAWIO) now means something different to every
>> > other use of capable(), and we still need get_trusted_kernel() calls for
>> > cases where the checks have nothing to do with processes and so
>> > capabilities can't be used.

And this ignores the fact that being able to query the measured state
is potentially valuable to additional security policies (e.g. module
loading, firmware loading). Hiding the measured logic in capabilities
makes no sense -- they're orthogonal restrictions.

>>
>> You don't need get_measured_kernel() calls because thats hidden within
>> capable/capable_always. And if the interaction is a complicated as you
>> imply that again says to me the model is wrong. Complicated multi-way
>> security interactions lead to complicated exploits leveraging the
>> disconnects.
>
> How is capable() going to be any use when deciding whether or not to
> interpret some kernel command line options?

The command line problem here is a total red herring. If you've got a
measured kernel, you have a measured command line. (If not, you don't
have a measured kernel.) Dealing with the command line has nothing to
do with enforcing the ring0/uid0 boundary which is what this patch
series does.

>> > We can do this without unnecessarily breaking any userspace. We just
>> > can't do it by fiddling with capabilities.
>>
>> It should still be a security model nto spreading measured_kernel()
>> checks about. Now if that means
>>
>>       capable(CAP_SYS_RAWIO)
>>
>> should become security-> interface hooks that pass something meaningful
>> to the security layer then I'd rather we did the job properly in the first
>> place and put the policy in one spot not all over the kernel.
>
> We still need a mechanism to differentiate between cases where
> CAP_SYS_RAWIO should be forbidden and cases where it should be
> permitted, which means that we need to add additional policy. We can
> modify capable(), but that means that capable() no longer does what you
> expect it to - it's not a transparent interface, and that's likely to
> result in people accidentally misusing it.
>
>> The question then becomes what do we need to pass beyond "CAP_SYS_RAWIO"
>> so the policy can be in the right place - even for example imposed by
>> SELinux rules.
>
> It needs to be possible for this policy to be imposed without userspace
> being involved, so using selinux would mean baking it into the kernel
> (along with an additional implementation for apparmor, and presumably
> one for tomoyo as well).
>
>>
>> > > I don't think we need to break any userspace for "normal" mode to do
>> > > this. Userspace in measured mode is going to change anyway. It already
>> > > has just for things like module signing.
>> >
>> > This has been discussed at length. Nobody who's actually spent time
>> > working on the problem wants to use capabilities. CAP_SYS_RAWIO is not
>> > semantically identical to the trusted kernel bit. Trying to make them
>> > semantically identical will break existing userspace.
>>
>> I never said it was. I said that getting rid of CAP_SYS_RAWIO and then
>> dealing with *just* the exceptions to this is a lot cleaner, and likely
>> to be more secure.
>
> And will give us the choice between complicating a simple interface or
> breaking userspace. If the maintainer believes that's a better approach
> then I can rewrite all of this again, but so far you seem to be in a
> minority on this front.
>
>> In addition several of the cases that you point out could be fixed by
>> replacing the CAP_SYS_RAWIO using stuff with a proper interface should
>> probably just be *fixed* to provide that.
>
> ...thus breaking userspace outside this use case. I mean, sure, I'm
> absolutely fine with deleting /dev/mem entirely. I don't see Linus
> agreeing.

Right. As mentioned, we've been over all of this before. We cannot
change the meaning of capabilities (nor expand their coverage to
existing interfaces) without breaking userspace. Since we cannot break
userspace, we must create a different policy system that covers this
new thing we want to do and keeps the new policy distinctly separate.

-Kees

-- 
Kees Cook
Chrome OS Security
