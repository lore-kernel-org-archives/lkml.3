Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaEACvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:51:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49745 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaEACvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:51:08 -0400
Date: Thu, 1 May 2014 03:51:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140501025105.GY18016@ZenIV.linux.org.uk>
References: <20140430195918.GS18016@ZenIV.linux.org.uk>
 <CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
 <20140430203823.GT18016@ZenIV.linux.org.uk>
 <CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
 <20140430211206.GU18016@ZenIV.linux.org.uk>
 <20140430221238.GV18016@ZenIV.linux.org.uk>
 <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
 <CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
 <20140430234341.GX18016@ZenIV.linux.org.uk>
 <CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 05:18:23PM -0700, Linus Torvalds wrote:

> and then suddenly it looks like we have a common exit sequence from
> that dentry_kill() function, no?
> 
> (The earlier "unlock_on_failure" exit case is altogether a different case).
> 
> I dunno. Maybe not a big deal, but one reason I prefer doing that
> "free" flag is because I really tend to prefer the simple case of
> lock-unlock pairing cleanly at the same level. NOT the pattern where
> you have one lock at one indentation level, paired with multiple
> unlocks for all the different cases.

Yeah, but... I have such variant, but the best I could get still generated
the code that wasn't particulary nice.  Part might be gcc code generation
sucking for bool, part - extra register pressure...  It has slightly lower
i-cache footprint, though, so it might be worth doing.  Hell knows; that's a
fairly hot codepath, so let's do it that way - I've just pushed an alternative
branch with bool can_free variant; branches in question: vfs.git#for-linus and
vfs.git#dentry_kill-2. Help with profiling is needed; the loads to watch are
the ones where dentry_kill() + dentry_free() are sufficiently high in profiles
for the differences to matter.  Any takers?
