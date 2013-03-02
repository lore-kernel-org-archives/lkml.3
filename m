Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3CBTZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 14:25:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57367 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3CBTZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 14:25:19 -0500
Date: Sat, 2 Mar 2013 19:25:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Russ Dill <russ.dill@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: fasync race in fs/fcntl.c
Message-ID: <20130302192518.GD4503@ZenIV.linux.org.uk>
References: <CA+Bv8XZM7yO-=vrGZg5LFLik8YkQiMC9ppCgQbyi1yuLiKstJQ@mail.gmail.com>
 <20130302184243.GC4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302184243.GC4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 06:42:43PM +0000, Al Viro wrote:
> ... what makes you think that it's fown->lock, in the first place?
> 
> > [172635.399651]  <<EOE>>  [<ffffffff816c3e13>] _raw_read_lock+0x13/0x20
> > [172635.399654]  [<ffffffff811a4532>] send_sigio+0x52/0xf0
> 
> send_sigio() is
> 	[initialization of a local variable to 1]
> 	read_lock(&fown->lock);
> 	[getting type and pid, checking them]
> 	read_lock(&tasklist_lock);
> 	[loop doing the majority of work]
> 	read_unlock(&tasklist_lock);
> 	read_unlock(&fown->lock);
> and you are at about 1/3 into the function.  Who said it's fown->lock and
> not tasklist_lock?  Could you check (or post) disassembly of send_sigio
> to see which one it is?

FWIW, after having grabbed Ubuntu binary of 3.8.0-8 generic (yours is -7, it's
not immediately visible on their site and the odds the damn thing has changed
in send_sigio() between those revisions are low):

send_sigio: (address is off by 16 compared to yours)
ffffffff811a4bf0:       e8 cb b5 52 00          callq  0xffffffff816d01c0
(that's __fentry__)
ffffffff811a4bf5:       55                      push   %rbp
ffffffff811a4bf6:       48 89 e5                mov    %rsp,%rbp
ffffffff811a4bf9:       41 57                   push   %r15
ffffffff811a4bfb:       41 89 d7                mov    %edx,%r15d
ffffffff811a4bfe:       41 56                   push   %r14
ffffffff811a4c00:       41 89 f6                mov    %esi,%r14d
ffffffff811a4c03:       41 55                   push   %r13
ffffffff811a4c05:       41 54                   push   %r12
ffffffff811a4c07:       53                      push   %rbx
ffffffff811a4c08:       48 89 fb                mov    %rdi,%rbx
ffffffff811a4c0b:       48 83 ec 10             sub    $0x10,%rsp
ffffffff811a4c0f:       e8 1c 32 52 00          callq  0xffffffff816c7e30
(first _raw_read_lock())

ffffffff811a4c14:       44 8b 4b 10             mov    0x10(%rbx),%r9d
ffffffff811a4c18:       41 83 f9 03             cmp    $0x3,%r9d
ffffffff811a4c1c:       0f 84 a6 00 00 00       je     0xffffffff811a4cc8
ffffffff811a4c22:       c7 45 d4 01 00 00 00    movl   $0x1,-0x2c(%rbp)
ffffffff811a4c29:       4c 8b 63 08             mov    0x8(%rbx),%r12
ffffffff811a4c2d:       4d 85 e4                test   %r12,%r12
ffffffff811a4c30:       74 5b                   je     0xffffffff811a4c8d
ffffffff811a4c32:       48 c7 c7 40 60 c0 81    mov    $0xffffffff81c06040,%rdi
ffffffff811a4c39:       44 89 4d c8             mov    %r9d,-0x38(%rbp)
ffffffff811a4c3d:       e8 ee 31 52 00          callq  0xffffffff816c7e30
ffffffff811a4c42:
... and this was the second one, i.e. read_lock(&tasklist_lock).  Note that
return address is send_sigio + 0x52, just as in your trace.

In other words, tasklist_lock it is...
