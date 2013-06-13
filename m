Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab3FMVOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 17:14:15 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57719 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab3FMVOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 17:14:14 -0400
Date: Thu, 13 Jun 2013 14:14:25 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613211425.GC8650@moria.home.lan>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
 <20130613190610.GA13970@mtj.dyndns.org>
 <20130613121324.2cab80256217df97254af16c@linux-foundation.org>
 <20130613192152.GC13970@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613192152.GC13970@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 12:21:52PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jun 13, 2013 at 12:13:24PM -0700, Andrew Morton wrote:
> > As I understand it, if a task is stuck in this loop at freeze time, the
> > whole freeze attempt will fail.  But it's been a long time since I
> > thought about or worked on this stuff.
> 
> It depends on who's calling the allocator but if the device driver or
> its midlayer is doing things properly, the ideal way would be the task
> being marked unfreezable (I think freezable kthreads harms more than
> help in general) and the driver suspend callback draining commands
> while not issuing new ones.  What the tag allocator does doesn't
> really matter as all resources necessary for command execution should
> eventually be freed before entering suspend anyway.
> 
> If that's not the case, the freezing should still be controlled by the
> caller and again the allocator should be able to return -EBUSY/INTR to
> indicate and then the caller, after releasing all other resources,
> shouldf to try_to_freeze().  There simply is no reliable way to tell
> from as deep as tag allocator whether it'd be safe to freeze or not.

Yeah, I think you're definitely right. (I only started reading up on the
freezer stuff yesterday, though).

Do you know offhand what existing (i.e. slab) allocators do? Whatever
they do should make sense for us.
