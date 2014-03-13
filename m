Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaCMXWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:22:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35708 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaCMXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:22:13 -0400
Date: Thu, 13 Mar 2014 23:21:40 +0000
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
Message-ID: <20140313232140.03bdaac3@alan.etchedpixels.co.uk>
In-Reply-To: <1394746248.27846.3.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	<1394726363.25122.16.camel@x230>
	<20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	<1394746248.27846.3.camel@x230>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 21:30:48 +0000
Matthew Garrett <matthew.garrett@nebula.com> wrote:

> On Thu, 2014-03-13 at 21:24 +0000, One Thousand Gnomes wrote:
> 
> > If I have CAP_SYS_RAWIO I can make arbitary ring 0 calls from userspace,
> > trivially and in a fashion well known and documented.
> 
> How?

You want a list... there are load of places all over the kernel that have
assumptions that RAWIO = safe from the boringly mundane like MSR access
to the more obscure driver "this is RAWIO trust the user" cases of which
there are plenty.

If you are going to do something "secure" then do it *right* otherwise
you are not actually implementing anything, just making fake security
noises.

SELinux required user space changes, fiddle with CAP_SYS_RAWIO will need
userspace changes IFF you want to run 'secure' mode. That I think is
acceptable.

You can even avoid the userspace issues with a small amount of checking.
If you don't want to touch capability sets then make the default
behaviour for capable(x) in fact be

	capable(x & ~secure_forbidden)

for a measured kernel and add a 

	capable_always()

for the cases you want to not break.

As for mem= and exactmap, it has nothing to do with /dev/mem and
everything to do with giving the kernel a memory map where some of the
space it thinks is RAM is in fact devices, rom, space etc. If the kernel
is given a false memory map it will misbehave. Exploitably - well given
the kind of things people have achieved in the past - quite possibly.

If you are not prepared to do the job right, then I don't think it
belongs upstream. Let's do it right, and if we have to tweak a few bits
of userspace to make them work in measured mode (but without breaking
anything in normal modes) then it's worth doing the job properly.

I don't think we need to break any userspace for "normal" mode to do
this. Userspace in measured mode is going to change anyway. It already
has just for things like module signing.

(As an aside you may also then want to think about whether you allow
measured userspace elements that secure_forbidden is considered to be 0
for so you can sign userspace apps that are allowed to do RAWIO)

Alan
