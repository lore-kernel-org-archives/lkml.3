Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbbAVUfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:35:22 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58735 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbbAVUfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <20150122161446.101EBC40A80@trevor.secretlab.ca>
References: <1421250356-16690-1-git-send-email-geert+renesas@glider.be>
	<20150122161446.101EBC40A80@trevor.secretlab.ca>
Date: Thu, 22 Jan 2015 21:35:15 +0100
X-Google-Sender-Auth: D8qoG6aEM6IIEpfll1EGb1RasEc
Message-ID: <CAMuHMdXcroty+HJ4wiE-s849hiHi5Ct_XnfinGC0U+Az1u90vg@mail.gmail.com>
Subject: Re: [PATCH] of: Add missing of_node_put() in of_find_node_by_path()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Gaurav Minocha <gaurav.minocha.os@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thu, Jan 22, 2015 at 5:14 PM, Grant Likely <grant.likely@linaro.org> wrote:
> On Wed, 14 Jan 2015 16:45:56 +0100
> , Geert Uytterhoeven <geert+renesas@glider.be>
>  wrote:
>> When traversing all nodes and moving to a new path component, the old
>> one must be released by calling of_node_put(). Else the refcounts of the
>> parent node(s) will not be decremented.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>> Background.
>>
>> While investigating a reference count imbalance issue with
>> CONFIG_OF_DYNAMIC=y, I wrote the debug code below to validate the
>> reference counts of the nodes I was interested in.
>> During the first call of check_refcnts(), it gathers all reference
>> counts. During a subsequent call, it verifies that they are still the
>> same.
>>
>> Surprisingly, lots of reference counts were wrong, and kept incrementing
>> every time check_refcnts() was called.

>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>> index 36536b6a8834acd2..f3e346e19c69d1f2 100644
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -791,8 +791,10 @@ struct device_node *of_find_node_opts_by_path(const char *path, const char **opt
>>       if (!np)
>>               np = of_node_get(of_root);
>>       while (np && *path == '/') {
>> +             struct device_node *parent = np;
>>               path++; /* Increment past '/' delimiter */
>> -             np = __of_find_node_by_path(np, path);
>> +             np = __of_find_node_by_path(parent, path);
>> +             of_node_put(parent);
>>               path = strchrnul(path, '/');
>>       }
>>       raw_spin_unlock_irqrestore(&devtree_lock, flags);
>
> This doesn't look /quite/ the best. __for_each_child_of_node() is
> fiddling with refcounts, but the '__' of functions shouldn't need to do
> that since they are called under the spinlock (nothing is going to
> change while they are called). __of_find_all_nodes() for instance
> doesn't do refcounting, but of_find_all_nodes() does.
>
> Does the following also solve the problem?

Yes, it does.

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 36536b6a8834..0357b51a7440 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -626,9 +626,8 @@ static struct device_node *__of_get_next_child(const struct device_node *node,
>
>         next = prev ? prev->sibling : node->child;
>         for (; next; next = next->sibling)
> -               if (of_node_get(next))
> +               if (next)
>                         break;
> -       of_node_put(prev);
>         return next;
>  }
>  #define __for_each_child_of_node(parent, child) \
> @@ -650,7 +649,8 @@ struct device_node *of_get_next_child(const struct device_node *node,
>         unsigned long flags;
>
>         raw_spin_lock_irqsave(&devtree_lock, flags);
> -       next = __of_get_next_child(node, prev);
> +       next = of_node_get(__of_get_next_child(node, prev));
> +       of_node_put(prev);
>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
>         return next;
>  }
> @@ -789,12 +789,13 @@ struct device_node *of_find_node_opts_by_path(const char *path, const char **opt
>         /* Step down the tree matching path components */
>         raw_spin_lock_irqsave(&devtree_lock, flags);
>         if (!np)
> -               np = of_node_get(of_root);
> +               np = of_root;
>         while (np && *path == '/') {
>                 path++; /* Increment past '/' delimiter */
>                 np = __of_find_node_by_path(np, path);
>                 path = strchrnul(path, '/');
>         }
> +       of_node_get(np);
>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
>         return np;
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
