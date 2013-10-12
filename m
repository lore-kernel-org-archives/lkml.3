Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab3JLB4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 21:56:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34880 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab3JLB42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 21:56:28 -0400
X-Sasl-enc: 8CVjt8qd8Z6hIU3BZoUXJ/zcv6kJq0t8FmBDiqzlSKB1 1381542987
Message-ID: <1381542984.2272.21.camel@perseus.fritz.box>
Subject: Re: NULL pointer dereference in autofs4_expire_wait
From: Ian Kent <raven@themaw.net>
To: David Ahern <dsahern@gmail.com>
Cc: autofs@vger.kernel.org, viro@ZenIV.linux.org.uk,
        linux-kernel@vger.kernel.org
Date: Sat, 12 Oct 2013 09:56:24 +0800
In-Reply-To: <5257FD34.2060406@gmail.com>
References: <525736C7.9080400@gmail.com>
	  <1381457199.2631.3.camel@perseus.fritz.box>
	 <1381485327.2631.18.camel@perseus.fritz.box> <5257FD34.2060406@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 07:29 -0600, David Ahern wrote:
> On 10/11/13 3:55 AM, Ian Kent wrote:
> > On Fri, 2013-10-11 at 10:06 +0800, Ian Kent wrote:
> >> On Thu, 2013-10-10 at 17:22 -0600, David Ahern wrote:
> >>> Running 3.12-rc3 just hit BUG in autofs4_expire_wait
> >>
> >> It doesn't look like this could be due to Al's change to the locking in
> >> autos4_wait() and that the only change to autofs that I'm aware of.
> >>
> >> Could you do a bisect please?
> >
> > Of course that assumes it's repeatable.
> > Is it?
> >
> > Can you provide any information about the environment and activity that
> > was happening at the time of the BUG()?
> 
> The system was up and running for 9 days before hitting the BUG. After 
> that with 3 cpus on softlockup I had to do a reboot (forced). After the 
> reboot I continued the workload again without a repeat incident (yet), 
> so I am not sure bisect is going to be possible.

Yeah, it isn't repeatable.

> 
> This is a corporate environment where practically everything is in an 
> automount. Specific to this problem I was repeatedly building a 
> workspace in one window, using cscope in another and checking code 
> against a different workspace in a third -- all 3 of those were 
> different automounts and different NAS servers.
> 
>  From objdump on vmlinux the line in question is fs/autofs4/expire.c:465
> 
>      if (ino->flags & AUTOFS_INF_EXPIRING) {

Right, there haven't been changes to the autofs kernel code that affect
the reference counting of dentrys so I have to conclude this is being
caused by other changes.

When walking an autofs path, the walk should always be put into refwalk
mode, so the function containing this line should always have a dentry
with a reference held. Which just means that the autofs info struct (ino
here) won't be invalid.

Now ->d_release() (which frees ino) is only called after the dentry
reference count falls to zero and the dentry is going away.

We can't check ino for NULL here because the dentry pointer to it isn't
set to NULL when it's freed in ->d_release(). Setting the dentry field
to NULL is futile because the next thing the VFS does is to free the
dentry itself. Well, it calls RCU to schedule the free anyway.

The fact that ->d_release() has been called makes me think there's a
reference counting problem somewhere in the VFS.

Al, is my thinking correct here?

There were some significant changes to this area of the VFS in 3.11 by
the look of it.

So more history please, had you used 3.11 for an extended amount of
time, before using the 3.12-rc? IOW what's your kernel version use
history please?

Ian


