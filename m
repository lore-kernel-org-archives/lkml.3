Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbbAHWjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:39:19 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51053 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665AbbAHWjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:39:17 -0500
Message-Id: <1420756756.1755002.211556745.0418D128@webmail.messagingengine.com>
X-Sasl-Enc: h/9c8SalRL8DHK5KGTxjRUPZU671ZhJXQ0RBx3rp2cLV 1420756756
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Rahul Sharma <rsharma@arista.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-210a55cc
Subject: Re: [PATCH net] ipv6: Prevent ipv6_find_hdr() from returning ENOENT for
 valid non-first fragments
Date: Thu, 08 Jan 2015 23:39:16 +0100
In-Reply-To: <20150108205328.GA3361@salvia>
References: <CAFB3abzYNYqtzd_n+Ym0Lo=DYbV0HPU=Tqw=stALNnu188hMKQ@mail.gmail.com>
 <20150106224706.GA7416@salvia>
 <CAFB3abwKpR1VqZXUrsexqveAZrA2LTSmTe8a=-H7z2HjAptjwA@mail.gmail.com>
 <1420627396.26870.36.camel@stressinduktion.org>
 <20150108205328.GA3361@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pablo,

On Thu, Jan 8, 2015, at 21:53, Pablo Neira Ayuso wrote:
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
> ever seen packet matching `-p ah' rules. Thus, we restore control to
> the user to allow this, but we would accept all kind of fragmented AH
> traffic through the firewall since we cannot know what transport
> protocol contains from non-1st fragments (unless I'm missing anything,
> I need to have a closer look at this again tomorrow with fresher
> mind).

The code in question is guarded by (_frag_off != 0), so we are
definitely processing a non-1st fragment currently. The -p match would
happen at the time when the packet is reassembled and thus ipv6_find_hdr
will find the real transport (final) header at this point (I hope I
followed the code correctly here).

The next proto field of the fragmentation header is copied from the
first fragment, thus it may specify AH header but actually only in the
original (unfragmented) packet an AH header is directly following the
fragmentation header, thus the next proto chain is somewhat unstable if
looking at the fragmented packets only.

Bye,
Hannes
