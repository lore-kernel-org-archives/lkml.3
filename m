Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaAVCrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:47:11 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:60086 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaAVCrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:47:08 -0500
MIME-Version: 1.0
In-Reply-To: <20140122014908.GG18164@kroah.com>
References: <20140121232708.GA29787@amazon.com>
	<20140122014908.GG18164@kroah.com>
Date: Tue, 21 Jan 2014 18:47:07 -0800
X-Google-Sender-Auth: 3XfgY9KIE-1sQYasc743weghs94
Message-ID: <CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Steven Noonan <steven@uplinklabs.net>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=047d7b6d7f7a04e79e04f0862403
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6d7f7a04e79e04f0862403
Content-Type: text/plain; charset=UTF-8

On Tue, Jan 21, 2014 at 5:49 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Odds are this also shows up in 3.13, right?

Probably. I don't have a Xen PV setup to test with (and very little
interest in setting one up).. And I have a suspicion that it might not
be so much about Xen PV, as perhaps about the kind of hardware.

I suspect the issue has something to do with the magic _PAGE_NUMA
tie-in with _PAGE_PRESENT. And then mprotect(PROT_NONE) ends up
removing the _PAGE_PRESENT bit, and now the crazy numa code is
confused.

The whole _PAGE_NUMA thing is a f*cking horrible hack, and shares the
bit with _PAGE_PROTNONE, which is why it then has that tie-in to
_PAGE_PRESENT.

Adding Andrea to the Cc, because he's the author of that horridness.
Putting Steven's test-case here as an attachement for Andrea, maybe
that makes him go "Ahh, yes, silly case".

Also added Kirill, because he was involved the last _PAGE_NUMA debacle.

Andrea, you can find the thread on lkml, but it boils down to commit
1667918b6483 (backported to 3.12.7 as 3d792d616ba4) breaking the
attached test-case (but apparently only under Xen PV). There it
apparently causes a "BUG: Bad page map .." error.

And I suspect this is another of those "this bug is only visible on
real numa machines, because _PAGE_NUMA isn't actually ever set
otherwise". That has pretty much guaranteed that it gets basically
zero testing, which is not a great idea when coupled with that subtle
sharing of the _PAGE_PROTNONE bit..

It may be that the whole "Xen PV" thing is a red herring, and that
Steven only sees it on that one machine because the one he runs as a
PV guest under is a real NUMA machine, and all the other machines he
has tried it on haven't been numa. So it *may* be that that "only
under Xen PV" is a red herring. But that's just a possible guess.

Christ, how I hate that _PAGE_NUMA bit. Andrea: the fact that it gets
no testing on any normal machines is a major problem. If it was simple
and straightforward and the code was "obviously correct", it wouldn't
be such a problem, but the _PAGE_NUMA code definitely does not fall
under that "simple and obviously correct" heading.

Guys, any ideas?

                Linus

--047d7b6d7f7a04e79e04f0862403
Content-Type: text/x-csrc; charset=US-ASCII; name="t.c"
Content-Disposition: attachment; filename="t.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqpzjmdr0

I2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8c3RkbGliLmg+
CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgoKdm9pZCBkaWUoY29uc3QgY2hhciAqd2hhdCkKewoJcGVy
cm9yKHdoYXQpOwoJZXhpdCgxKTsKfQoKaW50IG1haW4oaW50IGFyZywgY2hhciAqKmFyZ3YpCnsK
CXZvaWQgKnAgPQoJICAgIG1tYXAoTlVMTCwgNDA5NiwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwK
CQkgTUFQX1BSSVZBVEUgfCBNQVBfQU5PTllNT1VTLCAtMSwgMCk7CgoJaWYgKHAgPT0gTUFQX0ZB
SUxFRCkKCQlkaWUoIm1tYXAiKTsKCgkvKiBUaWNrbGUgdGhlIHBhZ2UuICovCgkoKGNoYXIgKikg
cClbMF0gPSAwOwoKCWlmIChtcHJvdGVjdChwLCA0MDk2LCBQUk9UX05PTkUpICE9IDApCgkJZGll
KCJtcHJvdGVjdCIpOwoKCWlmIChtcHJvdGVjdChwLCA0MDk2LCBQUk9UX1JFQUQpICE9IDApCgkJ
ZGllKCJtcHJvdGVjdCIpOwoKCWlmIChtdW5tYXAocCwgNDA5NikgIT0gMCkKCQlkaWUoIm11bm1h
cCIpOwoKCXJldHVybiAwOwp9Cg==
--047d7b6d7f7a04e79e04f0862403--
