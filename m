Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaJaSAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:00:05 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:63752 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaJaSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <20141030233801.GF7996@ZenIV.linux.org.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
	<20141030233801.GF7996@ZenIV.linux.org.uk>
Date: Fri, 31 Oct 2014 11:00:01 -0700
X-Google-Sender-Auth: Iu6awU-3oaolLYBM-LuTdvhX8mU
Message-ID: <CA+55aFxB=jWGvPH3TMhB=ungOg9TBai5Ak-ma5vChBB-H2AgnQ@mail.gmail.com>
Subject: Re: How Not To Use kref (was Re: kdbus: add code for buses, domains
 and endpoints)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, hadess@hadess.net,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        Daniel Mack <daniel@zonque.org>,
        Alban Crequy <alban.crequy@collabora.co.uk>,
        javier.martinez@collabora.co.uk, teg@jklm.no
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 4:38 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> If you remove an object from some search structures, taking the lock in
> destructor is Too Fucking Late(tm).  Somebody might have already found
> that puppy and decided to pick it (all under that lock) just as we'd
> got to that point in destructor and blocked there.  Oops...

Ugh, yes. This is a much too common anti-pattern.

> Normally I'd say "just use kref_put_mutex()", but this case is even worse.
> Look:

Yeah the whole "release the structure the lock is in" is another one.

Both of these patterns have happened so many times that I'd love to
have some kind of automated tool to see them, but I suspect it is
*much* too complex to be easily checked for. The lock object debugging
we have only triggers for the case where the freeing actually happens
with the lock still held, which is too late and too hard-to-hit to be
a very useful check.

                     Linus
