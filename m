Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaLPPfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:35:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaLPPfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:35:38 -0500
Date: Tue, 16 Dec 2014 16:35:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Mitchell Krome <mitchellkrome@gmail.com>
Cc: acme@kernel.org, mingo@redhat.com, paulus@samba.org,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tool: Fix use after free in filename__read_build_id
Message-ID: <20141216153523.GA19086@krava.brq.redhat.com>
References: <20141216021612.GA7199@mitchell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216021612.GA7199@mitchell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:16:12PM +1000, Mitchell Krome wrote:
> In filename__read_build_id, phdr points to memory in buf, which gets realloced
> before a call to fseek that uses phdr->p_offset. This change stores the value
> of p_offset before buf is realloced, so the fseek can use the value safely.
> 
> Signed-off-by: Mitchell Krome <mitchellkrome@gmail.com>
> ---
>  tools/perf/util/symbol-minimal.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
> index fa585c6..d7efb03 100644
> --- a/tools/perf/util/symbol-minimal.c
> +++ b/tools/perf/util/symbol-minimal.c
> @@ -129,6 +129,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
>  
>  		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
>  			void *tmp;
> +			long offset;
>  
>  			if (need_swap) {
>  				phdr->p_type = bswap_32(phdr->p_type);
> @@ -140,12 +141,13 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
>  				continue;
>  
>  			buf_size = phdr->p_filesz;
> +			offset = phdr->p_offset;
>  			tmp = realloc(buf, buf_size);
>  			if (tmp == NULL)
>  				goto out_free;
>  
>  			buf = tmp;
> -			fseek(fp, phdr->p_offset, SEEK_SET);
> +			fseek(fp, offset, SEEK_SET);

so the concern is that the realloc buf_size will be smaller
than the 'buf' offset of phdr->p_offset value, right? Anyway:

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka
