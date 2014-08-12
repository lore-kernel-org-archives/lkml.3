Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaHLMrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:47:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbaHLMry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:47:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANP1eJG572cAR1t+pzCExk7EQWb=aDz77-PuP50GAP2j2mETiw@mail.gmail.com>
References: <CANP1eJG572cAR1t+pzCExk7EQWb=aDz77-PuP50GAP2j2mETiw@mail.gmail.com> <cover.1406043029.git.milosz@adfin.com> <53CE8862.7020201@adfin.com> <28626.1406648278@warthog.procyon.org.uk>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Shantanu Goel <sgoel01@yahoo.com>
Subject: Re: [PATCH 2/3] FS-Cache: Reduce cookie ref count if submit fails.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17619.1407847665.1@warthog.procyon.org.uk>
Date: Tue, 12 Aug 2014 13:47:45 +0100
Message-ID: <17620.1407847665@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> The honest answer is I don't know if it know if needs to be unlocked
> before or after. I saw a same pattern with unlocking order inside of
> __fscache_attr_changed in the failure case.

Following the enomem label, I'm calling fscache_unuse_cookie() which does this
without holding the lock in the same function.

I don't think the lock is required because:

 (1) We hold a ref on cookie->n_active so the cookie cannot go away until we
     release it, so calling __fscache_unuse_cookie() without the lock held
     should be fine.

 (2) wake_up_atomic_t() does not access cookie->n_active.  The address is
     merely needed as a key for the waiters to match on.

David
