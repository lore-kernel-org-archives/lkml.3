Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbaDHH1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:27:47 -0400
Received: from mail.us.es ([193.147.175.20]:40663 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbaDHH1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:27:45 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18755. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.8/7.5):. 
 Processed in 2.268144 secs); 08 Apr 2014 07:27:41 -0000
X-Spam-ASN: AS12715 188.78.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 8 Apr 2014 09:27:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Andrew Vagin <avagin@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org, vvs@parallels.com,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] [RFC] netfilter: ct: flush net_gre->keymap_list only in
 nf_conntrack_proto_gre
Message-ID: <20140408072738.GA3613@localhost>
References: <1396275258-19015-1-git-send-email-avagin@openvz.org>
 <20140407145158.GA25974@localhost>
 <20140408065600.GA15309@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408065600.GA15309@paralelels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 10:56:00AM +0400, Andrew Vagin wrote:
> On Mon, Apr 07, 2014 at 04:51:58PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Mar 31, 2014 at 06:14:18PM +0400, Andrey Vagin wrote:
> > > nf_ct_gre_keymap_flush() removes a nf_ct_gre_keymap object from
> > > net_gre->keymap_list and frees the object. But it doesn't clean
> > > a reference on this object from ct_pptp_info->keymap[dir].
> > > Then nf_ct_gre_keymap_destroy() may release the same object again.
> > > 
> > > So nf_ct_gre_keymap_flush() can be called only when we are sure that
> > > when nf_ct_gre_keymap_destroy will not be called.
> > > 
> > > nf_ct_gre_keymap is created by nf_ct_gre_keymap_add() and the right way
> > > to destroy it is to call nf_ct_gre_keymap_destroy().
> > 
> > I think you use call nf_ct_iterate_cleanup() to get rid of all GRE
> > conntrack entries that have a ct->master, which means that they were
> > created by PPTP. That implicitly calls gre_destroy, which releases the
> > keymap object.
> 
> I'm not sure that I understand your comment. Currently I change nothing
> about nf_ct_iterate_cleanup(). In this sentence I point to the right
> procedure of destroying a gre conntrack.
> 
> nf_ct_iterate_cleanup() is called from nf_ct_l4proto_pernet_unregister().

I was considering the scenario in which we only remove the pptp
module, so my proposal was to get rid of the gre entry that were
created through the pptp helper as well.  But we don't seem to do that
in any of our helpers and I think that cleanup is not possible in all
cases.

I'll take your patch, thanks.
