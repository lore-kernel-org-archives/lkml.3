Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3CVAIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:08:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38956 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3CVAIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:08:05 -0400
Date: Fri, 22 Mar 2013 00:08:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: VFS deadlock ?
Message-ID: <20130322000803.GG21522@ZenIV.linux.org.uk>
References: <20130321202635.GA16406@redhat.com>
 <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
 <20130321203639.GC16406@redhat.com>
 <20130321204704.GZ21522@ZenIV.linux.org.uk>
 <20130321210255.GD16406@redhat.com>
 <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
 <20130321221256.GA30620@redhat.com>
 <CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
 <20130321233630.GE21522@ZenIV.linux.org.uk>
 <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 04:58:41PM -0700, Linus Torvalds wrote:

> And the only other reason we don't want to allow it is to make sure
> you can't have directory loops etc, afaik, and again, for this
> particular case of /proc, we happen to be ok.

Not really.  Do that and yes, this deadlock goes away.  But the locking
order in general goes to hell - we order directory inodes by "which dentry
is an ancestor of another?"  So we have no warranty that we won't get
alias1/foo/bar/baz < alias2/foo.  Take rename_lock() on those two and
have it race with rmdir alias2/foo/bar/baz (locks alias2/foo/bar, then
alias2/foo/bar/baz) and rmdir alias2/foo/bar (locks alias2/foo and
alias2/foo/bar).  Oops - we have a cycle now...
