Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaAVRqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:46:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaAVRqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:46:42 -0500
Date: Wed, 22 Jan 2014 18:46:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 1/2] exec: kill the unnecessary mm->def_flags setting in
	load_elf_binary()
Message-ID: <20140122174627.GB29710@redhat.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com> <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com> <20140118234957.GB10970@node.dhcp.inet.fi> <20140120195812.GD18196@sgi.com> <20140120201525.GA31416@redhat.com> <20140120204108.GE18196@sgi.com> <20140122174553.GA29710@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122174553.GA29710@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_elf_binary() sets current->mm->def_flags = def_flags and
def_flags is always zero. Not only this looks strange, this is
unnecessary because mm_init() has already set ->def_flags = 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/binfmt_elf.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 571a423..19f569c 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -582,7 +582,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc __maybe_unused = 0;
 	int executable_stack = EXSTACK_DEFAULT;
-	unsigned long def_flags = 0;
 	struct pt_regs *regs = current_pt_regs();
 	struct {
 		struct elfhdr elf_ex;
@@ -722,9 +721,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	if (retval)
 		goto out_free_dentry;
 
-	/* OK, This is the point of no return */
-	current->mm->def_flags = def_flags;
-
 	/* Do this immediately, since STACK_TOP as used in setup_arg_pages
 	   may depend on the personality.  */
 	SET_PERSONALITY(loc->elf_ex);
-- 
1.5.5.1


