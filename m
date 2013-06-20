Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935563Ab3FTCQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:16:15 -0400
Received: from ozlabs.org ([203.10.76.45]:33439 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935491Ab3FTCQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:16:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11 1/2] percpu-refcount: add __must_check to percpu_ref_init() and don't use ACCESS_ONCE() in percpu_ref_kill_rcu()
In-Reply-To: <20130619082123.GD30681@mtj.dyndns.org>
References: <20130613035201.GD9451@mtj.dyndns.org> <87y5a6n71o.fsf@rustcorp.com.au> <20130619082123.GD30681@mtj.dyndns.org>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 20 Jun 2013 10:29:51 +0930
Message-ID: <878v25mwag.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
> On Wed, Jun 19, 2013 at 12:25:14PM +0930, Rusty Russell wrote:
>> But it's quite OK to ignore OOM errors in builtin init functions.
>
> I think it'd be cleaner to let those use cases use BUG_ON() around it.
> We really want most users to be checking its return value.

Yeah, but it's an admission of API design failure.

__attribute__((warn_unused_result)) is a bad implementation of a poorly
conceived idea.  It was originally designed to catch realloc misuse,
which is presumably why casting to (void) doesn't suppress it.
Protecting realloc properly would mean the GCC understanding that the
pointer arg handed to realloc was no longer valid which would catch many
more cases, but compilers are hard, so we got the hacky attribute.

Now seems to get abused by lazy coders who blame users for their own
broken APIs.  And Ubuntu, who turn it on by default in their gcc when
optimizing.  Yeah, it's a sore point :)

So I end up writing code like this (to quote from ccan):

        /* Gcc's warn_unused_result is fascist bullshit. */
        #define doesnt_matter()
...
        	if (system(command))
        		doesnt_matter();

>> It would be neatest to have it fail into slow mode, of course, but it's
>> probably not worth the pain.
>
> percpu allocation is always GFP_KERNEL, so it can't get any slower
> without deadlocking.

Sorry, I was unclear.  If you fail the percpu allocation, you have a
counter which is always in atomic mode.

This saves everyone a headache.  init doesn't fail, no poorly-tested
failure paths, no whining Rusty.

Rant over,
Rusty.
