Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3IERxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:53:10 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:41054 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3IERxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CDC7F7@ORSMSX106.amr.corp.intel.com>
References: <20130905131814.GA24274@osiris>
	<CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31CDC7F7@ORSMSX106.amr.corp.intel.com>
Date: Thu, 5 Sep 2013 10:53:07 -0700
X-Google-Sender-Auth: U9THnkDuWhf55bJFSPeOK1r3VOc
Message-ID: <CA+55aFyevZQG5pEz-iJF6MFEMpwJD=biB-x852ki0spOM293Sg@mail.gmail.com>
Subject: Re: [PATCH] lockref: remove cpu_relax() again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 10:35 AM, Luck, Tony <tony.luck@intel.com> wrote:
>
> So Linus is right that the cpu_relax() makes things less fair ... but without it performance sucks so
> much that I don't want to use the clever cmpxchg at all - I'm much better off without it!

Hmm. Is this single-socket? The thing really only is supposed to help
if there's tons of contention.

Also, it strikes me that ia64 has tons of different versions of
cmpxchg, and the one you use by default is the one with "acquire"
semantics. That may well be the right thing to do, but I have this
possibly unfounded gut feeling that you might want to try using a
relaxed cmpxchg and then perhaps have a memory barrier *after* it has
successfully executed.

I'll have to think a bit more about what the exact memory ordering
requirements for lockref's are, but my gut feel is that just for
incrementing the reference count you don't actually have any real
memory ordering requirements.

                 Linus
