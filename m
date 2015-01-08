Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbbAHVIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 16:08:35 -0500
Received: from mail.us.es ([193.147.175.20]:56104 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331AbbAHVId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 16:08:33 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.5/19898. spamassassin: 3.4.0.  
 Clear:RC:1(127.0.0.1):SA:0(-104.0/7.5):. 
 Processed in 1.996415 secs); 08 Jan 2015 21:08:31 -0000
X-Spam-ASN: 
X-Envelope-From: pneira@us.es
Date: Thu, 8 Jan 2015 22:11:23 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Rahul Sharma <rsharma@arista.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Prevent ipv6_find_hdr() from returning ENOENT
 for valid non-first fragments
Message-ID: <20150108211123.GA4140@salvia>
References: <CAFB3abzYNYqtzd_n+Ym0Lo=DYbV0HPU=Tqw=stALNnu188hMKQ@mail.gmail.com>
 <20150106224706.GA7416@salvia>
 <CAFB3abwKpR1VqZXUrsexqveAZrA2LTSmTe8a=-H7z2HjAptjwA@mail.gmail.com>
 <1420627396.26870.36.camel@stressinduktion.org>
 <20150108205328.GA3361@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108205328.GA3361@salvia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 09:53:28PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 07, 2015 at 11:43:16AM +0100, Hannes Frederic Sowa wrote:
> > > >> @@ -250,9 +251,7 @@ int ipv6_find_hdr(const struct sk_buff *
> > > >>
> > > >>                         _frag_off = ntohs(*fp) & ~0x7;
> > > >>                         if (_frag_off) {
> > > >> -                               if (target < 0 &&
> > > >> -                                   ((!ipv6_ext_hdr(hp->nexthdr)) ||
> > > >
> > > > This check assumes that the following headers cannot show up in the
> > > > fragmented part of the IPv6 packet:
> > > >
> > > >  12 bool ipv6_ext_hdr(u8 nexthdr)
> > > >  13 {
> > > >  14         /*
> > > >  15          * find out if nexthdr is an extension header or a protocol
> > > >  16          */
> > > >  17         return   (nexthdr == NEXTHDR_HOP)       ||
> > > >  18                  (nexthdr == NEXTHDR_ROUTING)   ||
> > > >  19                  (nexthdr == NEXTHDR_FRAGMENT)  ||
> > > >  20                  (nexthdr == NEXTHDR_AUTH)      ||
> > > >  21                  (nexthdr == NEXTHDR_NONE)      ||
> > > >  22                  (nexthdr == NEXTHDR_DEST);
> > > >
> > > >> -                                    hp->nexthdr == NEXTHDR_NONE)) {
> > > >> +                               if (target < 0) {
> > > >>                                         if (fragoff)
> > > >>                                                 *fragoff = _frag_off;
> > > >>                                         return hp->nexthdr;
> > > >> --
> > > >> To unsubscribe from this list: send the line "unsubscribe netdev" in
> > > >> the body of a message to majordomo@vger.kernel.org
> > > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > > I think this is incorrect. Authentication header shows up in the
> > > fragmentable part of the original IPv6 packet. So, for the non-first
> > > fragments the next-header field value can be NEXTHDR_AUTH.
> > 
> > Pablo's mail got me thinking again.
> > 
> > In general, IPv6 extension headers can appear in any order and stacks
> > must be process them. Fragmentation adds a limitation, that some
> > extension headers do not make sense and don't have any effect if they
> > appear after a fragmentation header (HbH and ROUTING).
> > 
> > Looking at the rest of the function we don't check for HBHHDR or RTHDR
> > following a fragmentation header either if we process the first fragment
> > (core stack only processes HBH if directly following the ipv6 header
> > anyway).
> > 
> > So, in my opinion, it is safe to completely remove this check and it
> > would align if the rest of the extension processing logic. The callers
> > all seem fine with that.
> > 
> > Pablo, what do you think?
> 
> I'm afraid we cannot just get rid of that !ipv6_ext_hdr() check. The
> ipv6_find_hdr() function is designed to return the transport protocol.
> After the proposed change, it will return extension header numbers.
> This will break existing ip6tables rulesets since the `-p' option
> relies on this function to match the transport protocol.
> 
> Note that the AH header is skipped (see code a bit below this
> problematic fragmentation handling) so the follow up header after the
> AH header is returned as the transport header.
> 
> We can probably return the AH protocol number for non-1st fragments.
> However, that would be something new to ip6tables since nobody has
> ever seen packet matching `-p ah' rules.

# ip6tables -I INPUT -p ah
Warning: never matched protocol: ah. use extension match instead.
