Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaJAEgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 00:36:52 -0400
Received: from mailsec102.isp.belgacom.be ([195.238.20.98]:17370 "EHLO
	mailsec102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbaJAEgv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 00:36:51 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=xmGiAQlKtCF5+ra7FDB8hpYjXxwBLBdzsqYiSFHyMzI= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=e1BOfgUz7UrkkWfsn4UA:9
 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj4SAP+DK1TD7hTS/2dsb2JhbAAZAUaDDoQssk0BBQabTAKBDxYBe4QDAQEBAwEjVgULBQQCDgoCAhgOAgIhNgYTEYgZAwkMi20WnEyGf4dWDYceGIEshGaHXIF9MweCeIFTBZsfjlmCW4ZMgiCBRTsvgQYHgT0BAQE
Date: Wed, 1 Oct 2014 06:36:49 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Alexander Aring <alex.aring@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Message-ID: <1016857334.83918.1412138209231.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20141001002459.GA1007@omega>
References: <1412109249-7432-1-git-send-email-fabf@skynet.be> <20141001002459.GA1007@omega>
Subject: Re: [PATCH 1/1 linux-next] ieee802154: add __init to
 lowpan_frags_sysctl_register
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 01 October 2014 at 02:25 Alexander Aring <alex.aring@gmail.com> wrote:
>
>
> Hi,
>
> On Tue, Sep 30, 2014 at 10:34:08PM +0200, Fabian Frederick wrote:
> > lowpan_frags_sysctl_register is only called by __init lowpan_net_frag_init
> > (part of the lowpan module).
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> > This is untested.
> >
> >  net/ieee802154/reassembly.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ieee802154/reassembly.c b/net/ieee802154/reassembly.c
> > index 32755cb..30ec608 100644
> > --- a/net/ieee802154/reassembly.c
> > +++ b/net/ieee802154/reassembly.c
> > @@ -485,7 +485,7 @@ static void __net_exit
> > lowpan_frags_ns_sysctl_unregister(struct net *net)
> > 
> >  static struct ctl_table_header *lowpan_ctl_header;
> > 
> > -static int lowpan_frags_sysctl_register(void)
> > +static int __init lowpan_frags_sysctl_register(void)
>
> yes right, but there is more lacks of missing "__init". See below.
>
> >  {
> >     lowpan_ctl_header = register_net_sysctl(&init_net,
> >                                             "net/ieee802154/6lowpan",
> > @@ -498,7 +498,7 @@ static void lowpan_frags_sysctl_unregister(void)
> >     unregister_net_sysctl_table(lowpan_ctl_header);
> >  }
> >  #else
> > -static inline int lowpan_frags_ns_sysctl_register(struct net *net)
> > +static inline int __init lowpan_frags_ns_sysctl_register(struct net *net)
>
> This is wrong, it's callback from "struct pernet_operations lowpan_frags_ops".
>
> >  {
> >     return 0;
> >  }
>
>
> Your patch adds "__init" now for two different functions and we have
> two different declarations for these functions, depends if CONFIG_SYSCTL is
> enabled.
>
> Now if CONFIG_SYSCTL select we have as lowpan_frags_sysctl_register
> declaration:
>
> static int __init lowpan_frags_sysctl_register(void)
>
> if not:
>
> static inline int lowpan_frags_sysctl_register(void)
>
> Same for lowpan_frags_ns_sysctl_register and vice versa for CONFIG_SYSCTL.
>
> Your changes are for two different functions (Don't know if you realized
> that):

Hi Alexander,

    I didn't see _ns_ . I'll send the right fix based on wpan-next.

Thanks,
Fabian


>
> "lowpan_frags_sysctl_register" and "lowpan_frags_ns_sysctl_register",
> which makes no sense. Also lowpan_frags_ns_sysctl_register isn't called
> by module init which is wrong.
>
>
> To make "correct" cleanup for this "__init" should be add to the functions,
> for
> both declarations if CONFIG_SYSCTL is set or not:
>
>  - lowpan_net_frag_init
>  - lowpan_frags_sysctl_register
>
>
> I see now it's already applied, David please revert this change. Are you
> fine to apply a correct version of this to wpan-next tree, next time?
>
> - Alex
