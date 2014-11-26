Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaKZL0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:26:40 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40845 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbaKZL0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:26:39 -0500
Date: Wed, 26 Nov 2014 12:26:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Andreas Ruprecht <rupran@einserver.de>
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: netfilter: Fix undefined reference to
 nf_nat_redirect_* functions
Message-ID: <20141126112627.GB24801@breakpoint.cc>
References: <1416928034-10882-1-git-send-email-rupran@einserver.de>
 <1416994537-1592-1-git-send-email-rupran@einserver.de>
 <20141126102402.GA24801@breakpoint.cc>
 <5475AC6F.9010902@einserver.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5475AC6F.9010902@einserver.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Ruprecht <rupran@einserver.de> wrote:
> When the file is compiled, i.e. CONFIG_NETFILTER_XT_TARGET_REDIRECT is
> selected, all headers will be included and all functions inside the file
> will be compiled, regardless of other Kconfig options.
> 
> This means redirect_tg6 and redirect_tg4 will be compiled (which doesn't
> necessarily mean they will be _called_) but the linker needs to resolve
> nf_nat_redirect_ipv4() due to the compilation of the redirect_tg4()
> function.

So the problem is eg.
CONFIG_NETFILTER_XT_TARGET_REDIRECT=y
CONFIG_NF_NAT_IPV4=n

which yields
undefined reference to `nf_nat_redirect_ipv4'

adding stub fixes this; we will still register a netfilter target for
ipv4 redirect, but it cannot be called ever since that target is
resticted to 'nat' table, which doesn't exist for ipv4 in the above
config.

To me it seem cleaner to put

IS_ENABLED(NF_NAT_REDIRECT_IPV4)

into xt_REDIRECT.c instead of building not-working-but-never-called
ipv4 redirect.

Pablo, if you disagree I am fine with the patch, although
the stubs should get a 'static inline' prefix to not cause sym clash
in case we ever gain another call site.

