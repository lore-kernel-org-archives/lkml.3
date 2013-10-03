Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab3JCXLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:11:50 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:35969 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3JCXLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:11:48 -0400
MIME-Version: 1.0
In-Reply-To: <1380841666.19002.262.camel@edumazet-glaptop.roam.corp.google.com>
References: <1380840466-3822-1-git-send-email-ast@plumgrid.com>
	<1380841666.19002.262.camel@edumazet-glaptop.roam.corp.google.com>
Date: Thu, 3 Oct 2013 16:11:47 -0700
Message-ID: <CAMEtUuz4Qyg1s7CocNotTYXcn1odcbT5nek1T66dd+dK3ukfTw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] fix unsafe set_memory_rw from softirq
From: Alexei Starovoitov <ast@plumgrid.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 4:07 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2013-10-03 at 15:47 -0700, Alexei Starovoitov wrote:
>
>> @@ -722,7 +725,8 @@ EXPORT_SYMBOL_GPL(sk_unattached_filter_destroy);
>>  int sk_attach_filter(struct sock_fprog *fprog, struct sock *sk)
>>  {
>>       struct sk_filter *fp, *old_fp;
>> -     unsigned int fsize = sizeof(struct sock_filter) * fprog->len;
>> +     unsigned int fsize = max(sizeof(struct sock_filter) * fprog->len,
>> +                              sizeof(struct work_struct));
>>       int err;
>>
>>       if (sock_flag(sk, SOCK_FILTER_LOCKED))
>
> Thats broken, as we might copy more data from user than expected,
> and eventually trigger EFAULT :
>
> if (copy_from_user(fp->insns, fprog->filter, fsize)) {

yes. will fix.
