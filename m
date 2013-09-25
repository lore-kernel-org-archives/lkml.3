Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3IYOfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:35:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45111 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab3IYOfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:35:18 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-0e-5242f4a35d19
Message-id: <5242F4A2.60308@samsung.com>
Date: Wed, 25 Sep 2013 16:35:14 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330
 Thunderbird/17.0.5
MIME-version: 1.0
To: charlebm@gmail.com
Cc: balbi@ti.com, Behan Webster <behanw@converseincode.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove VLAIS usage from gadget code - alternate patch
References: <1380045419-10367-1-git-send-email-charlebm@gmail.com>
In-reply-to: <1380045419-10367-1-git-send-email-charlebm@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7qLvzgFGWx6pWNx8H69xakzORYH
	vjxmsmhevJ7N4vKuOWwWi5a1Mls86nvL7sDusbNtPqvHzll32T1OzPjN4rF/7hp2j+M3tjN5
	fN4kF8AWxWWTkpqTWZZapG+XwJXx9EoXe8FVoYrenyvYGxiX8HcxcnJICJhInO5ZzQRhi0lc
	uLeerYuRi0NIYCmjxNW3r5khnM+MEg1X97N3MXJw8ApoSHT8ZAZpYBFQlfiwuZ0NxGYTMJbY
	e7CDEcQWFQiTmPr2DlicV0BQ4sfkeywgtgjQgjM/j7KCzGQWaGGSWH9iDitIQljAS+LJ/qts
	IPOFBJwkHj4qAAlzCjhLLNpwAayEWcBM4lHLOmYIW15i85q3zBMYBWYhWTELSdksJGULGJlX
	MYqmliYXFCel5xrpFSfmFpfmpesl5+duYoSE+tcdjEuPWR1iFOBgVOLhfdHkFCTEmlhWXJl7
	iFGCg1lJhLfuBVCINyWxsiq1KD++qDQntfgQIxMHp1QDo0PXtclc095HfY6Qz70mv2br3S1h
	y/P/PJH1czXnYQxan6B4UkhQLsIggMPtZsKrz6wdronXO5jdQ15NFhM4Zzvb2dBrxVqPGf8a
	+9w758mteVQl4rUk7s2i9x+nvGDTq26sWf0g7/qr84WeevuP3S5dEO7cyte2eM0KbuYrpZK7
	uCYev++WqcRSnJFoqMVcVJwIAGYza6dTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Nice to hear from you again; on Saturday LOT's dreamliner was not
grounded and I have safely returned home ;)

Please see my comments inline.

W dniu 24.09.2013 19:56, charlebm@gmail.com pisze:
> From: Mark Charlebois <charlebm@gmail.com>
>
>
> --- linux.orig/drivers/usb/gadget/f_fs.c
> +++ linux/drivers/usb/gadget/f_fs.c
> @@ -30,6 +30,21 @@
>
>   #define FUNCTIONFS_MAGIC	0xa647361 /* Chosen by a honest dice roll ;) */
>
> +/* Variable Length Array Macros **********************************************/
> +#define vla_struct(structname) size_t structname##__##next = 0
> +#define vla_struct_size(structname) structname##__##next
> +
> +#define vla_item(structname, type, name, n) \
> +	type * structname##_##name; \
> +	size_t structname##_##name##__##offset = \
> +		(structname##__##next + __alignof__(type) - 1) & \
> +		~(__alignof__(type) - 1); \
> +	size_t structname##_##name##__##sz = n * sizeof(type); \

most likely this shoud read:

+	size_t structname##_##name##__##sz = (n) * sizeof(type); \

otherwise vla_item(....., lang_count + 1); will expand to:

size_t d_stringtabs__sz = lang_count + \
	1 * sizeof(struct usb_gadget_strings *);

> +	structname##__##next = structname##_##name##__##offset + \
> +		structname##_##name##__##sz;
> +
> +#define vla_ptr(ptr,structname,name) structname##_##name = \
> +	(__typeof__(structname##_##name))&ptr[structname##_##name##__##offset]

<snip>

>   		unsigned i = 0;
> +		vla_struct(d);
> +		vla_item(d, struct usb_gadget_strings *, stringtabs,
> +			lang_count + 1);

Can you somehow avoid mixing code and declarations? The last thing in
the  expansion of this vla_item(.......) is an assignment, and

> +		vla_item(d, struct usb_gadget_strings, stringtab, lang_count);

the first thing in expansion of the next vla_item(.......) is a
declaration. GCC most likely will complain (issue a warning).

One solution I can think of here (a bit hackish) is to use a braced
group as an expression: define vla_item() in such a way that first
it declares e.g. d_stringtabs__offset, then d_stringtabs__sz, and
then

struct usb_gadget_strings **d_stringtabs =
	({d__next = d_stringtabs__offset + d_stringtabs__sz; NULL;});

I am not a fan of this kind of style, but can't think of any better way
now. And I don't know what Clang thinks of it :O

Thanks,

AP
