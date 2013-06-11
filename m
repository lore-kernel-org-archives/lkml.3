Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3FKWe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:34:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab3FKWe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:34:56 -0400
Date: Tue, 11 Jun 2013 15:34:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>, Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: prevent warnings when allocating with
 __GFP_NOWARN
Message-Id: <20130611153454.6ab17ce44bc4a678b8bf72d4@linux-foundation.org>
In-Reply-To: <51B73F38.6040802@kernel.org>
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com>
	<CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com>
	<51B62F6B.8040308@oracle.com>
	<0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com>
	<51B67553.6020205@oracle.com>
	<CAOJsxLH56xqCoDikYYaY_guqCX=S4rcVfDJQ4ki=r-PkNQW9ug@mail.gmail.com>
	<51B72323.8040207@oracle.com>
	<0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>
	<51B73F38.6040802@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013 18:16:08 +0300 Pekka Enberg <penberg@kernel.org> wrote:

> On Tue, 11 Jun 2013, Sasha Levin wrote:
> >> I think that leaving the warning makes sense to catch similar
> >> things which are actually bugs - we had a similar issue with
> >> /dev/kmsg (if I remember correctly) which actually pointed to
> >> a bug.
> 
> On 6/11/13 6:14 PM, Christoph Lameter wrote:
> > Right. Requesting an allocation larger than even supported by the page
> > allocator from the slab allocators that are specializing in allocations of
> > small objects is usually an indication of a problem in the code.
> 
> So you're OK with going forward with Sasha's patch?

Yes please.  slab should honour __GFP_NOWARN.

__GFP_NOWARN is frequently used by kernel code to probe for "how big an
allocation can I get".  That's a bit lame, but it's used on slow paths
and is pretty simple.

In the case of pipe_set_size(), it's userspace who is doing the
probing: an application can request a huge pipe buffer and if that
fails, try again with a smaller one.  It's just wrong to emit a kernel
warning in this case.  Plus, we've already reported the failure
anyway, by returning -ENOMEM from pipe_fcntl().
