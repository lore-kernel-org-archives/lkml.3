Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaCNRHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:07:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36672 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbaCNRHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:07:12 -0400
Date: Fri, 14 Mar 2014 17:06:55 +0000
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
Message-ID: <20140314170655.0ce398a3@alan.etchedpixels.co.uk>
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
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But you keep talking about MSRs despite there being a patch that limits
> access to MSRs. If you have specific examples of privilege escalations
> that are possible even with these patches then please, mention them.

I mentioned MSRs once, and then you kept going on about it. 

Your patches are all over the tree, for what should be one piece of
policy. They rely on not missing a single case, which is also bad
security engineering. We know that, as an industry we've spent fifty
years repeatedly sticking our fingers in our ears, refusing to listen and
then learning it again and again the hard way.

> How is capable() going to be any use when deciding whether or not to
> interpret some kernel command line options?

I have no idea, why are you asking such an odd question ?

You need to whitelist module parameters and boot options that are safe in
your measured kernel environment. Nothing to do with RAWIO or capable(),
just that we have thousands of such options many of which are quite
exploitable because they assume the loader is trustable (which btw is
already *broken* and on many systems - eg Fedora - allows you to break
from DAC override into RAWIO).

That one actually wants cleaning up anyway but its hard to see the right
way to do it.

> We still need a mechanism to differentiate between cases where
> CAP_SYS_RAWIO should be forbidden and cases where it should be
> permitted, which means that we need to add additional policy. We can
> modify capable(), but that means that capable() no longer does what you
> expect it to - it's not a transparent interface, and that's likely to
> result in people accidentally misusing it.

capable() is not a good interface. If we are going to patch half
the capable() calls in the kernel wouldn't it be a good time to actually
do something about it properly ?

At the very least we should turn capabilities/needs into two lists and
make them a 2D grid so we break the tie between the userspace
'capability' and 'what this allows you to do in this specific
instance'.

For example instead of spewing magic trusted kernel checks all over the
place we could do a global seach/replace of most of the capable calls with

	is_permitted(x)

where x is a value indicating what we wish to do (action) not what right
we need (policy). All the real mess comes from the fact that capable() is
implementing security *policy* in drivers all over the kernel.

You can then set up a map of capability to X values, and more importantly
you can use that map to have more complete, and descriptive versions of
'x' than capabilities.

You can now ask the rather more useful question

	am I allowed to do 'X'

and the answer may well depend upon selinux, trust models and what have
you as well as securelevels and other concepts anyone wishes to play with
(things like remote attestation for example)

A simple minded adjustment to cap_capable would then be to make
cap_is_permitted what cap_capable is now but with

	cap = security_required_capability[x];
	if (cap == -1)
		return 0;

Prior to adding anything or considered measured kernels that would be a
1:1 mapping. Nothing breaks, nothing exciting happens.

But you can now add new permissions and map them about. So you can mark
some of the RAW_IO ones with new names and in non trusted kernels they
get given a map value of CAP_SYS_RAWIO, or in trusted cases -1.

At that point we've got

- an automated conversion for the non-measured case, so we don't screw up
  a long change set.

- no breakages of userspace in the non measured case (and we can test at
  this point quite happily)

- a single interface, because driver authors can't be expected to
  understand two differently broken interacting sets of checks (plus
  since we just got rid of capable they can't forget to update their code
  or copy old now broken but happily compiling code).

- a way to fix the existing capable() mess

- a way to support measured kernels by adding new permissions without
  them breaking non measured userspace cases, without breaking the
  capability model seen from userspace.

  So for example we can add

	RIGHT_LOAD_SIGNED_FIRMWARE
	RIGHT_LOAD_UNSIGNED_FIRMWARE

  etc and we can tie them to things other than CAP_SYS_RAWIO in untrusted
  mode. Indeed it wouldn't be hard to make the table two dimensional

	cap = security_required_capability[measured_kernel()][x];

  and just mark the 'generic' RIGHT_RAW_IO_ACCESS as -1 in trusted mode
  but CAP_SYS_RAWIO if not, while RIGHT_LOAD_SIGNED_FIRMWARE is
  CAP_SYS_RAWIO in both cases.

- a whitelist type behaviour. If the default for RIGHT_RAW_IO_ACCESS is
  -1 in trusted mode then only the cases someone goes back and explicitly
  refines will get enabled. Anyone adding a driver or blindly copying the
  old behaviours either breaks or if they blindly convert gets the safe
  behaviour.

- a way to allow security modules to make smarter decisions because they
  all have the ability to implement policy for such events, and
  because we can provide a meaningful way to split them further as
  needed

- a way to make the question of trust namespace specific (because caps
  are and the cap_capable logic has NS visibility)

Why do we care about that, because if you want you can boot a measured
file system which contains some services you consider part of the
measured environment, and put the unmeasured universe in another
namespace.

> > The question then becomes what do we need to pass beyond "CAP_SYS_RAWIO"
> > so the policy can be in the right place - even for example imposed by
> > SELinux rules.
> 
> It needs to be possible for this policy to be imposed without userspace
> being involved, so using selinux would mean baking it into the kernel
> (along with an additional implementation for apparmor, and presumably
> one for tomoyo as well).

That's clearly false. You can load signed modules so you can load signed
policies. Assuming you don't have an initial measured file system you
need a kernel policy initially that protects you. If you have a measured
file system you don't even need that, nor do you need to revoke RAWIO in
kernel, you can do it before you switch into "measured and running
un-measured code" mode - ie about the point you pivot root out of the
initrd that loaded the measured policy.

> > In addition several of the cases that you point out could be fixed by
> > replacing the CAP_SYS_RAWIO using stuff with a proper interface should
> > probably just be *fixed* to provide that.
> 
> ...thus breaking userspace outside this use case. I mean, sure, I'm
> absolutely fine with deleting /dev/mem entirely. I don't see Linus
> agreeing.

That's not what I meant. We have a lot of interfaces where we use
CAP_SYS_RAWIO rather than having a structured interface as opposed to a
'yeah whatever, poke the registers' interface.

For a lot of environments btw you don't actually need /dev/mem. It's not
really got a lot of uses any more and plenty of people really restrict or
remove it from systems. I don't think very many people would be sad
if /dev/mem became a legacy interface most people left turned off.

> That's why I used trusted rather than measured. The Secure Boot trust
> model assumes that the user is able to modify the command line (it's
> basically impossible to deploy generically otherwise), so we need to
> filter out command line options that allow a user to elevate themselves
> into the kernel at boot time.

This is the kind of head up arsehole thinking that has security people
banging their heads against the wall wondering why programmers are
incapable of learning from history.

You do not want to "filter out" options. You'll never get them all, there
are rather a lot of them, and many apparently harmless ones are not at
all harmless. The number of drivers where you can pass the maximum number
of interfaces which then do

	blah = kzalloc(sizeof(stuff) * unchecked_number)

is rather large for example. The number of devices that allow you force
arbitary MMIO values is not exactly small either.

You want to whitelist the ones you actually need, and have done careful
inspections of. The number of kernel options actually used by 99.99% of
the universe in normal operational state or when doing basic poking at
stuff or verbose booting is minimal. It also btw means you can have a
measured command line (all trusted), or a mixed command line (measured
bits trusted implicitly, rest not).

It's not too hard. Most are module_parm, so we just need
module_parm_is_safe(x) and a single centralised check for the general
case.

If we are going to do a measured kernel then it needs to be done right,
it needs to be properly abstracted so we don't add another one for
Android, another one for Chrome, another one for ARM trustzone, another
one for Intel SGX, and so on.

Alan
