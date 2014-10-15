Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaJOUBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:01:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaJOUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:01:08 -0400
Date: Wed, 15 Oct 2014 13:01:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] checkpatch: Add error on use of attribute((weak))
 or __weak
Message-Id: <20141015130102.43f322c4db1ed1bf736e97f1@linux-foundation.org>
In-Reply-To: <1413402764.7484.10.camel@perches.com>
References: <cover.1413400022.git.joe@perches.com>
	<4391d882bb26278110d07b9a5e23ec44f5f8328a.1413400022.git.joe@perches.com>
	<20141015124225.01a4cad19c4f3a198efc996e@linux-foundation.org>
	<1413402348.7484.8.camel@perches.com>
	<20141015125000.44353284288395e216659953@linux-foundation.org>
	<1413402764.7484.10.camel@perches.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 12:52:44 -0700 Joe Perches <joe@perches.com> wrote:

> On Wed, 2014-10-15 at 12:50 -0700, Andrew Morton wrote:
> > On Wed, 15 Oct 2014 12:45:48 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > On Wed, 2014-10-15 at 12:42 -0700, Andrew Morton wrote:
> > > > On Wed, 15 Oct 2014 12:32:08 -0700 Joe Perches <joe@perches.com> wrote:
> > > > 
> > > > > Using weak can have unintended link defects.
> > > > > Emit an error on its use.
> > > > 
> > > > Well, we don't want a warning about use of __weak in function
> > > > definitions.  Only in declarations.
> > > 
> > > Why is that?
> > 
> > Because the problem we're trying to detect is when __weak is used on a
> > declaration.
> > 
> > This is OK:
> > 
> > foo.h:
> > extern int foo(void);
> > foo.c:
> > int __weak foo(void)
> > {
> > 	...
> > }
> > 
> > But this is not OK:
> > 
> > foo.h:
> > extern __weak int foo(void);
> > foo.c:
> > int __weak foo(void)
> > {
> > 	...
> > }
> > 
> 
> And this?
> 
> foo.c:
> 
> extern __weak int foo(void);
> 
> int __weak foo(void)
> {
> }
> 

That's why I just said "And this bit maybe is checking for use in a
header file, which is not as good as checking for a declaration but is
probably good enough."

I don't think that would trigger the bug anyway.  The problem is that

extern __weak int foo(void);

int foo(void)
{
}

unexpectedly and undesirably turns foo() into __weak.

I think it would be sufficient to check for __weak in a declaration. 
If that isn't practical then checking for __weak in a .h file should
suffice.

