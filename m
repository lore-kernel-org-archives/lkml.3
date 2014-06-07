Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaFGVxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:53:38 -0400
Received: from mout.gmx.net ([212.227.15.15]:49490 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbaFGVxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:53:37 -0400
Message-ID: <1402178010.4806.3.camel@schoellingm.dzne.de>
Subject: Re: [PATCH v2] dns_resolver: assure that dns_query() result is
 null-terminated
From: Manuel Schoelling <manuel.schoelling@gmx.de>
To: David Rientjes <rientjes@google.com>
Cc: davem@davemloft.net, jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 07 Jun 2014 23:53:30 +0200
In-Reply-To: <alpine.DEB.2.02.1406071441050.24927@chino.kir.corp.google.com>
References: <CAHQdGtTtwS_DAXx-nhVjjO3D1wksuV+5br10gX0DheHzWDD+sw@mail.gmail.com>
	 <1402167681-24676-1-git-send-email-manuel.schoelling@gmx.de>
	 <alpine.DEB.2.02.1406071441050.24927@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:wqBwOqvsRlPqEtsdpAXm748zeJlnHS5Z5SRutH1Geq8jADAHVnH
 B9v2j3GEfYSWhPxRjYS8pQ5b/TT1OqnPM3rQYimHjfMA1MvxKawn57Puj2ey7ki+2LYNMnT
 2zxGRvJugkZu2lrWMU4WZi24yIBhdAPt5Pujehwam+BSe43J7u4Y3NsBujtSxOjkKJMu204
 b71p4yZNPKkfwQJhYxwrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 2014-06-07 at 14:42 -0700, David Rientjes wrote:
> On Sat, 7 Jun 2014, Manuel Schölling wrote:
> 
> > dns_query() credulously assumes that keys are null-terminated and
> > returns a copy of a memory block that is off by one.
> 
> No sign-off?  Please read Documentation/SubmittingPatches.
It's just not my day today.
Sorry, I forgot about the sign-off.

> > ---
> >  net/dns_resolver/dns_query.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
> > index e7b6d53..84871a2 100644
> > --- a/net/dns_resolver/dns_query.c
> > +++ b/net/dns_resolver/dns_query.c
> > @@ -145,11 +145,11 @@ int dns_query(const char *type, const char *name, size_t namelen,
> >  	len = upayload->datalen;
> >  
> >  	ret = -ENOMEM;
> > -	*_result = kmalloc(len + 1, GFP_KERNEL);
> > +	*_result = kzalloc(len + 1, GFP_KERNEL);
> >  	if (!*_result)
> >  		goto put;
> >  
> > -	memcpy(*_result, upayload->data, len + 1);
> > +	memcpy(*_result, upayload->data, len);
> >  	if (_expiry)
> >  		*_expiry = rkey->expiry;
> >  
> 
> kzalloc() would be unnecessary overhead (zeroing definitely comes with a 
> cost) if you're going to copy to the memory immediately afterwards.  Just 
> leave the kmalloc(), do the memcpy() and explicitly zero terminate it 
> _result.

Using kzalloc() was suggested of a developer on IRC (#kernelnewbies) but
if you prefer kmalloc, that's ok, too.
I'll send you a corrected patch in a second.


