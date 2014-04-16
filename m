Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaDPSg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:36:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbaDPSgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:36:19 -0400
Date: Wed, 16 Apr 2014 14:36:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Simo Sorce <ssorce@redhat.com>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
Message-ID: <20140416183614.GH31074@redhat.com>
References: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
 <20140416002010.GA5035@redhat.com>
 <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
 <20140416.085743.1614257692560892039.davem@davemloft.net>
 <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
 <1397664837.19767.410.camel@willson.li.ssimo.org>
 <CALCETrXn7b6UuALpGUVoyQYfR2uzk5tj2ABV=dkvtFNgqM5sxQ@mail.gmail.com>
 <1397667766.19767.440.camel@willson.li.ssimo.org>
 <CALCETrU_yKQVZyVug25cxwQFjWJ7Zf20FY-6ht+RJifXtDdDWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU_yKQVZyVug25cxwQFjWJ7Zf20FY-6ht+RJifXtDdDWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:29:08AM -0700, Andy Lutomirski wrote:

[..]
> >> Admittedly cgroups aren't currently as important as uid, but if this
> >> changes, then SO_PASSCGROUP, as currently written, will have *exactly*
> >> the same problem.
> >
> > Which is easy to foil by using SO_PEERCGROUP and find out who originally
> > opened the socket, which is why that is also available!
> 
> Then please remove SO_PASSCGROUP.

SO_PASSCGROUP is important because SO_PEERCGROUP does not work with unix
datagram sockets.

Again going back to logging example, if some clients are logging to unix
datagram sockets, SO_PASSCGROUP is the only option to figure out cgroup
of client.

> 
> >> The issue here is that the receiver sets SO_(PASS|PEER)CGROUP, forcing
> >> the sender to identify or authenticate itself.  The sender might not
> >> want to identify itself.
> >
> > You need to explain, why, on a host, when an application connects to
> > another, it is ok to make it anonymous. If you do not want to expose
> > yourself, do not talk to other applications in the first place.
> 
> Why is anonymity harmful here?  I don't have a great argument off the
> top of my head for why it's necessary, but neither do I see why it's
> bad.

So once we have example where anonymity helps, we can implement
SO_NOPASSCGROUP to take care of it.

> And I think a lack of anonymity is asking for trouble (see
> below).

I read the example, below. I don't get where the *lack of anonymity*
is a problem.

You just seem to referring to the fact that SO_PEERCGROUP will not
be reliable if after opening a connection fd was passed to a program
in a different cgroup. And that's one reason why SCM_PASSCGROUP is
also implemented so that these kind of issues can be avoided.

So I fail to see what's the relation to *anonymity* in your example.

> 
> >
> >> the sender might not intend to authenticate.  Certainly no existing
> >> callers of connect or write intend to authenticate using their cgroup,
> >> since current kernels don't have those semantics.
> >
> > This is a passive check, it's the receiver that wants to make decisions
> > about who is connecting, again if you do not want to "disclose"
> > information do not connect in the first place ?
> >
> 
> Let's say I have a receiver.  I'll call it journald, since I think
> that's one of the eventual use cases.
> 
> Let's also say I some random program on my box.  It is willing to
> answer requests on behalf of anyone else with the same uid, and it
> will happily open a given unix socket and send the requester the file
> descriptor.  Such a program is a bit odd, but it's perfectly safe
> right now.
> 
> Now add a malicious program into the mix.  It asks the daemon to open
> /run/systemd/journal/socket.  Then it starts writing to the fd.
> 
> Whoops, now the malicious program can impersonate the helper.  This
> happens because SO_PEERCGROUP (and journald's use of SO_PEERCGROUP)
> caused connect(2) to produce a descriptor that carries a permission
> that the descriptor did not carry in the past, and because the caller
> of connect(2) did not need to opt in to the new behavior.
> 
> I still haven't seen any explanation for what's wrong with requiring
> senders to ask the kernel to transmit their cgroup.

If nothing else, additional complexity and ovhead. Extra pair of messages
need to be exchanged to request and then provide the information.

How would it work in logging example? Every time logger receives a
message, is it supposed to send another message to client to send
SCM_CGROUP? That does not sound right.

Thanks
Vivek
