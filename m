Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3AWKrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:47:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3AWKrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:47:48 -0500
Date: Wed, 23 Jan 2013 11:47:36 +0100
From: Leandro Lucarella <leandro.lucarella@sociomantic.com>
To: Rick Jones <rick.jones2@hp.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Doubts about listen backlog and tcp_max_syn_backlog
Message-ID: <20130123104736.GK4608@sociomantic.com>
References: <20130122161038.GG4608@sociomantic.com>
 <1358873142.3464.3964.camel@edumazet-glaptop>
 <20130122165929.GH4608@sociomantic.com>
 <1358874800.3464.4002.camel@edumazet-glaptop>
 <50FED7CE.1030008@hp.com>
 <20130122184245.GJ4608@sociomantic.com>
 <50FF0C25.9000300@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FF0C25.9000300@hp.com>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:6FVe5nSP87/vh2DuZfzNuDZz/imakTRAE2RWnzYq6q9
 uNjChOT1gQOIQK2E2r5qwAORERYPFCP4l21R7/CGE20fuGSAZT
 dMuo22rOO9jOs8nY+bZN0UDyFS4mAtCB8Kps+pB5u0wtBTAldL
 otWMJchhLZQX4nvzAhA4Nw5jIVqS3sSK7UK8i5/Ah1x0JEE8dX
 cJieRJkAcGqeRMv8KiWFeYmNGX4ONta8yxXO2Anr0u6z6kQWyI
 un5eLCsW2+fwOLxoo3CK6AIy/BsKYWK28VZp/SiJV1qwBL8rTQ
 1EStRUhGtkaEZjjmM9S9PP8Y1zEk6bLrfGQLDvopg+8XsSoNmR
 RPjNMmgUgFfb59dMV9pT8rTzlsaYqxGiUIBGx+OFqxPEZ8nMpd
 Bbim0boPyEbBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 02:01:09PM -0800, Rick Jones wrote:
> >>If that is being overflowed, I believe you should be seeing something like:
> >>
> >>     14 SYNs to LISTEN sockets dropped
> >>
> >>in the output of netstat -s on the system on which the server
> >>application is running.
> >
> >What is that value reporting exactly?
> 
> Netstat is reporting the ListenDrops and/or ListenOverflows  which
> map to LINUX_MIB_LISTENDROPS and LINUX_MIB_LISTENOVERFLOWS.  Those
> get incremented in tcp_v4_syn_recv_sock() (and its v6 version etc)
> 
>        if (sk_acceptq_is_full(sk))
>                 goto exit_overflow;
> 
> Will increment both overflows and drops, and drops will increment on
> its own in some additional cases.
> 
> >Because we are using syncookies, and AFAIK with that enabled, all
> >SYNs are being replied, and what the listen backlog is really
> >limitting is the "completely established sockets waiting to be
> >accepted", according to listen(2). What I don't really know to be
> >honest, is what a "completely established socket" is, does it mean
> >that the SYN,ACK was sent, or the ACK was received back?
> 
> I have always thought it meant that the ACK of the SYN|ACK has been
> received.
> 
> SyncookiesSent SyncookiesRecv SyncookiesFailed also appear in
> /proc/net/netstat and presumably in netstat -s output.

Thanks for the info. I'm definitely dropping SYNs and sending cookies,
around 50/s. Is there any way to tell how many connections are queued in
a particular socket?

> >Also, from the client side, when is the connect(2) call done? When the
> >SYN,ACK is received?
> 
> That would be my assumption.

Then if syncookies are enabled, the time spent in connect() shouldn't be
bigger than 3 seconds even if SYNs are being "dropped" by listen, right?
(and I'm saying "dropped" because I assume if syncookies are enabled,
SYN,ACK replies are sent anyway, with a cookie, but they are not stored
in the queue/hash table).

> In a previous message:
> 
> >What I'm seeing are clients taking either useconds to connect, or 3
> >seconds, which suggest SYNs are getting lost, but the network doesn't
> >seem to be the problem. I'm still investigating this, so unfortunately
> >I'm not really sure.
> 
> I recently ran into something like that, which turned-out to be an
> issue with nf_conntrack and its table filling.

Doing a quick research about it, I found that when that happens I should
get a message about it in dmesg (like "kernel: nf_conntrack: table full,
dropping packet.") but I'm not getting any, so I guess that's not a
problem.

Thanks!

-- 
Leandro Lucarella
sociomantic labs GmbH
http://www.sociomantic.com
