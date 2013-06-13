Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3FMFjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 01:39:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52557 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3FMFjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 01:39:01 -0400
Message-ID: <1371101936.3252.92.camel@edumazet-glaptop>
Subject: Re: [PATCH 1/3] skbuff: Update truesize in pskb_expand_head
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Wiltshire <david.wiltshire@gmx.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, eparis@redhat.com, edumazet@google.com
Date: Wed, 12 Jun 2013 22:38:56 -0700
In-Reply-To: <20130612233503.GB10989@linux-rbgc.site>
References: <1371027934-1955-1-git-send-email-david.wiltshire@gmx.com>
	 <1371027934-1955-2-git-send-email-david.wiltshire@gmx.com>
	 <1371028618.3252.57.camel@edumazet-glaptop>
	 <20130612233503.GB10989@linux-rbgc.site>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 09:35 +1000, Dave Wiltshire wrote:

> Firstly, from my cover letter: "Perhaps I don't understand something,
> but I thought it best to generate the change and then ask. So is this
> correct?".

Sure I have no problems with that.

>  But secondly, I understand that the only reason for truesize
> is for memory accounting on sockets. Indeed that's why I thought this
> was incorrect. Something being complex is not a good reason not to do
> it.

OK but right now your patch adds many regressions, that will take weeks
for other dev to discover, understand and fix.

If you change skb->truesize not properly while skb is owned by a socket,
we can hold references forever and prevent sockets from being
dismantled/freed, or worse we'll free sockets while they are still in
use and panic the machine.

Some callers of pskb_expand_head() do not want skb->truesize to be
modified, because skb might be orphaned or not.

There are hundred of call sites.

Really, your patch is way too risky and will consume too much time for
very little gain. We cannot change conventions without a full audit.

There are some cases where truesize can not be exactly tracked.
For example, when we pull all data from a frag into skb->head, and the
frag can be release (put_page() on it), we do not know its original size
and can not reduce skb->truesize by this amount.
Thats fine, most of the time, because we pull network headers and they
are limited in size.

Your changelog used : "This is likely a memory audit leak", which is
weak considering the amount of time needed for us to validate such a big
change.



