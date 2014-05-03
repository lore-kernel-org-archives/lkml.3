Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaECSH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:07:59 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64273 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaECSH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140503042604.GM18016@ZenIV.linux.org.uk>
References: <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
	<20140429232013.GM18016@ZenIV.linux.org.uk>
	<20140430023142.GN18016@ZenIV.linux.org.uk>
	<CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
	<20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
	<20140502055127.GH18016@ZenIV.linux.org.uk>
	<CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
	<20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
	<20140502224022.GJ18016@ZenIV.linux.org.uk>
	<20140503042604.GM18016@ZenIV.linux.org.uk>
Date: Sat, 3 May 2014 11:07:57 -0700
X-Google-Sender-Auth: ejp96VjtNGqj-XK2KTJkAhFhqPo
Message-ID: <CA+55aFwA57CEkCrRTrNUgtVxSFvaVfRfbi=MEqWzpm+2igEpmg@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 9:26 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> See vfs.git#dentry_kill-3; warning - this is completely untested and I would
> really like comments on spinning case there (i.e. the one where select_collect()
> finds some stuff already on some other shrink list and nothing with zero
> refcount that wouldn't be there).

I'm not seeing why you say that there can be no other shrinkers active
during umount (that whole "buggered" thing).

Sure, umount itself should be serialized by the sb lock, so there
should be only one umount dentry collector. But why wouldn't there be
shrinkers active due to memory pressure?

generic_unmount_super() is called by ->kill_sb(), which is done
*before* the superblock shrinker is unregistered  So any memory
pressure during that will cause dentries to be shrunk other ways.

What am I missing?

                Linus
