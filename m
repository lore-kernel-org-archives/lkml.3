Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbaF3Rjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:39:52 -0400
Received: from mail.us.es ([193.147.175.20]:40669 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbaF3Rjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:39:51 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19144. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-101.0/7.5):. 
 Processed in 2.247851 secs); 30 Jun 2014 17:39:48 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 30 Jun 2014 19:39:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Kees Cook <keescook@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: net/netfilter/xt_LOG.c:43: error: format not a string literal
 and no format arguments
Message-ID: <20140630173944.GA1377@localhost>
References: <53aeb8bc.DsBnC5jOuuC6IST2%fengguang.wu@intel.com>
 <20140628140726.GD5691@localhost>
 <CAGXu5j++FFJ2=2Q07kcY9_Fk2dnvA+BR8kKRCe27cgusbbpjrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j++FFJ2=2Q07kcY9_Fk2dnvA+BR8kKRCe27cgusbbpjrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 10:05:01AM -0700, Kees Cook wrote:
> On Sat, Jun 28, 2014 at 7:07 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > tree:   git://internal_merge_and_test_tree devel-ant-um-201406281943
> > head:   fbb9065499371b760e0543f2ff66fde4778b46ae
> > commit: 2af37708d3ce0ae78898051ea76bc7c5f683171c [30/31] Merge 'nftables/master' into devel-ant-um-201406281943
> > config: make ARCH=avr32 atngw100_defconfig
> >
> > All error/warnings:
> >
> >    net/netfilter/xt_LOG.c: In function 'log_tg':
> >>> net/netfilter/xt_LOG.c:43: error: format not a string literal and no format arguments
> >
> > vim +43 net/netfilter/xt_LOG.c
> >
> > 6939c33a Richard Weinberger 2012-02-10  27  #include <linux/netfilter/xt_LOG.h>
> > 6939c33a Richard Weinberger 2012-02-10  28  #include <linux/netfilter_ipv6/ip6_tables.h>
> > 6939c33a Richard Weinberger 2012-02-10  29  #include <net/netfilter/nf_log.h>
> > 6939c33a Richard Weinberger 2012-02-10  30
> > 6939c33a Richard Weinberger 2012-02-10  31  static unsigned int
> > 6939c33a Richard Weinberger 2012-02-10  32  log_tg(struct sk_buff *skb, const struct xt_action_param *par)
> > 6939c33a Richard Weinberger 2012-02-10  33  {
> > 6939c33a Richard Weinberger 2012-02-10  34      const struct xt_log_info *loginfo = par->targinfo;
> > 6939c33a Richard Weinberger 2012-02-10  35      struct nf_loginfo li;
> > 8cdb46da Hans Schillstrom   2013-05-15  36      struct net *net = dev_net(par->in ? par->in : par->out);
> > 6939c33a Richard Weinberger 2012-02-10  37
> > 6939c33a Richard Weinberger 2012-02-10  38      li.type = NF_LOG_TYPE_LOG;
> > 6939c33a Richard Weinberger 2012-02-10  39      li.u.log.level = loginfo->level;
> > 6939c33a Richard Weinberger 2012-02-10  40      li.u.log.logflags = loginfo->logflags;
> > 6939c33a Richard Weinberger 2012-02-10  41
> > fab4085f Pablo Neira Ayuso  2014-06-18  42      nf_log_packet(net, par->family, par->hooknum, skb, par->in, par->out,
> > fab4085f Pablo Neira Ayuso  2014-06-18 @43                    &li, loginfo->prefix);
> 
> This needs to be:
> 
> nf_log_packet(net, par->family, par->hooknum, skb, par->in, par->out,
>                      &li, "%s", loginfo->prefix);
> 
> Without this, any format strings contained by "prefix" can get
> processed and leak kernel contents.


http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/commit/?id=ca1aa54f272d47bec77baa292f803df7a81f966b
