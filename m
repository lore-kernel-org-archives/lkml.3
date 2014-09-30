Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaI3NFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:05:04 -0400
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:42165 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751306AbaI3NFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:05:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:6742:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13073:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tooth93_2b531a0d09d27
X-Filterd-Recvd-Size: 2779
Message-ID: <1412082296.4302.101.camel@joe-AO725>
Subject: Re: [PATCH 2/7] netfilter: Convert print_tuple functions to return
 void
From: Joe Perches <joe@perches.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Sep 2014 06:04:56 -0700
In-Reply-To: <20140930102221.GB2707@dhcp128.suse.cz>
References: <20140929124246.3e39dac8@gandalf.local.home>
	 <cover.1412031505.git.joe@perches.com>
	 <f2e8cf8df433a197daa62cbaf124c900c708edc7.1412031505.git.joe@perches.com>
	 <20140930102221.GB2707@dhcp128.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 12:22 +0200, Petr Mladek wrote:
> On Mon 29-09-14 16:08:22, Joe Perches wrote:
> > Since adding a new function to seq_file (seq_is_full)
> > there isn't any value for functions called from seq_show to
> > return anything.   Remove the int returns of the various
> > print_tuple/<foo>_print_tuple functions.

[a bunch of quoted stuff]

Please remember to cut out from your replies the unnecessary old stuff.
It can take quite awhile to scan through looking for your comments.

> > diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
[]
> > @@ -202,9 +203,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
> >  	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
> >  		goto release;
> >  
> > -	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> > -			l3proto, l4proto))
> > -		goto release;
> > +	print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> > +		    l3proto, l4proto);
> 
> To be precise, we should add:
> 
> 	if (seq_overflow(s))
> 		goto release;

Precision isn't all that useful when checking seq_<output>.

There really isn't much value in checking each possible
overflow site.  A periodic check prior to or in the middle
of a more costly/longish operation should be acceptable.

The entire block that precedes any seq buffer full test will
be redone when the buffer is expanded.

