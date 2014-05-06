Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbaEFQWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:22:35 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:43437 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEFQWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <1398227709-4926-1-git-send-email-tuxoko@gmail.com>
References: <1398227709-4926-1-git-send-email-tuxoko@gmail.com>
Date: Tue, 6 May 2014 20:22:32 +0400
Message-ID: <CALFYKtBovU83Y5WDsYq1Kzi6=QtHPKuefxJ5Ej5bdFdVADCNzQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix corruption when using page_count 0 page in rbd
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Chunwei Chen <tuxoko@gmail.com>
Cc: Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sage Weil <sage@inktank.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 8:35 AM, Chunwei Chen <tuxoko@gmail.com> wrote:
> It has been reported that using ZFSonLinux on rbd will result in memory
> corruption. The bug report can be found here:
>
> https://github.com/zfsonlinux/spl/issues/241
> http://tracker.ceph.com/issues/7790
>
> The reason is that ZFS will send pages with page_count 0 into rbd, which in
> turns send them to tcp_sendpage. However, tcp_sendpage cannot deal with
> page_count 0, as it will do get_page and put_page, and erroneously free the
> page.
>
> This type of issue has been noted before, and handled in iscsi, drbd,
> etc. So, rbd should also handle this. This fix address this issue by fall back
> to slower sendmsg when page_count 0 detected.
>
> Cc: Sage Weil <sage@inktank.com>
> Cc: Yehuda Sadeh <yehuda@inktank.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Chunwei Chen <tuxoko@gmail.com>
> ---
>  net/ceph/messenger.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 4f55f9c..9a964e7 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -557,7 +557,7 @@ static int ceph_tcp_sendmsg(struct socket *sock, struct kvec *iov,
>         return r;
>  }
>
> -static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
> +static int __ceph_tcp_sendpage(struct socket *sock, struct page *page,
>                      int offset, size_t size, bool more)
>  {
>         int flags = MSG_DONTWAIT | MSG_NOSIGNAL | (more ? MSG_MORE : MSG_EOR);
> @@ -570,6 +570,24 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
>         return ret;
>  }
>
> +static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
> +                    int offset, size_t size, bool more)
> +{
> +       int ret;
> +       struct kvec iov;
> +
> +       /* sendpage cannot properly handle pages with page_count == 0,
> +        * we need to fallback to sendmsg if that's the case */
> +       if (page_count(page) >= 1)
> +               return __ceph_tcp_sendpage(sock, page, offset, size, more);
> +
> +       iov.iov_base = kmap(page) + offset;
> +       iov.iov_len = size;
> +       ret = ceph_tcp_sendmsg(sock, &iov, 1, size, more);
> +       kunmap(page);
> +
> +       return ret;
> +}

Looks good to me.  Have you tested it with pre "Fix crash when using
ZFS on Ceph rbd" ZFS?

Thanks,

                Ilya
