Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaHTOUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:20:21 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:49796 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHTOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <1408539282-5699-2-git-send-email-dmonakhov@openvz.org>
References: <1408539282-5699-1-git-send-email-dmonakhov@openvz.org>
	<1408539282-5699-2-git-send-email-dmonakhov@openvz.org>
Date: Wed, 20 Aug 2014 23:20:18 +0900
Message-ID: <CAC5umyjaE6HimXyBc52jMvGYM3OgQCX1aOhQxtZ90j+9vfGnSg@mail.gmail.com>
Subject: Re: [PATCH 2/2] fault-inject: add ratelimit option
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-20 21:54 GMT+09:00 Dmitry Monakhov <dmonakhov@openvz.org>:
> @@ -40,10 +40,25 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
>
>  static void fail_dump(struct fault_attr *attr)
>  {
> -       if (attr->verbose > 0)
> -               printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure\n");
> -       if (attr->verbose > 1)
> -               dump_stack();
> +       if (attr->verbose > 0 &&
> +           ___ratelimit(&attr->ratelimit_state, __func__)) {

You can use __ratelimit(state) instead of ___ratelimit(state, __func__).

> +               if (attr->dname)
> +                       printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure."
> +                              "name %pd, interval %lu, probability %lu, "
> +                              "space %d, times %d\n", attr->dname,
> +                              attr->probability, attr->interval,
> +                              atomic_read(&attr->space),
> +                              atomic_read(&attr->times));
> +               else
> +                       printk(KERN_NOTICE "FAULT_INJECTION: forcing a "
> +                              "failure, interval %lu, probability %lu, "
> +                              "space %d, times %d\n", attr->probability,
> +                              attr->interval, atomic_read(&attr->space),
> +                              atomic_read(&attr->times));

This looks a bit redundant.  NULL pointer to "%pd" format produces
"(null)" string, so this printk and if-else can be removed.

Also, this message line is a bit longer than usual kernel message.
Should we put '\n' after "forcing a failure."?

This patch looks good to me.  Please feel free to add my ACK.
