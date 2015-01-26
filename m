Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbbAZVua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:50:30 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:45913 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbbAZVuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:50:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAPc5daVu=hjjYwDoCwco=cdg16kib80ZBbArh3z8R+j2vq6C6g@mail.gmail.com>
References: <CA+5PVA7rVy6Li_1haj1QmGG0D6avLB5Xej=2YGt6K-11kKHR5A@mail.gmail.com>
	<CA+5PVA4bs6CYU8MHn1JqBjnb-5wYJT2Tjqa65=v2uSPL8c7dYw@mail.gmail.com>
	<CA+55aFxbY21vBbPs5qCFPT1HSBbaeS+Z2Fr9So1r3rXrMWe_ZQ@mail.gmail.com>
	<CA+5PVA5RdtLyRiYerG=u--bRZQ87qU0EGf7kGPMiQs9_KB3hRw@mail.gmail.com>
	<CA+55aFwa1-pudNus+r=5EghpGkm33h--GZNND5UHt=ZKvP15Xw@mail.gmail.com>
	<CAPc5daVu=hjjYwDoCwco=cdg16kib80ZBbArh3z8R+j2vq6C6g@mail.gmail.com>
Date: Mon, 26 Jan 2015 13:50:10 -0800
X-Google-Sender-Auth: e4jHrz25M44yl5BhMZhIvUPShQU
Message-ID: <CA+55aFxdssyi_CrhB_yf8yXrG2PnuEHxf-=X6NnoVFxJnG0Jww@mail.gmail.com>
Subject: Re: patch-2.7.3 no longer applies relative symbolic link patches
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Junio C Hamano <gitster@pobox.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        twaugh@redhat.com, Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 1:35 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> What is your take on CVE-2015-1196, which brought this /regression/ to
> GNU patch?
> If "git apply" get /fixed/ for that same CVE, would that /break/ your fix?

I _think_ we allow arbitrary symlinks to be created, but then we
should be careful about actually _following_ them.

At least I _thought_ we were already quite careful not to do that,
even if it's been a long time since I looked at the code. So even if
we create a symlink to outside the repository, it normally shouldn't
matter. We have that whole "lstat_cache()" thing that exists exactly
to make it efficient to do pathname lookups while at the same time
being aware of symlinks in the middle.

Of course, our lstat cache is racy if somebody else modifies the tree
concurrently and changes things, but that's a non-issue, because if
somebody can just directly create random symlinks in the middle of the
tree, I don't think we care about any symlinks _git_ might be creating
concurrently ;)

But it is entirely possible that "git apply" - especially when used
outside of a real git directory - ends up doing that. And it's not
like we necessarily always use the whole "lstat-cache" mechanism to
begin with, so the fact that we have the infrastructure to be careful
in no way means that we necessarily always _are_ careful...

                                 Linus
