Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaDWPs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:48:59 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:54682 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaDWPs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:48:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140423114039.GY4963@mwanda>
References: <57bf4e51f05fad506a0d1638852a5233b359e1dc.1398194946.git.luto@amacapital.net>
 <20140423114039.GY4963@mwanda>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 23 Apr 2014 08:48:34 -0700
Message-ID: <CALCETrXhY-XdAk_cUbQfVN2=2jx-6J3wX7DYMeAiML=VOhM+SA@mail.gmail.com>
Subject: Re: [PATCH] crypto_user: Fix out-of-bounds read
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-crypto@vger.kernel.org, "security@kernel.org" <security@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 23, 2014 4:40 AM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:
>
> On Tue, Apr 22, 2014 at 12:30:28PM -0700, Andy Lutomirski wrote:
> > This is unlikely to be exploitable for anything except an OOPS.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > ---
> >
> > Notes:
> >     This is entirely untested, but it looks obviously correct to me.
> >
> >  crypto/crypto_user.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> > index 1512e41..bc7c4b5 100644
> > --- a/crypto/crypto_user.c
> > +++ b/crypto/crypto_user.c
> > @@ -460,7 +460,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >       int type, err;
> >
> >       type = nlh->nlmsg_type;
> > -     if (type > CRYPTO_MSG_MAX)
> > +     if (type < CRYPTO_MSG_BASE || type > CRYPTO_MSG_MAX)
> >               return -EINVAL;
>
> Adding a check here is obviously harmless but I think this is only
> called from netlink_rcv_skb() which already checks:
>
>         if (nlh->nlmsg_type < NLMSG_MIN_TYPE)
>                 goto ack;
>
> NLMSG_MIN_TYPE is 0x10 as well, so I don't think we can hit your
> condition.
>
> Your patch freaked me out a little because this is one of the bugs that
> I should have caught throught static analysis.

BUILD_BUG_ON(NLMSG_MIN_TYPE != CRYPTO_MSG_BASE) might be a better
thing to add, then.

I don't feel so bad for missing this.

>
> regards,
> dan carpenter
>
