Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3JCXHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:07:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46658 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3JCXHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:07:48 -0400
Message-ID: <1380841666.19002.262.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH v2 net-next] fix unsafe set_memory_rw from softirq
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Xi Wang <xi.wang@gmail.com>, x86@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Oct 2013 16:07:46 -0700
In-Reply-To: <1380840466-3822-1-git-send-email-ast@plumgrid.com>
References: <1380840466-3822-1-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 15:47 -0700, Alexei Starovoitov wrote:

> @@ -722,7 +725,8 @@ EXPORT_SYMBOL_GPL(sk_unattached_filter_destroy);
>  int sk_attach_filter(struct sock_fprog *fprog, struct sock *sk)
>  {
>  	struct sk_filter *fp, *old_fp;
> -	unsigned int fsize = sizeof(struct sock_filter) * fprog->len;
> +	unsigned int fsize = max(sizeof(struct sock_filter) * fprog->len,
> +				 sizeof(struct work_struct));
>  	int err;
>  
>  	if (sock_flag(sk, SOCK_FILTER_LOCKED))

Thats broken, as we might copy more data from user than expected,
and eventually trigger EFAULT :

if (copy_from_user(fp->insns, fprog->filter, fsize)) {


