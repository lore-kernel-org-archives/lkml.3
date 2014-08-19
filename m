Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaHSI3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:29:35 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:49453 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaHSI3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:29:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140818210333.GC24023@mtj.dyndns.org>
References: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
	<1407869648-1449-2-git-send-email-dh.herrmann@gmail.com>
	<20140818210333.GC24023@mtj.dyndns.org>
Date: Tue, 19 Aug 2014 10:29:31 +0200
Message-ID: <CANq1E4Tv0pKpZQnVEQXeMPYdiucMnhjEcwpoCKaneNd0-6v7wQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] kactive: introduce generic "active"-refcounts
From: David Herrmann <dh.herrmann@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun

On Mon, Aug 18, 2014 at 11:03 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Aug 12, 2014 at 08:54:05PM +0200, David Herrmann wrote:
>> This introduces a new reference-type "struct kactive". Unlike kref, this
>> type manages "active references". That means, references can only be
>> acquired if the object is active. At any time the object can be
>> deactivated, causing any new attempt to acquire an active reference to
>> fail. Furthermore, after disabling an object, you can wait for all active
>> references to be dropped. This allows synchronous object removal without
>> dangling _active_ objects.
>>
>> This obivously does NOT replace the usual ref-count. Moreover, it is meant
>> to be used in combination with normal ref-counts. This way, you can get
>> active references and normal references to the object.
>>
>> Active references are usually required for callbacks. That is, if an
>> object has callbacks that can be entered by user-space, you usually want
>> an active reference to the object as long as you are _inside_ the
>> callback. This way the object cannot be removed while you work on it.
>> Normal references, on the other hand, are required by the underlying
>> file/device to make sure the object with its callback-pointer can be
>> accessed at all.
>>
>> kernfs implements an active-reference type with spin-locks. This patch is
>> very loosely based on kernfs but avoids spin-locks.
>
> Yeah, this is very similar to kernfs's [de]activation support which is
> pretty much a revocation mechanism.  I have two comments.
>
> * Is it necessary to make this a library?  Should it just be embedded
>   into revoke(2) implementation?

I have no objections to embedding it into revoke(2).

> * I struggled a lot with self-draining support in kernfs.  Ultimately,
>   what worked is the ability to just put the reference which is held
>   for the current invocation, fully delegating the responsibility of
>   keeping the current object accessible to whoever requested to put
>   that reference.  Self-draining can be implemented on top of it but
>   that in itself is a bit too rigid for dynamic filesystems.

Yes, I saw that you just drop the own reference and then acquire a
fake-ref to simplify exit-paths. Not sure which's the better way. I
guess for the start it'd be enough to just get normal draining and add
self-draining once we're done with the base implementation.

> I'd love to see this in vfs layer.  A lot of kernfs's complexities
> come from revocation support and using something common would be nice.
> If this gets in, do you plan to convert kernfs to use it?

kernfs also requires delayed 'enable' for attributes, so you can
enable a whole tree at once. I haven't added support for this to
revoke(2), but I'm planning to.

Thanks
David
