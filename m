Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaCNMWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:22:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36334 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaCNMWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:22:49 -0400
Date: Fri, 14 Mar 2014 12:22:31 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
In-Reply-To: <1394762250.6416.24.camel@x230.lan>
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
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Have you actually looked at these patches? I've looked at every case of
> RAWIO in the kernel. For cases that are hardware specific and tied to
> fairly old hardware, I've ignored them. For cases which provide an

Yes I have - and it's not exactly localised: it modifies stuff all over
the tree when it shouldn't need to. It's a security policy. If it leaks
policy all over the kernel then the implementation model is *wrong*.

> >default behaviour for capable(x) in fact be
> >
> >        capable(x & ~secure_forbidden)
> >
> >for a measured kernel and add a 
> >
> >        capable_always()
> >
> >for the cases you want to not break.
> 
> We could do that, but now the behaviour of the patchset is far less
> obvious. capable(CAP_SYS_RAWIO) now means something different to every
> other use of capable(), and we still need get_trusted_kernel() calls for
> cases where the checks have nothing to do with processes and so
> capabilities can't be used. 

You don't need get_measured_kernel() calls because thats hidden within
capable/capable_always. And if the interaction is a complicated as you
imply that again says to me the model is wrong. Complicated multi-way
security interactions lead to complicated exploits leveraging the
disconnects.

But see further down...

> > As for mem= and exactmap, it has nothing to do with /dev/mem and
> > everything to do with giving the kernel a memory map where some of the
> > space it thinks is RAM is in fact devices, rom, space etc. If the kernel
> > is given a false memory map it will misbehave. Exploitably - well given
> > the kind of things people have achieved in the past - quite possibly.
> 
> Sure. That's a worthwhile thing to fix, and it's something that dropping
> CAP_SYS_RAWIO would do nothing to help you with.

I didn't mention it with regards to CAP_SYS_RAWIO, just as a general
example of stuff not dealt with. Again that one really suggests that the
right approach is to whitelist allowed boot options not blacklist bad
ones. It's the usual story with security, people fight bitterly not to do
whitelisting, then spend two years and more effort fixing holes than
doing whitelisting then eventually have to whitelist anyway. 

(or maybe I'm just bitter and cynical)
 
> We can do this without unnecessarily breaking any userspace. We just
> can't do it by fiddling with capabilities.

It should still be a security model nto spreading measured_kernel()
checks about. Now if that means

	capable(CAP_SYS_RAWIO)

should become security-> interface hooks that pass something meaningful
to the security layer then I'd rather we did the job properly in the first
place and put the policy in one spot not all over the kernel.

The question then becomes what do we need to pass beyond "CAP_SYS_RAWIO"
so the policy can be in the right place - even for example imposed by
SELinux rules.
	

> > I don't think we need to break any userspace for "normal" mode to do
> > this. Userspace in measured mode is going to change anyway. It already
> > has just for things like module signing.
> 
> This has been discussed at length. Nobody who's actually spent time
> working on the problem wants to use capabilities. CAP_SYS_RAWIO is not
> semantically identical to the trusted kernel bit. Trying to make them
> semantically identical will break existing userspace.

I never said it was. I said that getting rid of CAP_SYS_RAWIO and then
dealing with *just* the exceptions to this is a lot cleaner, and likely
to be more secure.

Right now the 'measured' patches spew all over the place. That shouldn't
be needed.

In addition several of the cases that you point out could be fixed by
replacing the CAP_SYS_RAWIO using stuff with a proper interface should
probably just be *fixed* to provide that.

> > (As an aside you may also then want to think about whether you allow
> > measured userspace elements that secure_forbidden is considered to be 0
> > for so you can sign userspace apps that are allowed to do RAWIO)
> 
> I'd be amazed if any of the applications that need RAWIO have had any
> kind of meaningful security audit

How re-assuring ;)

Alan
