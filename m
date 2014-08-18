Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaHRVDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:03:43 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:42972 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaHRVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:03:42 -0400
Date: Mon, 18 Aug 2014 16:03:33 -0500
From: Tejun Heo <tj@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 1/4] kactive: introduce generic "active"-refcounts
Message-ID: <20140818210333.GC24023@mtj.dyndns.org>
References: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
 <1407869648-1449-2-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407869648-1449-2-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 12, 2014 at 08:54:05PM +0200, David Herrmann wrote:
> This introduces a new reference-type "struct kactive". Unlike kref, this
> type manages "active references". That means, references can only be
> acquired if the object is active. At any time the object can be
> deactivated, causing any new attempt to acquire an active reference to
> fail. Furthermore, after disabling an object, you can wait for all active
> references to be dropped. This allows synchronous object removal without
> dangling _active_ objects.
> 
> This obivously does NOT replace the usual ref-count. Moreover, it is meant
> to be used in combination with normal ref-counts. This way, you can get
> active references and normal references to the object.
> 
> Active references are usually required for callbacks. That is, if an
> object has callbacks that can be entered by user-space, you usually want
> an active reference to the object as long as you are _inside_ the
> callback. This way the object cannot be removed while you work on it.
> Normal references, on the other hand, are required by the underlying
> file/device to make sure the object with its callback-pointer can be
> accessed at all.
> 
> kernfs implements an active-reference type with spin-locks. This patch is
> very loosely based on kernfs but avoids spin-locks.

Yeah, this is very similar to kernfs's [de]activation support which is
pretty much a revocation mechanism.  I have two comments.

* Is it necessary to make this a library?  Should it just be embedded
  into revoke(2) implementation?

* I struggled a lot with self-draining support in kernfs.  Ultimately,
  what worked is the ability to just put the reference which is held
  for the current invocation, fully delegating the responsibility of
  keeping the current object accessible to whoever requested to put
  that reference.  Self-draining can be implemented on top of it but
  that in itself is a bit too rigid for dynamic filesystems.

I'd love to see this in vfs layer.  A lot of kernfs's complexities
come from revocation support and using something common would be nice.
If this gets in, do you plan to convert kernfs to use it?

Thanks.

-- 
tejun
