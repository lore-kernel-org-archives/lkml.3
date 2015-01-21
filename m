Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbbAUVkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:40:35 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:6000 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbbAUVk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:40:28 -0500
Date: Wed, 21 Jan 2015 22:40:24 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121214024.GA28012@kria>
References: <20150121033600.GN29656@ZenIV.linux.org.uk>
 <54BF2496.4000807@roeck-us.net>
 <20150121043637.GO29656@ZenIV.linux.org.uk>
 <20150121110539.GA8924@kria>
 <54BFAA5D.4040108@roeck-us.net>
 <20150121182905.GQ29656@ZenIV.linux.org.uk>
 <54BFF8B3.6060802@roeck-us.net>
 <20150121200626.GR29656@ZenIV.linux.org.uk>
 <54C01418.5060204@roeck-us.net>
 <20150121212833.GS29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150121212833.GS29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-21, 21:28:33 +0000, Al Viro wrote:
> On Wed, Jan 21, 2015 at 01:03:20PM -0800, Guenter Roeck wrote:
> > ok case (putname commented out):
> > 
> > user_path_at_empty lookup usr flags 0x0
> > path_lookupat: calling path_init 'usr' flags=40
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=40[50] returned 0
> > walk_component: lookup_fast() returned 1
> > walk_component: lookup_slow() returned 0
> > walk_component: inode=  (null), negative=1
> > do_path_lookup(usr, 0x10)
> > path_lookupat: calling path_init 'usr' flags=50
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=50[50] returned 0
> > mkdir[c74012a0,/usr] => 0
> > user_path_at_empty lookup usr flags 0x1
> > path_lookupat: calling path_init 'usr' flags=41
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=41[51] returned 0
> > walk_component: inode=c74004a0, negative=0
> > user_path_at_empty lookup usr flags 0x1
> > path_lookupat: calling path_init 'usr' flags=41
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=41[51] returned 0
> > 
> > failing case:
> > 
> > path_lookupat: calling path_init 'usr' flags=40
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=40[50] returned 0
> > walk_component: lookup_fast() returned 1
> > walk_component: lookup_slow() returned 0
> > walk_component: inode=  (null), negative=1
> > do_path_lookup(usr, 0x10)
> > path_lookupat: calling path_init 'usr' flags=50
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=50[50] returned 0
> > mkdir[c74012a0,/kkk] => 0						<==== SIC!
> 
> Cute. 'k' being 0x6b, aka POISON_FREE...  OK, the next question is what's
> been freed under us - I don't believe that it's dentry itself...
> Oh, fuck.  OK, I see what happens.  Look at kern_path_create(); it does
> LOOKUP_PARENT walk, leaving nd->last pointing to the last component of
> the *COPY* of the name it's just created, walked and freed.
> 
> OK...  Fortunately, struct nameidata is completely opaque outside of fs/namei.c,
> so we only need to care about a couple of codepaths.
> 
> Folks, could you check if the following on top of linux-next fixes the problem?

Yes, it works.


-- 
Sabrina
