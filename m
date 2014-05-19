Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbaESUW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:22:29 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:37303 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbaESUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:22:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140515202628.GB25896@mail.hallyn.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <20140515013245.GA1764@kroah.com> <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
 <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com> <20140515140856.GA17453@kroah.com>
 <CAFLxGvwfbVdLUq0NrSrQNYH+bTzYLuCE2moooHH319qRfDkS6Q@mail.gmail.com>
 <20140515195010.GA22317@ubuntumail> <53751FFA.5040103@nod.at> <20140515202628.GB25896@mail.hallyn.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 19 May 2014 13:22:06 -0700
Message-ID: <CALCETrWE72G86QKVZT2aqWsEmjwOPwsWMUNz5-JkDvbqaGbrvw@mail.gmail.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user namespaces
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Michael H. Warfield" <mhw@wittsend.com>, Arnd Bergmann <arnd@arndb.de>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Richard Weinberger <richard@nod.at>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 15, 2014 1:26 PM, "Serge E. Hallyn" <serge@hallyn.com> wrote:
>
> Quoting Richard Weinberger (richard@nod.at):
> > Am 15.05.2014 21:50, schrieb Serge Hallyn:
> > > Quoting Richard Weinberger (richard.weinberger@gmail.com):
> > >> On Thu, May 15, 2014 at 4:08 PM, Greg Kroah-Hartman
> > >> <gregkh@linuxfoundation.org> wrote:
> > >>> Then don't use a container to build such a thing, or fix the build
> > >>> scripts to not do that :)
> > >>
> > >> I second this.
> > >> To me it looks like some folks try to (ab)use Linux containers
> > >> for purposes where KVM would much better fit in.
> > >> Please don't put more complexity into containers. They are already
> > >> horrible complex
> > >> and error prone.
> > >
> > > I, naturally, disagree :)  The only use case which is inherently not
> > > valid for containers is running a kernel.  Practically speaking there
> > > are other things which likely will never be possible, but if someone
> > > offers a way to do something in containers, "you can't do that in
> > > containers" is not an apropos response.
> > >
> > > "That abstraction is wrong" is certainly valid, as when vpids were
> > > originally proposed and rejected, resulting in the development of
> > > pid namespaces.  "We have to work out (x) first" can be valid (and
> > > I can think of examples here), assuming it's not just trying to hide
> > > behind a catch-22/chicken-egg problem.
> > >
> > > Finally, saying "containers are complex and error prone" is conflating
> > > several large suites of userspace code and many kernel features which
> > > support them.  Being more precise would, if the argument is valid,
> > > lend it a lot more weight.
> >
> > We (my company) use Linux containers since 2011 in production. First LXC, now libvirt-lxc.
> > To understand the internals better I also wrote my own userspace to create/start
> > containers. There are so many things which can hurt you badly.
> > With user namespaces we expose a really big attack surface to regular users.
> > I.e. Suddenly a user is allowed to mount filesystems.
>
> That is currently not the case.  They can mount some virtual filesystems
> and do bind mounts, but cannot mount most real filesystems.  This keeps
> us protected (for now) from potentially unsafe superblock readers in the
> kernel.
>
> > Ask Andy, he found already lots of nasty things...

I don't think I have anything brilliant to add to this discussion
right now, except possibly:

ISTM that Linux distributions are, in general, vulnerable to all kinds
of shenanigans that would happen if an untrusted user can cause a
block device to appear.  That user doesn't need permission to mount it
or even necessarily to change its contents on the fly.

E.g. what happens if you boot a machine that contains a malicious disk
image that has the same partition UUID as /?  Nothing good, I imagine.

So if we're going to go down this road, we really need some way to
tell the host that certain devices are not trusted.

--Andy
