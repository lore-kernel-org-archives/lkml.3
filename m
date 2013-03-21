Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3CUQTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:19:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab3CUQTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:19:04 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=PQXwkx6xI6AA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=v06FSq8qSjgA:10 a=20KFwNOVAAAA:8 a=3sWEq_Tzt65v1uUirYUA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=JkP4zLpnRuRcxNJP:21 a=4i4GiruTCwg-Yn_A:21 wl=env:18 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Thu, 21 Mar 2013 11:19:52 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Message-ID: <20130321161952.GA4957@austin.hallyn.com>
References: <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
 <1363806968.2580.86.camel@falcor1.watson.ibm.com>
 <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
 <1363813877.2580.120.camel@falcor1.watson.ibm.com>
 <1363814289.2553.41.camel@x230.sbx07502.somerma.wayport.net>
 <20130321134348.GA3934@redhat.com>
 <20130321153725.GA3656@austin.hallyn.com>
 <20130321155220.GL3934@redhat.com>
 <20130321155823.GA4438@austin.hallyn.com>
 <20130321160441.GB6575@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321160441.GB6575@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Vivek Goyal (vgoyal@redhat.com):
> On Thu, Mar 21, 2013 at 10:58:23AM -0500, Serge E. Hallyn wrote:
> > Quoting Vivek Goyal (vgoyal@redhat.com):
> > > On Thu, Mar 21, 2013 at 10:37:25AM -0500, Serge E. Hallyn wrote:
> > > > Quoting Vivek Goyal (vgoyal@redhat.com):
> > > > ...
> > > > > Giving CAP_MODIFY_KERNEL to processess upon signature verification
> > > > > will simplify things a bit.
> > > > > 
> > > > > Only thing is that signature verification alone is not sufficient. We
> > > > > also need to make sure after signature verification executable can
> > > > > not be modified in memory in any way. So that means atleast couple of
> > > > > things.
> > > > 
> > > > Also what about context?  If I construct a mounts namespace a certain
> > > > way, can I trick this executable into loading an old singed bzImage that
> > > > I had laying around?
> > > 
> > > We were thinking that /sbin/kexec will need to verify bzImage signature
> > > before loading it. 
> > > 
> > > Key for verification is in kernel so idea was to take kernel's help
> > > in verifying signature.
> > > 
> > > Not sure how exactly the interface should look like. 
> > > 
> > > - I was thinking may be process can mmap() the bzImage with MAP_LOCKED.
> > >   We can create additional flag say MAP_VERIFY_SIG_POST, which tries
> > >   to verify signature/integrity of mapped region of file after mapping and
> > >   locking pages and mmap() fails if signature verification fails.
> > > 
> > > There have been suggestions about creating new system call altogether.
> > > 
> > > > 
> > > > ISTM the only sane thing to do, if you're going down this road,
> > > > is to have CAP_MODIFIY_KERNEL pulled from bounding set for everyone
> > > > except a getty started by init on ttyS0.  Then log in on serial
> > > > to update.  Or run a damon with CAP_MODIFIY_KERNEL which listens
> > > > to a init_net_ns netlink socket for very basic instructions, like
> > > > "find and install latest signed bzImage in /boot".  Then you can
> > > > at least trust that /boot for that daemon is not faked.
> > > 
> > > daemon does not have the key and can't verify signature of signed
> > > bzImage. Even if it had the key, it can't trust the crypto code for
> > > signature verification as none of that is signed.
> > 
> > I'm not saying not to use the kernel to verify the signature.
> 
> Ok. So why can't /sbin/kexec can do the verification of bzImage with
> kernel's help. Due to crafted /boot/ it might load old signed bzImage,
> but it can't load unsigned/untrusted code on secureboot system at ring 0.
> 
> I am hoping I did not miss your point entirely.

No, you didn't.  If replay attacks are not a concern then that bit
doesn't matter.  But if^Wwhen there is a vulnerability in a signed kernel,
and a user has a copy of bzImage sitting around, signed kexec alone does
not suffice (and I'm assuming revocation is not going into the kernel?).
It seems to me if replay attacks are ignored, this is all for theater...

The other concern is analogous, just more general - seems like I may very
well be able to find a way to corrupt kexec or even corrupt the kernel with
a bad environment.

So I'm just saying that in general it doesn't seem worth having a special
list of capabilities that only signed executables can have, without doing 
something about the environment.  And that the solution to that seems like
what we can already do today (with a bounding set and init-launched
services).

All of this is probably premature though.  IIUC the first thing you are
after is a way to record on the file the fact that it is a verified-signature
binary, and that's what CAP_SIGNED meant right?  I agree we need something
like that, but using a capability is not right.  You can add a field to
the binprm or file or f_cred, or even add a field to the capability struct,
meaningful only on files, to show it was signed - but not taint the list of
capabilities with something that is not a capability.  I haven't looked
closer to see which would be the best way (my hunch would be binprm), will 
be happy to come up with a proposal when I have time, but I don't want to slow
you down :)

-serge
