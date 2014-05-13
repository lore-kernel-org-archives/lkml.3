Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbaEMMtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:49:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35052 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbaEMMtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:49:45 -0400
Date: Tue, 13 May 2014 14:49:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [ 080/143] net: rework recvmsg handler msg_name and msg_namelen logic
Message-ID: <20140513124938.GB28976@1wt.eu>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local> <20140512003203.962853843@1wt.eu> <20140513124425.GB4006@hercules>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513124425.GB4006@hercules>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Tue, May 13, 2014 at 01:44:25PM +0100, Luis Henriques wrote:
> On Mon, May 12, 2014 at 02:33:20AM +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > 
> > [ Upstream commit f3d3342602f8bcbf37d7c46641cb9bca7618eb1c ]
> > 
> 
> <snip>
> 
> > diff --git a/net/rxrpc/ar-recvmsg.c b/net/rxrpc/ar-recvmsg.c
> > index a39bf97..f779fc3 100644
> > --- a/net/rxrpc/ar-recvmsg.c
> > +++ b/net/rxrpc/ar-recvmsg.c
> > @@ -142,10 +142,12 @@ int rxrpc_recvmsg(struct kiocb *iocb, struct socket *sock,
> >  
> >  		/* copy the peer address and timestamp */
> >  		if (!continue_call) {
> > -			if (msg->msg_name && msg->msg_namelen > 0)
> > +			if (msg->msg_name) {
> > +				size_t len =
> > +					sizeof(call->conn->trans->peer->srx);
> >  				memcpy(msg->msg_name,
> > -				       &call->conn->trans->peer->srx,
> > -				       sizeof(call->conn->trans->peer->srx));
> > +				       &call->conn->trans->peer->srx, len);
>   +                                    msg->msg_namelen = len;
> 
> This statement^^^ is missing in this backport.

Ah this is the one that was placed out of scope and which failed on
the first round. Now I understand what happened. I rememeber having
applied one patch with git am -C0 to help it pass, and a few patches
later I was scared to see that I still had -C0 on the command I was
reusing (up arrow, ctrl-w, copy-paste patch name and enter). I carefully
rechecked the few affected patches but found nothing suspicious. It seems
I did not check well enough. Given how this patch was mangled, clearly it
was affected by this mistake.

> Also missing in this patch are the changes to the following functions:
> 
> - pppoe_recvmsg()
>   In file drivers/net/pppoe.c instead of drivers/net/ppp/pppoe.c
> 
> - pppol2tp_recvmsg()
>   In file drivers/net/pppol2tp.c instead of net/l2tp/l2tp_ppp.c
> 
> For reference, I'm attaching the backport we have used in our Ubuntu
> kernel.  (Note that we added some extra information to the commit
> message to include the CVE number and a link to the CVE bug.)

OK thank you very much Luis!

Willy

