Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaF3RFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:05:04 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34005 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaF3RFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:05:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140628140726.GD5691@localhost>
References: <53aeb8bc.DsBnC5jOuuC6IST2%fengguang.wu@intel.com>
	<20140628140726.GD5691@localhost>
Date: Mon, 30 Jun 2014 10:05:01 -0700
Message-ID: <CAGXu5j++FFJ2=2Q07kcY9_Fk2dnvA+BR8kKRCe27cgusbbpjrw@mail.gmail.com>
Subject: Re: net/netfilter/xt_LOG.c:43: error: format not a string literal and
 no format arguments
From: Kees Cook <keescook@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 7:07 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> tree:   git://internal_merge_and_test_tree devel-ant-um-201406281943
> head:   fbb9065499371b760e0543f2ff66fde4778b46ae
> commit: 2af37708d3ce0ae78898051ea76bc7c5f683171c [30/31] Merge 'nftables/master' into devel-ant-um-201406281943
> config: make ARCH=avr32 atngw100_defconfig
>
> All error/warnings:
>
>    net/netfilter/xt_LOG.c: In function 'log_tg':
>>> net/netfilter/xt_LOG.c:43: error: format not a string literal and no format arguments
>
> vim +43 net/netfilter/xt_LOG.c
>
> 6939c33a Richard Weinberger 2012-02-10  27  #include <linux/netfilter/xt_LOG.h>
> 6939c33a Richard Weinberger 2012-02-10  28  #include <linux/netfilter_ipv6/ip6_tables.h>
> 6939c33a Richard Weinberger 2012-02-10  29  #include <net/netfilter/nf_log.h>
> 6939c33a Richard Weinberger 2012-02-10  30
> 6939c33a Richard Weinberger 2012-02-10  31  static unsigned int
> 6939c33a Richard Weinberger 2012-02-10  32  log_tg(struct sk_buff *skb, const struct xt_action_param *par)
> 6939c33a Richard Weinberger 2012-02-10  33  {
> 6939c33a Richard Weinberger 2012-02-10  34      const struct xt_log_info *loginfo = par->targinfo;
> 6939c33a Richard Weinberger 2012-02-10  35      struct nf_loginfo li;
> 8cdb46da Hans Schillstrom   2013-05-15  36      struct net *net = dev_net(par->in ? par->in : par->out);
> 6939c33a Richard Weinberger 2012-02-10  37
> 6939c33a Richard Weinberger 2012-02-10  38      li.type = NF_LOG_TYPE_LOG;
> 6939c33a Richard Weinberger 2012-02-10  39      li.u.log.level = loginfo->level;
> 6939c33a Richard Weinberger 2012-02-10  40      li.u.log.logflags = loginfo->logflags;
> 6939c33a Richard Weinberger 2012-02-10  41
> fab4085f Pablo Neira Ayuso  2014-06-18  42      nf_log_packet(net, par->family, par->hooknum, skb, par->in, par->out,
> fab4085f Pablo Neira Ayuso  2014-06-18 @43                    &li, loginfo->prefix);

This needs to be:

nf_log_packet(net, par->family, par->hooknum, skb, par->in, par->out,
                     &li, "%s", loginfo->prefix);

Without this, any format strings contained by "prefix" can get
processed and leak kernel contents.

-Kees

> 6939c33a Richard Weinberger 2012-02-10  44      return XT_CONTINUE;
> 6939c33a Richard Weinberger 2012-02-10  45  }
> 6939c33a Richard Weinberger 2012-02-10  46
> 6939c33a Richard Weinberger 2012-02-10  47  static int log_tg_check(const struct xt_tgchk_param *par)
> 6939c33a Richard Weinberger 2012-02-10  48  {
> 6939c33a Richard Weinberger 2012-02-10  49      const struct xt_log_info *loginfo = par->targinfo;
> 6939c33a Richard Weinberger 2012-02-10  50
> 6939c33a Richard Weinberger 2012-02-10  51      if (par->family != NFPROTO_IPV4 && par->family != NFPROTO_IPV6)
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation



-- 
Kees Cook
Chrome OS Security
