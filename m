Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3BCON4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:13:56 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:46639 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3BCONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:13:54 -0500
MIME-Version: 1.0
In-Reply-To: <87a9rltszn.fsf@xmission.com>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	<87a9rltszn.fsf@xmission.com>
Date: Sun, 3 Feb 2013 06:13:53 -0800
X-Google-Sender-Auth: Y_YXh6UkpwieTPcWQG_nZvfM3YQ
Message-ID: <CAOS58YPhSz4DQT5-hTkH-wW_P3b5LK1WuEbWiR8uyNZPZdf_Gw@mail.gmail.com>
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        jmorris@namei.org, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Eric.

On Sun, Feb 3, 2013 at 5:41 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Why the deep percpu magic?

Eh? What's magical about it?  You preload percpu buffer if you're
gonna be allocating an id from context which doesn't allow permissive
allocation.  This is the same technique used by radix tree preloading.
 The only reason idr did its own preloading was probably because it
got implemented before we had proper percpu techniques.

> Why don't associate idr_preload with an idr structure.

Because then you end up with a lot more preloaded buffers which are
much less useful.  You can't guarantee your preload target is the only
one who's gonna use the preload buffer so you end up with this ugly
-EAGAIN retry loop.  It's inefficient & inconvenient.

> When reading code with idr_preload I get this deep down creepy feeling.
> What is this magic that is going on?

Seriously, if this gives you deep creepy feeling, you need to get on
with time.  It's a basic percpu technique.

> Can't we just put the preload list_head into struct idr make
> idr_preload and idr_preload_end take an idr argument?

Inefficient & inconvenient.

> Maybe we can have a special structure we put on the stack that has
> the list_head and the preload state instead.
>
> The way this works just weirds me out and I really really don't like it.
>
> I would rather continue to use the existing functions as problematic as
> they are as I don't need a course in deep magic to make sense of them.

Heh, this is the weirdest review I got in quite a while.  Please sit
down and read it again.

Thanks.

-- 
tejun
