Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3CWTbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 15:31:13 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:35680 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3CWTbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 15:31:12 -0400
MIME-Version: 1.0
In-Reply-To: <1363685150-18303-2-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<1363685150-18303-2-git-send-email-liwanp@linux.vnet.ibm.com>
Date: Sat, 23 Mar 2013 20:31:11 +0100
X-Google-Sender-Auth: 31Zho1S_09P_q-hQYA-9R7rUw64
Message-ID: <CAMuHMdUTsHs0-5=kYLMHYGTxBiCAGB33KZH0wvz51vgtExjK8Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] staging: zcache: introduce zero-filled pages handler
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:25 AM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
> Introduce zero-filled pages handler to capture and handle zero pages.
>
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/zcache-main.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 328898e..d73dd4b 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c

> +static void handle_zero_filled_page(void *page)
> +{
> +       void *user_mem;
> +
> +       user_mem = kmap_atomic(page);

kmap_atomic() takes a "struct page *", not a "void *".

> +       memset(user_mem, 0, PAGE_SIZE);
> +       kunmap_atomic(user_mem);
> +
> +       flush_dcache_page(page);

While flush_dcache_page() is a no-op on many architectures, it also
takes a "struct page *", not a "void *":

m68k/allmodconfig:

drivers/staging/zcache/zcache-main.c:309:2: error: request for member
'virtual' in something not a structure or union

Cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/8433711/

> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
