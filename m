Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaDNMlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:41:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42872 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaDNMle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:41:34 -0400
Date: Mon, 14 Apr 2014 13:41:13 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: DRM security flaws and security levels.
Message-ID: <20140414134113.6c1a488d@alan.etchedpixels.co.uk>
In-Reply-To: <5347E32B.1080002@vmware.com>
References: <5347E32B.1080002@vmware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> throw out all GPU memory on master drop and block ioctls requiring
> authentication until master becomes active again.

If you have a per driver method then the driver can implement whatever is
optimal (possibly including throwing it all out). 

> -1: The driver allows an authenticated client to craft command streams
> that could access any part of system memory. These drivers should be
> kept in staging until they are fixed.

I am not sure they belong in staging even.

> 0: Drivers that are vulnerable to any of the above scenarios.
> 1: Drivers that are immune against all above scenarios but allows any
> authenticated client with *active* master to access all GPU memory. Any
> enabled render nodes will be insecure, while primary nodes are secure.
> 2: Drivers that are immune against all above scenarios and can protect
> clients from accessing eachother's gpu memory:
> Render nodes will be secure.
> 
> Thoughts?

Another magic number to read, another case to get wrong where the OS
isn't providing security by default.

If the driver can be fixed to handle it by flushing out all GPU memory
then the driver should be fixed to do so. Adding magic udev nodes is just
adding complexity that ought to be made to go away before it even becomes
an API.

So I think there are three cases

- insecure junk driver. Shouldn't even be in staging
- hardware isn't as smart enough, or perhaps has a performance problem so
  sometimes flushes all buffers away on a switch
- drivers that behave well

Do you then even need a sysfs node and udev hacks (remembering not
everyone even deploys udev on their Linux based products)

For the other cases

- how prevalent are the problem older user space drivers nowdays ?

- the fix for "won't fix" drivers is to move them to staging, and then
  if they are not fixed or do not acquire a new maintainer who will,
  delete them.

- if we have 'can't fix drivers' then its a bit different and we need to
  understand better *why*.

Don't screw the kernel up because there are people who can't be bothered
to fix bugs. Moving them out of the tree is a great incentive to find
someone to fix it.

[Rob Clark]
>fwiw, I do think we want security level reporting for drivers that
>don't have per-process pagetables (either the hw doesn't support, or
>simply just not implemented yet)

Agreed - and this is an example of where it can't really be hidden very
easily. Even better would be if asking for an isolation safe buffer was
required to be sure you got one. Policy is then in the X server (although
I'm not sure how you'd map it nicely - Xsecurity or something new ?)

This discussion is missing one other thing. If you have a desktop
spanning multiple hardware interfaces you need to get the right
information to the desktop. Do you just refuse to support the secure
buffer for the banking app, or does it merely get tied into the display
area rendered by a particular adapter ?

Alan


