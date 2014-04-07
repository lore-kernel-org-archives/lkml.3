Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaDGOwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:52:06 -0400
Received: from mail.us.es ([193.147.175.20]:57685 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbaDGOwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:52:04 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus6 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18752. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.8/7.5):. 
 Processed in 2.027437 secs); 07 Apr 2014 14:52:01 -0000
X-Spam-ASN: AS12715 188.78.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 7 Apr 2014 16:51:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, vvs@parallels.com,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] [RFC] netfilter: ct: flush net_gre->keymap_list only in
 nf_conntrack_proto_gre
Message-ID: <20140407145158.GA25974@localhost>
References: <1396275258-19015-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396275258-19015-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 06:14:18PM +0400, Andrey Vagin wrote:
> nf_ct_gre_keymap_flush() removes a nf_ct_gre_keymap object from
> net_gre->keymap_list and frees the object. But it doesn't clean
> a reference on this object from ct_pptp_info->keymap[dir].
> Then nf_ct_gre_keymap_destroy() may release the same object again.
> 
> So nf_ct_gre_keymap_flush() can be called only when we are sure that
> when nf_ct_gre_keymap_destroy will not be called.
> 
> nf_ct_gre_keymap is created by nf_ct_gre_keymap_add() and the right way
> to destroy it is to call nf_ct_gre_keymap_destroy().

I think you use call nf_ct_iterate_cleanup() to get rid of all GRE
conntrack entries that have a ct->master, which means that they were
created by PPTP. That implicitly calls gre_destroy, which releases the
keymap object.

> This patch marks nf_ct_gre_keymap_flush() as static, so this patch can
> break compilation of third party modules, which use
> nf_ct_gre_keymap_flush. I'm not sure this is the right way to deprecate
> this function.

No problem with that, we don't mind about out of tree modules. With
the approach I'm proposing I think you will also need to make this
function static as it won't be used by PPTP anymore.
