Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3IHF2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 01:28:21 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:53445 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3IHF2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 01:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <201309081332.FEJ52163.FHJOMQVOFOLStF@I-love.SAKURA.ne.jp>
References: <201309080100.FFE90102.FFOVOtJQOFHSLM@I-love.SAKURA.ne.jp>
	<201309081332.FEJ52163.FHJOMQVOFOLStF@I-love.SAKURA.ne.jp>
Date: Sun, 8 Sep 2013 01:28:19 -0400
X-Google-Sender-Auth: xvk2ciWXq00GkHBes68NG91s8js
Message-ID: <CAKb7UvjH1XZ3f-c=149s5=rqxkxVUhG_7-cfUYH3zrwJwr2_MQ@mail.gmail.com>
Subject: Re: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes unbootable kernel.
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>, a.p.zijlstra@chello.nl,
        mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 8, 2013 at 12:32 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Hello.
>
> I found what is wrong.
>
> ---------- bad patch start ----------
> >From 3c56dfbd32a9b67ba824ce96128bb513eb65de4b Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Sun, 8 Sep 2013 12:44:20 +0900
> Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p() usage.
>
> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
> "!__builtin_constant_p(p == NULL)" which I guess the author meant that
> "__builtin_constant_p(p) && p", but gcc 3.x cannot handle such expression
> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.

I think that !__builtin_constant_p(p == NULL) is basically saying "I
am unable to conclude that p == NULL at build time", which would
translate to something along the lines of

(__builtin_constant_p(p) && p) || !__builtin_constant_p(p)

Your logic will be be false for non-built-in-constants supplied as p.

Or perhaps it's just equivalent to !__builtin_constant_p(p), since the
compiler's ability to conclude whether it is NULL at build-time should
be unaffected by whether it actually is NULL or not. Some simple
experimentation with recent gcc's should be able to determine this.
The more I think about it, the more likely the latter interpretation
is correct and you can just drop the == NULL's. (Although perhaps the
original intent was more like the former.)

  -ilia
