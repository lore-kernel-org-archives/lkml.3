Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3CVDgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:36:54 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:45045 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3CVDgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <1363648862.1774.18.camel@buesod1.americas.hpqcorp.net>
References: <1363648862.1774.18.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 21 Mar 2013 20:36:52 -0700
Message-ID: <CANN689GJeykvA1jt2m2iDEPwfvVFkkCdKBVoNYMoyr8T51cJCA@mail.gmail.com>
Subject: Re: [PATCH 3/3] rbtree_test: add more rbtree integrity checks
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 4:21 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> When checking the rbtree, account for more properties:
>
>    - Both children of a red node are black.
>    - The tree has at least 2**bh(v)-1 internal nodes.

> -               WARN_ON_ONCE(is_red(rb) &&
> -                            (!rb_parent(rb) || is_red(rb_parent(rb))));
> +
> +               if (is_red(rb)) {
> +                       /*
> +                        * root must be black and no path contains two
> +                        * consecutive red nodes.
> +                        */
> +                       WARN_ON_ONCE(!rb_parent(rb) || is_red(rb_parent(rb)));
> +
> +                       /* both children of a red node are black */
> +                       WARN_ON_ONCE(is_red(rb->rb_left) || is_red(rb->rb_right));
> +               }

This seems quite redundant with the previous test - if we're going to
visit each children, then at that point we're going to check that they
can't be black if their parent (the current node) is black. So I don't
see that the tests adds any coverage.

>         WARN_ON_ONCE(count != nr_nodes);
> +       WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);

I like this last check - it can also be seen as a consequence of the
others, but it it's only one line and it nicely sums up what the other
properties are for :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
