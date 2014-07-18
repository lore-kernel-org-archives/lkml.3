Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbaGRBhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:37:42 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55852 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaGRBhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <1405619953-5475-1-git-send-email-elder@linaro.org>
References: <1405619953-5475-1-git-send-email-elder@linaro.org>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 18 Jul 2014 03:37:19 +0200
Message-ID: <CAPXgP13LZQTu7-LQp4Amj6YmEh7X+Jk3e27D-wUz60qmSYfOwQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] printk: more log flag simplification
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, pmladek@suse.cz, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 7:59 PM, Alex Elder <elder@linaro.org> wrote:
> This series rearranges the log code in such a way that the LOG_CONT
> and LOG_PREFIX log record flags can be eliminated entirely.  The
> result should be considerably easier to understand than before.  It
> builds on another recently-posted series of patches:
>     https://lkml.org/lkml/2014/7/17/363
>
> The first patch exploits the fact that LOG_CONT and LOG_NEWLINE
> are inverses, and uses LOG_NEWLINE (or its negation) anywhere
> LOG_CONT is used.  As a result, LOG_CONT is no longer needed, so
> it's eliminated.
>
> The next three patches together eliminate LOG_PREFIX.  The effect
> of LOG_PREFIX is to complete the previous log entry before recording
> a new one.  Patch 2 arranges to do this directly, marking the previous
> log record with LOG_NEWLINE whenever a new record is presented with
> LOG_PREFIX set.  Patch 3 stops saving LOG_PREFIX in any log records,
> and patch 4 finally gets rid of LOG_PREFIX.
>
> The last patch is just some cleanup of the code now that it's gone
> through this transformation.

Continuation lines are racy and unreliable by definition, they create
a problem that cannot be solved properly, so we need to try to make
the best out of it. The idea of the record buffer flags was to record
what actually happened when things race against each other. A line
without a newline is recorded as a line without a newline.

Your simplifying patches changes the code to store how things will
*look* like when exported, not what actually *happened*; like it
pretends the earlier line had a newline, while that might not have
been the case.

Maybe your simplified logic is "good enough" for the common use cases,
I haven't thought it through, but it sounds a bit strange to pretend
things in the flags of a record which actually did not happen for this
record that way, just to save a bit in a flag field.

Thanks,
Kay
