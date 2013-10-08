Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab3JHVNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:13:00 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50050 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3JHVM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131008132845.7e6c1c28f1c917f30ecb8dc5@linux-foundation.org>
References: <1381201011-4230-1-git-send-email-keescook@chromium.org>
	<1381201011-4230-3-git-send-email-keescook@chromium.org>
	<20131008132845.7e6c1c28f1c917f30ecb8dc5@linux-foundation.org>
Date: Tue, 8 Oct 2013 14:12:56 -0700
X-Google-Sender-Auth: MMgc1ApWNLJKusw26h81psSLKeA
Message-ID: <CAGXu5jKmmH=7fVEP+W0iWM+oafcNyCrvmOwgKNNSzhacPTWD9w@mail.gmail.com>
Subject: Re: [PATCH 3/3] vsprintf: ignore %n again
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 1:28 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon,  7 Oct 2013 19:56:51 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> This ignores %n in printf again, as was originally documented. Implementing
>> %n poses a greater security risk than utility, so it should stay ignored.
>> To help anyone attempting to use %n, a warning will be emitted if it is
>> encountered.
>>
>> Based on earlier patch by Joe Perches.
>
> Well this sucks.  Nowhere in this patchset are we told what is the
> alleged security risk with %n.  There's even a runtime warning telling
> people not to use it, but we've provided no way for them to find out
> *why*.
>
> Please send along suitable changelog text so I can fix this up.

Perhaps add these two paragraphs to the end of the "vsprintf: ignore
%n again" commit:


Because %n was designed to write to pointers on the stack, it has been
frequently used as an attack vector when bugs are found that leak
user-controlled strings into functions that ultimately process format
strings. While this class of bug can still be turned into an
information leak, removing %n eliminates the common method of
elevating such a bug into an arbitrary kernel memory writing
primitive, significantly reducing the danger of this class of bug.

For seq_file users that need to know the length of a written string
for padding, please see seq_setwidth() and seq_pad() instead.


> A new checkpatch rule might be appropriate?

I can look into that -- I worry it won't be very effective since
checkpatch lacks the knowledge of which functions are taking format
strings, and looking for just %n may lead to some false positives.
Maybe I can look for the common case of %n" (at the end of a string
literal).

> Two of these patches were acked-by:you.  But you sent the patches, so I
> changed these to Signed-off-by:, as per
> Documentation/SubmittingPatches, section 12.

Ah! Yes, thanks for fixing that.

-Kees

-- 
Kees Cook
Chrome OS Security
