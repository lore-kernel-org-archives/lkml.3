Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3HGP2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:28:41 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36650 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab3HGP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:28:38 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: sedat.dilek@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext4 tree
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
	<CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
	<20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
Date: Wed, 07 Aug 2013 08:28:35 -0700
In-Reply-To: <20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
	(Stephen Rothwell's message of "Wed, 7 Aug 2013 15:38:40 +1000")
Message-ID: <87zjsted0c.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Sedat,
>
> On Wed, 7 Aug 2013 07:16:57 +0200 Sedat Dilek
> <sedat.dilek@gmail.com> wrote:
>>
>> On Mon, Jul 29, 2013 at 3:08 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >
>> > After merging the ext4 tree, today's linux-next build (powerpc
>> > ppc64_defconfig) failed like this:
>> >
>> > fs/ext4/ialloc.c: In function '__ext4_new_inode':
>> > fs/ext4/ialloc.c:817:1: warning: label 'next_ino' defined but not used [-Wunused-label]
>> >  next_ino:
>> >  ^
>> > fs/ext4/ialloc.c:792:4: error: label 'next_inode' used but not defined
>> >     goto next_inode;
>> >     ^
>> >
>> > Hmm ...
>> >
>> > Caused by commit 4a8603ef197a ("ext4: avoid reusing recently deleted
>> > inodes in no journal mode").
>> >
>> > I have used the ext4 tree from next-20130726 for today.
>> 
>> Since this message ext4-tree was not updated.
>> The commit "ext4: avoid reusing recently deleted inodes in no journal
>> mode" was refreshed and has a different commit-id.
>> Did you test with this one? You still see the breakage?
>
> Today's linux-next does not have this build failure.

However, this same commit does introduce a new build failure (not
present in next-20130806) when ext4 is built as a module:

ERROR: "dirty_expire_interval" [fs/ext4/ext4.ko] undefined!
make[3]: *** [__modpost] Error 1
make[2]: *** [modules] Error 2

The change below fixes the problem.

Found when building the mv78xx0_defconfig on ARM.

Kevin

------------8<--------------
>From 8bd28888e08124d9b298f42a0e0c3a7584ba285f Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Wed, 7 Aug 2013 08:17:43 -0700
Subject: [PATCH] mm: page-writeback: export dirty_expire_interval, used by
 ext4

commit 533ec0ed (ext4: avoid reusing recently deleted inodes in no
journal mode) started using dirty_expire_inteval, which is not
available to modules.  Make it available to modules.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 mm/page-writeback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index d374b29..c8b61ef 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -104,6 +104,8 @@ EXPORT_SYMBOL_GPL(dirty_writeback_interval);
  */
 unsigned int dirty_expire_interval = 30 * 100; /* centiseconds */
 
+EXPORT_SYMBOL_GPL(dirty_expire_interval);
+
 /*
  * Flag that makes the machine dump writes/reads and block dirtyings.
  */
-- 
1.8.3

