Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaHVVNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:13:21 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:55353 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaHVVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:13:17 -0400
Date: Sat, 23 Aug 2014 01:13:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tj@kernel.org,
        avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com
Subject: Re: [patch 4/4] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP
 operation, v3
Message-ID: <20140822211314.GD25918@moon>
References: <20140804172255.109539743@openvz.org>
 <20140804172610.965949916@openvz.org>
 <20140821155115.8433bb37bf631b8ae8340f84@linux-foundation.org>
 <20140822063242.GI14072@moon>
 <20140821234912.f007e2fb.akpm@linux-foundation.org>
 <20140822203809.GC25918@moon>
 <20140822134628.5df9cda87d744e35d794b5c2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822134628.5df9cda87d744e35d794b5c2@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 01:46:28PM -0700, Andrew Morton wrote:
> On Sat, 23 Aug 2014 00:38:09 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > > 
> > > Or will we?  What happens if we later decide that some additional field
> > > needs to be added?  Do we version the interface?  Add a new prctl()
> > > mode?  Let's cook up a plan for that and at least add to changelog?
> > 
> > I don't expect to change it anytime soon but we still have an option --
> > if we decide to extend or shrink it we always can use sizeof/offsetof
> > helpers to check which exactly version userspace asks us to use.
> 
> How does that work?  We just have a blob of bytes coming in from
> userspace.

Not just blob. We have it as a structure where all fields have a
constant size. Say we have

struct prctl_mm_map {
	__u64 start_code;
	__u64 start_code;
	__u64 some-new-field;
};

in the kernel, so its size will be 24 bytes but userspace
uses old definition without @some-new-field member (16 bytes).
So when we get a reguest with 16 bytes from userspace we can
find the userspace have passed old definition. It's not as
explicit as if we would have some @version field in struct
prctl_mm_mmap, but looks fine for me. Still I can add @version
into the structure if you prefer.

> > As far as I understand the mm_struct is not the structure which
> > changes that frequently, right?
> 
> We might find existing things which criu wants to access.  And criu
> lives forever, yes?  The mm_struct is likely to change over that time
> period ;)

Hopefully criu will live long enough so I would have a chance to update
prctl_mm_map accordingly :) Still the good thing is that once mm_struct
get changed the kernel fails to build in sys.c and the change will
be noticed immediately so we update sys.c as well.
