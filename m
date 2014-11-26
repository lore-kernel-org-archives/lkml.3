Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaKZKd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:33:26 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45702 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaKZKdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:33:23 -0500
Message-ID: <5475AC6F.9010902@einserver.de>
Date: Wed, 26 Nov 2014 11:33:19 +0100
From: Andreas Ruprecht <rupran@einserver.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Florian Westphal <fw@strlen.de>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: netfilter: Fix undefined reference to nf_nat_redirect_*
 functions
References: <1416928034-10882-1-git-send-email-rupran@einserver.de> <1416994537-1592-1-git-send-email-rupran@einserver.de> <20141126102402.GA24801@breakpoint.cc>
In-Reply-To: <20141126102402.GA24801@breakpoint.cc>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure.

When the file is compiled, i.e. CONFIG_NETFILTER_XT_TARGET_REDIRECT is
selected, all headers will be included and all functions inside the file
will be compiled, regardless of other Kconfig options.

This means redirect_tg6 and redirect_tg4 will be compiled (which doesn't
necessarily mean they will be _called_) but the linker needs to resolve
nf_nat_redirect_ipv4() due to the compilation of the redirect_tg4()
function.

nf_nat_redirect_ip4() is defined in
net/ipv4/netfilter/nf_nat_redirect_ipv4.c but this file is only included
into the build when CONFIG_NF_NAT_REDIRECT_IPV4 is enabled.

Now when a kernel config enables CONFIG_NETFILTER_XT_TARGET_REDIRECT but
_not_ CONFIG_NF_NAT_REDIRECT_IPV4, the declaration of
nf_nat_redirect_ipv4() from the header
<net/netfilter/ipv4/nf_nat_redirect.h> will have no definition (i.e., no
implementation), causing the linker to report an "undefined reference".

Same logic goes for nf_nat_redirect_ipv6().

Hope this helps,

Andreas

On 26.11.2014 11:24, Florian Westphal wrote:
> Andreas Ruprecht <rupran@einserver.de> wrote:
>> Additionally it is necessary to provide stubs for the
>> nf_nat_redirect_ipv{4,6} functions in case the header is included but
>> the corresponding Kconfig feature is not enabled.
> 
> Hmmm, not following.
> 
> Can you elaborate?
> 
> Under which circumstances do we have a call to nf_nat_redirect_ipv4()
> (i.e., linker error) but can safely do a noop operation instead of the
> requested nat redirect...?
> 
