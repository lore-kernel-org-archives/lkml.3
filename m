Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbaKFWQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:16:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47672 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKFWQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:16:15 -0500
Date: Thu, 6 Nov 2014 22:16:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jon Maloy <jon.maloy@ericsson.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Masahide Nakamura <nakam@linux-ipv6.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: ipv4: Use standard iovec primitive in raw_probe_proto_opt
Message-ID: <20141106221608.GA7996@ZenIV.linux.org.uk>
References: <20141105035536.GO7996@ZenIV.linux.org.uk>
 <20141105.155054.2198151263164321219.davem@davemloft.net>
 <20141105210745.GT7996@ZenIV.linux.org.uk>
 <20141105.165719.835728206041332333.davem@davemloft.net>
 <20141106032533.GU7996@ZenIV.linux.org.uk>
 <20141106055023.GA28865@gondor.apana.org.au>
 <20141106064318.GW7996@ZenIV.linux.org.uk>
 <20141106064629.GA29321@gondor.apana.org.au>
 <20141106071109.GX7996@ZenIV.linux.org.uk>
 <A2BAEFC30C8FD34388F02C9B3121859D1C3087CA@eusaamb103.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2BAEFC30C8FD34388F02C9B3121859D1C3087CA@eusaamb103.ericsson.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:55:31AM +0000, Jon Maloy wrote:
> > Point, but that might very well be a pattern to watch for - there's at least one
> > more instance in TIPC (also not exploitable, according to TIPC folks) and such
> 
> I don't recall this, and I can't see where it would be either. Can you please
> point to where it is?

The same dest_name_check() thing.  This
        if (copy_from_user(&hdr, m->msg_iov[0].iov_base, sizeof(hdr)))
                return -EFAULT;
        if ((ntohs(hdr.tcm_type) & 0xC000) && (!capable(CAP_NET_ADMIN)))
                return -EACCES;
is easily bypassed.  Suppose you want to send a packet with these two
bits in ->tcm_type not being 00, and you don't have CAP_NET_ADMIN.
Not a problem - spawn two threads sharing memory, have one trying to
call sendmsg() while another keeps flipping these two bits.  Sooner
of later you'll get the timing right and have these bits observed as 00
in dest_name_check() and 11 when it comes to memcpy_fromiovecend() actually
copying the whole thing.  And considering that the interval between those
two is much longer than the loop in the second thread would take on
each iteration, I'd expect the odds around 25% per attempted sendmsg().

IOW, this test is either pointless and can be removed completely, or there's
an exploitable race.  As far as I understand from your replies both back then
and in another branch of this thread, it's the former and the proper fix is
to remove at least that part of dest_name_check().  So this case is also
not something exploitable, but it certainly matches the same pattern.

My point was simply that this pattern is worth watching for - recurrent bug
classes like that have a good chance to spawn an instance that will be
exploitable.
