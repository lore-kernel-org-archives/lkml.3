Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbaCSJyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:54:05 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53524 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758831AbaCSJyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:54:01 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'behanw@converseincode.com'" <behanw@converseincode.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "pablo@netfilter.org" <pablo@netfilter.org>,
        "kaber@trash.net" <kaber@trash.net>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "pageexec@freemail.hu" <pageexec@freemail.hu>,
        Mark Charlebois <charlebm@gmail.com>,
        =?utf-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>
Subject: RE: [PATCH v3] net: netfilter: LLVMLinux: vlais-netfilter
Thread-Topic: [PATCH v3] net: netfilter: LLVMLinux: vlais-netfilter
Thread-Index: AQHPQxWD4T4457lW/kW319DpbR1c2ZroKPTw
Date: Wed, 19 Mar 2014 09:52:40 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6E0F8D@AcuExch.aculab.com>
References: <063D6719AE5E284EB5DD2968C1650D6D0F6E0286@AcuExch.aculab.com>
 <1395193841-2886-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1395193841-2886-1-git-send-email-behanw@converseincode.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2J9sFOf011923

From: behanw@converseincode.com 
> From: Mark Charlebois <charlebm@gmail.com>
> 
> Replaced non-standard C use of Variable Length Arrays In Structs (VLAIS) in
> xt_repldata.h with a C99 compliant flexible array member and then calculated
> offsets to the other struct members. These other members aren't referenced by
> name in this code, however this patch maintains the same memory layout and
> padding as was previously accomplished using VLAIS.
> 
> Had the original structure been ordered differently, with the entries VLA at
> the end, then it could have been a flexible member, and this patch would have
> been a lot simpler. However since the data stored in this structure is
> ultimately exported to userspace, the order of this structure can't be changed.
> 
> This patch makes no attempt to change the existing behavior, merely the way in
> which the current layout is accomplished using standard C99 constructs. As such
> the code can now be compiled with either gcc or clang.
> 
> Author: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: VinÃ­cius Tinti <viniciustinti@gmail.com>
> ---
>  net/netfilter/xt_repldata.h | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
> index 6efe4e5..343599e 100644
> --- a/net/netfilter/xt_repldata.h
> +++ b/net/netfilter/xt_repldata.h
> @@ -5,23 +5,40 @@
>   * they serve as the hanging-off data accessed through repl.data[].
>   */
> 
> +/* tbl has the following structure equivalent, but is C99 compliant:
> + * struct {
> + *	struct type##_replace repl;
> + *	struct type##_standard entries[nhooks];
> + *	struct type##_error term;
> + * } *tbl;
> + */
> +
>  #define xt_alloc_initial_table(type, typ2) ({ \
>  	unsigned int hook_mask = info->valid_hooks; \
>  	unsigned int nhooks = hweight32(hook_mask); \
>  	unsigned int bytes = 0, hooknum = 0, i = 0; \
>  	struct { \
>  		struct type##_replace repl; \
> -		struct type##_standard entries[nhooks]; \
> -		struct type##_error term; \
> -	} *tbl = kzalloc(sizeof(*tbl), GFP_KERNEL); \
> +		struct type##_standard entries[]; \
> +	} *tbl; \
> +	struct type##_error *term; \
> +	size_t entries_end = offsetof(typeof(*tbl), \
> +		entries[nhooks-1]) + sizeof(tbl->entries[0]); \

Is the compiler complaining about:
	offsetof(typeof(*tbl), entries[nhooks])
If it does it is a PITA.

> +	size_t term_offset = (entries_end + __alignof__(*term) - 1) \
> +		& ~(__alignof__(*term) - 1); \

You've not tested this - the () are in the wrong places.

> +	size_t term_end = term_offset + sizeof(*term); \
> +	size_t tbl_sz = (term_end + __alignof__(tbl->repl) - 1) \
> +		& ~(__alignof__(tbl->repl) - 1); \
> +	tbl = kzalloc(tbl_sz, GFP_KERNEL); \

The number of temporary variables make the above hard to read.
I'm not at all sure you need to worry about the trailing alignment.
It rather depends on how the final data is used.
If the combined buffer is copied to userspace you may not
be copying all of the required data.
It might be easier to call copytouser() twice.

>  	if (tbl == NULL) \
>  		return NULL; \
> +	term = (struct type##_error *)&(((char *)tbl)[term_offset]); \
>  	strncpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
> -	tbl->term = (struct type##_error)typ2##_ERROR_INIT;  \
> +	*term = (struct type##_error)typ2##_ERROR_INIT;  \

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
