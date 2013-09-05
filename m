Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063Ab3IECm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:42:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58440 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762449Ab3IECmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:42:25 -0400
Date: Thu, 5 Sep 2013 03:42:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
Message-ID: <20130905024222.GM13318@ZenIV.linux.org.uk>
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
 <20130904191104.GK13318@ZenIV.linux.org.uk>
 <52278AEC.2020307@hp.com>
 <20130904194341.GL13318@ZenIV.linux.org.uk>
 <5227E49F.1090809@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5227E49F.1090809@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 09:55:43PM -0400, Waiman Long wrote:
> On 09/04/2013 03:43 PM, Al Viro wrote:
> >On Wed, Sep 04, 2013 at 03:33:00PM -0400, Waiman Long wrote:
> >
> >>I have thought about that. But if a d_move() is going on, the string
> >>in the buffer will be discarded as the sequence number will change.
> >>So whether or not it have embedded null byte shouldn't matter. That
> >>is why I didn't add code to do byte-by-byte copy at this first
> >>patch. I can add code to do that if you think it is safer to do so.
> >Sigh...  Junk in the output is not an issue; reading from invalid address
> >is, since you might not survive to the sequence number check.  Again,
> >if p is an address returned by kmalloc(size, ...), dereferencing p + offset
> >is not safe unless offset is less than size.
> 
> Yeah, I understand that. As said in my reply to Linus, I will use
> memchr() to see if there is null byte within the specified length.
> If one is found, I will assume the string is not valid and return
> error to the caller.

Umm...  Strictly speaking, memchr() behaviour is undefined if the third
argument exceeds the size of object pointed to by the first one.  IOW,
it has every right to assume that all characters in the range to be
searched in are safely readable.  You can't assume that it will read
them one by one until it hits the one you are searching for.  In practice
it's probably almost[1] true for all our implementations of memchr(), but...

[1] reads past the character being searched for are very likely, but they'll
be within the same page, which is safe.
