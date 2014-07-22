Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaGVTUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:20:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40315 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaGVTUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:20:19 -0400
Message-ID: <53CEB973.2080406@infradead.org>
Date: Tue, 22 Jul 2014 12:20:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ian Kumlien <ian.kumlien@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] 3.16-rc6 -- fs/direct-io.c:1011 from and to uninitialized.
References: <1406055834.23587.1.camel@gmail.com>
In-Reply-To: <1406055834.23587.1.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 12:03 PM, Ian Kumlien wrote:
> This is a resend, try two... 
> 
> ---
> Hi,
> 
> While playing around compiling the kernel i noticed the following:
> fs/direct-io.c: In function ‘do_blockdev_direct_IO’:
> fs/direct-io.c:1022:29: warning: ‘from’ may be used uninitialized in
> this function [-Wmaybe-uninitialized]
>     ret = submit_page_section(dio, sdio, page,
>                              ^
> fs/direct-io.c:913:10: note: ‘from’ was declared here
>    size_t from, to;
>           ^
> fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this
> function [-Wmaybe-uninitialized]
>     u = (to - from) >> blkbits;
>             ^
> fs/direct-io.c:913:16: note: ‘to’ was declared here
>    size_t from, to;
>                 ^
> ---
> 
> 
> And while the fix is simple, something along the lines of:
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 98040ba..64a8286 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -910,7 +910,7 @@ static int do_direct_IO(struct dio *dio, struct
> dio_submit *sdi
>  
>         while (sdio->block_in_file < sdio->final_block_in_request) {
>                 struct page *page;
> -               size_t from, to;
> +               size_t from, to = {0};
>                 page = dio_get_page(dio, sdio, &from, &to);
>                 if (IS_ERR(page)) {
>                         ret = PTR_ERR(page);
> ---
> 
> I however don't know if it's in the correct C standard, it compiles fine
> though... (or if this is more gcc speific)

so... do you know C or not?

Why the braces around the 0?

Why do you initialize 'to' but not 'from'?


-- 
~Randy
