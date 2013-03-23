Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423081Ab3CWDZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 23:25:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56792 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422808Ab3CWDY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 23:24:59 -0400
From: "Anna, Suman" <s-anna@ti.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "loic.pallardy@st.com" <loic.pallardy@st.com>,
        "omar.ramirez@copitl.com" <omar.ramirez@copitl.com>,
        "lugo.fernando@gmail.com" <lugo.fernando@gmail.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] mailbox: fix invalid use of sizeof in
 mailbox_msg_send()
Thread-Topic: [PATCH -next] mailbox: fix invalid use of sizeof in
 mailbox_msg_send()
Thread-Index: AQHOJwBE4+CeCCaimE6mVYfHW7MD8ZiynNEg
Date: Sat, 23 Mar 2013 03:24:50 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C5049E935@DLEE11.ent.ti.com>
References: <CAPgLHd-4=Nie0-jdy9-0V9v5GfgKP5L3XycQdw1qWL3dhzYjMw@mail.gmail.com>
In-Reply-To: <CAPgLHd-4=Nie0-jdy9-0V9v5GfgKP5L3XycQdw1qWL3dhzYjMw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> sizeof() when applied to a pointer typed expression gives the size of the pointer,
> not that of the pointed data.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mailbox/mailbox.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c index
> 5fea5c2..e011a75 100644
> --- a/drivers/mailbox/mailbox.c
> +++ b/drivers/mailbox/mailbox.c
> @@ -93,8 +93,8 @@ int mailbox_msg_send(struct mailbox *mbox, struct
> mailbox_msg *msg)
>  		goto out;
>  	}
> 
> -	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(msg));
> -	WARN_ON(len != sizeof(msg));
> +	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(*msg));
> +	WARN_ON(len != sizeof(*msg));

Thanks Wei, missed this one. In this same function, there is one more similar occurrence, which needs fixing as well.
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -83,7 +83,7 @@ int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg

        mutex_lock(&mq->mlock);

-       if (kfifo_avail(&mq->fifo) < (sizeof(msg) + msg->size)) {
+       if (kfifo_avail(&mq->fifo) < (sizeof(*msg) + msg->size)) {
                ret = -ENOMEM;
                goto out;
        }

Regards
Suman
