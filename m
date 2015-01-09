Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbbAILmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:42:19 -0500
Received: from mail.us.es ([193.147.175.20]:37951 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbbAILmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:42:17 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus5 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.5/19899. spamassassin: 3.4.0.  
 Clear:RC:1(127.0.0.1):SA:0(-104.2/7.5):. 
 Processed in 1.880735 secs); 09 Jan 2015 11:42:14 -0000
X-Spam-ASN: 
X-Envelope-From: pneira@us.es
Date: Fri, 9 Jan 2015 12:45:06 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Rahul Sharma <rsharma@arista.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Prevent ipv6_find_hdr() from returning ENOENT
 for valid non-first fragments
Message-ID: <20150109114506.GA4857@salvia>
References: <CAFB3abzYNYqtzd_n+Ym0Lo=DYbV0HPU=Tqw=stALNnu188hMKQ@mail.gmail.com>
 <20150106224706.GA7416@salvia>
 <CAFB3abwKpR1VqZXUrsexqveAZrA2LTSmTe8a=-H7z2HjAptjwA@mail.gmail.com>
 <1420627396.26870.36.camel@stressinduktion.org>
 <20150108205328.GA3361@salvia>
 <1420756756.1755002.211556745.0418D128@webmail.messagingengine.com>
 <20150109000546.GA3488@salvia>
 <CAFB3abwrjp61LLOk3RWwXYEq1g4QZUC8OTKuO2cAr+GbV3n4rw@mail.gmail.com>
 <1420803255.1978819.211762005.707EFFB9@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420803255.1978819.211762005.707EFFB9@webmail.messagingengine.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

On Fri, Jan 09, 2015 at 12:34:15PM +0100, Hannes Frederic Sowa wrote:
> On Fri, Jan 9, 2015, at 08:18, Rahul Sharma wrote:
> > Hi Pablo,
> > 
> > On Fri, Jan 9, 2015 at 5:35 AM, Pablo Neira Ayuso <pablo@netfilter.org>
> > wrote:
> > > On Thu, Jan 08, 2015 at 11:39:16PM +0100, Hannes Frederic Sowa wrote:
> > >> Hi Pablo,
> > >>
> > >> On Thu, Jan 8, 2015, at 21:53, Pablo Neira Ayuso wrote:
> > >> > I'm afraid we cannot just get rid of that !ipv6_ext_hdr() check. The
> > >> > ipv6_find_hdr() function is designed to return the transport protocol.
> > >> > After the proposed change, it will return extension header numbers.
> > >> > This will break existing ip6tables rulesets since the `-p' option
> > >> > relies on this function to match the transport protocol.
> > >> >
> > >> > Note that the AH header is skipped (see code a bit below this
> > >> > problematic fragmentation handling) so the follow up header after the
> > >> > AH header is returned as the transport header.
> > >> >
> > >> > We can probably return the AH protocol number for non-1st fragments.
> > >> > However, that would be something new to ip6tables since nobody has
> > >> > ever seen packet matching `-p ah' rules. Thus, we restore control to
> > >> > the user to allow this, but we would accept all kind of fragmented AH
> > >> > traffic through the firewall since we cannot know what transport
> > >> > protocol contains from non-1st fragments (unless I'm missing anything,
> > >> > I need to have a closer look at this again tomorrow with fresher
> > >> > mind).
> > >>
> > >> The code in question is guarded by (_frag_off != 0), so we are
> > >> definitely processing a non-1st fragment currently. The -p match would
> > >> happen at the time when the packet is reassembled and thus ipv6_find_hdr
> > >> will find the real transport (final) header at this point (I hope I
> > >> followed the code correctly here).
> > >
> > > Then, Rahul should get things working by modprobing nf_defrag_ipv6.
> > 
> > I already had nf_defrag_ipv6 installed when the issue occured. But I
> > see ip6table_raw_hook returning NF_DROP for the second fragment.
> 
> That's what I expected. I think the change only affects hooks before
> reassembly.

reassembly happens at NF_IP6_PRI_CONNTRACK_DEFRAG (-400), so that
happens before NF_IP6_PRI_RAW (-300) in IPv6 which is where the raw
table is placed.
