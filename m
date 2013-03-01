Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3CAKZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:25:35 -0500
Received: from jablonecka.jablonka.cz ([91.219.244.36]:52062 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3CAKZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:25:33 -0500
X-Greylist: delayed 1475 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 05:25:33 EST
Date: Fri, 1 Mar 2013 11:00:52 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130301100052.GA20085@suse.cz>
References: <30665.1361461678@warthog.procyon.org.uk>
 <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz>
 <20130228225115.GA12360@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130228225115.GA12360@srcf.ucam.org>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 10:51:15PM +0000, Matthew Garrett wrote:
> On Thu, Feb 28, 2013 at 11:48:06PM +0100, Jiri Kosina wrote:
> 
> > Let me formulate my point more clearly -- Microsoft very likely going to 
> > sign hello world EFI PE binary, no matter the contents of .keylist 
> > section, as they don't give a damn about this section, as it has zero 
> > semantic value to them, right?
> > 
> > They sign the binary. By signing the binary, they are *NOT* establishing 
> > cryptographic chain of trust to the key stored in .keylist, but your 
> > patchset seems to imply so.
> 
> Mr Evil Blackhat's binary is then a mechanism for circumventing the 
> Windows trust mechanism, and as such his account is subject to 
> termination and his binary can be added to dbx. 

Why?

Let's take a look on what would happen in this scenario:

A PE binary, from Mr. Blackhat, doing nothing, in general, but
containing a key in a section, was signed by MS on the grounds that the
binary isn't harmful.

By issuing the signature, MS is attesting that the binary is safe, but
isn't saying anything about the data (key) embedded in it. It doesn't
say the key comes from a trusted party. It just says "this isn't
malware", and that's what their tools verify.

Your shim loader (signed by MS) loads your Linux kernel.

Your Linux kernel, then, based on the key-in-PE model decides to trust
the key, although nobody really said it's to be trusted.

Mr. Blackhat then can load his i_own_your_ring0.ko module signed by his
key on your system, having obtained root access previously.

You call Microsoft, telling them what Mr. Blackhat has done.

They now can:

a) Do what you want: Disable Mr. Blackhat's account and revoke the hash
   of his binary.

But also:

b) Say, "oh well, we're sorry this kills your security model, but it's
enough for us that you already fully booted Linux to worry about Windows
security, this affects only your distribution and we don't care".

c) Decide your security model is flawed, because you're abusing their
signature process to mean something else from what they intended and
revoke your shim hash instead.

And I don't think you can rely on MS doing 'a'. Particularly when there
will be a large number of key-in-PE binaries signed by them at that
point, with them not being able to tell by any analysis which of them
are evil and which not.

I would even say b) is most likely.

> We'd check the binary hash against dbx and refuse to load it on
> systems that have received the update, and Mr Evil Blackhat would have
> to find a new bunch of identity documents to create a new account to
> repeat the process.

Yes, from the point it gets blacklisted, it's fairly clear. You're
forced to reboot, but under the Secure Boot model, you have to do that
on any system that used code whose hash has been revoked.

-- 
Vojtech Pavlik
Director SuSE Labs
