Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3GKCL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:11:57 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:35292 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab3GKCLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:11:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130710133742.GA29368@emu.suse.cz>
References: <20130710133742.GA29368@emu.suse.cz>
Date: Wed, 10 Jul 2013 19:11:53 -0700
X-Google-Sender-Auth: 9EJjWvfUpwwGlG7CK5fUA9JX1M8
Message-ID: <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
Subject: Re: [GIT] kbuild changes for v3.11-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Jan Beulich <JBeulich@suse.com>, dt.tangr@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        James Hogan <james.hogan@imgtec.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        robert.richter@calxeda.com,
        "Yaakov (Cygwin/X)" <yselkowitz@users.sourceforge.net>,
        zzs0213@gmail.com,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 6:37 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> please pull the kbuild bits for v3.11-rc1:

THIS IS SOME HORRIBLY BROKEN CRAP.

"make install" and "make modules_install" ABSOLUTELY MUST NOT MODIFY
THE SOURCE TREE.

Dammit, this has happened before, and it was broken then, and it is broken now.

If they do, they are *F*CKING*BROKEN*. They are really really badly
broken, since we do *not* want root to write to the source tree. You
should build the tree as a normal user, and install as root, and
dammit, if there are any root-owned files in the source tree after
that "make install", then the build system is broken.

You need to start being more careful. And I would seriously suggest
you start doing some explicit testing for this. You can do things like
"find . -user root", and if that shows a single file in the kernel
tree after a "make [modules_]install", then there's a problem.

Commit d2aae8477cd00325bb7c7c7e95be488088900c48 is broken. It causes
root to re-write "include/config/kernel.release".

There is no excuse for this. That commit is shit. There's no way in
hell that "make modules_install" should ever rebuild anything, so
adding that kind of dependency is fundamentally wrong and broken.

And that totally crap commit is even marked for stable.

I hate hate hate when this kind of crap happens. In this case I
noticed it because the git commit abbreviation rules are different for
root and for a normal user on my machine, and so running that
version-generation script as root actually GIVES THE WRONG ANSWER - it
gives a different version than the one the kernel was actually built
with.

So no. We do *not* start adding random dependencies to the install
targets. Because they damn well should not be building anything.

                           Linus
