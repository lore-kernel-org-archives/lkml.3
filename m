Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761872Ab3EBUDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:03:16 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:50958 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab3EBUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130501224604.21ebc42a@annuminas.surriel.com>
References: <517B1153.8000401@valvesoftware.com>
	<517B2FB4.30605@redhat.com>
	<20130427024248.GA1229@cmpxchg.org>
	<517EEBD1.503@valvesoftware.com>
	<CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
	<517F14D1.3070307@redhat.com>
	<20130502013426.GC9583@home.goodmis.org>
	<20130501224604.21ebc42a@annuminas.surriel.com>
Date: Thu, 2 May 2013 13:03:14 -0700
X-Google-Sender-Auth: lUzQ-FInTiRUKPq512fBUzIKmjQ
Message-ID: <CA+55aFwApXJzJYPg40Bn_+qmv470OnfwMwNMQnfV8eXKtqVzWQ@mail.gmail.com>
Subject: Re: [PATCH] mm,x86: limit 32 bit kernel to 12GB memory
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sonnyrao@chromium.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 7:46 PM, Rik van Riel <riel@redhat.com> wrote:
>
> Here's a somewhat friendlier one. Printing out the total amount of
> memory in the system may give them some extra motivation to upgrade
> to a 64 bit kernel :)

This needs more work:

 - suggesting a 64-bit kernel on a truly 32-bit CPU is insane, so it
had better actually check the CPUID for 64-bit support ("lm" for "long
mode").

 - we don't remove features, so there should be a kernel command line
option to say "I'm insane, I know this is going to have problems, I
want you to try to use more memory anyway" and disable the new 12GB
limit

 - I don't think it's necessarily "system stability". The problem with
large amounts of highmem ends up being that we end up using up almost
all of the lowmem just to *track* the huge amount of highmem, and then
we have so little lowmem that we suck at performance and have various
random problems. So it's not just "system stability", it's more fluid
than that.

The "it's more fluid than that" is also why I'd want to have a way to
override it. Using up all lowmem to track highmem is actually ok under
some very specific loads. If you have a setup where you have tons of
highmem, but all it is ever used for is anonymous user pages, you
don't need a lot of lowmem. Some of the craziest PAE users were that
class of use, and for all we know there are still crazy people with
real 32-bit CPU's that want to do it.

We don't really want to support it, we don't really care, but I don't
think we want to then say "you cannot do that" either. We want to say
"you're a f*cking crazy moron, and we don't think what you do is a
good idea, but if if you absolutely want to shoot yourself in the
foot, here's how to do it. Don't expect things to work well in
general, but you might have a load where it's acceptable".

                  Linus
